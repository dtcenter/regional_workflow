#!/bin/bash

#
#-----------------------------------------------------------------------
#
# Source the variable definitions file and the bash utility functions.
#
#-----------------------------------------------------------------------
#
. ${GLOBAL_VAR_DEFNS_FP}
. $USHDIR/source_util_funcs.sh
#
#-----------------------------------------------------------------------
#
# Source the file containing the function that sets various field-
# dependent naming parameters needed by MET/METplus verification tasks.
#
#-----------------------------------------------------------------------
#
. $USHDIR/set_vx_fieldname_params.sh
#
#-----------------------------------------------------------------------
#
# Save current shell options (in a global array).  Then set new options
# for this script/function.
#
#-----------------------------------------------------------------------
#
{ save_shell_opts; set -u +x; } > /dev/null 2>&1
#
#-----------------------------------------------------------------------
#
# Get the full path to the file in which this script/function is located 
# (scrfunc_fp), the name of that file (scrfunc_fn), and the directory in
# which the file is located (scrfunc_dir).
#
#-----------------------------------------------------------------------
#
scrfunc_fp=$( $READLINK -f "${BASH_SOURCE[0]}" )
scrfunc_fn=$( basename "${scrfunc_fp}" )
scrfunc_dir=$( dirname "${scrfunc_fp}" )
#
#-----------------------------------------------------------------------
#
# Print message indicating entry into script.
#
#-----------------------------------------------------------------------
#
print_info_msg "
========================================================================
Entering script:  \"${scrfunc_fn}\"
In directory:     \"${scrfunc_dir}\"

This is the ex-script for the task that runs the MET/METplus point_stat
tool to perform point-based deterministic verification of surface and
upper air fields to generate statistics for an individual ensemble 
member.
========================================================================"
#
#-----------------------------------------------------------------------
#
# Specify the set of valid argument names for this script/function.  
# Then process the arguments provided to this script/function (which 
# should consist of a set of name-value pairs of the form arg1="value1",
# etc).
#
#-----------------------------------------------------------------------
#
valid_args=( "cycle_dir" )
process_args valid_args "$@"
#
#-----------------------------------------------------------------------
#
# For debugging purposes, print out values of arguments passed to this
# script.  Note that these will be printed out only if VERBOSE is set to
# TRUE.
#
#-----------------------------------------------------------------------
#
print_input_args "valid_args"
#
#-----------------------------------------------------------------------
#
# Set various field name parameters associated with the field to be
# verified.
#
#-----------------------------------------------------------------------
#
FIELDNAME_IN_OBS_INPUT=""
FIELDNAME_IN_FCST_INPUT=""
FIELDNAME_IN_MET_OUTPUT=""
FIELDNAME_IN_MET_FILEDIR_NAMES=""
set_vx_fieldname_params \
  field="$VAR" accum="${ACCUM:-}" \
  outvarname_fieldname_in_obs_input="FIELDNAME_IN_OBS_INPUT" \
  outvarname_fieldname_in_fcst_input="FIELDNAME_IN_FCST_INPUT" \
  outvarname_fieldname_in_MET_output="FIELDNAME_IN_MET_OUTPUT" \
  outvarname_fieldname_in_MET_filedir_names="FIELDNAME_IN_MET_FILEDIR_NAMES"
#
#-----------------------------------------------------------------------
#
# Set variable that contains a description of what type of field (really
# a group of fields) is to be verified.
#
#-----------------------------------------------------------------------
#
field_desc=""
if [ "${FIELDNAME_IN_MET_FILEDIR_NAMES}" = "sfc" ]; then
  field_desc="surface"
elif [ "${FIELDNAME_IN_MET_FILEDIR_NAMES}" = "upa" ]; then
  field_desc="upper air"
fi
#
#-----------------------------------------------------------------------
#
# Set the array of forecast hours for which to run point_stat.
#
#-----------------------------------------------------------------------
#
echo "ZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
echo "  CDATE = |$CDATE|"

FHR_LAST=${FCST_LEN_HRS}
echo "FHR_LAST = |${FHR_LAST}|"
fhr_array=($( seq 0 1 ${FCST_LEN_HRS} ))
echo "fhr_array = |${fhr_array[@]}|"
FHR_LIST=$( echo "${fhr_array[@]}" | $SED "s/ /,/g" )
echo "FHR_LIST = |${FHR_LIST}|"

TIME_LAG="0"
mem_indx="${mem_indx:-}"
if [ ! -z "mem_indx" ]; then
  TIME_LAG=$(( ${ENS_TIME_LAG_HRS[$mem_indx-1]}*${secs_per_hour} ))
fi
# Calculate the negative of the time lag.  This is needed because in the
# METplus configuration file, simply placing a minus sign in front of
# TIME_LAG causes an error.
MNS_TIME_LAG=$((-${TIME_LAG}))
#
#-----------------------------------------------------------------------
#
# Set paths for input to and output from point_stat.  Also, set the
# suffix for the name of the log file that METplus will generate.
#
#-----------------------------------------------------------------------
#
OBS_INPUT_BASE="${MET_OUTPUT_DIR}/metprd/pb2nc_obs_cmn"
FCST_INPUT_BASE="${MET_INPUT_DIR}"
OUTPUT_BASE="${MET_OUTPUT_DIR}/${CDATE}${SLASH_ENSMEM_SUBDIR_OR_NULL}"
OUTPUT_SUBDIR="metprd/point_stat_cmn"
STAGING_DIR="${OUTPUT_BASE}/stage_cmn/${FIELDNAME_IN_MET_FILEDIR_NAMES}"
LOG_SUFFIX="_${FIELDNAME_IN_MET_FILEDIR_NAMES}_cmn${USCORE_ENSMEM_NAME_OR_NULL}_${CDATE}"
#
#-----------------------------------------------------------------------
#
# Create the directory(ies) in which MET/METplus will place its output
# from this script.  We do this here because (as of 20220811), when
# multiple workflow tasks are launched that all require METplus to create
# the same directory, some of the METplus tasks can fail.  This is a
# known bug and should be fixed by 20221000.  See https://github.com/dtcenter/METplus/issues/1657.
# If/when it is fixed, the following directory creation step can be
# removed from this script.
#
#-----------------------------------------------------------------------
#
mkdir_vrfy -p "${OUTPUT_BASE}/${OUTPUT_SUBDIR}"
#
#-----------------------------------------------------------------------
#
# Check for existence of top-level OBS_DIR.
#
#-----------------------------------------------------------------------
#
if [ ! -d "${OBS_DIR}" ]; then
  print_err_msg_exit "\
OBS_DIR does not exist or is not a directory:
  OBS_DIR = \"${OBS_DIR}\""
fi
#
#-----------------------------------------------------------------------
#
# Export variables to environment to make them accessible in METplus
# configuration files.
#
#-----------------------------------------------------------------------
#
# Variables needed in the common METplus configuration file (at
# ${METPLUS_CONF}/common.conf).
#
export MET_INSTALL_DIR
export METPLUS_PATH
export MET_BIN_EXEC
export METPLUS_CONF
export LOGDIR
#
# Variables needed in the METplus configuration file metplus_config_fp
# defined below.
#
export CDATE
export OBS_INPUT_BASE
export FCST_INPUT_BASE
export OUTPUT_BASE
export OUTPUT_SUBDIR
export STAGING_DIR
export LOG_SUFFIX
export MODEL
export NET
export FHR_LIST
export FHR_LAST
export TIME_LAG
export MNS_TIME_LAG
export FIELDNAME_IN_MET_FILEDIR_NAMES
#
#-----------------------------------------------------------------------
#
# Run METplus.
#
#-----------------------------------------------------------------------
#
print_info_msg "$VERBOSE" "
Calling METplus to run MET's PointStat tool for ${field_desc} fields..."
metplus_config_fp="${METPLUS_CONF}/PointStat_${FIELDNAME_IN_MET_FILEDIR_NAMES}_cmn.conf"
${METPLUS_PATH}/ush/run_metplus.py \
  -c ${METPLUS_CONF}/common.conf \
  -c ${metplus_config_fp} || \
print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""
#
#-----------------------------------------------------------------------
#
# Print message indicating successful completion of script.
#
#-----------------------------------------------------------------------
#
print_info_msg "
========================================================================
METplus point_stat tool completed successfully.

Exiting script:  \"${scrfunc_fn}\"
In directory:    \"${scrfunc_dir}\"
========================================================================"
#
#-----------------------------------------------------------------------
#
# Restore the shell options saved at the beginning of this script/func-
# tion.
#
#-----------------------------------------------------------------------
#
{ restore_shell_opts; } > /dev/null 2>&1

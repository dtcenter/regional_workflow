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

This is the ex-script for the task that runs METplus for grid-stat on
the UPP output files by initialization time for all forecast hours.
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
# Check whether the field to verify is APCP with an accumulation interval
# greater than 1 hour and set the flag field_is_APCPgt01h accordingly.
#
#-----------------------------------------------------------------------
#
if [ "${VAR}" = "APCP" ] && [ "${ACCUM: -1}" != "1" ]; then
  field_is_APCPgt01h="TRUE"
else
  field_is_APCPgt01h="FALSE"
fi
#
#-----------------------------------------------------------------------
#
echo "KKKKKKKKKKKKKKKKKKKKKKKKKKK"
echo "  CDATE = |$CDATE|"

#mem_indx=$(( mem_indx+1))  # This needs to be removed after running the 2021050712 case.
echo "  mem_indx = |${mem_indx}|"
echo "  ENS_TIME_LAG_HRS = |${ENS_TIME_LAG_HRS[@]}|"
i=$(( ${mem_indx} - 1 ))
mem_fcst_len_hrs=$(( ${FCST_LEN_HRS} + ${ENS_TIME_LAG_HRS[$i]} ))
echo "  mem_fcst_len_hrs = |${mem_fcst_len_hrs}|"

mem_time_lag_hrs="${ENS_TIME_LAG_HRS[$i]}"
echo "mem_time_lag_hrs = |${mem_time_lag_hrs}|"
#exit 1

fhr_last=${mem_fcst_len_hrs}
export fhr_last

fhr_array=($( seq ${ACCUM:-1} ${ACCUM:-1} ${mem_fcst_len_hrs} ))
echo "fhr_array = |${fhr_array[@]}|"
FHR_LIST=$( echo "${fhr_array[@]}" | $SED "s/ /,/g" )
echo "FHR_LIST = |${FHR_LIST}|"
#
#-----------------------------------------------------------------------
#
# Set variables that the METplus conf files assume exist in the
# environment.
#
#-----------------------------------------------------------------------
#
INPUT_BASE="${MET_INPUT_DIR}/${CDATE}${SLASH_ENSMEM_SUBDIR_OR_NULL}/postprd"
OUTPUT_BASE="${MET_OUTPUT_DIR}/${CDATE}${SLASH_ENSMEM_SUBDIR_OR_NULL}"

LOG_SUFFIX="${CDATE}${USCORE_ENSMEM_NAME_OR_NULL}_${FIELDNAME_IN_MET_FILEDIR_NAMES}"
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
mkdir_vrfy -p "${OUTPUT_BASE}/metprd/grid_stat"
#
# If the variable is accumulated precipitation for a time interval 
# (bucket) other than 1 hour, the MET/METplus tools called below will
# include pcp_combine.  In that case, create (if necessary) directories
# needed by pcp_combine.
#
if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
  mkdir_vrfy -p "${EXPTDIR}/metprd/pcp_combine"      # For observations
  mkdir_vrfy -p "${OUTPUT_BASE}/metprd/pcp_combine"  # For forecast
fi
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
export INPUT_BASE
export OUTPUT_BASE
export LOG_SUFFIX
export MODEL
export NET
export FHR_LIST
export FIELDNAME_IN_OBS_INPUT
export FIELDNAME_IN_FCST_INPUT
export FIELDNAME_IN_MET_OUTPUT
export FIELDNAME_IN_MET_FILEDIR_NAMES
export EXPTDIR
#
#-----------------------------------------------------------------------
#
# Run METplus.
#
#-----------------------------------------------------------------------
#
print_info_msg "$VERBOSE" "
Calling METplus to run MET's GridStat tool..."
metplus_config_fp="${METPLUS_CONF}/GridStat_${FIELDNAME_IN_MET_FILEDIR_NAMES}.conf"
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
METplus grid_stat tool completed successfully.

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

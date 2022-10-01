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
# Define any field thresholds to consider in the verification.
#
#-----------------------------------------------------------------------
#
FIELD_THRESHOLDS=""
case "${FIELDNAME_IN_MET_FILEDIR_NAMES}" in

  "APCP01h")
    FIELD_THRESHOLDS="gt0.0, ge0.254, ge0.508, ge1.27, ge2.54"
    ;;

  "APCP03h")
    FIELD_THRESHOLDS="gt0.0, ge0.254, ge0.508, ge1.27, ge2.54, ge3.810, ge6.350"
    ;;

  "APCP06h")
    FIELD_THRESHOLDS="gt0.0, ge0.254, ge0.508, ge1.27, ge2.54, ge3.810, ge6.350, ge8.890, ge12.700"
    ;;

  "APCP24h")
    FIELD_THRESHOLDS="gt0.0, ge0.254, ge0.508, ge1.27, ge2.54, ge3.810, ge6.350, ge8.890, ge12.700, ge25.400"
    ;;

  "REFC")
    FIELD_THRESHOLDS="ge20, ge30, ge40, ge50"
    ;;

  "RETOP")
    FIELD_THRESHOLDS="ge20, ge30, ge40, ge50"
    ;;

  *)
    print_err_msg_exit "\
Thresholds have not been defined for this field (FIELDNAME_IN_MET_FILEDIR_NAMES):
  FIELDNAME_IN_MET_FILEDIR_NAMES = \"${FIELDNAME_IN_MET_FILEDIR_NAMES}\""
    ;;

esac
#
#-----------------------------------------------------------------------
#
# Set the array of forecast hours for which to run pcp_combine.
#
# Note that for ensemble forecasts (which may contain time-lagged
# members), the forecast hours set below are relative to the non-time-
# lagged initialization time of the cycle regardless of whether or not
# the current ensemble member is time-lagged, i.e. the forecast hours
# are not shifted to take the time-lagging into account.
#
# The time-lagging is taken into account in the METplus configuration
# file used by the call below to METplus (which in turn calls MET's
# pcp_combine tool).  In that configuration file, the locations and
# names of the input grib2 files to MET's pcp_combine tool are set using
# the time-lagging information.  This information is calculated and
# stored below in the variable TIME_LAG (and MNS_TIME_LAG) and then
# exported to the environment to make it available to the METplus
# configuration file.
#
# Note:
# Need to add a step here to to remove those forecast hours for which
# obs are not available (i.e. for which obs files do not exist).
#
#-----------------------------------------------------------------------
#
echo "KKKKKKKKKKKKKKKKKKKKKKKKKKK"
echo "  CDATE = |$CDATE|"

fhr_array=($( seq ${ACCUM:-1} ${ACCUM:-1} ${FCST_LEN_HRS} ))
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
# Set paths for input to and output from grid_stat.  Also, set the
# suffix for the name of the log file that METplus will generate.
#
#-----------------------------------------------------------------------
#
if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
  OBS_INPUT_BASE="${MET_OUTPUT_DIR}/metprd/pcp_combine_obs_nogridstat"
#  FCST_INPUT_BASE="${MET_OUTPUT_DIR}/${CDATE}${SLASH_ENSMEM_SUBDIR_OR_NULL}/metprd/pcp_combine_fcst_nogridstat"
  FCST_INPUT_BASE="${MET_OUTPUT_DIR}"
else
  OBS_INPUT_BASE="${OBS_DIR}"
#  FCST_INPUT_BASE="${MET_INPUT_DIR}/${CDATE_TIME_LAGGED}${SLASH_ENSMEM_SUBDIR_OR_NULL}/postprd"
  FCST_INPUT_BASE="${MET_INPUT_DIR}"
fi
OUTPUT_BASE="${MET_OUTPUT_DIR}/${CDATE}${SLASH_ENSMEM_SUBDIR_OR_NULL}"
OUTPUT_SUBDIR="metprd/grid_stat_nopcpcombine"
LOG_SUFFIX="nopcpcombine_${FIELDNAME_IN_MET_FILEDIR_NAMES}${USCORE_ENSMEM_NAME_OR_NULL}_${CDATE}"
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
export LOG_SUFFIX
export MODEL
export NET
export FHR_LIST
export TIME_LAG
export MNS_TIME_LAG
export FIELDNAME_IN_OBS_INPUT
export FIELDNAME_IN_FCST_INPUT
export FIELDNAME_IN_MET_OUTPUT
export FIELDNAME_IN_MET_FILEDIR_NAMES
export FIELD_THRESHOLDS
#
#-----------------------------------------------------------------------
#
# Run METplus.
#
#-----------------------------------------------------------------------
#
print_info_msg "$VERBOSE" "
Calling METplus to run MET's GridStat tool..."

if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
  metplus_config_fp="${METPLUS_CONF}/GridStat_nopcpcombine_APCPgt01h.conf"
else
  metplus_config_fp="${METPLUS_CONF}/GridStat_nopcpcombine_${FIELDNAME_IN_MET_FILEDIR_NAMES}.conf"
fi

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

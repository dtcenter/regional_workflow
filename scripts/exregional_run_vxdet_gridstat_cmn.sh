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
# Source files defining auxiliary functions for verification.
#
#-----------------------------------------------------------------------
#
. $USHDIR/set_vx_params.sh
. $USHDIR/set_vx_fhr_list.sh
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

This is the ex-script for the task that runs the MET/METplus grid_stat
tool to perform gridded deterministic verification of accumulated 
precipitation (APCP), composite reflectivity (REFC), and echo top 
(RETOP) to generate statistics for an individual ensemble member.
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
# Set various verification parameters associated with the field to be
# verified.  Not all of these are necessarily used later below but are
# set here for consistency with other verification ex-scripts.
#
#-----------------------------------------------------------------------
#
FIELDNAME_IN_OBS_INPUT=""
FIELDNAME_IN_FCST_INPUT=""
FIELDNAME_IN_MET_OUTPUT=""
FIELDNAME_IN_MET_FILEDIR_NAMES=""
fhr_int=""

set_vx_params \
  obtype="${OBTYPE}" \
  field="$VAR" \
  accum2d="${ACCUM}" \
  outvarname_field_is_APCPgt01h="field_is_APCPgt01h" \
  outvarname_fieldname_in_obs_input="FIELDNAME_IN_OBS_INPUT" \
  outvarname_fieldname_in_fcst_input="FIELDNAME_IN_FCST_INPUT" \
  outvarname_fieldname_in_MET_output="FIELDNAME_IN_MET_OUTPUT" \
  outvarname_fieldname_in_MET_filedir_names="FIELDNAME_IN_MET_FILEDIR_NAMES" \
  outvarname_fhr_intvl_hrs="fhr_int"
#
#-----------------------------------------------------------------------
#
# Get the time-lag (if any) for the current ensemble member forecast.
#
#-----------------------------------------------------------------------
#
time_lag="0"
mem_indx="${mem_indx:-}"
if [ ! -z "${mem_indx}" ]; then
  time_lag=$(( ${ENS_TIME_LAG_HRS[${mem_indx}-1]}*${secs_per_hour} ))
fi
#
#-----------------------------------------------------------------------
#
# Set additional field-dependent verification parameters.
#
#-----------------------------------------------------------------------
#
FIELD_THRESHOLDS=""
OBS_FN_TEMPLATE=""

case "${FIELDNAME_IN_MET_FILEDIR_NAMES}" in

  "APCP01h")
    OBS_FN_TEMPLATE="${OBS_CCPA_APCP01h_FN_TEMPLATE}"
    FIELD_THRESHOLDS="gt0.0, ge0.254, ge0.508, ge1.27, ge2.54"
    ;;

  "APCP03h")
    OBS_FN_TEMPLATE="${OBS_CCPA_APCPgt01h_FN_TEMPLATE}"
    FIELD_THRESHOLDS="gt0.0, ge0.254, ge0.508, ge1.27, ge2.54, ge3.810, ge6.350"
    ;;

  "APCP06h")
    OBS_FN_TEMPLATE="${OBS_CCPA_APCPgt01h_FN_TEMPLATE}"
    FIELD_THRESHOLDS="gt0.0, ge0.254, ge0.508, ge1.27, ge2.54, ge3.810, ge6.350, ge8.890, ge12.700"
    ;;

  "APCP24h")
    OBS_FN_TEMPLATE="${OBS_CCPA_APCPgt01h_FN_TEMPLATE}"
    FIELD_THRESHOLDS="gt0.0, ge0.254, ge0.508, ge1.27, ge2.54, ge3.810, ge6.350, ge8.890, ge12.700, ge25.400"
    ;;

  "REFC")
    OBS_FN_TEMPLATE="${OBS_MRMS_REFC_FN_TEMPLATE}"
    FIELD_THRESHOLDS="ge20, ge30, ge40, ge50"
    ;;

  "RETOP")
    OBS_FN_TEMPLATE="${OBS_MRMS_RETOP_FN_TEMPLATE}"
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
# Set paths for input to and output from grid_stat.  Also, set the
# suffix for the name of the log file that METplus will generate.
#
#-----------------------------------------------------------------------
#
if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
  OBS_INPUT_BASE="${MET_OUTPUT_DIR}/metprd/pcp_combine_obs_cmn"
  FCST_INPUT_BASE="${MET_OUTPUT_DIR}"
else
  OBS_INPUT_BASE="${OBS_DIR}"
  FCST_INPUT_BASE="${MET_INPUT_DIR}"
fi
OUTPUT_BASE="${MET_OUTPUT_DIR}/${CDATE}${SLASH_ENSMEM_SUBDIR_OR_NULL}"
OUTPUT_DIR="${OUTPUT_BASE}/metprd/grid_stat_cmn"
STAGING_DIR="${OUTPUT_BASE}/stage_cmn/${FIELDNAME_IN_MET_FILEDIR_NAMES}"
LOG_SUFFIX="_${FIELDNAME_IN_MET_FILEDIR_NAMES}_cmn${USCORE_ENSMEM_NAME_OR_NULL}_${CDATE}"

OBS_REL_PATH_TEMPLATE=$( eval echo ${OBS_FN_TEMPLATE} )
if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
  FCST_REL_PATH_TEMPLATE=$( eval echo ${FCST_SUBDIR_METPROC_TEMPLATE}/${FCST_FN_METPROC_TEMPLATE} )
else
  FCST_REL_PATH_TEMPLATE=$( eval echo ${FCST_SUBDIR_TEMPLATE}/${FCST_FN_TEMPLATE} )
fi
#
#-----------------------------------------------------------------------
#
# Set the array of forecast hours for which to run grid_stat.
#
# Note that for ensemble forecasts (which may contain time-lagged
# members), the forecast hours set below are relative to the non-time-
# lagged initialization time of the cycle regardless of whether or not
# the current ensemble member is time-lagged, i.e. the forecast hours
# are not shifted to take the time-lagging into account.
#
# The time-lagging is taken into account in the METplus configuration
# file used by the call below to METplus (which in turn calls MET's
# grid_stat tool).  In that configuration file, the locations and
# names of the input grib2 files to MET's grid_stat tool are set using
# the time-lagging information.  This information is calculated and
# stored below in the variable TIME_LAG (and MNS_TIME_LAG) and then
# exported to the environment to make it available to the METplus
# configuration file.
#
#-----------------------------------------------------------------------
#
set_vx_fhr_list \
  fhr_min="${ACCUM}" \
  fhr_int="${fhr_int}" \
  fhr_max="${FCST_LEN_HRS}" \
  cdate="${CDATE}" \
  base_dir="${OBS_INPUT_BASE}" \
  fn_template="${OBS_FN_TEMPLATE}" \
  check_hourly_files="FALSE" \
  accum="${ACCUM}" \
  outvarname_fhr_list="FHR_LIST"
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
mkdir_vrfy -p "${OUTPUT_DIR}"
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
# Export variables needed in the common METplus configuration file (at
# ${METPLUS_CONF}/common.conf).
#
#-----------------------------------------------------------------------
#
export MET_INSTALL_DIR
export METPLUS_PATH
export MET_BIN_EXEC
export METPLUS_CONF
export LOGDIR
#
#-----------------------------------------------------------------------
#
# Export variables needed in the METplus configuration file metplus_config_fp
# later defined below.  Not all of these are necessarily used in the 
# configuration file but are exported here for consistency with other
# verification ex-scripts.
#
#-----------------------------------------------------------------------
#
export CDATE
export OBS_INPUT_BASE
export FCST_INPUT_BASE
export OUTPUT_BASE
export OUTPUT_DIR
export STAGING_DIR
export LOG_SUFFIX
export MODEL
export NET
export FHR_LIST

export FIELDNAME_IN_OBS_INPUT
export FIELDNAME_IN_FCST_INPUT
export FIELDNAME_IN_MET_OUTPUT
export FIELDNAME_IN_MET_FILEDIR_NAMES

export FIELD_THRESHOLDS

export OBS_REL_PATH_TEMPLATE
export FCST_REL_PATH_TEMPLATE
#
#-----------------------------------------------------------------------
#
# Run METplus if there is at least one valid forecast hour.
#
#-----------------------------------------------------------------------
#
if [ -z "${FHR_LIST}" ]; then
  print_err_msg_exit "\
The list of forecast hours for which to run METplus is empty:
  FHR_LIST = [${FHR_LIST}]"
else
  print_info_msg "$VERBOSE" "
Calling METplus to run MET's GridStat tool for field(s): ${FIELDNAME_IN_MET_FILEDIR_NAMES}"
  if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
    metplus_config_fp="${METPLUS_CONF}/GridStat_APCPgt01h_cmn.conf"
  else
    metplus_config_fp="${METPLUS_CONF}/GridStat_${FIELDNAME_IN_MET_FILEDIR_NAMES}_cmn.conf"
  fi
  ${METPLUS_PATH}/ush/run_metplus.py \
    -c ${METPLUS_CONF}/common.conf \
    -c ${metplus_config_fp} || \
  print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""
fi
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

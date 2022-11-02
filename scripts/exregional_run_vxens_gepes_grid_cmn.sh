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

This is the ex-script for the task that runs the MET/METplus gen_ens_prod
and ensemble_stat tools.
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
# Set additional field-dependent verification parameters.
#
#-----------------------------------------------------------------------
#
FIELD_THRESHOLDS=""
OBS_FN_TEMPLATE=""

case "${FIELDNAME_IN_MET_FILEDIR_NAMES}" in

  "APCP01h")
    OBS_FN_TEMPLATE="${OBS_CCPA_APCP01h_FN_TEMPLATE}"
    FIELD_THRESHOLDS="gt0.0, ge0.254, ge0.508, ge2.54"
    ;;

  "APCP03h")
    OBS_FN_TEMPLATE="${OBS_CCPA_APCPgt01h_FN_TEMPLATE}"
    FIELD_THRESHOLDS="gt0.0, ge0.508, ge2.54, ge6.350"
    ;;

  "APCP06h")
    OBS_FN_TEMPLATE="${OBS_CCPA_APCPgt01h_FN_TEMPLATE}"
    FIELD_THRESHOLDS="gt0.0, ge2.54, ge6.350, ge12.700"
    ;;

  "APCP24h")
    OBS_FN_TEMPLATE="${OBS_CCPA_APCPgt01h_FN_TEMPLATE}"
    FIELD_THRESHOLDS="gt0.0, ge6.350, ge12.700, ge25.400"
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
# Set paths for input to and output from gen_ens_prod and ensemble_stat.
# Also, set the suffix for the names of the log files that METplus will
# generate.
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
OUTPUT_BASE="${MET_OUTPUT_DIR}/${CDATE}"
OUTPUT_DIR_GEN_ENS_PROD="${OUTPUT_BASE}/metprd/gen_ens_prod_cmn"
OUTPUT_DIR_ENSEMBLE_STAT="${OUTPUT_BASE}/metprd/ensemble_stat_cmn"
STAGING_DIR="${OUTPUT_BASE}/stage_cmn/${FIELDNAME_IN_MET_FILEDIR_NAMES}"
LOG_SUFFIX="_${FIELDNAME_IN_MET_FILEDIR_NAMES}_cmn_${CDATE}"

OBS_REL_PATH_TEMPLATE=$( eval echo ${OBS_FN_TEMPLATE} )
#
# Construct the variable fcst_pcp_combine_output_template that contains
# a template (that METplus can read) of the paths to the files that the
# pcp_combine tool has generated (in previous workflow tasks).  This
# will be exported to the environment and read into various variables in
# the METplus configuration files.
#
FCST_REL_PATH_TEMPLATE=""
for (( i=0; i<${NUM_ENS_MEMBERS}; i++ )); do

  mem_indx=$(($i+1))
  mem_indx_fmt=$(printf "%0${NDIGITS_ENSMEM_NAMES}d" "${mem_indx}")
  time_lag=$(( ${ENS_TIME_LAG_HRS[$i]}*${secs_per_hour} ))

  SLASH_ENSMEM_SUBDIR_OR_NULL="/mem${mem_indx}"
  if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
    template="${FCST_SUBDIR_METPROC_TEMPLATE}/${FCST_FN_METPROC_TEMPLATE}"
  else
    template="${FCST_SUBDIR_TEMPLATE}/${FCST_FN_TEMPLATE}"
  fi

  if [ -z "${FCST_REL_PATH_TEMPLATE}" ]; then
    FCST_REL_PATH_TEMPLATE="  $(eval echo ${template})"
  else
    FCST_REL_PATH_TEMPLATE="\
${FCST_REL_PATH_TEMPLATE},
  $(eval echo ${template})"
  fi

done
#
#-----------------------------------------------------------------------
#
# Set the array of forecast hours for which to run gen_ens_prod and
# ensemble_stat.
#
#-----------------------------------------------------------------------
#
set_vx_fhr_list \
  obtype="${OBTYPE}" \
  field="${VAR}" \
  field_is_APCPgt01h="${field_is_APCPgt01h}" \
  accum="${ACCUM}" \
  fhr_min="${ACCUM}" \
  fhr_int="${fhr_int}" \
  fhr_max="${FCST_LEN_HRS}" \
  cdate="${CDATE}" \
  obs_dir="${OBS_INPUT_BASE}" \
  obs_fn_template="${OBS_FN_TEMPLATE}" \
  outvarname_fhr_list="FHR_LIST"
#
#-----------------------------------------------------------------------
#
# Create the directory(ies) in which MET/METplus will place its output
# from this script.  We do this here because (as of 20220811), when
# multiple workflow tasks are launched that all require METplus to create
# the same directory, some of the METplus tasks can fail.  This is a
# known bug and should be fixed by 20221000.  See https://github.com/dtcenter/METplus/issues/1657.
# If/when it is fixed, the following directory creation steps can be
# removed from this script.
#
#-----------------------------------------------------------------------
#
if [ "${RUN_GEN_ENS_PROD}" = "TRUE" ]; then
  mkdir_vrfy -p "${OUTPUT_DIR_GEN_ENS_PROD}"
fi

if [ "${RUN_ENSEMBLE_STAT}" = "TRUE" ]; then
  mkdir_vrfy -p "${OUTPUT_DIR_ENSEMBLE_STAT}"
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
export OUTPUT_DIR_GEN_ENS_PROD
export OUTPUT_DIR_ENSEMBLE_STAT
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
export NUM_ENS_MEMBERS

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

  if [ "${RUN_GEN_ENS_PROD}" = "TRUE" ]; then

    print_info_msg "$VERBOSE" "
Calling METplus to run MET's GenEnsProd tool for field(s): ${FIELDNAME_IN_MET_FILEDIR_NAMES}"

    if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
      metplus_config_fp="${METPLUS_CONF}/GenEnsProd_APCPgt01h_cmn.conf"
    else
      metplus_config_fp="${METPLUS_CONF}/GenEnsProd_${FIELDNAME_IN_MET_FILEDIR_NAMES}_cmn.conf"
    fi

    ${METPLUS_PATH}/ush/run_metplus.py \
      -c ${METPLUS_CONF}/common.conf \
      -c ${metplus_config_fp} || \
    print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""

  fi

  if [ "${RUN_ENSEMBLE_STAT}" = "TRUE" ]; then

    print_info_msg "$VERBOSE" "
Calling METplus to run MET's EnsembleStat tool for field(s): ${FIELDNAME_IN_MET_FILEDIR_NAMES}"

    if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
      metplus_config_fp="${METPLUS_CONF}/EnsembleStat_APCPgt01h_cmn.conf"
    else
      metplus_config_fp="${METPLUS_CONF}/EnsembleStat_${FIELDNAME_IN_MET_FILEDIR_NAMES}_cmn.conf"
    fi

    ${METPLUS_PATH}/ush/run_metplus.py \
      -c ${METPLUS_CONF}/common.conf \
      -c ${metplus_config_fp} || \
    print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""

  fi

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
METplus gen_ens_prod and ensemble_stat tools completed successfully.

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

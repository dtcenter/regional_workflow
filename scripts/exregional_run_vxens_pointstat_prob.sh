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

This is the ex-script for the task that runs the MET/METplus point_stat
tool to perform point-based ensemble verification of surface and upper
air fields to generate ensemble probabilistic statistics.
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
# Set paths for input to and output from point_stat.  Also, set the
# suffix for the name of the log file that METplus will generate.
#
#-----------------------------------------------------------------------
#
OBS_INPUT_DIR="${VX_OUTPUT_BASEDIR}/metprd/pb2nc_obs"
OBS_INPUT_FN_TEMPLATE=$( eval echo ${OBS_NDAS_SFCorUPA_FN_METPROC_TEMPLATE} )
FCST_INPUT_DIR="${VX_OUTPUT_BASEDIR}/${CDATE}/metprd/gen_ens_prod"
FCST_INPUT_FN_TEMPLATE=$( eval echo 'gen_ens_prod_${VX_FCST_MODEL_NAME}_ADP${FIELDNAME_IN_MET_FILEDIR_NAMES}_{valid?fmt=%Y%m%d}_{valid?fmt=%H%M%S}V.nc')

OUTPUT_BASE="${VX_OUTPUT_BASEDIR}/${CDATE}"
OUTPUT_DIR="${OUTPUT_BASE}/metprd/point_stat_prob"
STAGING_DIR="${OUTPUT_BASE}/stage/${FIELDNAME_IN_MET_FILEDIR_NAMES}_prob"
LOG_SUFFIX="_${FIELDNAME_IN_MET_FILEDIR_NAMES}_prob_${CDATE}"
#
#-----------------------------------------------------------------------
#
# Set the array of forecast hours for which to run point_stat.
#
#-----------------------------------------------------------------------
#
set_vx_fhr_list \
  fhr_min="0" \
  fhr_int="${fhr_int}" \
  fhr_max="${FCST_LEN_HRS}" \
  cdate="${CDATE}" \
  base_dir="${OBS_INPUT_DIR}" \
  fn_template="${OBS_INPUT_FN_TEMPLATE}" \
  check_hourly_files="FALSE" \
  accum="${ACCUM}" \
  outvarname_fhr_list="FHR_LIST"
#
#-----------------------------------------------------------------------
#
# Make sure the MET/METplus output directory(ies) exists.
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
export OBS_INPUT_DIR
export OBS_INPUT_FN_TEMPLATE
export FCST_INPUT_DIR
export FCST_INPUT_FN_TEMPLATE
export OUTPUT_BASE
export OUTPUT_DIR
export STAGING_DIR
export LOG_SUFFIX
export VX_FCST_MODEL_NAME
export NET
export FHR_LIST

export FIELDNAME_IN_OBS_INPUT
export FIELDNAME_IN_FCST_INPUT
export FIELDNAME_IN_MET_OUTPUT
export FIELDNAME_IN_MET_FILEDIR_NAMES
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
Calling METplus to run MET's PointStat tool for field(s): ${FIELDNAME_IN_MET_FILEDIR_NAMES}"
  metplus_config_fp="${METPLUS_CONF}/PointStat_${FIELDNAME_IN_MET_FILEDIR_NAMES}_prob.conf"
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

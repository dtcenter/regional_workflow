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

This is the ex-script for the task that runs METplus for ensemble-stat on
the UPP output files by initialization time for all forecast hours for 
gridded data.
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
# Create a comma-separated list of forecast hours for METplus to step
# through.
#
#-----------------------------------------------------------------------
#
echo "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"
set -x

export fhr_last=${FCST_LEN_HRS}

fhr_array=($( seq ${ACCUM:-1} ${ACCUM:-1} ${FCST_LEN_HRS} ))
export fhr_list=$( echo "${fhr_array[@]}" | $SED "s/ /,/g" )
echo "fhr_list = |${fhr_list}|"

# Determine the number padding needed based on number of ensemble members.
NUM_PAD=${NDIGITS_ENSMEM_NAMES}
#
#-----------------------------------------------------------------------
#
# Set INPUT_BASE and OUTPUT_BASE for use in METplus configuration files.
#
#-----------------------------------------------------------------------
#
INPUT_BASE=${MET_INPUT_DIR}
#OUTPUT_BASE=${MET_OUTPUT_DIR}/${CDATE}
OUTPUT_BASE=${MET_OUTPUT_DIR}
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
  mkdir_vrfy -p "${OUTPUT_BASE}/${CDATE}/metprd/gen_ens_prod"  # Output directory for GenEnsProd tool
fi

if [ "${RUN_ENSEMBLE_STAT}" = "TRUE" ]; then
  mkdir_vrfy -p "${OUTPUT_BASE}/${CDATE}/metprd/ensemble_stat" # Output directory for EnsembleStat tool
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
# Set variables needed in forming the names of METplus configuration and
# log files.
#
#-----------------------------------------------------------------------
#
# Leave the variable acc in this script for now since it's needed in 
# setting fcst_pcp_combine_output_template.  May be able to remove it
# once pcp_combine is placed in its own task.
acc=""
if [ "${VAR}" = "APCP" ]; then
  acc="${ACCUM}h"
fi
#LOG_SUFFIX="${CDATE}_${VAR}${acc:+_${acc}}"

LOG_SUFFIX="${CDATE}_${FIELDNAME_IN_MET_FILEDIR_NAMES}"

echo
echo "VAR = |$VAR|"
echo "ACCUM = |${ACCUM:-}|"
echo "FIELDNAME_IN_MET_OUTPUT = |${FIELDNAME_IN_MET_OUTPUT}|"
echo "FIELDNAME_IN_MET_FILEDIR_NAMES = |${FIELDNAME_IN_MET_FILEDIR_NAMES}|"
#exit 1
#
#-----------------------------------------------------------------------
#
# Construct the variable fcst_pcp_combine_output_template that contains
# a template (that METplus can read) of the paths to the files that the
# pcp_combine tool has generated (in previous workflow tasks).  This
# will be exported to the environment and read into various variables in
# the METplus configuration files.
#
#-----------------------------------------------------------------------
#
fcst_postprd_output_template=""
fcst_pcp_combine_output_template=""
for (( i=0; i<${NUM_ENS_MEMBERS}; i++ )); do

  mem_indx=$(($i+1))
  mem_indx_fmt=$(printf "%0${NDIGITS_ENSMEM_NAMES}d" "${mem_indx}")
  time_lag=$(( ${ENS_TIME_LAG_HRS[$i]}*${secs_per_hour} ))
#  mns_time_lag=$(( -${time_lag} ))

#  template='{init?fmt=%Y%m%d%H?shift='${time_lag}'}/mem'${mem_indx}'/postprd/'$NET'.t{init?fmt=%H?shift='${time_lag}'}z.bgdawpf{lead?fmt=%HHH?shift='${mns_time_lag}'}.tm00.grib2'
  template='{init?fmt=%Y%m%d%H?shift=-'${time_lag}'}/mem'${mem_indx}'/postprd/'$NET'.t{init?fmt=%H?shift=-'${time_lag}'}z.bgdawpf{lead?fmt=%HHH?shift='${time_lag}'}.tm00.grib2'
  if [ -z "${fcst_postprd_output_template}" ]; then
    fcst_postprd_output_template="  ${template}"
  else
    fcst_postprd_output_template="\
${fcst_postprd_output_template},
  ${template}"
  fi

#  template='{init?fmt=%Y%m%d%H?shift='${time_lag}'}/mem'${mem_indx}'/metprd/pcp_combine/'$NET'.t{init?fmt=%H?shift='${time_lag}'}z.bgdawpf{lead?fmt=%HHH?shift='${mns_time_lag}'}.tm00_a'$acc'.nc'
  template='{init?fmt=%Y%m%d%H?shift=-'${time_lag}'}/mem'${mem_indx}'/metprd/pcp_combine/'$NET'.t{init?fmt=%H?shift=-'${time_lag}'}z.bgdawpf{lead?fmt=%HHH?shift='${time_lag}'}.tm00_a'$acc'.nc'
  if [ -z "${fcst_pcp_combine_output_template}" ]; then
    fcst_pcp_combine_output_template="  ${template}"
  else
    fcst_pcp_combine_output_template="\
${fcst_pcp_combine_output_template},
  ${template}"
  fi

done

echo
echo "fcst_postprd_output_template = 
${fcst_postprd_output_template}"
echo
echo "fcst_pcp_combine_output_template = 
${fcst_pcp_combine_output_template}"

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
export POST_OUTPUT_DOMAIN_NAME
export NUM_ENS_MEMBERS
export NUM_PAD
export acc

export FIELDNAME_IN_MET_OUTPUT
export FIELDNAME_IN_MET_FILEDIR_NAMES

export fcst_postprd_output_template
export fcst_pcp_combine_output_template
export EXPTDIR
#
#-----------------------------------------------------------------------
#
# Run METplus.
#
#-----------------------------------------------------------------------
#
if [ "${RUN_GEN_ENS_PROD}" = "TRUE" ]; then
  print_info_msg "$VERBOSE" "
Calling METplus to run MET's GenEnsProd tool..."
  metplus_config_fp="${METPLUS_CONF}/GenEnsProd_${FIELDNAME_IN_MET_FILEDIR_NAMES}.conf"
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
Calling METplus to run MET's EnsembleStat tool..."
  metplus_config_fp="${METPLUS_CONF}/EnsembleStat_${FIELDNAME_IN_MET_FILEDIR_NAMES}.conf"
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

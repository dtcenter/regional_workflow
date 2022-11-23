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

This is the ex-script for the task that runs METplus for point-stat on
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
# Get the cycle date and hour (in formats of yyyymmdd and hh, respect-
# ively) from CDATE. Also read in FHR and create a comma-separated list
# for METplus to run over.
#
#-----------------------------------------------------------------------
#
echo "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
set -x
#
#-----------------------------------------------------------------------
#
# Create a comma-separated list of forecast hours for METplus to step
# through.
#
#-----------------------------------------------------------------------
#
export fhr_last=${FCST_LEN_HRS}

fhr_array=($( seq 0 1 ${FCST_LEN_HRS} ))
export fhr_list=$( echo "${fhr_array[@]}" | $SED "s/ /,/g" )
echo "fhr_list = |${fhr_list}|"
#
#-----------------------------------------------------------------------
#
# Set INPUT_BASE and OUTPUT_BASE for use in METplus configuration files.
#
#-----------------------------------------------------------------------
#
INPUT_BASE=${VX_FCST_INPUT_BASEDIR}
#OUTPUT_BASE=${VX_OUTPUT_BASEDIR}/${CDATE}
OUTPUT_BASE=${VX_OUTPUT_BASEDIR}
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
if [ "${RUN_GEN_ENS_PROD}" = "TRUE" ]; then
  mkdir_vrfy -p "${OUTPUT_BASE}/${CDATE}/metprd_vxold/gen_ens_prod"   # Output directory for GenEnsProd tool
fi

if [ "${RUN_ENSEMBLE_STAT}" = "TRUE" ]; then
  mkdir_vrfy -p "${EXPTDIR}/metprd_vxold/pb2nc"                       # Output directory for PB2NC tool
  mkdir_vrfy -p "${OUTPUT_BASE}/${CDATE}/metprd_vxold/ensemble_stat"  # Output directory for EnsembleStat tool
fi
#
#-----------------------------------------------------------------------
#
# Create LOG_SUFFIX to read into METplus conf files.
#
#-----------------------------------------------------------------------
#
LOG_SUFFIX=${CDATE}
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
# Construct the variable fcst_pcp_combine_output_template that contains
# a template (that METplus can read) of the paths to the files that the
# pcp_combine tool has generated (in previous workflow tasks).  This
# will be exported to the environment and read into various variables in
# the METplus configuration files.
#
#-----------------------------------------------------------------------
#
fcst_postprd_output_template=""
#fcst_pcp_combine_output_template=""
for (( i=0; i<${NUM_ENS_MEMBERS}; i++ )); do
#for (( i=1; i<${NUM_ENS_MEMBERS}+1; i++ )); do  # This needs to be removed after the 2021050712 test runs are done.

  mem_indx=$(($i+1))
  mem_indx_fmt=$(printf "%0${NDIGITS_ENSMEM_NAMES}d" "${mem_indx}")
  time_lag=$(( ${ENS_TIME_LAG_HRS[$i]}*${secs_per_hour} ))
#  mns_time_lag=$(( -${time_lag} ))

#  template='{init?fmt=%Y%m%d%H?shift='${time_lag}'}/mem'${mem_indx}'/postprd/'$NET'.t{init?fmt=%H?shift='${time_lag}'}z.bgdawpf{lead?fmt=%HHH?shift='${mns_time_lag}'}.tm00.grib2'
  template='{init?fmt=%Y%m%d%H?shift=-'${time_lag}'}/mem'${mem_indx}'/postprd/'$NET'.t{init?fmt=%H?shift=-'${time_lag}'}z.bgdawpf{lead?fmt=%HHH?shift='${time_lag}'}.tm00.grib2'
#  if [ $i -eq "0" ]; then
  if [ -z "${fcst_postprd_output_template}" ]; then
    fcst_postprd_output_template="  ${template}"
  else
    fcst_postprd_output_template="\
${fcst_postprd_output_template},
  ${template}"
  fi

#  template='{init?fmt=%Y%m%d%H?shift='${time_lag}'}/mem'${mem_indx}'/metprd_vxold/pcp_combine/'$NET'.t{init?fmt=%H?shift='${time_lag}'}
#z.bgdawpf{lead?fmt=%HHH?shift='${mns_time_lag}'}.tm00_a'$acc
##  if [ $i -eq "0" ]; then
#  if [ -z "${fcst_pcp_combine_output_template}" ]; then
#    fcst_pcp_combine_output_template="  ${template}"
#  else
#    fcst_pcp_combine_output_template="\
#${fcst_pcp_combine_output_template},
#  ${template}"
#  fi

done

echo
echo "fcst_postprd_output_template = 
${fcst_postprd_output_template}"
#echo
#echo "fcst_pcp_combine_output_template = 
#${fcst_pcp_combine_output_template}"

#
#-----------------------------------------------------------------------
#
# Export variables to environment to make them accessible in METplus
# configuration files.
#
#-----------------------------------------------------------------------
#
export EXPTDIR
export LOGDIR
export CDATE
export INPUT_BASE
export OUTPUT_BASE
export LOG_SUFFIX
export MET_INSTALL_DIR
export MET_BIN_EXEC
export METPLUS_PATH
export METPLUS_CONF
export VX_FCST_MODEL_NAME
export NET
export NUM_ENS_MEMBERS

export fcst_postprd_output_template
#
#-----------------------------------------------------------------------
#
# Run METplus.
#
#-----------------------------------------------------------------------
#
if [ "${RUN_GEN_ENS_PROD}" = "TRUE" ]; then

  print_info_msg "$VERBOSE" "
Calling METplus to run MET's GenEnsProd tool for surface fields..."
  metplus_config_fp="${METPLUS_CONF}/vxold/GenEnsProd_conus_sfc.conf"
  ${METPLUS_PATH}/ush/run_metplus.py \
    -c ${METPLUS_CONF}/common.conf \
    -c ${metplus_config_fp} || \
  print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""
#  print_info_msg "
#METplus/GenEnsProd for surface fields returned with the following
#non-zero return code: $?"

  print_info_msg "$VERBOSE" "
Calling METplus to run MET's GenEnsProd tool for upper air fields..."
  metplus_config_fp="${METPLUS_CONF}/vxold/GenEnsProd_upper_air.conf"
  ${METPLUS_PATH}/ush/run_metplus.py \
    -c ${METPLUS_CONF}/common.conf \
    -c ${metplus_config_fp} || \
  print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""
#  print_info_msg "
#METplus/GenEnsProd for upper air fields returned with the following
#non-zero return code: $?"

fi

if [ "${RUN_ENSEMBLE_STAT}" = "TRUE" ]; then

  print_info_msg "$VERBOSE" "
Calling METplus to run MET's EnsembleStat tool for surface fields..."
  metplus_config_fp="${METPLUS_CONF}/vxold/EnsembleStat_conus_sfc.conf"
  ${METPLUS_PATH}/ush/run_metplus.py \
    -c ${METPLUS_CONF}/common.conf \
    -c ${metplus_config_fp} || \
  print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""
#  print_info_msg "
#METplus/EnsembleStat for surface fields returned with the following
#non-zero return code: $?"

  print_info_msg "$VERBOSE" "
Calling METplus to run MET's EnsembleStat tool for upper air fields..."
  metplus_config_fp="${METPLUS_CONF}/vxold/EnsembleStat_upper_air.conf"
  ${METPLUS_PATH}/ush/run_metplus.py \
    -c ${METPLUS_CONF}/common.conf \
    -c ${metplus_config_fp} || \
  print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""
#  print_info_msg "
#METplus/EnsembleStat for upper air fields returned with the following
#non-zero return code: $?"

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
METplus ensemble-stat completed successfully.

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

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
echo "LLLLLLLLLLLLLLLLLLLLLLLLLLLL"
echo "  CDATE = |$CDATE|"

yyyymmdd=${CDATE:0:8}
hh=${CDATE:8:2}
cyc=$hh
export CDATE
export hh

#mem_indx=$(( mem_indx+1))  # This needs to be removed after running the 2021050712 case.
echo "  mem_indx = |${mem_indx}|"
echo "  ENS_DELTA_FCST_LEN_HRS = |${ENS_DELTA_FCST_LEN_HRS[@]}|"
i=$(( ${mem_indx} - 1 ))
mem_fcst_len_hrs=$(( ${FCST_LEN_HRS} + ${ENS_DELTA_FCST_LEN_HRS[$i]} ))
echo "  mem_fcst_len_hrs = |${mem_fcst_len_hrs}|"

mem_time_lag_hrs="${ENS_TIME_LAG_HRS[$i]}"
echo "mem_time_lag_hrs = |${mem_time_lag_hrs}|"
#exit 1

fhr_last=${mem_fcst_len_hrs}
export fhr_last

#fhr_array=($( seq 1 ${ACCUM:-1} ${mem_fcst_len_hrs} ))  # Does this list need to be formatted to have 0 padding to the left?
fhr_array=($( seq 0 1 ${mem_fcst_len_hrs} ))  # Does this list need to be formatted to have 0 padding to the left?
echo "fhr_array = |${fhr_array[@]}|"
fhr_list=$( echo "${fhr_array[@]}" | $SED "s/ /,/g" )
export fhr_list

#echo "mem_fcst_len_hrs = |${mem_fcst_len_hrs}|"
#echo "mem_time_lag_hrs = |${mem_time_lag_hrs}|"
echo "fhr_last = |${fhr_last}|"
echo "fhr_list = |${fhr_list}|"
#exit 1
#
#-----------------------------------------------------------------------
#
# Set variables that the METplus conf files assume exist in the 
# environment.
#
#-----------------------------------------------------------------------
#
#uscore_ensmem_or_null=""
#slash_ensmem_subdir_or_null=""
#if [ "${DO_ENSEMBLE}" = "TRUE" ]; then
#  uscore_ensmem_or_null="_${mem_indx}"
#  slash_ensmem_subdir_or_null="${SLASH_ENSMEM_SUBDIR_OR_NULL}"
#fi

#INPUT_BASE=${MET_INPUT_DIR}/${CDATE}${slash_ensmem_subdir_or_null}/postprd
#OUTPUT_BASE=${MET_OUTPUT_DIR}/${CDATE}${slash_ensmem_subdir_or_null}
#LOG_SUFFIX="pointstat_${CDATE}${uscore_ensmem_or_null}"
#MODEL=${MODEL}${uscore_ensmem_or_null}
INPUT_BASE=${MET_INPUT_DIR}/${CDATE}${SLASH_ENSMEM_SUBDIR_OR_NULL}/postprd
OUTPUT_BASE=${MET_OUTPUT_DIR}/${CDATE}${SLASH_ENSMEM_SUBDIR_OR_NULL}
LOG_SUFFIX="${CDATE}${USCORE_ENSMEM_NAME_OR_NULL}"
MODEL=${MODEL}${USCORE_ENSMEM_NAME_OR_NULL}

echo "USCORE_ENSMEM_NAME_OR_NULL = |${USCORE_ENSMEM_NAME_OR_NULL}|"
echo "MODEL = |$MODEL|"
#exit 1

##
##-----------------------------------------------------------------------
##
## Create INPUT_BASE, OUTPUT_BASE, and LOG_SUFFIX to read into METplus
## conf files.
##
##-----------------------------------------------------------------------
##
#if [ "${DO_ENSEMBLE}" = "FALSE" ]; then
#  INPUT_BASE=${MET_INPUT_DIR}/${CDATE}/postprd
#  OUTPUT_BASE=${MET_OUTPUT_DIR}/${CDATE}
#  LOG_SUFFIX=pointstat_${CDATE}
#elif [ "${DO_ENSEMBLE}" = "TRUE" ]; then
#  INPUT_BASE=${MET_INPUT_DIR}/${CDATE}/${SLASH_ENSMEM_SUBDIR}/postprd
#  OUTPUT_BASE=${MET_OUTPUT_DIR}/${CDATE}/${SLASH_ENSMEM_SUBDIR}
#  ENSMEM=`echo ${SLASH_ENSMEM_SUBDIR} | cut -d"/" -f2`
#  MODEL=${MODEL}_${ENSMEM}
#  LOG_SUFFIX=pointstat_${CDATE}_${ENSMEM}
#fi
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
mkdir_vrfy -p "${EXPTDIR}/metprd/pb2nc"           # Output directory for pb2nc tool.
mkdir_vrfy -p "${OUTPUT_BASE}/metprd/point_stat"  # Output directory for point_stat tool.
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
# Export some environment variables passed in by the XML.
#
#-----------------------------------------------------------------------
#
export EXPTDIR
export LOGDIR
export INPUT_BASE
export OUTPUT_BASE
export LOG_SUFFIX
export MET_INSTALL_DIR
export MET_BIN_EXEC
export METPLUS_PATH
export METPLUS_CONF
export MET_CONFIG
export MODEL
export NET
export POST_OUTPUT_DOMAIN_NAME
#
#-----------------------------------------------------------------------
#
# Run METplus.
#
#-----------------------------------------------------------------------
#
print_info_msg "$VERBOSE" "
Calling METplus to run MET's PointStat tool for surface fields..."
metplus_config_fp="${METPLUS_CONF}/PointStat_conus_sfc.conf"
${METPLUS_PATH}/ush/run_metplus.py \
  -c ${METPLUS_CONF}/common.conf \
  -c ${metplus_config_fp} || \
print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""
#print_info_msg "
#METplus/PointStat for surface fields returned with the following
#non-zero return code: $?"

print_info_msg "$VERBOSE" "
Calling METplus to run MET's PointStat tool for upper air fields..."
metplus_config_fp="${METPLUS_CONF}/PointStat_upper_air.conf"
${METPLUS_PATH}/ush/run_metplus.py \
  -c ${METPLUS_CONF}/common.conf \
  -c ${metplus_config_fp} || \
print_err_msg_exit "
Call to METplus failed with return code: $?
METplus configuration file used is:
  metplus_config_fp = \"${metplus_config_fp}\""
#print_info_msg "
#METplus/PointStat for upper air fields returned with the following
#non-zero return code: $?"
#
#-----------------------------------------------------------------------
#
# Print message indicating successful completion of script.
#
#-----------------------------------------------------------------------
#
print_info_msg "
========================================================================
METplus point-stat completed successfully.

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

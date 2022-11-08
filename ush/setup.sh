#!/bin/bash
#
#-----------------------------------------------------------------------
#
# This file defines and then calls a function that sets a secondary set
# of parameters needed by the various scripts that are called by the 
# FV3-LAM rocoto community workflow.  This secondary set of parameters is 
# calculated using the primary set of user-defined parameters in the de-
# fault and custom experiment/workflow configuration scripts (whose file
# names are defined below).  This script then saves both sets of parame-
# ters in a global variable definitions file (really a bash script) in 
# the experiment directory.  This file then gets sourced by the various 
# scripts called by the tasks in the workflow.
#
#-----------------------------------------------------------------------
#
function setup() {
#
#-----------------------------------------------------------------------
#
# Get the full path to the file in which this script/function is located 
# (scrfunc_fp), the name of that file (scrfunc_fn), and the directory in
# which the file is located (scrfunc_dir).
#
#-----------------------------------------------------------------------
#
local scrfunc_fp=$( $READLINK -f "${BASH_SOURCE[0]}" )
local scrfunc_fn=$( basename "${scrfunc_fp}" )
local scrfunc_dir=$( dirname "${scrfunc_fp}" )
#
#-----------------------------------------------------------------------
#
# Get the name of this function.
#
#-----------------------------------------------------------------------
#
local func_name="${FUNCNAME[0]}"
#
#-----------------------------------------------------------------------
#
#
#
#-----------------------------------------------------------------------
#
cd_vrfy ${scrfunc_dir}
#
#-----------------------------------------------------------------------
#
# Source bash utility functions.
#
#-----------------------------------------------------------------------
#

. ./source_util_funcs.sh

print_info_msg "
========================================================================
Starting function ${func_name}() in \"${scrfunc_fn}\"...
========================================================================"
#
#-----------------------------------------------------------------------
#
# Source other necessary files.
#
#-----------------------------------------------------------------------
#
. ./check_expt_config_vars.sh
. ./set_cycle_dates.sh
. ./set_predef_grid_params.sh
. ./set_gridparams_GFDLgrid.sh
. ./set_gridparams_ESGgrid.sh
. ./link_fix.sh
. ./set_ozone_param.sh
. ./set_thompson_mp_fix_files.sh
. ./check_ruc_lsm.sh
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
# Set the name of the configuration file containing default values for
# the experiment/workflow variables.  Then source the file.
#
#-----------------------------------------------------------------------
#
EXPT_DEFAULT_CONFIG_FN="config_defaults.sh"
. ./${EXPT_DEFAULT_CONFIG_FN}
#
#-----------------------------------------------------------------------
#
# If a user-specified configuration file exists, source it.  This file
# contains user-specified values for a subset of the experiment/workflow 
# variables that override their default values.  Note that the user-
# specified configuration file is not tracked by the repository, whereas
# the default configuration file is tracked.
#
#-----------------------------------------------------------------------
#
if [ -f "${EXPT_CONFIG_FN}" ]; then
#
# We require that the variables being set in the user-specified configu-
# ration file have counterparts in the default configuration file.  This
# is so that we do not introduce new variables in the user-specified 
# configuration file without also officially introducing them in the de-
# fault configuration file.  Thus, before sourcing the user-specified 
# configuration file, we check that all variables in the user-specified
# configuration file are also assigned default values in the default 
# configuration file.
#
  check_expt_config_vars \
    default_config_fp="./${EXPT_DEFAULT_CONFIG_FN}" \
    config_fp="./${EXPT_CONFIG_FN}"
#
# Now source the user-specified configuration file.
#
  . ./${EXPT_CONFIG_FN}
#
fi
#
#-----------------------------------------------------------------------
#
# Source the script defining the valid values of experiment variables.
#
#-----------------------------------------------------------------------
#
. ./valid_param_vals.sh
#
#-----------------------------------------------------------------------
#
# Make sure that user-defined variables are set to valid values
#
# Set binary switch variables to either "TRUE" or "FALSE" by calling
# boolify so we don't have to consider other valid values later on.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "RUN_ENVIR" "valid_vals_RUN_ENVIR"

check_var_valid_value "VERBOSE" "valid_vals_BOOLEAN"
VERBOSE=$(boolify "$VERBOSE")

check_var_valid_value "DEBUG" "valid_vals_BOOLEAN"
DEBUG=$(boolify "$DEBUG")

check_var_valid_value "USE_CRON_TO_RELAUNCH" "valid_vals_BOOLEAN"
USE_CRON_TO_RELAUNCH=$(boolify "${USE_CRON_TO_RELAUNCH}")
#
#-----------------------------------------------------------------------
#
# If DEBUG is set to "TRUE", set VERBOSE to "TRUE" to print out all
# of the VERBOSE output (in addition to any DEBUG output).
#
#-----------------------------------------------------------------------
#
if [ "$DEBUG" = "TRUE" ]; then
  print_info_msg "
Setting VERBOSE to \"TRUE\" because DEBUG has been set to \"TRUE\"..."
  VERBOSE="TRUE"
fi
#
#-----------------------------------------------------------------------
#
# Check flags that turn on/off various workflow tasks.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "RUN_TASK_MAKE_GRID" "valid_vals_BOOLEAN"
RUN_TASK_MAKE_GRID=$(boolify "${RUN_TASK_MAKE_GRID}")

check_var_valid_value "RUN_TASK_MAKE_OROG" "valid_vals_BOOLEAN"
RUN_TASK_MAKE_OROG=$(boolify "${RUN_TASK_MAKE_OROG}")

check_var_valid_value "RUN_TASK_MAKE_SFC_CLIMO" "valid_vals_BOOLEAN"
RUN_TASK_MAKE_SFC_CLIMO=$(boolify "${RUN_TASK_MAKE_SFC_CLIMO}")

check_var_valid_value "RUN_TASK_GET_EXTRN_ICS" "valid_vals_BOOLEAN"
RUN_TASK_GET_EXTRN_ICS=$(boolify "${RUN_TASK_GET_EXTRN_ICS}")

check_var_valid_value "RUN_TASK_GET_EXTRN_LBCS" "valid_vals_BOOLEAN"
RUN_TASK_GET_EXTRN_LBCS=$(boolify "${RUN_TASK_GET_EXTRN_LBCS}")

check_var_valid_value "RUN_TASK_RUN_FCST" "valid_vals_BOOLEAN"
RUN_TASK_RUN_FCST=$(boolify "${RUN_TASK_RUN_FCST}")

check_var_valid_value "RUN_TASK_RUN_POST" "valid_vals_BOOLEAN"
RUN_TASK_RUN_POST=$(boolify "${RUN_TASK_RUN_POST}")

check_var_valid_value "RUN_TASK_GET_OBS_CCPA" "valid_vals_BOOLEAN"
RUN_TASK_GET_OBS_CCPA=$(boolify "${RUN_TASK_GET_OBS_CCPA}")

check_var_valid_value "RUN_TASK_GET_OBS_MRMS" "valid_vals_BOOLEAN"
RUN_TASK_GET_OBS_MRMS=$(boolify "${RUN_TASK_GET_OBS_MRMS}")

check_var_valid_value "RUN_TASK_GET_OBS_NDAS" "valid_vals_BOOLEAN"
RUN_TASK_GET_OBS_NDAS=$(boolify "${RUN_TASK_GET_OBS_NDAS}")

check_var_valid_value "RUN_TASKS_VXDET" "valid_vals_BOOLEAN"
RUN_TASKS_VXDET=$(boolify "${RUN_TASKS_VXDET}")

check_var_valid_value "RUN_TASKS_VXENS" "valid_vals_BOOLEAN"
RUN_TASKS_VXENS=$(boolify "${RUN_TASKS_VXENS}")


# Remove the following at some point.
check_var_valid_value "RUN_TASK_VX_GRIDSTAT" "valid_vals_BOOLEAN"
RUN_TASK_VX_GRIDSTAT=$(boolify "${RUN_TASK_VX_GRIDSTAT}")

check_var_valid_value "RUN_TASK_VX_POINTSTAT" "valid_vals_BOOLEAN"
RUN_TASK_VX_POINTSTAT=$(boolify "${RUN_TASK_VX_POINTSTAT}")

check_var_valid_value "RUN_TASK_VX_ENSGRID" "valid_vals_BOOLEAN"
RUN_TASK_VX_ENSGRID=$(boolify "${RUN_TASK_VX_ENSGRID}")

check_var_valid_value "RUN_TASK_VX_ENSPOINT" "valid_vals_BOOLEAN"
RUN_TASK_VX_ENSPOINT=$(boolify "${RUN_TASK_VX_ENSPOINT}")
#
#-----------------------------------------------------------------------
#
# Check stochastic physcs flags.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "DO_SHUM" "valid_vals_BOOLEAN"
DO_SHUM=$(boolify "${DO_SHUM}")

check_var_valid_value "DO_SPPT" "valid_vals_BOOLEAN"
DO_SPPT=$(boolify "${DO_SPPT}")

check_var_valid_value "DO_SKEB" "valid_vals_BOOLEAN"
DO_SKEB=$(boolify "${DO_SKEB}")

check_var_valid_value "DO_SPP" "valid_vals_BOOLEAN"
DO_SPP=$(boolify "${DO_SPP}")

check_var_valid_value "DO_LSM_SPP" "valid_vals_BOOLEAN"
DO_LSM_SPP=$(boolify "${DO_LSM_SPP}")

check_var_valid_value "USE_ZMTNBLCK" "valid_vals_BOOLEAN"
USE_ZMTNBLCK=$(boolify "${USE_ZMTNBLCK}")
#
#-----------------------------------------------------------------------
#
# Set magnitude of stochastic ad-hoc schemes to -999.0 if they are not
# being used. This is required at the moment, since "do_shum/sppt/skeb"
# does not override the use of the scheme unless the magnitude is also
# specifically set to -999.0.  If all "do_shum/sppt/skeb" are set to
# "false," then none will run, regardless of the magnitude values. 
#
#-----------------------------------------------------------------------
#
if [ "${DO_SHUM}" = "FALSE" ]; then
  SHUM_MAG=-999.0
fi
if [ "${DO_SKEB}" = "FALSE" ]; then
  SKEB_MAG=-999.0
fi
if [ "${DO_SPPT}" = "FALSE" ]; then
  SPPT_MAG=-999.0
fi
#
#-----------------------------------------------------------------------
#
# If running with SPP in MYNN PBL, MYNN SFC, GSL GWD, Thompson MP, or 
# RRTMG, count the number of entries in SPP_VAR_LIST to correctly set 
# N_VAR_SPP, otherwise set it to zero. 
#
#-----------------------------------------------------------------------
#
N_VAR_SPP=0
if [ "${DO_SPP}" = "TRUE" ]; then
  N_VAR_SPP=${#SPP_VAR_LIST[@]}
fi
#
#-----------------------------------------------------------------------
#
# If running with Noah or RUC-LSM SPP, count the number of entries in 
# LSM_SPP_VAR_LIST to correctly set N_VAR_LNDP, otherwise set it to zero.
# Also set LNDP_TYPE to 2 for LSM SPP, otherwise set it to zero.  Finally,
# initialize an "FHCYC_LSM_SPP" variable to 0 and set it to 999 if LSM SPP
# is turned on.  This requirement is necessary since LSM SPP cannot run with 
# FHCYC=0 at the moment, but FHCYC cannot be set to anything less than the
# length of the forecast either.  A bug fix will be submitted to 
# ufs-weather-model soon, at which point, this requirement can be removed
# from regional_workflow. 
#
#-----------------------------------------------------------------------
#
N_VAR_LNDP=0
LNDP_TYPE=0
FHCYC_LSM_SPP_OR_NOT=0
if [ "${DO_LSM_SPP}" = "TRUE" ]; then
  N_VAR_LNDP=${#LSM_SPP_VAR_LIST[@]}
  LNDP_TYPE=2
  FHCYC_LSM_SPP_OR_NOT=999
fi
#
#-----------------------------------------------------------------------
#
# If running with SPP, confirm that each SPP-related namelist value 
# contains the same number of entries as N_VAR_SPP (set above to be equal
# to the number of entries in SPP_VAR_LIST).
#
#-----------------------------------------------------------------------
#
if [ "${DO_SPP}" = "TRUE" ]; then
  if [ "${#SPP_MAG_LIST[@]}" != "${N_VAR_SPP}" ] || \
     [ "${#SPP_LSCALE[@]}" != "${N_VAR_SPP}" ] || \
     [ "${#SPP_TSCALE[@]}" != "${N_VAR_SPP}" ] || \
     [ "${#SPP_SIGTOP1[@]}" != "${N_VAR_SPP}" ] || \
     [ "${#SPP_SIGTOP2[@]}" != "${N_VAR_SPP}" ] || \
     [ "${#SPP_STDDEV_CUTOFF[@]}" != "${N_VAR_SPP}" ] || \
     [ "${#ISEED_SPP[@]}" != "${N_VAR_SPP}" ]; then
  print_err_msg_exit "\
All MYNN PBL, MYNN SFC, GSL GWD, Thompson MP, or RRTMG SPP-related namelist 
variables set in ${CONFIG_FN} must be equal in number of entries to what is 
found in SPP_VAR_LIST:
  Number of entries in SPP_VAR_LIST = \"${#SPP_VAR_LIST[@]}\""
  fi
fi
#
#-----------------------------------------------------------------------
#
# If running with LSM SPP, confirm that each LSM SPP-related namelist
# value contains the same number of entries as N_VAR_LNDP (set above to
# be equal to the number of entries in LSM_SPP_VAR_LIST).
#
#-----------------------------------------------------------------------
#
if [ "${DO_LSM_SPP}" = "TRUE" ]; then
  if [ "${#LSM_SPP_MAG_LIST[@]}" != "${N_VAR_LNDP}" ] || \
     [ "${#LSM_SPP_LSCALE[@]}" != "${N_VAR_LNDP}" ] || \
     [ "${#LSM_SPP_TSCALE[@]}" != "${N_VAR_LNDP}" ]; then
  print_err_msg_exit "\
All Noah or RUC-LSM SPP-related namelist variables (except ISEED_LSM_SPP) 
set in ${CONFIG_FN} must be equal in number of entries to what is found in 
SPP_VAR_LIST:
  Number of entries in SPP_VAR_LIST = \"${#LSM_SPP_VAR_LIST[@]}\""
  fi
fi
#
#-----------------------------------------------------------------------
#
# Make sure that DOT_OR_USCORE is set to a valid value.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "DOT_OR_USCORE" "valid_vals_DOT_OR_USCORE"
#
#-----------------------------------------------------------------------
#
# Make sure that USE_FVCOM is set to a valid value and assign directory
# and file names.
# 
# Make sure that FVCOM_WCSTART is set to lowercase "warm" or "cold"
#
#-----------------------------------------------------------------------
#
check_var_valid_value "USE_FVCOM" "valid_vals_BOOLEAN"
USE_FVCOM=$(boolify "${USE_FVCOM}")

check_var_valid_value "FVCOM_WCSTART" "valid_vals_FVCOM_WCSTART"
FVCOM_WCSTART=$(echo_lowercase "${FVCOM_WCSTART}")
#
#-----------------------------------------------------------------------
#
# Set various directories.
#
# HOMErrfs:
# Top directory of the clone of the FV3-LAM workflow git repository.
#
# USHDIR:
# Directory containing the shell scripts called by the workflow.
#
# SCRIPTSDIR:
# Directory containing the ex scripts called by the workflow.
#
# JOBSSDIR:
# Directory containing the jjobs scripts called by the workflow.
#
# SORCDIR:
# Directory containing various source codes.
#
# PARMDIR:
# Directory containing parameter files, template files, etc.
#
# EXECDIR:
# Directory containing various executable files.
#
# TEMPLATE_DIR:
# Directory in which templates of various FV3-LAM input files are locat-
# ed.
#
# UFS_WTHR_MDL_DIR:
# Directory in which the (NEMS-enabled) FV3-LAM application is located.
# This directory includes subdirectories for FV3, NEMS, and FMS.
#
#-----------------------------------------------------------------------
#

#
# The current script should be located in the ush subdirectory of the 
# workflow directory.  Thus, the workflow directory is the one above the
# directory of the current script.
#
SR_WX_APP_TOP_DIR=${scrfunc_dir%/*/*}

#
#-----------------------------------------------------------------------
#
# Set the base directories in which codes obtained from external reposi-
# tories (using the manage_externals tool) are placed.  Obtain the rela-
# tive paths to these directories by reading them in from the manage_ex-
# ternals configuration file.  (Note that these are relative to the lo-
# cation of the configuration file.)  Then form the full paths to these
# directories.  Finally, make sure that each of these directories actu-
# ally exists.
#
#-----------------------------------------------------------------------
#
mng_extrns_cfg_fn=$( $READLINK -f "${SR_WX_APP_TOP_DIR}/Externals.cfg" )
property_name="local_path"
#
# Get the path to the workflow scripts
#
external_name=regional_workflow
HOMErrfs=$( \
get_manage_externals_config_property \
"${mng_extrns_cfg_fn}" "${external_name}" "${property_name}" ) || \
print_err_msg_exit "\
Call to function get_manage_externals_config_property failed."
HOMErrfs="${SR_WX_APP_TOP_DIR}/${HOMErrfs}"
set +x
#
# Get the base directory of the FV3 forecast model code.
#
external_name="${FCST_MODEL}"
UFS_WTHR_MDL_DIR=$( \
get_manage_externals_config_property \
"${mng_extrns_cfg_fn}" "${external_name}" "${property_name}" ) || \
print_err_msg_exit "\
Call to function get_manage_externals_config_property failed."

UFS_WTHR_MDL_DIR="${SR_WX_APP_TOP_DIR}/${UFS_WTHR_MDL_DIR}"
if [ ! -d "${UFS_WTHR_MDL_DIR}" ]; then
  print_err_msg_exit "\
The base directory in which the FV3 source code should be located
(UFS_WTHR_MDL_DIR) does not exist:
  UFS_WTHR_MDL_DIR = \"${UFS_WTHR_MDL_DIR}\"
Please clone the external repository containing the code in this directory,
build the executable, and then rerun the workflow."
fi
#
# Get the base directory of the UFS_UTILS codes.
#
external_name="ufs_utils"
UFS_UTILS_DIR=$( \
get_manage_externals_config_property \
"${mng_extrns_cfg_fn}" "${external_name}" "${property_name}" ) || \
print_err_msg_exit "\
Call to function get_manage_externals_config_property failed."

UFS_UTILS_DIR="${SR_WX_APP_TOP_DIR}/${UFS_UTILS_DIR}"
if [ ! -d "${UFS_UTILS_DIR}" ]; then
  print_err_msg_exit "\
The base directory in which the UFS utilities source codes should be lo-
cated (UFS_UTILS_DIR) does not exist:
  UFS_UTILS_DIR = \"${UFS_UTILS_DIR}\"
Please clone the external repository containing the code in this direct-
ory, build the executables, and then rerun the workflow."
fi
#
# Get the base directory of the UPP code.
#
external_name="UPP"
UPP_DIR=$( \
get_manage_externals_config_property \
"${mng_extrns_cfg_fn}" "${external_name}" "${property_name}" ) || \
print_err_msg_exit "\
Call to function get_manage_externals_config_property failed."

UPP_DIR="${SR_WX_APP_TOP_DIR}/${UPP_DIR}"
if [ ! -d "${UPP_DIR}" ]; then
  print_err_msg_exit "\
The base directory in which the UPP source code should be located
(UPP_DIR) does not exist:
  UPP_DIR = \"${UPP_DIR}\"
Please clone the external repository containing the code in this directory,
build the executable, and then rerun the workflow."
fi
#
# Define some other useful paths
#
USHDIR="$HOMErrfs/ush"
SCRIPTSDIR="$HOMErrfs/scripts"
JOBSDIR="$HOMErrfs/jobs"
SORCDIR="$HOMErrfs/sorc"
SRC_DIR="${SR_WX_APP_TOP_DIR}/src"
PARMDIR="$HOMErrfs/parm"
MODULES_DIR="$HOMErrfs/modulefiles"
EXECDIR="${SR_WX_APP_TOP_DIR}/${EXEC_SUBDIR}"
TEMPLATE_DIR="$USHDIR/templates"
#
#-----------------------------------------------------------------------
#
# Convert machine name to upper case if necessary.  Then make sure that
# MACHINE is set to a valid value.
#
#-----------------------------------------------------------------------
#
MACHINE=$( printf "%s" "$MACHINE" | $SED -e 's/\(.*\)/\U\1/' )
check_var_valid_value "MACHINE" "valid_vals_MACHINE"
#
#-----------------------------------------------------------------------
#
# Source the machine config file containing architechture information,
# queue names, and supported input file paths.
#
#-----------------------------------------------------------------------
#
machine=$(echo_lowercase "${MACHINE}")
RELATIVE_LINK_FLAG="--relative"
MACHINE_FILE=${MACHINE_FILE:-${USHDIR}/machine/${machine}.sh}
source $USHDIR/source_machine_file.sh

if [ -z "${NCORES_PER_NODE:-}" ]; then
  print_err_msg_exit "\
    NCORES_PER_NODE has not been specified in the file ${MACHINE_FILE}
    Please ensure this value has been set for your desired platform. "
fi

if [ -z "$FIXgsm" -o -z "$FIXaer" -o -z "$FIXlut" -o -z "$TOPO_DIR" -o -z "$SFC_CLIMO_INPUT_DIR" ]; then
      print_err_msg_exit "\
One or more fix file directories have not been specified for this machine:
  MACHINE = \"$MACHINE\"
  FIXgsm = \"${FIXgsm:-\"\"}
  FIXaer = \"${FIXaer:-\"\"}
  FIXlut = \"${FIXlut:-\"\"}
  TOPO_DIR = \"${TOPO_DIR:-\"\"}
  SFC_CLIMO_INPUT_DIR = \"${SFC_CLIMO_INPUT_DIR:-\"\"}
  DOMAIN_PREGEN_BASEDIR = \"${DOMAIN_PREGEN_BASEDIR:-\"\"}
You can specify the missing location(s) in ${machine_file}"
fi
#
#-----------------------------------------------------------------------
#
# Make sure COMPILER is set to a valid value.
#
#-----------------------------------------------------------------------
#
COMPILER=$(echo_lowercase "$COMPILER")
check_var_valid_value "COMPILER" "valid_vals_COMPILER"
#
#-----------------------------------------------------------------------
#
# Set the names of the build and workflow module files (if not already 
# specified by the user).  These are the files that need to be loaded 
# before building the component SRW App codes and running various workflow 
# scripts, respectively.
#
#-----------------------------------------------------------------------
#
WFLOW_MOD_FN=${WFLOW_MOD_FN:-"wflow_${machine}"}
BUILD_MOD_FN=${BUILD_MOD_FN:-"build_${machine}_${COMPILER}"}
#
#-----------------------------------------------------------------------
#
# Calculate a default value for the number of processes per node for the
# RUN_FCST_TN task.  Then set PPN_RUN_FCST to this default value if 
# PPN_RUN_FCST is not already specified by the user.
#
#-----------------------------------------------------------------------
#
ppn_run_fcst_default="$(( ${NCORES_PER_NODE} / ${OMP_NUM_THREADS_RUN_FCST} ))"
PPN_RUN_FCST=${PPN_RUN_FCST:-${ppn_run_fcst_default}}
#
#-----------------------------------------------------------------------
#
# Make sure SCHED is set to a valid value.
#
#-----------------------------------------------------------------------
#
SCHED=$(echo_lowercase "$SCHED")
check_var_valid_value "SCHED" "valid_vals_SCHED"
#
#-----------------------------------------------------------------------
#
# If we are using a workflow manager check that the ACCOUNT variable is
# not empty.
#
#-----------------------------------------------------------------------
#
if [ "$WORKFLOW_MANAGER" != "none" ]; then
  if [ -z "$ACCOUNT" ]; then
    print_err_msg_exit "\
The variable ACCOUNT cannot be empty if you are using a workflow manager:
  ACCOUNT = \"$ACCOUNT\"
  WORKFLOW_MANAGER = \"$WORKFLOW_MANAGER\""
  fi
fi
#
#-----------------------------------------------------------------------
#
# Set the grid type (GTYPE).  In general, in the FV3 code, this can take
# on one of the following values: "global", "stretch", "nest", and "re-
# gional".  The first three values are for various configurations of a
# global grid, while the last one is for a regional grid.  Since here we
# are only interested in a regional grid, GTYPE must be set to "region-
# al".
#
#-----------------------------------------------------------------------
#
GTYPE="regional"
TILE_RGNL="7"
#
#-----------------------------------------------------------------------
#
# Make sure that GTYPE is set to a valid value.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "GTYPE" "valid_vals_GTYPE"
#
#-----------------------------------------------------------------------
#
# Make sure PREDEF_GRID_NAME is set to a valid value.
#
#-----------------------------------------------------------------------
#
if [ ! -z ${PREDEF_GRID_NAME} ]; then
  err_msg="\
The predefined regional grid specified in PREDEF_GRID_NAME is not sup-
ported:
  PREDEF_GRID_NAME = \"${PREDEF_GRID_NAME}\""
  check_var_valid_value \
    "PREDEF_GRID_NAME" "valid_vals_PREDEF_GRID_NAME" "${err_msg}"
fi
#
#-----------------------------------------------------------------------
#
# Make sure that PREEXISTING_DIR_METHOD is set to a valid value.
#
#-----------------------------------------------------------------------
#
check_var_valid_value \
  "PREEXISTING_DIR_METHOD" "valid_vals_PREEXISTING_DIR_METHOD"
#
#-----------------------------------------------------------------------
#
# Make sure that FCST_MODEL is set to a valid value.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "FCST_MODEL" "valid_vals_FCST_MODEL"
#
#-----------------------------------------------------------------------
#
# Set CPL to TRUE/FALSE based on FCST_MODEL.
#
#-----------------------------------------------------------------------
#
if [ "${FCST_MODEL}" = "ufs-weather-model" ]; then
  CPL="FALSE"
elif [ "${FCST_MODEL}" = "fv3gfs_aqm" ]; then
  CPL="TRUE"
else
  print_err_msg_exit "\ 
The coupling flag CPL has not been specified for this value of FCST_MODEL:
  FCST_MODEL = \"${FCST_MODEL}\""
fi
#
#-----------------------------------------------------------------------
#
# Make sure RESTART_INTERVAL is set to an integer value if present
#
#-----------------------------------------------------------------------
#
if [[ ! "${RESTART_INTERVAL}" =~ ^[0-9]+$ ]]; then
  print_err_msg_exit "\
RESTART_INTERVAL must be set to an integer number of hours.
  RESTART_INTERVAL = \"${RESTART_INTERVAL}\""
fi
#
#-----------------------------------------------------------------------
#
# Check that DATE_FIRST_CYCL and DATE_LAST_CYCL are strings consisting 
# of exactly 8 digits.
#
#-----------------------------------------------------------------------
#
date_or_null=$( printf "%s" "${DATE_FIRST_CYCL}" | \
                $SED -n -r -e "s/^([0-9]{8})$/\1/p" )
if [ -z "${date_or_null}" ]; then
  print_err_msg_exit "\
DATE_FIRST_CYCL must be a string consisting of exactly 8 digits of the 
form \"YYYYMMDD\", where YYYY is the 4-digit year, MM is the 2-digit 
month, and DD is the 2-digit day-of-month.
  DATE_FIRST_CYCL = \"${DATE_FIRST_CYCL}\""
fi

date_or_null=$( printf "%s" "${DATE_LAST_CYCL}" | \
                $SED -n -r -e "s/^([0-9]{8})$/\1/p" )
if [ -z "${date_or_null}" ]; then
  print_err_msg_exit "\
DATE_LAST_CYCL must be a string consisting of exactly 8 digits of the 
form \"YYYYMMDD\", where YYYY is the 4-digit year, MM is the 2-digit 
month, and DD is the 2-digit day-of-month.
  DATE_LAST_CYCL = \"${DATE_LAST_CYCL}\""
fi
#
#-----------------------------------------------------------------------
#
# Check that all elements of CYCL_HRS are strings consisting of exactly
# 2 digits that are between "00" and "23", inclusive.
#
#-----------------------------------------------------------------------
#
cycl_hrs_str=$(printf "\"%s\" " "${CYCL_HRS[@]}")
cycl_hrs_str="( ${cycl_hrs_str})"

i=0
for cycl_hr in "${CYCL_HRS[@]}"; do

  cycl_hr_or_null=$( printf "%s" "${cycl_hr}" | $SED -n -r -e "s/^([0-9]{2})$/\1/p" )

  if [ -z "${cycl_hr_or_null}" ]; then
    print_err_msg_exit "\
Each element of CYCL_HRS must be a string consisting of exactly 2 digits
(including a leading \"0\", if necessary) specifying an hour-of-day.  
Element #$i of CYCL_HRS (where the index of the first element is 0) does 
not have this form:
  CYCL_HRS = ${cycl_hrs_str}
  CYCL_HRS[$i] = \"${CYCL_HRS[$i]}\""
  fi

  if [ "${cycl_hr_or_null}" -lt "0" ] || \
     [ "${cycl_hr_or_null}" -gt "23" ]; then
    print_err_msg_exit "\
Each element of CYCL_HRS must be an integer between \"00\" and \"23\", 
inclusive (including a leading \"0\", if necessary), specifying an hour-
of-day.  Element #$i of CYCL_HRS (where the index of the first element 
is 0) does not have this form:
  CYCL_HRS = ${cycl_hrs_str}
  CYCL_HRS[$i] = \"${CYCL_HRS[$i]}\""
  fi

  i=$(( $i+1 ))

done
#
#-----------------------------------------------------------------------
# Check cycle increment for cycle frequency (cycl_freq).
# only if INCR_CYCL_FREQ < 24.
#-----------------------------------------------------------------------
#
if [ "${INCR_CYCL_FREQ}" -lt "24" ] && [ "$i" -gt "1" ]; then
  cycl_intv="$(( 24/$i ))"
  cycl_intv=( $( printf "%02d " "${cycl_intv}" ) )
  INCR_CYCL_FREQ=( $( printf "%02d " "${INCR_CYCL_FREQ}" ) )
  if [ "${cycl_intv}" -ne "${INCR_CYCL_FREQ}" ]; then
    print_err_msg_exit "\
The number of CYCL_HRS does not match with that expected by INCR_CYCL_FREQ:
  INCR_CYCL_FREQ = ${INCR_CYCL_FREQ}
  cycle interval by the number of CYCL_HRS = ${cycl_intv}
  CYCL_HRS = ${cycl_hrs_str}"
  fi

  im1=$(( $i-1 ))
  for itmp in $( seq 1 ${im1} ); do
    itm1=$(( ${itmp}-1 ))
    cycl_next_itmp="$(( ${CYCL_HRS[itm1]} + ${INCR_CYCL_FREQ} ))"
    cycl_next_itmp=( $( printf "%02d " "${cycl_next_itmp}" ) )
    if [ "${cycl_next_itmp}" -ne "${CYCL_HRS[$itmp]}" ]; then
      print_err_msg_exit "\
Element #${itmp} of CYCL_HRS does not match with the increment of cycle
frequency INCR_CYCL_FREQ:
  CYCL_HRS = ${cycl_hrs_str}
  INCR_CYCL_FREQ = ${INCR_CYCL_FREQ}
  CYCL_HRS[$itmp] = \"${CYCL_HRS[$itmp]}\""
    fi
  done
fi
#
#-----------------------------------------------------------------------
#
# Call a function to generate the array ALL_CDATES containing the cycle 
# dates/hours for which to run forecasts.  The elements of this array
# will have the form YYYYMMDDHH.  They are the starting dates/times of 
# the forecasts that will be run in the experiment.  Then set NUM_CYCLES
# to the number of elements in this array.
#
#-----------------------------------------------------------------------
#
set_cycle_dates \
  date_start="${DATE_FIRST_CYCL}" \
  date_end="${DATE_LAST_CYCL}" \
  cycle_hrs="${cycl_hrs_str}" \
  incr_cycl_freq="${INCR_CYCL_FREQ}" \
  output_varname_all_cdates="ALL_CDATES"

NUM_CYCLES="${#ALL_CDATES[@]}"

if [ $NUM_CYCLES -gt 90 ] ; then
  unset ALL_CDATES
  print_info_msg "$VERBOSE" "
Too many cycles in ALL_CDATES to list, redefining in abbreviated form."
ALL_CDATES="${DATE_FIRST_CYCL}${CYCL_HRS[0]}...${DATE_LAST_CYCL}${CYCL_HRS[-1]}"
fi

#
#-----------------------------------------------------------------------
#
# If using a custom post configuration file, make sure that it exists.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "USE_CUSTOM_POST_CONFIG_FILE" "valid_vals_BOOLEAN"
USE_CUSTOM_POST_CONFIG_FILE=$(boolify "${USE_CUSTOM_POST_CONFIG_FILE}")

if [ ${USE_CUSTOM_POST_CONFIG_FILE} = "TRUE" ]; then
  if [ ! -f "${CUSTOM_POST_CONFIG_FP}" ]; then
    print_err_msg_exit "
The custom post configuration specified by CUSTOM_POST_CONFIG_FP does not 
exist:
  CUSTOM_POST_CONFIG_FP = \"${CUSTOM_POST_CONFIG_FP}\""
  fi
fi
#
#-----------------------------------------------------------------------
#
# Ensure that USE_CRTM is set to a valid value.  Then, if it is set to 
# "TRUE" (i.e. if using external CRTM fix files to allow post-processing 
# of synthetic satellite products from the UPP, make sure that the fix 
# file directory exists.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "USE_CRTM" "valid_vals_BOOLEAN"
USE_CRTM=$(boolify "${USE_CRTM}")

if [ ${USE_CRTM} = "TRUE" ]; then
  if [ ! -d "${CRTM_DIR}" ]; then
    print_err_msg_exit "
The external CRTM fix file directory specified by CRTM_DIR does not exist:
  CRTM_DIR = \"${CRTM_DIR}\""
  fi
fi
#
#-----------------------------------------------------------------------
#
# The forecast length (in integer hours) must be an integer and cannot 
# contain more than 3 digits.  Check for this.
#
#-----------------------------------------------------------------------
#
if [[ ! "${FCST_LEN_HRS}" =~ ^[0-9]{1,3}$ ]]; then
  print_err_msg_exit "\
Forecast length must be at most a 3-digit integer:
  FCST_LEN_HRS = \"${FCST_LEN_HRS}\""
fi
#
#-----------------------------------------------------------------------
#
# If running the RUN_TASK_GET_EXTRN_LBCS or RUN_FCST_TN task, first check 
# whether the lateral boundary condition update interval (LBC_SPEC_FCST_HRS, 
# in hours) contains only integers (and at least 1).  Then check whether
# the forecast length (FCST_LEN_HRS) is evenly divisible by the BC update
# interval (LBC_SPEC_INTVL_HRS).  If so, generate an array (LBC_SPEC_FCST_HRS)
# containing the forecast hours at which the lateral boundary conditions
# will be updated.  [Note that this array does not include the 0-th hour 
# initial time).]  If not, print out a warning and exit this script.  
#
#-----------------------------------------------------------------------
#
LBC_SPEC_FCST_HRS=()

if [ "${RUN_TASK_GET_EXTRN_LBCS}" = "TRUE" ] || \
   [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then

  if [[ ! "${FCST_LEN_HRS}" =~ ^[0-9]+$ ]]; then
    print_err_msg_exit "\
Forecast length must be at most a 3-digit integer:
  FCST_LEN_HRS = \"${FCST_LEN_HRS}\""
  fi

  rem=$(( ${FCST_LEN_HRS}%${LBC_SPEC_INTVL_HRS} ))
  if [ "$rem" -eq "0" ]; then
    LBC_SPEC_FCST_HRS=($( seq ${LBC_SPEC_INTVL_HRS} ${LBC_SPEC_INTVL_HRS} \
                          ${FCST_LEN_HRS} ))
  else
    print_err_msg_exit "\
The forecast length (FCST_LEN_HRS) is not evenly divisible by the lateral
boundary conditions update interval (LBC_SPEC_INTVL_HRS):
  FCST_LEN_HRS = ${FCST_LEN_HRS}
  LBC_SPEC_INTVL_HRS = ${LBC_SPEC_INTVL_HRS}
  rem = FCST_LEN_HRS%%LBC_SPEC_INTVL_HRS = $rem"
  fi

fi
#
#-----------------------------------------------------------------------
#
# If PREDEF_GRID_NAME is set to a non-empty string, set or reset native
# and write-component grid parameters according to the specified predefined 
# domain.
#
#-----------------------------------------------------------------------
#
if [ ! -z "${PREDEF_GRID_NAME}" ]; then

  set_predef_grid_params \
    predef_grid_name="${PREDEF_GRID_NAME}" \
    dt_atmos="${DT_ATMOS}" \
    layout_x="${LAYOUT_X}" \
    layout_y="${LAYOUT_Y}" \
    blocksize="${BLOCKSIZE}" \
    quilting="${QUILTING}" \
    outvarname_grid_gen_method="GRID_GEN_METHOD" \
    outvarname_esggrid_lon_ctr="ESGgrid_LON_CTR" \
    outvarname_esggrid_lat_ctr="ESGgrid_LAT_CTR" \
    outvarname_esggrid_delx="ESGgrid_DELX" \
    outvarname_esggrid_dely="ESGgrid_DELY" \
    outvarname_esggrid_nx="ESGgrid_NX" \
    outvarname_esggrid_ny="ESGgrid_NY" \
    outvarname_esggrid_pazi="ESGgrid_PAZI" \
    outvarname_esggrid_wide_halo_width="ESGgrid_WIDE_HALO_WIDTH" \
    outvarname_gfdlgrid_lon_t6_ctr="GFDLgrid_LON_T6_CTR" \
    outvarname_gfdlgrid_lat_t6_ctr="GFDLgrid_LAT_T6_CTR" \
    outvarname_gfdlgrid_stretch_fac="GFDLgrid_STRETCH_FAC" \
    outvarname_gfdlgrid_res="GFDLgrid_RES" \
    outvarname_gfdlgrid_refine_ratio="GFDLgrid_REFINE_RATIO" \
    outvarname_gfdlgrid_istart_of_rgnl_dom_on_t6g="GFDLgrid_ISTART_OF_RGNL_DOM_ON_T6G" \
    outvarname_gfdlgrid_iend_of_rgnl_dom_on_t6g="GFDLgrid_IEND_OF_RGNL_DOM_ON_T6G" \
    outvarname_gfdlgrid_jstart_of_rgnl_dom_on_t6g="GFDLgrid_JSTART_OF_RGNL_DOM_ON_T6G" \
    outvarname_gfdlgrid_jend_of_rgnl_dom_on_t6g="GFDLgrid_JEND_OF_RGNL_DOM_ON_T6G" \
    outvarname_gfdlgrid_use_gfdlgrid_res_in_filenames="GFDLgrid_USE_GFDLgrid_RES_IN_FILENAMES" \
    outvarname_dt_atmos="DT_ATMOS" \
    outvarname_layout_x="LAYOUT_X" \
    outvarname_layout_y="LAYOUT_Y" \
    outvarname_blocksize="BLOCKSIZE" \
    outvarname_wrtcmp_write_groups="WRTCMP_write_groups" \
    outvarname_wrtcmp_write_tasks_per_group="WRTCMP_write_tasks_per_group" \
    outvarname_wrtcmp_output_grid="WRTCMP_output_grid" \
    outvarname_wrtcmp_cen_lon="WRTCMP_cen_lon" \
    outvarname_wrtcmp_cen_lat="WRTCMP_cen_lat" \
    outvarname_wrtcmp_stdlat1="WRTCMP_stdlat1" \
    outvarname_wrtcmp_stdlat2="WRTCMP_stdlat2" \
    outvarname_wrtcmp_nx="WRTCMP_nx" \
    outvarname_wrtcmp_ny="WRTCMP_ny" \
    outvarname_wrtcmp_lon_lwr_left="WRTCMP_lon_lwr_left" \
    outvarname_wrtcmp_lat_lwr_left="WRTCMP_lat_lwr_left" \
    outvarname_wrtcmp_lon_upr_rght="WRTCMP_lon_upr_rght" \
    outvarname_wrtcmp_lat_upr_rght="WRTCMP_lat_upr_rght" \
    outvarname_wrtcmp_dx="WRTCMP_dx" \
    outvarname_wrtcmp_dy="WRTCMP_dy" \
    outvarname_wrtcmp_dlon="WRTCMP_dlon" \
    outvarname_wrtcmp_dlat="WRTCMP_dlat"

fi
#
#-----------------------------------------------------------------------
#
# Make sure GRID_GEN_METHOD is set to a valid value.  Note that we 
# perform this check only if running the MAKE_GRID_TN or MAKE_OROG_TN 
# tasks because these are the only tasks that need this variable to be
# defined (and we want to allow GRID_GEN_METHOD to remain undefined if
# these tasks are not being run).
#
#-----------------------------------------------------------------------
#
if [ "${RUN_TASK_MAKE_GRID}" = "TRUE" ] || \
   [ "${RUN_TASK_MAKE_OROG}" = "TRUE" ]; then 
  err_msg="\
The horizontal grid generation method specified in GRID_GEN_METHOD is 
not supported:
  GRID_GEN_METHOD = \"${GRID_GEN_METHOD}\""
  check_var_valid_value \
    "GRID_GEN_METHOD" "valid_vals_GRID_GEN_METHOD" "${err_msg}"
fi
#
#-----------------------------------------------------------------------
#
# For a "GFDLgrid" type of grid, make sure GFDLgrid_RES is set to a valid
# value.
#
#-----------------------------------------------------------------------
#
if [ "${GRID_GEN_METHOD}" = "GFDLgrid" ]; then
  err_msg="\
The number of grid cells per tile in each horizontal direction specified
in GFDLgrid_RES is not supported:
  GFDLgrid_RES = \"${GFDLgrid_RES}\""
  check_var_valid_value "GFDLgrid_RES" "valid_vals_GFDLgrid_RES" "${err_msg}"
fi
#
#-----------------------------------------------------------------------
#
# Check to make sure that various computational parameters needed by the 
# forecast model are set to valid values.  If running the RUN_FCST_TN
# task, at this point in the experiment generation, all of these should 
# have gotten set to valid values.  Also, if running the RUN_POST_TN task, 
# DT_ATMOS must at this point be set to a valid value.
#
#-----------------------------------------------------------------------
#
err_msg_suffix="\
Please set this to a valid numerical value in the user-specified experiment
configuration file EXPT_CONFIG_FN in the USHDIR directory and rerun:
  EXPT_CONFIG_FN = \"${EXPT_CONFIG_FN}\"
  USHDIR = \"$USHDIR\""

if [ "${RUN_TASK_RUN_FCST}" = "TRUE" ] || \
   [ "${RUN_TASK_RUN_POST}" = "TRUE" ]; then
  if [ -z "${DT_ATMOS}" ]; then
    print_err_msg_exit "\
The forecast model main time step (DT_ATMOS) is set to a null string:
  DT_ATMOS = ${DT_ATMOS}
${err_msg_suffix}"
  fi
fi

if [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then

  if [[ ! "${LAYOUT_X}" =~ ^[0-9]+$ ]]; then
    print_err_msg_exit "\
The number of MPI processes to be used in the x direction (LAYOUT_X) by 
the forecast job is not set to an integer:
  LAYOUT_X = \"${LAYOUT_X}\"
${err_msg_suffix}"
  fi

  if [[ ! "${LAYOUT_Y}" =~ ^[0-9]+$ ]]; then
    print_err_msg_exit "\
The number of MPI processes to be used in the y direction (LAYOUT_Y) by 
the forecast job is not set to an integer:
  LAYOUT_Y = \"${LAYOUT_Y}\"
${err_msg_suffix}"
  fi

  if [[ ! "${BLOCKSIZE}" =~ ^[0-9]+$ ]]; then
    print_err_msg_exit "\
The cache size to use for each MPI task of the forecast (BLOCKSIZE) is 
not set to an integer:
  BLOCKSIZE = \"${BLOCKSIZE}\"
${err_msg_suffix}"
  fi

fi
#
#-----------------------------------------------------------------------
#
# If performing sub-hourly model output and post-processing, check that
# the output interval DT_SUBHOURLY_POST_MNTS (in minutes) is specified
# correctly.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "SUB_HOURLY_POST" "valid_vals_BOOLEAN"
SUB_HOURLY_POST=$(boolify "${SUB_HOURLY_POST}")

if [ "${SUB_HOURLY_POST}" = "TRUE" ]; then
#
# Check that DT_SUBHOURLY_POST_MNTS is a string consisting of one or two
# digits.
#
  mnts_or_null=$( printf "%s" "${DT_SUBHOURLY_POST_MNTS}" | \
                  $SED -n -r -e "s/^([0-9])([0-9])?$/\1\2/p" )
  if [ -z "${mnts_or_null}" ]; then
    print_err_msg_exit "\
When performing sub-hourly post (i.e. SUB_HOURLY_POST set to \"TRUE\"), 
DT_SUBHOURLY_POST_MNTS must be set to a one- or two-digit integer but 
in this case is not:
  SUB_HOURLY_POST = \"${SUB_HOURLY_POST}\"
  DT_SUBHOURLY_POST_MNTS = \"${DT_SUBHOURLY_POST_MNTS}\""
  fi
#
# Check that DT_SUBHOURLY_POST_MNTS is between 0 and 59, inclusive.
#
  if [ ${DT_SUBHOURLY_POST_MNTS} -lt "0" ] || \
     [ ${DT_SUBHOURLY_POST_MNTS} -gt "59" ]; then
    print_err_msg_exit "\
When performing sub-hourly post (i.e. SUB_HOURLY_POST set to \"TRUE\"), 
DT_SUBHOURLY_POST_MNTS must be set to an integer between 0 and 59, 
inclusive but in this case is not:
  SUB_HOURLY_POST = \"${SUB_HOURLY_POST}\"
  DT_SUBHOURLY_POST_MNTS = \"${DT_SUBHOURLY_POST_MNTS}\""
  fi
#
# Check that DT_SUBHOURLY_POST_MNTS (after converting to seconds) is 
# evenly divisible by the forecast model's main time step DT_ATMOS.
#
  rem=$(( DT_SUBHOURLY_POST_MNTS*60 % DT_ATMOS ))
  if [ ${rem} -ne 0 ]; then
    print_err_msg_exit "\
When performing sub-hourly post (i.e. SUB_HOURLY_POST set to \"TRUE\"), 
the time interval specified by DT_SUBHOURLY_POST_MNTS (after converting 
to seconds) must be evenly divisible by the time step DT_ATMOS used in 
the forecast model, i.e. the remainder (rem) must be zero.  In this case, 
it is not:
  SUB_HOURLY_POST = \"${SUB_HOURLY_POST}\"
  DT_SUBHOURLY_POST_MNTS = \"${DT_SUBHOURLY_POST_MNTS}\"
  DT_ATMOS = \"${DT_ATMOS}\"
  rem = \$(( (DT_SUBHOURLY_POST_MNTS*60) %% DT_ATMOS )) = $rem
Please reset DT_SUBHOURLY_POST_MNTS and/or DT_ATMOS so that this remainder 
is zero."
  fi
#
# If DT_SUBHOURLY_POST_MNTS is set to 0 (with SUB_HOURLY_POST set to 
# "TRUE"), then we're not really performing subhourly post-processing.
# In this case, reset SUB_HOURLY_POST to "FALSE" and print out an 
# informational message that such a change was made.
#
  if [ "${DT_SUBHOURLY_POST_MNTS}" -eq "0" ]; then
    print_info_msg "\
When performing sub-hourly post (i.e. SUB_HOURLY_POST set to \"TRUE\"), 
DT_SUBHOURLY_POST_MNTS must be set to a value greater than 0; otherwise,
sub-hourly output is not really being performed:
  SUB_HOURLY_POST = \"${SUB_HOURLY_POST}\"
  DT_SUBHOURLY_POST_MNTS = \"${DT_SUBHOURLY_POST_MNTS}\"
Resetting SUB_HOURLY_POST to \"FALSE\".  If you do not want this, you 
must set DT_SUBHOURLY_POST_MNTS to something other than zero."
    SUB_HOURLY_POST="FALSE"
  fi
#
# For now, the sub-hourly capability is restricted to having values of 
# DT_SUBHOURLY_POST_MNTS that evenly divide into 60 minutes.  This is 
# because the jinja rocoto XML template (${WFLOW_XML_FN}) assumes that
# model output is generated at the top of every hour (i.e. at 00 minutes).
# This restricts DT_SUBHOURLY_POST_MNTS to the following values (inluding
# both cases with and without a leading 0):
#
#   "1" "01" "2" "02" "3" "03" "4" "04" "5" "05" "6" "06" "10" "12" "15" "20" "30"
#   
# This restriction will be removed in a future version of the workflow, 
# For now, check that DT_SUBHOURLY_POST_MNTS is one of the above values.
#
  if [ "${SUB_HOURLY_POST}" = "TRUE" ]; then
    check_var_valid_value "DT_SUBHOURLY_POST_MNTS" "valid_vals_DT_SUBHOURLY_POST_MNTS"
  fi

fi
#
#-----------------------------------------------------------------------
#
# If the base directory (EXPT_BASEDIR) in which the experiment subdirectory 
# (EXPT_SUBDIR) will be located does not start with a "/", then it is 
# either set to a null string or contains a relative directory.  In both 
# cases, prepend to it the absolute path of the default directory under 
# which the experiment directories are placed.  If EXPT_BASEDIR was set 
# to a null string, it will get reset to this default experiment directory, 
# and if it was set to a relative directory, it will get reset to an 
# absolute directory that points to the relative directory under the 
# default experiment directory.  Then create EXPT_BASEDIR if it doesn't 
# already exist.
#
#-----------------------------------------------------------------------
#
if [ "${EXPT_BASEDIR:0:1}" != "/" ]; then
  EXPT_BASEDIR="${SR_WX_APP_TOP_DIR}/../expt_dirs/${EXPT_BASEDIR}"
fi
EXPT_BASEDIR="$( $READLINK -m ${EXPT_BASEDIR} )"
mkdir_vrfy -p "${EXPT_BASEDIR}"
#
#-----------------------------------------------------------------------
#
# If the experiment subdirectory name (EXPT_SUBDIR) is set to an empty
# string, print out an error message and exit.
#
#-----------------------------------------------------------------------
#
if [ -z "${EXPT_SUBDIR}" ]; then
  print_err_msg_exit "\
The name of the experiment subdirectory (EXPT_SUBDIR) cannot be empty:
  EXPT_SUBDIR = \"${EXPT_SUBDIR}\""
fi
#
#-----------------------------------------------------------------------
#
# Set the full path to the experiment directory.  Then check if it already
# exists and if so, deal with it as specified by PREEXISTING_DIR_METHOD.
#
#-----------------------------------------------------------------------
#
EXPTDIR="${EXPT_BASEDIR}/${EXPT_SUBDIR}"
check_for_preexist_dir_file "$EXPTDIR" "${PREEXISTING_DIR_METHOD}"
#
#-----------------------------------------------------------------------
#
# Set other directories, some of which may depend on EXPTDIR (depending
# on whether we're running in NCO or community mode, i.e. whether RUN_ENVIR 
# is set to "nco" or "community").  Definitions:
#
# LOGDIR:
# Directory in which the log files from the workflow tasks will be placed.
#
# FIXam:
# This is the directory that will contain the fixed files or symlinks to
# the fixed files containing various fields on global grids (which are
# usually much coarser than the native FV3-LAM grid).
#
# FIXclim:
# This is the directory that will contain the MERRA2 aerosol climatology 
# data file and lookup tables for optics properties
#
# FIXLAM:
# This is the directory that will contain the fixed files or symlinks to
# the fixed files containing the grid, orography, and surface climatology
# on the native FV3-LAM grid.
#
# CYCLE_BASEDIR:
# The base directory in which the directories for the various cycles will
# be placed.
#
# COMROOT:
# In NCO mode, this is the full path to the "com" directory under which 
# output from the RUN_POST_TN task will be placed.  Note that this output
# is not placed directly under COMROOT but several directories further
# down.  More specifically, for a cycle starting at yyyymmddhh, it is at
#
#   $COMROOT/$NET/$model_ver/$RUN.$yyyymmdd/$hh
#
# Below, we set COMROOT in terms of PTMP as COMROOT="$PTMP/com".  COMOROOT 
# is not used by the workflow in community mode.
#
# COMOUT_BASEDIR:
# In NCO mode, this is the base directory directly under which the output 
# from the RUN_POST_TN task will be placed, i.e. it is the cycle-independent 
# portion of the RUN_POST_TN task's output directory.  It is given by
#
#   $COMROOT/$NET/$model_ver
#
# COMOUT_BASEDIR is not used by the workflow in community mode.
#
#-----------------------------------------------------------------------
#
LOGDIR="${EXPTDIR}/log"

FIXam="${EXPTDIR}/fix_am"
FIXclim="${EXPTDIR}/fix_clim"
FIXLAM="${EXPTDIR}/fix_lam"

if [ "${RUN_ENVIR}" = "nco" ]; then
  CYCLE_BASEDIR="${STMP}/tmpnwprd/${RUN}"
  check_for_preexist_dir_file "${CYCLE_BASEDIR}" "${PREEXISTING_DIR_METHOD}"
  COMROOT="${PTMP}/com"
  COMOUT_BASEDIR="${COMROOT}/${NET}/${model_ver}"
  check_for_preexist_dir_file "${COMOUT_BASEDIR}" "${PREEXISTING_DIR_METHOD}"
else
  CYCLE_BASEDIR="$EXPTDIR"
  COMROOT=""
  COMOUT_BASEDIR=""
fi
#
#-----------------------------------------------------------------------
#
# Specify default values for directories needed for verification using
# MET/METplus.
#
#-----------------------------------------------------------------------
#
METPLUS_CONF=${METPLUS_CONF:-"${TEMPLATE_DIR}/parm/metplus"}
MET_FCST_INPUT_DIR="${MET_FCST_INPUT_DIR:-$EXPTDIR}"
MET_OUTPUT_DIR="${MET_OUTPUT_DIR:-$EXPTDIR}"
#
#-----------------------------------------------------------------------
#
# If running one of the tasks that need the CCPP physics suite defined...
#
#-----------------------------------------------------------------------
#
# Initialize secondary experiment variables (i.e. those not already 
# defined in EXPT_DEFAULT_CONFIG_FN).
#
CCPP_PHYS_SUITE_FN=""
CCPP_PHYS_SUITE_IN_CCPP_FP=""
CCPP_PHYS_SUITE_FP=""
OZONE_PARAM=""
SDF_USES_RUC_LSM="FALSE"
THOMPSON_MP_CLIMO_FN=""
THOMPSON_MP_CLIMO_FP=""
SDF_USES_THOMPSON_MP="FALSE"

if [ "${RUN_TASK_MAKE_OROG}" = "TRUE" ] || \
   [ "${RUN_TASK_MAKE_ICS}" = "TRUE" ] || \
   [ "${RUN_TASK_MAKE_LBCS}" = "TRUE" ] || \
   [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then
#
# Make sure CCPP_PHYS_SUITE is set to a valid value.
#
  err_msg="\
The CCPP physics suite specified in CCPP_PHYS_SUITE is not supported:
  CCPP_PHYS_SUITE = \"${CCPP_PHYS_SUITE}\""
  check_var_valid_value \
    "CCPP_PHYS_SUITE" "valid_vals_CCPP_PHYS_SUITE" "${err_msg}"
#
# If running the RUN_FCST_TN task...
#
  if [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then
#
# Make sure that USE_MERRA_CLIMO is set to a valid value.  Then ensure
# that this flag is set to "TRUE" if the physics suite is set to
# FV3_GFS_v15_thompson_mynn_lam3km.
#
    check_var_valid_value "USE_MERRA_CLIMO" "valid_vals_BOOLEAN"
    USE_MERRA_CLIMO=$(boolify "${USE_MERRA_CLIMO}")
    if [ "${CCPP_PHYS_SUITE}" = "FV3_GFS_v15_thompson_mynn_lam3km" ]; then
      USE_MERRA_CLIMO="TRUE"
    fi
#
# Set:
#
# 1) CCPP_PHYS_SUITE_FN to the name of the CCPP physics suite definition
#    file.
# 2) CCPP_PHYS_SUITE_IN_CCPP_FP to the full path of this file in the
#    forecast model's directory structure.
# 3) CCPP_PHYS_SUITE_FP to the full path of this file in the experiment
#    directory.
#
# Note that the experiment generation scripts will copy this file from
# CCPP_PHYS_SUITE_IN_CCPP_FP to CCPP_PHYS_SUITE_FP.  Then, for each 
# cycle, the forecast launch script will create a link in the cycle run
# directory to the copy of this file at CCPP_PHYS_SUITE_FP.
#
    CCPP_PHYS_SUITE_FN="suite_${CCPP_PHYS_SUITE}.xml"
    CCPP_PHYS_SUITE_IN_CCPP_FP="${UFS_WTHR_MDL_DIR}/FV3/ccpp/suites/${CCPP_PHYS_SUITE_FN}"
    CCPP_PHYS_SUITE_FP="${EXPTDIR}/${CCPP_PHYS_SUITE_FN}"
    if [ ! -f "${CCPP_PHYS_SUITE_IN_CCPP_FP}" ]; then
      print_err_msg_exit "\
The CCPP suite definition file (CCPP_PHYS_SUITE_IN_CCPP_FP) does not 
exist in the local clone of the ufs-weather-model:
  CCPP_PHYS_SUITE_IN_CCPP_FP = \"${CCPP_PHYS_SUITE_IN_CCPP_FP}\""
    fi
#
# Call the function that sets the ozone parameterization being used in
# the physics suite and modifies associated parameters accordingly. 
#
    if [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then
      set_ozone_param \
        ccpp_phys_suite_fp="${CCPP_PHYS_SUITE_IN_CCPP_FP}" \
        output_varname_ozone_param="OZONE_PARAM"
    fi

  fi
#
# Set parameters associated with the RUC Land Surface Model (LSM).
# 
  if [ "${RUN_TASK_MAKE_ICS}" = "TRUE" ] || \
     [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then                             
#
# Call the function that checks whether the RUC land surface model (LSM)
# is being called by the physics suite and sets the workflow variable 
# SDF_USES_RUC_LSM to "TRUE" or "FALSE" accordingly.
#
    check_ruc_lsm \
      ccpp_phys_suite_fp="${CCPP_PHYS_SUITE_IN_CCPP_FP}" \
      output_varname_sdf_uses_ruc_lsm="SDF_USES_RUC_LSM"
  fi
#
# Set parameters associated with Thompson microphysics.
#
  if [ "${RUN_TASK_MAKE_ICS}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_LBCS}" = "TRUE" ] || \
     [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then
#
# Set the name of the file containing aerosol climatology data that, if
# necessary, can be used to generate approximate versions of the aerosol
# fields needed by Thompson microphysics.  This file will be used to 
# generate such approximate aerosol fields in the ICs and LBCs if Thompson 
# MP is included in the physics suite and if the exteranl model for ICs
# or LBCs does not already provide these fields.  Also, set the full path
# to this file.
#
    THOMPSON_MP_CLIMO_FN="Thompson_MP_MONTHLY_CLIMO.nc"
    THOMPSON_MP_CLIMO_FP="$FIXam/${THOMPSON_MP_CLIMO_FN}"
#
# Call the function that, if the Thompson microphysics parameterization
# is being called by the physics suite, modifies certain workflow arrays
# to ensure that fixed files needed by this parameterization are copied
# to the FIXam directory and appropriate symlinks to them are created in
# the run directories.  This function also sets the workflow variable
# SDF_USES_THOMPSON_MP that indicates whether Thompson MP is called by 
# the physics suite.
#
    set_thompson_mp_fix_files \
      ccpp_phys_suite_fp="${CCPP_PHYS_SUITE_IN_CCPP_FP}" \
      thompson_mp_climo_fn="${THOMPSON_MP_CLIMO_FN}" \
      output_varname_sdf_uses_thompson_mp="SDF_USES_THOMPSON_MP"
  
  fi

fi
#
#-----------------------------------------------------------------------
#
# Checks on and default values for user-specified verification (vx)
# parameters.
#
#-----------------------------------------------------------------------
#
# Ensure that the fields to be verified have valid values.
#
num_vx_fields="${#VX_FIELDS[@]}"
if [ "${RUN_TASKS_VXDET}" = "TRUE" -o "${RUN_TASKS_VXENS}" = "TRUE" ]; then

  if [ "${num_vx_fields}" -gt 0 ]; then
    for (( i=0; i<${num_vx_fields}; i++ )); do
      check_var_valid_value "VX_FIELDS[$i]" "valid_vals_VX_FIELDS"
    done
  else
    print_err_msg_exit "\
When deterministic or ensemble verification is enabled (via RUN_TASKS_VXDET
or RUN_TASKS_VXENS), at least one field must be specified for verification
in VX_FIELDS (i.e. VX_FIELDS cannot be empty):
  RUN_TASKS_VXDET = \"${RUN_TASKS_VXDET}\"
  RUN_TASKS_VXENS = \"${RUN_TASKS_VXENS}\"
  VX_FIELDS = ()"
  fi
#
# When verification tasks are turned off, then if VX_FIELDS is set to an
# empty array (which is considered an undefined in bash), reset it to an
# empty string to avoid "undefined variable" messages.
#
else
  if [ "${num_vx_fields}" -eq 0 ]; then
    VX_FIELDS=""
  fi
fi
#
# If APCP (accumulated precipitation) is one of the fields to be verified,
# make sure that there is at least one accumulation period specified and
# that the specified periods are valid.
# 
is_element_of "VX_FIELDS" "APCP" && {
  num_apcp_accums="${#VX_APCP_ACCUMS_HRS[@]}"
  if [ ${num_apcp_accums} -eq 0 ]; then
    print_err_msg_exit "\
When \"APCP\" is specified as one of the fields to verify (as an element
of the array VX_FIELDS), at least one valid accumulation period must be
specified in the array VX_APCP_ACCUMS_HRS:
  VX_FIELDS = ( $( printf "\"%s\" " "${VX_FIELDS[@]}" ))
  VX_APCP_ACCUMS_HRS = ( $( printf "\"%s\" " "${VX_APCP_ACCUMS_HRS[@]}" ))
Valid values for the elements of VX_APCP_ACCUMS_HRS are:
  $( printf "\"%s\" " "${valid_vals_VX_APCP_ACCUMS_HRS[@]}" )"
  fi

  for (( i=0; i<${num_apcp_accums}; i++ )); do
    check_var_valid_value "VX_APCP_ACCUMS_HRS[$i]" "valid_vals_VX_APCP_ACCUMS_HRS"
  done
}
#
# During generation of the vx tasks in the rocoto workflow xml (which
# is done in the jinja xml template by looping over all user-specified
# vx fields and accumulations), an accumulation of 00 is used to trigger
# certain actions (e.g. creation of tasks) for fields other than APCP
# (accumulated precipitation).  Thus, if the list of fields to verify
# contains any non-APCP fields (e.g. REFC, RETOP, SFC, UPA), a "00" must
# be prepended to the list of accumulations in order for the vx tasks in
# xml to be properly generated.
#
for (( i=0; i<${num_vx_fields}; i++ )); do
  vx_field="${VX_FIELDS[$i]}"
  if [ "${vx_field}" = "REFC" ] || \
     [ "${vx_field}" = "RETOP" ] || \
     [ "${vx_field}" = "SFC" ] || \
     [ "${vx_field}" = "UPA" ]; then
    VX_APCP_ACCUMS_HRS=( "00" ${VX_APCP_ACCUMS_HRS[@]} )
    break
  fi
done
#
# Default value for VX_FCST_MODEL_NAME.
#
VX_FCST_MODEL_NAME=${VX_FCST_MODEL_NAME:-${NET}.${POST_OUTPUT_DOMAIN_NAME}}
#
#-----------------------------------------------------------------------
#
# If POST_OUTPUT_DOMAIN_NAME has not been specified by the user, set it
# to PREDEF_GRID_NAME (which won't be empty if using a predefined grid).
# Then change it to lowercase.  Finally, if running one or more of the 
# tasks that require a non-empty value for POST_OUTPUT_DOMAIN_NAME, 
# ensure that it does not end up getting set to an empty string.
#
#-----------------------------------------------------------------------
#
POST_OUTPUT_DOMAIN_NAME="${POST_OUTPUT_DOMAIN_NAME:-${PREDEF_GRID_NAME}}"
POST_OUTPUT_DOMAIN_NAME=$(echo_lowercase "${POST_OUTPUT_DOMAIN_NAME}")

if [ "${RUN_TASK_RUN_FCST}" = "TRUE" ] || \
   [ "${RUN_TASK_RUN_POST}" = "TRUE" ] || \
   [ "${RUN_TASK_VX_GRIDSTAT}" = "TRUE" ] || \
   [ "${RUN_TASK_VX_POINTSTAT}" = "TRUE" ] || \
   [ "${RUN_TASKS_VXDET}" = "TRUE" ] || \
   [ "${RUN_TASKS_VXENS}" = "TRUE" ] || \
   [ "${RUN_TASK_VX_ENSGRID}" = "TRUE" ] || \
   [ "${RUN_TASK_VX_ENSPOINT}" = "TRUE" ]; then

  if [ -z "${POST_OUTPUT_DOMAIN_NAME}" ]; then
    print_err_msg_exit "\
The domain name used in naming the run_post output files (POST_OUTPUT_DOMAIN_NAME)
has not been set:
  POST_OUTPUT_DOMAIN_NAME = \"${POST_OUTPUT_DOMAIN_NAME}\"
If this experiment is not using a predefined grid (i.e. if PREDEF_GRID_NAME 
is set to a null string), POST_OUTPUT_DOMAIN_NAME must be set in the SRW 
App's configuration file (\"${EXPT_CONFIG_FN}\")."
  fi

fi
#
#-----------------------------------------------------------------------
#
# The FV3 forecast model needs the following input files in the run 
# directory to start a forecast:
#
#   (1) The data table file
#   (2) The diagnostics table file
#   (3) The field table file
#   (4) The FV3 namelist file
#   (5) The model configuration file
#   (6) The NEMS configuration file
#   (7) The CCPP physics suite definition file
#
# The workflow contains templates for the first six of these files.  
# Template files are versions of these files that contain placeholder
# (i.e. dummy) values for various parameters.  The experiment generation
# and/or the forecast task (i.e. J-job) scripts copy these templates to 
# appropriate locations in the experiment directory (e.g. to the top of 
# the experiment directory, to one of the cycle subdirectories, etc) and 
# replace the placeholders with actual values to obtain the files that 
# are used as inputs to the forecast model.
#
# Note that the CCPP physics suite defintion file (SDF) does not have a 
# corresponding template file because it does not contain any values 
# that need to be replaced according to the experiment configuration.  
# This file simply needs to be copied over from its location in the 
# forecast model's directory structure to the experiment directory.
#
# Below, we first set the names of the templates for the first six files
# listed above.  We then set the full paths to these template files.  
# Note that some of these file names depend on the physics suite while
# others do not.
#
#-----------------------------------------------------------------------
#
dot_ccpp_phys_suite_or_null="${CCPP_PHYS_SUITE:+.${CCPP_PHYS_SUITE}}"

# Names of input files that the forecast model (ufs-weather-model) expects 
# to read in.  These should only be changed if the input file names in the 
# forecast model code are changed.
#----------------------------------
DATA_TABLE_FN="data_table"
DIAG_TABLE_FN="diag_table"
FIELD_TABLE_FN="field_table"
MODEL_CONFIG_FN="model_configure"
NEMS_CONFIG_FN="nems.configure"
#----------------------------------

DATA_TABLE_TMPL_FN="${DATA_TABLE_TMPL_FN:-${DATA_TABLE_FN}}"
DIAG_TABLE_TMPL_FN="${DIAG_TABLE_TMPL_FN:-${DIAG_TABLE_FN}}${dot_ccpp_phys_suite_or_null}"
FIELD_TABLE_TMPL_FN="${FIELD_TABLE_TMPL_FN:-${FIELD_TABLE_FN}}${dot_ccpp_phys_suite_or_null}"
MODEL_CONFIG_TMPL_FN="${MODEL_CONFIG_TMPL_FN:-${MODEL_CONFIG_FN}}"
NEMS_CONFIG_TMPL_FN="${NEMS_CONFIG_TMPL_FN:-${NEMS_CONFIG_FN}}"

DATA_TABLE_TMPL_FP="${TEMPLATE_DIR}/${DATA_TABLE_TMPL_FN}"
DIAG_TABLE_TMPL_FP="${TEMPLATE_DIR}/${DIAG_TABLE_TMPL_FN}"
FIELD_TABLE_TMPL_FP="${TEMPLATE_DIR}/${FIELD_TABLE_TMPL_FN}"
FV3_NML_BASE_SUITE_FP="${TEMPLATE_DIR}/${FV3_NML_BASE_SUITE_FN}"
FV3_NML_YAML_CONFIG_FP="${TEMPLATE_DIR}/${FV3_NML_YAML_CONFIG_FN}"
FV3_NML_BASE_ENS_FP="${EXPTDIR}/${FV3_NML_BASE_ENS_FN}"
MODEL_CONFIG_TMPL_FP="${TEMPLATE_DIR}/${MODEL_CONFIG_TMPL_FN}"
NEMS_CONFIG_TMPL_FP="${TEMPLATE_DIR}/${NEMS_CONFIG_TMPL_FN}"
#
#-----------------------------------------------------------------------
#
# Set:
#
# 1) the variable FIELD_DICT_FN to the name of the field dictionary
#    file.
# 2) the variable FIELD_DICT_IN_UWM_FP to the full path of this
#    file in the forecast model's directory structure.
# 3) the variable FIELD_DICT_FP to the full path of this file in
#    the experiment directory.
#
#-----------------------------------------------------------------------
#
FIELD_DICT_FN="fd_nems.yaml"
FIELD_DICT_IN_UWM_FP="${UFS_WTHR_MDL_DIR}/tests/parm/${FIELD_DICT_FN}"
FIELD_DICT_FP="${EXPTDIR}/${FIELD_DICT_FN}"
if [ ! -f "${FIELD_DICT_IN_UWM_FP}" ]; then
  print_err_msg_exit "\
The field dictionary file (FIELD_DICT_IN_UWM_FP) does not exist
in the local clone of the ufs-weather-model:
  FIELD_DICT_IN_UWM_FP = \"${FIELD_DICT_IN_UWM_FP}\""
fi
#
#-----------------------------------------------------------------------
#
# Set the full paths to those forecast model input files that are cycle-
# independent, i.e. they don't include information about the cycle's 
# starting day/time.  These are:
#
#   * The data table file [(1) in the list above)]
#   * The field table file [(3) in the list above)]
#   * The FV3 namelist file [(4) in the list above)]
#   * The NEMS configuration file [(6) in the list above)]
#
# Since they are cycle-independent, the experiment/workflow generation
# scripts will place them in the main experiment directory (EXPTDIR).
# The script that runs each cycle will then create links to these files
# in the run directories of the individual cycles (which are subdirecto-
# ries under EXPTDIR).  
# 
# The remaining two input files to the forecast model, i.e.
#
#   * The diagnostics table file [(2) in the list above)]
#   * The model configuration file [(5) in the list above)]
#
# contain parameters that depend on the cycle start date.  Thus, custom
# versions of these two files must be generated for each cycle and then
# placed directly in the run directories of the cycles (not EXPTDIR).
# For this reason, the full paths to their locations vary by cycle and
# cannot be set here (i.e. they can only be set in the loop over the 
# cycles in the rocoto workflow XML file).
#
#-----------------------------------------------------------------------
#
DATA_TABLE_FP="${EXPTDIR}/${DATA_TABLE_FN}"
FIELD_TABLE_FP="${EXPTDIR}/${FIELD_TABLE_FN}"
FV3_NML_FN="${FV3_NML_BASE_SUITE_FN%.*}"
FV3_NML_FP="${EXPTDIR}/${FV3_NML_FN}"
NEMS_CONFIG_FP="${EXPTDIR}/${NEMS_CONFIG_FN}"
#
#-----------------------------------------------------------------------
#
# If USE_USER_STAGED_EXTRN_FILES is set to TRUE, make sure that the user-
# specified directories under which the external model files should be 
# located actually exist.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "USE_USER_STAGED_EXTRN_FILES" "valid_vals_BOOLEAN"
USE_USER_STAGED_EXTRN_FILES=$(boolify "${USE_USER_STAGED_EXTRN_FILES}")

if [ "${USE_USER_STAGED_EXTRN_FILES}" = "TRUE" ]; then

  # Check for the base directory up to the first templated field.
  if [ ! -d "$(dirname ${EXTRN_MDL_SOURCE_BASEDIR_ICS%%\$*})" ]; then
    print_err_msg_exit "\
The directory (EXTRN_MDL_SOURCE_BASEDIR_ICS) in which the user-staged 
external model files for generating ICs should be located does not exist:
  EXTRN_MDL_SOURCE_BASEDIR_ICS = \"${EXTRN_MDL_SOURCE_BASEDIR_ICS}\""
  fi

  if [ ! -d "$(dirname ${EXTRN_MDL_SOURCE_BASEDIR_LBCS%%\$*})" ]; then
    print_err_msg_exit "\
The directory (EXTRN_MDL_SOURCE_BASEDIR_LBCS) in which the user-staged 
external model files for generating LBCs should be located does not exist:
  EXTRN_MDL_SOURCE_BASEDIR_LBCS = \"${EXTRN_MDL_SOURCE_BASEDIR_LBCS}\""
  fi

fi

check_var_valid_value "NOMADS" "valid_vals_BOOLEAN"
NOMADS=$(boolify "${NOMADS}")
#
#-----------------------------------------------------------------------
#
# Make sure that IS_ENS_FCST is set to a valid value.  Then, if it is
# set to "TRUE":
#
# 1) Make sure there is at least one memeber in the ensemble.
# 2) Set the names of the ensemble members.  These will be used to set
#    the ensemble member directories.
# 3) Set the full path to the FV3 namelist file corresponding to each
#    ensemble member.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "IS_ENS_FCST" "valid_vals_BOOLEAN"
IS_ENS_FCST=$(boolify "${IS_ENS_FCST}")

NDIGITS_ENSMEM_NAMES="0"
ENSMEM_NAMES=("")
FV3_NML_ENSMEM_FPS=("")

if [ "${IS_ENS_FCST}" = "TRUE" ]; then

  if [ "${NUM_ENS_MEMBERS}" -lt 1 ]; then
    print_err_msg_exit "\
When running an ensemble forecast (or assuming staged forecast data for
verification is in an ensemble directory structure), i.e. when IS_ENS_FCST
is set to \"TRUE\", the number of ensemble members (NUM_ENS_MEMBERS) must
be greater than 0.  Current values are:
  IS_ENS_FCST = \"${IS_ENS_FCST}\"
  NUM_ENS_MEMBERS = \"${NUM_ENS_MEMBERS}\"
  RUN_TASKS_VXDET = \"${RUN_TASKS_VXDET}\"
Either reset NUM_ENS_MEMBERS to a value greater than 0 or reset IS_ENS_FCST
to \"FALSE\", then rerun."
  fi

  NDIGITS_ENSMEM_NAMES="${#NUM_ENS_MEMBERS}"
# Strip away all leading zeros in NUM_ENS_MEMBERS by converting it to a 
# decimal (leading zeros will cause bash to interpret the number as an 
# octal).  Note that the variable definitions file will therefore contain
# the version of NUM_ENS_MEMBERS with any leading zeros stripped away.
  NUM_ENS_MEMBERS="$((10#${NUM_ENS_MEMBERS}))"  
  fmt="%0${NDIGITS_ENSMEM_NAMES}d"
  for (( i=0; i<${NUM_ENS_MEMBERS}; i++ )); do
    ip1=$( printf "$fmt" $((i+1)) )
    ENSMEM_NAMES[$i]="mem${ip1}"
    FV3_NML_ENSMEM_FPS[$i]="$EXPTDIR/${FV3_NML_FN}_${ENSMEM_NAMES[$i]}"
  done

fi
#
#-----------------------------------------------------------------------
#
# If running either deterministic or ensemble vx on an ensemble forecast,
# make sure that IS_ENS_FCST is also set to "TRUE".  This causes the vx
# tasks to assume that the post-processed forecast output files (whether
# they were generated as part of the current experiment or were staged
# from the forecast output of another experiment) are in an ensemble
# directory structure (e.g. under subdirectories named "mem01", "mem02",
# etc).
#
# Note that the deterministic vx tasks assume that the post-processed
# forecast output files are in an ensemble directory structure if 
# NUM_ENS_MEMBERS is greater than 0, and the ensemble vx tasks always
# assume an ensemble directory structure.
#
#-----------------------------------------------------------------------
#
if [ "${IS_ENS_FCST}" = "FALSE" ]; then

  if [ "${RUN_TASKS_VXDET}" = "TRUE" ] && \
     [ "${NUM_ENS_MEMBERS}" -gt 0 ]; then

    print_err_msg_exit "\
When running deterministic verification on an ensemble forecast (i.e.
when RUN_TASKS_VXDET is set to \"TRUE\" and NUM_ENS_MEMBERS is greater
than 0), IS_ENS_FCST must also be set to \"TRUE\" in order for the
verification tasks to assume that the post-processed forecast output
files are in an ensemble directory structure (e.g. in subdirectories
\"mem01\", \"mem02\", etc).  Current values are:
  IS_ENS_FCST = \"${IS_ENS_FCST}\"
  NUM_ENS_MEMBERS = \"${NUM_ENS_MEMBERS}\"
  RUN_TASKS_VXDET = \"${RUN_TASKS_VXDET}\"
Reset IS_ENS_FCST to \"TRUE\" and rerun."

  elif [ "${RUN_TASKS_VXENS}" = "TRUE" ]; then

    print_err_msg_exit "\
When running ensemble verification (i.e. when RUN_TASKS_VXENS is set to
\"TRUE\"), IS_ENS_FCST must also be set to \"TRUE\" in order for the 
verification tasks to assume that the post-processed forecast output
files are in an ensemble directory structure (e.g. in subdirectories
\"mem01\", \"mem02\", etc).  Current values are:
  IS_ENS_FCST = \"${IS_ENS_FCST}\"
  RUN_TASKS_VXENS = \"${RUN_TASKS_VXENS}\"
Reset IS_ENS_FCST to \"TRUE\" and rerun."

  fi

fi
#
#-----------------------------------------------------------------------
#
# The directories in which the obs are fetched are allowed to be template
# variables.  Evaluate these templates now.
#
#-----------------------------------------------------------------------
#
CCPA_OBS_DIR=$( eval echo ${CCPA_OBS_DIR} )
MRMS_OBS_DIR=$( eval echo ${MRMS_OBS_DIR} )
NDAS_OBS_DIR=$( eval echo ${NDAS_OBS_DIR} )
#
#-----------------------------------------------------------------------
#
# Set the full path to the forecast model executable.
#
#-----------------------------------------------------------------------
#
FV3_EXEC_FP="${EXECDIR}/${FV3_EXEC_FN}"
#
#-----------------------------------------------------------------------
#
# Set the full path to the script that can be used to (re)launch the 
# workflow.  Also, if USE_CRON_TO_RELAUNCH is set to TRUE, set the line
# to add to the cron table to automatically relaunch the workflow every
# CRON_RELAUNCH_INTVL_MNTS minutes.  Otherwise, set the variable con-
# taining this line to a null string.
#
#-----------------------------------------------------------------------
#
WFLOW_LAUNCH_SCRIPT_FP="$USHDIR/${WFLOW_LAUNCH_SCRIPT_FN}"
WFLOW_LAUNCH_LOG_FP="$EXPTDIR/${WFLOW_LAUNCH_LOG_FN}"
if [ "${USE_CRON_TO_RELAUNCH}" = "TRUE" ]; then
  CRONTAB_LINE="*/${CRON_RELAUNCH_INTVL_MNTS} * * * * cd $EXPTDIR && \
./${WFLOW_LAUNCH_SCRIPT_FN} called_from_cron=\"TRUE\" >> ./${WFLOW_LAUNCH_LOG_FN} 2>&1"
else
  CRONTAB_LINE=""
fi
#
#-----------------------------------------------------------------------
#
# Set the full path to the script that, for a given task, loads the
# necessary module files and runs the tasks.
#
#-----------------------------------------------------------------------
#
LOAD_MODULES_RUN_TASK_FP="$USHDIR/load_modules_run_task.sh"
#
#-----------------------------------------------------------------------
#
# Define the various work subdirectories under the main work directory.
# Each of these corresponds to a different step/substep/task in the pre-
# processing, as follows:
#
# GRID_DIR:
# Directory in which the grid files will be placed (if RUN_TASK_MAKE_GRID 
# is set to "TRUE") or searched for (if RUN_TASK_MAKE_GRID is set to 
# "FALSE").
#
# OROG_DIR:
# Directory in which the orography files will be placed (if RUN_TASK_MAKE_OROG 
# is set to "TRUE") or searched for (if RUN_TASK_MAKE_OROG is set to 
# "FALSE").
#
# SFC_CLIMO_DIR:
# Directory in which the surface climatology files will be placed (if
# RUN_TASK_MAKE_SFC_CLIMO is set to "TRUE") or searched for (if 
# RUN_TASK_MAKE_SFC_CLIMO is set to "FALSE").
#
#----------------------------------------------------------------------
#
# Initialize flags that specify whether symlinks to the grid, orography,
# and surface climatology files should be created (that are needed by 
# other workflow tasks that will be run).
#
create_symlinks_to_grid_files="FALSE"
create_symlinks_to_orog_files="FALSE"
create_symlinks_to_sfc_climo_files="FALSE"

if [ "${RUN_ENVIR}" = "nco" ]; then

  nco_fix_dir="${DOMAIN_PREGEN_BASEDIR}/${PREDEF_GRID_NAME}"
  if [ ! -d "${nco_fix_dir}" ]; then
    print_err_msg_exit "\
The directory (nco_fix_dir) that should contain the pregenerated grid,
orography, and surface climatology files does not exist:
  nco_fix_dir = \"${nco_fix_dir}\""
  fi

  if [ "${RUN_TASK_MAKE_GRID}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_GRID}" = "FALSE" -a \
       "${GRID_DIR}" != "${nco_fix_dir}" ]; then

    msg="
When RUN_ENVIR is set to \"nco\", the workflow assumes that pregenerated
grid files already exist in the directory 

  \${DOMAIN_PREGEN_BASEDIR}/\${PREDEF_GRID_NAME}

where

  DOMAIN_PREGEN_BASEDIR = \"${DOMAIN_PREGEN_BASEDIR}\"
  PREDEF_GRID_NAME = \"${PREDEF_GRID_NAME}\"

Thus, the MAKE_GRID_TN task must not be run (i.e. RUN_TASK_MAKE_GRID must 
be set to \"FALSE\"), and the directory in which to look for the grid 
files (i.e. GRID_DIR) must be set to the one above.  Current values for 
these quantities are:

  RUN_TASK_MAKE_GRID = \"${RUN_TASK_MAKE_GRID}\"
  GRID_DIR = \"${GRID_DIR}\"

Resetting RUN_TASK_MAKE_GRID to \"FALSE\" and GRID_DIR to the one above.
Reset values are:
"

    RUN_TASK_MAKE_GRID="FALSE"
    GRID_DIR="${nco_fix_dir}"

    msg="$msg""
  RUN_TASK_MAKE_GRID = \"${RUN_TASK_MAKE_GRID}\"
  GRID_DIR = \"${GRID_DIR}\"
"
    print_info_msg "$msg"

  fi

  if [ "${RUN_TASK_MAKE_OROG}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_OROG}" = "FALSE" -a \
       "${OROG_DIR}" != "${nco_fix_dir}" ]; then

    msg="
When RUN_ENVIR is set to \"nco\", the workflow assumes that pregenerated
orography files already exist in the directory 
  \${DOMAIN_PREGEN_BASEDIR}/\${PREDEF_GRID_NAME}

where

  DOMAIN_PREGEN_BASEDIR = \"${DOMAIN_PREGEN_BASEDIR}\"
  PREDEF_GRID_NAME = \"${PREDEF_GRID_NAME}\"

Thus, the MAKE_OROG_TN task must not be run (i.e. RUN_TASK_MAKE_OROG must 
be set to \"FALSE\"), and the directory in which to look for the orography 
files (i.e. OROG_DIR) must be set to the one above.  Current values for 
these quantities are:

  RUN_TASK_MAKE_OROG = \"${RUN_TASK_MAKE_OROG}\"
  OROG_DIR = \"${OROG_DIR}\"

Resetting RUN_TASK_MAKE_OROG to \"FALSE\" and OROG_DIR to the one above.
Reset values are:
"

    RUN_TASK_MAKE_OROG="FALSE"
    OROG_DIR="${nco_fix_dir}"

    msg="$msg""
  RUN_TASK_MAKE_OROG = \"${RUN_TASK_MAKE_OROG}\"
  OROG_DIR = \"${OROG_DIR}\"
"
    print_info_msg "$msg"

  fi

  if [ "${RUN_TASK_MAKE_SFC_CLIMO}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_SFC_CLIMO}" = "FALSE" -a \
       "${SFC_CLIMO_DIR}" != "${nco_fix_dir}" ]; then

    msg="
When RUN_ENVIR is set to \"nco\", the workflow assumes that pregenerated
surface climatology files already exist in the directory 

  \${DOMAIN_PREGEN_BASEDIR}/\${PREDEF_GRID_NAME}

where

  DOMAIN_PREGEN_BASEDIR = \"${DOMAIN_PREGEN_BASEDIR}\"
  PREDEF_GRID_NAME = \"${PREDEF_GRID_NAME}\"

Thus, the MAKE_SFC_CLIMO_TN task must not be run (i.e. RUN_TASK_MAKE_SFC_CLIMO 
must be set to \"FALSE\"), and the directory in which to look for the 
surface climatology files (i.e. SFC_CLIMO_DIR) must be set to the one 
above.  Current values for these quantities are:

  RUN_TASK_MAKE_SFC_CLIMO = \"${RUN_TASK_MAKE_SFC_CLIMO}\"
  SFC_CLIMO_DIR = \"${SFC_CLIMO_DIR}\"

Resetting RUN_TASK_MAKE_SFC_CLIMO to \"FALSE\" and SFC_CLIMO_DIR to the 
one above.  Reset values are:
"

    RUN_TASK_MAKE_SFC_CLIMO="FALSE"
    SFC_CLIMO_DIR="${nco_fix_dir}"

    msg="$msg""
  RUN_TASK_MAKE_SFC_CLIMO = \"${RUN_TASK_MAKE_SFC_CLIMO}\"
  SFC_CLIMO_DIR = \"${SFC_CLIMO_DIR}\"
"
    print_info_msg "$msg"

  fi

  if [ "${RUN_TASK_VX_GRIDSTAT}" = "TRUE" ]; then

    msg="
When RUN_ENVIR is set to \"nco\", it is assumed that the verification
will not be run.
  RUN_TASK_VX_GRIDSTAT = \"${RUN_TASK_VX_GRIDSTAT}\"
Resetting RUN_TASK_VX_GRIDSTAT to \"FALSE\".  Reset value is:"

    RUN_TASK_VX_GRIDSTAT="FALSE"

    msg="$msg""
  RUN_TASK_VX_GRIDSTAT = \"${RUN_TASK_VX_GRIDSTAT}\"
"
    print_info_msg "$msg"

  fi

  if [ "${RUN_TASK_VX_POINTSTAT}" = "TRUE" ]; then

    msg="
When RUN_ENVIR is set to \"nco\", it is assumed that the verification
will not be run.
  RUN_TASK_VX_POINTSTAT = \"${RUN_TASK_VX_POINTSTAT}\"
Resetting RUN_TASK_VX_POINTSTAT to \"FALSE\"
Reset value is:"

    RUN_TASK_VX_POINTSTAT="FALSE"

    msg="$msg""
  RUN_TASK_VX_POINTSTAT = \"${RUN_TASK_VX_POINTSTAT}\"
"
    print_info_msg "$msg"

  fi

  if [ "${RUN_TASKS_VXDET}" = "TRUE" ] || \
     [ "${RUN_TASKS_VXENS}" = "TRUE" ]; then

    print_error_msg_exit "
Currently, verification cannot be run in NCO mode (i.e. when RUN_ENVIR
is set to \"nco\"):
  RUN_ENVIR = \"${RUN_ENVIR}\"
Current values of RUN_TASKS_VXDET and RUN_TASKS_VXENS are:
  RUN_TASKS_VXDET = \"${RUN_TASKS_VXDET}\"
  RUN_TASKS_VXENS = \"${RUN_TASKS_VXENS}\"
Reset these both to \"FALSE\" in the SRW App's configuration file and
rerun."

  fi
#
#-----------------------------------------------------------------------
#
# Now consider community mode.
#
#-----------------------------------------------------------------------
#
else
#
# Set flags that specify whether or not symlinks to the grid, orography,
# and surface climatology files should be created.  Such links will be
# created only if tasks that need these files are going to be run in
# the workflow.
#
  if [ "${RUN_TASK_MAKE_OROG}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_SFC_CLIMO}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_ICS}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_LBCS}" = "TRUE" ] || \
     [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then
    create_symlinks_to_grid_files="TRUE"
  fi

  if [ "${RUN_TASK_MAKE_SFC_CLIMO}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_ICS}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_LBCS}" = "TRUE" ] || \
     [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then
    create_symlinks_to_orog_files="TRUE"
  fi

  if [ "${RUN_TASK_MAKE_ICS}" = "TRUE" ] || \
     [ "${RUN_TASK_MAKE_LBCS}" = "TRUE" ]; then
    create_symlinks_to_sfc_climo_files="TRUE"
  fi
#
# If RUN_TASK_MAKE_GRID is set to "FALSE" and symlinks to pregenerated
# grid files need to be created (because there is at least one worklow
# task to be run that needs these files as input), the workflow will 
# look for these pregenerated grid files in GRID_DIR.  In this case, 
# make sure that GRID_DIR exists.  Otherwise, set it to a default location 
# under the experiment directory (EXPTDIR).
#
  if [ "${RUN_TASK_MAKE_GRID}" = "FALSE" ] && \
     [ "${create_symlinks_to_grid_files}" = "TRUE" ]; then
    if [ ! -d "${GRID_DIR}" ]; then
      print_err_msg_exit "\
The directory (GRID_DIR) that should contain the pregenerated grid files 
does not exist:
  GRID_DIR = \"${GRID_DIR}\""
    fi
  else
    GRID_DIR="$EXPTDIR/grid"
  fi
#
# Same as above but for orography files.
#
  if [ "${RUN_TASK_MAKE_OROG}" = "FALSE" ] && \
     [ "${create_symlinks_to_orog_files}" = "TRUE" ]; then
    if [ ! -d "${OROG_DIR}" ]; then
      print_err_msg_exit "\
The directory (OROG_DIR) that should contain the pregenerated orography
files does not exist:
  OROG_DIR = \"${OROG_DIR}\""
    fi
  else
    OROG_DIR="$EXPTDIR/orog"
  fi
#
# Same as above but for surface climatology files.
#
  if [ "${RUN_TASK_MAKE_SFC_CLIMO}" = "FALSE" ] && \
     [ "${create_symlinks_to_sfc_climo_files}" = "TRUE" ]; then
    if [ ! -d "${SFC_CLIMO_DIR}" ]; then
      print_err_msg_exit "\
The directory (SFC_CLIMO_DIR) that should contain the pregenerated surface
climatology files does not exist:
  SFC_CLIMO_DIR = \"${SFC_CLIMO_DIR}\""
    fi
  else
    SFC_CLIMO_DIR="$EXPTDIR/sfc_climo"
  fi

fi
#
#-----------------------------------------------------------------------
#
# Make sure EXTRN_MDL_NAME_ICS is set to a valid value.
#
#-----------------------------------------------------------------------
#
err_msg="\
The external model specified in EXTRN_MDL_NAME_ICS that provides initial
conditions (ICs) and surface fields to the FV3-LAM is not supported:
  EXTRN_MDL_NAME_ICS = \"${EXTRN_MDL_NAME_ICS}\""
check_var_valid_value \
  "EXTRN_MDL_NAME_ICS" "valid_vals_EXTRN_MDL_NAME_ICS" "${err_msg}"
#
#-----------------------------------------------------------------------
#
# Make sure EXTRN_MDL_NAME_LBCS is set to a valid value.
#
#-----------------------------------------------------------------------
#
err_msg="\
The external model specified in EXTRN_MDL_NAME_ICS that provides lateral
boundary conditions (LBCs) to the FV3-LAM is not supported:
  EXTRN_MDL_NAME_LBCS = \"${EXTRN_MDL_NAME_LBCS}\""
check_var_valid_value \
  "EXTRN_MDL_NAME_LBCS" "valid_vals_EXTRN_MDL_NAME_LBCS" "${err_msg}"
#
#-----------------------------------------------------------------------
#
# Make sure FV3GFS_FILE_FMT_ICS is set to a valid value.
#
#-----------------------------------------------------------------------
#
if [ "${EXTRN_MDL_NAME_ICS}" = "FV3GFS" ]; then
  err_msg="\
The file format for FV3GFS external model files specified in FV3GFS_-
FILE_FMT_ICS is not supported:
  FV3GFS_FILE_FMT_ICS = \"${FV3GFS_FILE_FMT_ICS}\""
  check_var_valid_value \
    "FV3GFS_FILE_FMT_ICS" "valid_vals_FV3GFS_FILE_FMT_ICS" "${err_msg}"
fi
#
#-----------------------------------------------------------------------
#
# Make sure FV3GFS_FILE_FMT_LBCS is set to a valid value.
#
#-----------------------------------------------------------------------
#
if [ "${EXTRN_MDL_NAME_LBCS}" = "FV3GFS" ]; then
  err_msg="\
The file format for FV3GFS external model files specified in FV3GFS_-
FILE_FMT_LBCS is not supported:
  FV3GFS_FILE_FMT_LBCS = \"${FV3GFS_FILE_FMT_LBCS}\""
  check_var_valid_value \
    "FV3GFS_FILE_FMT_LBCS" "valid_vals_FV3GFS_FILE_FMT_LBCS" "${err_msg}"
fi
#
#-----------------------------------------------------------------------
#
# Set cycle-independent parameters associated with the external models
# from which we will obtain the ICs and LBCs.
#
#-----------------------------------------------------------------------
#
. ./set_extrn_mdl_params.sh
#
#-----------------------------------------------------------------------
#
# Set parameters according to the type of horizontal grid generation 
# method specified.  First consider GFDL's global-parent-grid based 
# method.
#
#-----------------------------------------------------------------------
#
LON_CTR=""
LAT_CTR=""
NX=""
NY=""
NHW="6"  # This needs to be removed and moved to constants.sh.
STRETCH_FAC=""

if [ "${GRID_GEN_METHOD}" = "GFDLgrid" ]; then

  set_gridparams_GFDLgrid \
    lon_of_t6_ctr="${GFDLgrid_LON_T6_CTR}" \
    lat_of_t6_ctr="${GFDLgrid_LAT_T6_CTR}" \
    res_of_t6g="${GFDLgrid_RES}" \
    stretch_factor="${GFDLgrid_STRETCH_FAC}" \
    refine_ratio_t6g_to_t7g="${GFDLgrid_REFINE_RATIO}" \
    istart_of_t7_on_t6g="${GFDLgrid_ISTART_OF_RGNL_DOM_ON_T6G}" \
    iend_of_t7_on_t6g="${GFDLgrid_IEND_OF_RGNL_DOM_ON_T6G}" \
    jstart_of_t7_on_t6g="${GFDLgrid_JSTART_OF_RGNL_DOM_ON_T6G}" \
    jend_of_t7_on_t6g="${GFDLgrid_JEND_OF_RGNL_DOM_ON_T6G}" \
    verbose="${VERBOSE}" \
    outvarname_lon_of_t7_ctr="LON_CTR" \
    outvarname_lat_of_t7_ctr="LAT_CTR" \
    outvarname_nx_of_t7_on_t7g="NX" \
    outvarname_ny_of_t7_on_t7g="NY" \
    outvarname_halo_width_on_t7g="NHW" \
    outvarname_stretch_factor="STRETCH_FAC" \
    outvarname_istart_of_t7_with_halo_on_t6sg="ISTART_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG" \
    outvarname_iend_of_t7_with_halo_on_t6sg="IEND_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG" \
    outvarname_jstart_of_t7_with_halo_on_t6sg="JSTART_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG" \
    outvarname_jend_of_t7_with_halo_on_t6sg="JEND_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG"
#
#-----------------------------------------------------------------------
#
# Now consider Jim Purser's map projection/grid generation method.
#
#-----------------------------------------------------------------------
#
elif [ "${GRID_GEN_METHOD}" = "ESGgrid" ]; then

  set_gridparams_ESGgrid \
    lon_ctr="${ESGgrid_LON_CTR}" \
    lat_ctr="${ESGgrid_LAT_CTR}" \
    nx="${ESGgrid_NX}" \
    ny="${ESGgrid_NY}" \
    pazi="${ESGgrid_PAZI}" \
    halo_width="${ESGgrid_WIDE_HALO_WIDTH}" \
    delx="${ESGgrid_DELX}" \
    dely="${ESGgrid_DELY}" \
    outvarname_lon_ctr="LON_CTR" \
    outvarname_lat_ctr="LAT_CTR" \
    outvarname_nx="NX" \
    outvarname_ny="NY" \
    outvarname_pazi="PAZI" \
    outvarname_halo_width="NHW" \
    outvarname_stretch_factor="STRETCH_FAC" \
    outvarname_del_angle_x_sg="DEL_ANGLE_X_SG" \
    outvarname_del_angle_y_sg="DEL_ANGLE_Y_SG" \
    outvarname_neg_nx_of_dom_with_wide_halo="NEG_NX_OF_DOM_WITH_WIDE_HALO" \
    outvarname_neg_ny_of_dom_with_wide_halo="NEG_NY_OF_DOM_WITH_WIDE_HALO"

fi
#
#-----------------------------------------------------------------------
#
# Create a new experiment directory.  Note that at this point we are 
# guaranteed that there is no preexisting experiment directory. For
# platforms with no workflow manager, we need to create LOGDIR as well,
# since it won't be created later at runtime.
#
#-----------------------------------------------------------------------
#
mkdir_vrfy -p "$EXPTDIR"
mkdir_vrfy -p "$LOGDIR"
#
#-----------------------------------------------------------------------
#
# If not running the MAKE_GRID_TN, MAKE_OROG_TN, and/or MAKE_SFC_CLIMO
# tasks, create symlinks under the FIXLAM directory to pregenerated grid,
# orography, and surface climatology files.  In the process, also set 
# RES_IN_FIXLAM_FILENAMES, which is the resolution of the grid (in units
# of number of grid points on an equivalent global uniform cubed-sphere
# grid) used in the names of the fixed files in the FIXLAM directory.
#
#-----------------------------------------------------------------------
#
mkdir_vrfy -p "$FIXLAM"
RES_IN_FIXLAM_FILENAMES=""
#
#-----------------------------------------------------------------------
#
# If the grid file generation task in the workflow is not going to be
# run (because pregenerated versions of these files are available) and
# these files are needed by other workflow tasks, create links in the 
# FIXLAM directory to the pregenerated files.
#
#-----------------------------------------------------------------------
#
res_in_grid_fns=""
if [ "${RUN_TASK_MAKE_GRID}" = "FALSE" ] && \
   [ "${create_symlinks_to_grid_files}" = "TRUE" ]; then

  link_fix \
    verbose="$VERBOSE" \
    file_group="grid" \
    output_varname_res_in_filenames="res_in_grid_fns" || \
  print_err_msg_exit "\
Call to function to create links to grid files failed."

  RES_IN_FIXLAM_FILENAMES="${res_in_grid_fns}"

fi
#
#-----------------------------------------------------------------------
#
# If the orography file generation task in the workflow is not going to 
# be run (because pregenerated versions of these files are available) 
# and these files are needed by other workflow tasks, create links in
# the FIXLAM directory to the pregenerated files.
#
#-----------------------------------------------------------------------
#
res_in_orog_fns=""
if [ "${RUN_TASK_MAKE_OROG}" = "FALSE" ] && \
   [ "${create_symlinks_to_orog_files}" = "TRUE" ]; then

  link_fix \
    verbose="$VERBOSE" \
    file_group="orog" \
    output_varname_res_in_filenames="res_in_orog_fns" || \
  print_err_msg_exit "\
Call to function to create links to orography files failed."

  if [ ! -z "${RES_IN_FIXLAM_FILENAMES}" ] && \
     [ "${res_in_orog_fns}" -ne "${RES_IN_FIXLAM_FILENAMES}" ]; then
    print_err_msg_exit "\
The resolution extracted from the orography file names (res_in_orog_fns)
does not match the resolution in other groups of files already consi-
dered (RES_IN_FIXLAM_FILENAMES):
  res_in_orog_fns = ${res_in_orog_fns}
  RES_IN_FIXLAM_FILENAMES = ${RES_IN_FIXLAM_FILENAMES}"
  else
    RES_IN_FIXLAM_FILENAMES="${res_in_orog_fns}"
  fi

fi
#
#-----------------------------------------------------------------------
#
# If the surface climatology file generation task in the workflow is not
# going to be run (because pregenerated versions of these files are 
# available) and these files are needed by other workflow tasks, create
# links in the FIXLAM directory to the pregenerated files.
#
#-----------------------------------------------------------------------
#
res_in_sfc_climo_fns=""
if [ "${RUN_TASK_MAKE_SFC_CLIMO}" = "FALSE" ] && \
   [ "${create_symlinks_to_sfc_climo_files}" = "TRUE" ]; then

  link_fix \
    verbose="$VERBOSE" \
    file_group="sfc_climo" \
    output_varname_res_in_filenames="res_in_sfc_climo_fns" || \
  print_err_msg_exit "\
Call to function to create links to surface climatology files failed."

  if [ ! -z "${RES_IN_FIXLAM_FILENAMES}" ] && \
     [ "${res_in_sfc_climo_fns}" -ne "${RES_IN_FIXLAM_FILENAMES}" ]; then
    print_err_msg_exit "\
The resolution extracted from the surface climatology file names (res_-
in_sfc_climo_fns) does not match the resolution in other groups of files
already considered (RES_IN_FIXLAM_FILENAMES):
  res_in_sfc_climo_fns = ${res_in_sfc_climo_fns}
  RES_IN_FIXLAM_FILENAMES = ${RES_IN_FIXLAM_FILENAMES}"
  else
    RES_IN_FIXLAM_FILENAMES="${res_in_sfc_climo_fns}"
  fi

fi
#
#-----------------------------------------------------------------------
#
# The variable CRES is needed in constructing various file names.  If 
# not running the make_grid task, we can set it here.  Otherwise, it 
# will get set to a valid value by that task.
#
#-----------------------------------------------------------------------
#
CRES=""
if [ "${RUN_TASK_MAKE_GRID}" = "FALSE" ]; then
# Use the ":+" form of bash parameter expansion to ensure that CRES gets
# set to a non-empty string only if RES_IN_FIXLAM_FILENAMES is not empty
# or unset.
  CRES="${RES_IN_FIXLAM_FILENAMES:+C${RES_IN_FIXLAM_FILENAMES}}"
fi
#
#-----------------------------------------------------------------------
#
# Make sure various flags associated with the RUN_FCST_TN task are set 
# to valid values.
#
#-----------------------------------------------------------------------
#
check_var_valid_value "QUILTING" "valid_vals_BOOLEAN"
QUILTING=$(boolify "$QUILTING")

check_var_valid_value "PRINT_ESMF" "valid_vals_BOOLEAN"
PRINT_ESMF=$(boolify "${PRINT_ESMF}")

check_var_valid_value "WRITE_DOPOST" "valid_vals_BOOLEAN"
WRITE_DOPOST=$(boolify "${WRITE_DOPOST}")
#
#-----------------------------------------------------------------------
#
# If running the RUN_FCST_TN task ...
#
#-----------------------------------------------------------------------
#
PE_MEMBER01=""

if [ "${RUN_TASK_RUN_FCST}" = "TRUE" ]; then
#
# If performing inline post (i.e. calling UPP from within the weather
# model):
#
# 1) Turn off the RUN_POST_TN metatask since it is redundant.
# 2) If SUB_HOURLY_POST is set to "TRUE", quit out of the experiment
#    generation task since these two features (inline post and subhourly
#    model output and post-processing) currently cannot be used together.
#
  if [ "${WRITE_DOPOST}" = "TRUE" ] ; then
    RUN_TASK_RUN_POST="FALSE"
    if [ "${SUB_HOURLY_POST}" = "TRUE" ]; then
      print_err_msg_exit "\
SUB_HOURLY_POST is NOT available with Inline Post yet."
    fi
  fi
#
# Calculate PE_MEMBER01.  This is the number of MPI tasks used for the
# forecast, including those for the write component if QUILTING is set
# to "TRUE".  First, calculate its value without taking into consideration
# the processes needed for the write-component (the latter are added 
# later below).
#
  PE_MEMBER01=$(( LAYOUT_X*LAYOUT_Y ))
#
# If the write-component is going to be used to write forecast output 
# files to disk (i.e. if QUILTING is set to "TRUE")...
#
  if [ "$QUILTING" = "TRUE" ]; then
#
# Add to PE_MEMBER01 the processes needed for the write-component.
#
    PE_MEMBER01=$(( ${PE_MEMBER01} + ${WRTCMP_write_groups}*${WRTCMP_write_tasks_per_group} ))
#
# Make sure that the grid type used by the write-component (WRTCMP_output_grid) 
# is set to a valid value.
#
    err_msg="\
The coordinate system used by the write-component output grid specified
in WRTCMP_output_grid is not supported:
  WRTCMP_output_grid = \"${WRTCMP_output_grid}\""
    check_var_valid_value \
    "WRTCMP_output_grid" "valid_vals_WRTCMP_output_grid" "${err_msg}"

  fi
#
# Calculate the number of nodes (NNODES_RUN_FCST) to request from the job
# scheduler for the forecast task (RUN_FCST_TN).  This is just PE_MEMBER01
# dividied by the number of processes per node we want to request for this
# task (PPN_RUN_FCST), then rounded up to the nearest integer, i.e.
#
#   NNODES_RUN_FCST = ceil(PE_MEMBER01/PPN_RUN_FCST)
#
# where ceil(...) is the ceiling function, i.e. it rounds its floating
# point argument up to the next larger integer.  Since in bash, division
# of two integers returns a truncated integer, and since bash has no
# built-in ceil(...) function, we perform the rounding-up operation by
# adding the denominator (of the argument of ceil(...) above) minus 1 to
# the original numerator, i.e. by redefining NNODES_RUN_FCST to be
#
#   NNODES_RUN_FCST = (PE_MEMBER01 + PPN_RUN_FCST - 1)/PPN_RUN_FCST
#
  NNODES_RUN_FCST=$(( (PE_MEMBER01 + PPN_RUN_FCST - 1)/PPN_RUN_FCST ))

  print_info_msg "$VERBOSE" "
The number of MPI tasks for the ${RUN_FCST_TN} task (including those for the 
write component if it is being used) and the number of nodes are:
  PE_MEMBER01 = ${PE_MEMBER01}
  NNODES_RUN_FCST= ${NNODES_RUN_FCST}"

fi
#
#-----------------------------------------------------------------------
#
# Set the full path to the experiment's variable definitions file.  This 
# file will contain definitions of variables (in bash syntax) needed by 
# the various scripts in the workflow.
#
#-----------------------------------------------------------------------
#
GLOBAL_VAR_DEFNS_FP="$EXPTDIR/${GLOBAL_VAR_DEFNS_FN}"
#
#-----------------------------------------------------------------------
#
# Get the list of constants and their values.  The result is saved in
# the variable "constant_defns".  This will be written to the experiment's
# variable defintions file later below.
#
#-----------------------------------------------------------------------
#
print_info_msg "
Creating list of constants..." 

get_bash_file_contents fp="$USHDIR/${CONSTANTS_FN}" \
                       outvarname_contents="constant_defns"

print_info_msg "$DEBUG" "
The variable \"constant_defns\" containing definitions of various 
constants is set as follows:

${constant_defns}
"
#
#-----------------------------------------------------------------------
#
# Get the list of primary experiment variables and their default values 
# from the default experiment configuration file (EXPT_DEFAULT_CONFIG_FN).  
# By "primary", we mean those variables that are defined in the default 
# configuration file and can be reset in the user-specified experiment
# configuration file (EXPT_CONFIG_FN).  The default values will be updated 
# below to user-specified ones and the result saved in the experiment's 
# variable definitions file.
#
#-----------------------------------------------------------------------
#
print_info_msg "
Creating list of default experiment variable definitions..." 

get_bash_file_contents fp="$USHDIR/${EXPT_DEFAULT_CONFIG_FN}" \
                       outvarname_contents="default_var_defns"

print_info_msg "$DEBUG" "
The variable \"default_var_defns\" containing default values of primary 
experiment variables is set as follows:

${default_var_defns}
"
#
#-----------------------------------------------------------------------
#
# Create a list of primary experiment variable definitions containing 
# updated values.  By "updated", we mean non-default values.  Values
# may have been updated due to the presence of user-specified values in 
# the experiment configuration file (EXPT_CONFIG_FN) or due to other 
# considerations (e.g. resetting depending on the platform the App is 
# running on).
#
#-----------------------------------------------------------------------
#
print_info_msg "
Creating lists of (updated) experiment variable definitions..." 
#
# Set the flag that specifies whether or not array variables will be
# recorded in the variable definitions file on one line or one element 
# per line.  Then, if writing arrays one element per line (i.e. multiline), 
# set an escaped-newline character that needs to be included after every 
# element of each array as the newline character in order for sed to 
# write the line properly.
#
multiline_arrays="TRUE"
#multiline_arrays="FALSE"
escbksl_nl_or_null=""
if [ "${multiline_arrays}" = "TRUE" ]; then
  escbksl_nl_or_null='\\\n'
fi
#
# Loop through the lines in default_var_defns.  Reset the value of the
# variable on each line to the updated value (e.g. to a user-specified 
# value, as opposed to the default value).  The updated list of variables 
# and values will be saved in var_defns.
#
var_defns=""
while read crnt_line; do
#echo
#echo "000000000000000"
#echo "  crnt_line = |${crnt_line}|"
#
# Try to obtain the name of the variable being set on the current line.
# This will be successful only if the line consists of one or more non-
# whitespace characters representing the name of a variable followed by
# an equal sign, followed by zero or more characters representing the 
# value that the variable is being set to.  (Recall that in generating
# the variable default_var_defns, leading spaces on each line were 
# stripped out).
#
#  var_name=$( printf "%s" "${crnt_line}" | $SED -n -r -e "s/^([^ ]*)=.*/\1/p" )
#  var_name=$( printf "%s" "${crnt_line}" | $SED -n -r -e "s/^([\w]*)=.*/\1/p" )
  var_name=$( printf "%s" "${crnt_line}" | $SED -n -r -e "s/^([A-Za-z0-9_]*)=.*/\1/p" )
#echo "  var_name = |${var_name}|"
#
# If var_name is not empty, then a variable name was found on the current 
# line in default_var_defns.
#
  if [ ! -z ${var_name} ]; then

    print_info_msg "$DEBUG" "
var_name = \"${var_name}\""
#
# If the variable specified in var_name is set in the current environment 
# (to either an empty or non-empty string), get its value and save it in
# var_value.  Note that 
#
#   ${!var_name+x}
#
# will retrun the string "x" if the variable specified in var_name is 
# set (to either an empty or non-empty string), and it will return an
# empty string if the variable specified in var_name is unset (i.e. if
# it is undefined).
#
    unset "var_value"
    if [ ! -z "${!var_name+x}" ]; then
#
# The variable may be a scalar or an array.  Thus, we first treat it as
# an array and obtain the number of elements that it contains.
#
      array_name_at="${var_name}[@]"
      array=("${!array_name_at}")
      num_elems="${#array[@]}"
#
# Set var_value to the updated value of the current experiment variable.  
# How this is done depends on whether the variable is a scalar or an 
# array.
#
# If the variable contains only one element, then it is a scalar.  (It
# could be a 1-element array, but for simplicity, we treat that case as
# a scalar.)  In this case, we enclose its value in single quotes and
# save the result in var_value. No variable expansion should be
# happening from variables saved in the var_defns file.
#
      if [ "${num_elems}" -eq 1 ]; then

        var_value="${!var_name}"
        rhs="'${var_value}'"
#
# If the variable contains more than one element, then it is an array.
# In this case, we build var_value in two steps as follows:
#
# 1) Generate a string containing each element of the array in double
#    quotes and followed by a space (and followed by an optional backslash
#    and newline if multiline_arrays has been set to "TRUE").
#
# 2) Place parentheses around the double-quoted list of array elements
#    generated in the first step.  Note that there is no need to put a
#    space before the closing parenthesis because during step 1 above,
#    a space has already been placed after the last array element.
#
      else

        var_value=""
        printf -v "var_value" "%s${escbksl_nl_or_null}" ""
        for (( i=0; i<${num_elems}; i++ )); do
          printf -v "var_value" "%s${escbksl_nl_or_null}" "${var_value}\"${array[$i]}\" "
        done
        rhs="( ${var_value})"

      fi
#
# If for some reason the variable specified in var_name is not set in 
# the current environment (to either an empty or non-empty string), below
# we will still include it in the variable definitions file and simply 
# set it to a null string.  Thus, here, we set its value (var_value) to 
# an empty string).  In this case, we also issue an informational message.
#
    else

      print_info_msg "
The variable specified by \"var_name\" is not set in the current environment:
  var_name = \"${var_name}\"
Setting its value in the variable definitions file to an empty string."

      rhs="''"

    fi
#
# Set the line containing the variable's definition.  Then add the line
# to the list of all variable definitions.
#
    var_defn="${var_name}=$rhs"
    printf -v "var_defns" "%s\n" "${var_defns}${var_defn}"
#
# If var_name is empty, then a variable name was not found on the current 
# line in default_var_defns.  In this case, print out a warning and move 
# on to the next line.
#
  else

    print_info_msg "
Could not extract a variable name from the current line in \"default_var_defns\"
(probably because it does not contain an equal sign with no spaces on 
either side):
  crnt_line = \"${crnt_line}\"
  var_name = \"${var_name}\"
Continuing to next line in \"default_var_defns\"."

  fi

#if [ ! -z "${var_defn:-}" ]; then
#echo
#echo "11111111111111111"
#echo "  var_defn = |${var_defn}|"
#fi
done <<< "${default_var_defns}"
#
#-----------------------------------------------------------------------
#
# Construct the experiment's variable definitions file.  Below, we first
# record the contents we want to place in this file in the variable 
# var_defns_file_contents, and we then write the contents of this 
# variable to the file.
#
#-----------------------------------------------------------------------
#
print_info_msg "
Generating the global experiment variable definitions file specified by
GLOBAL_VAR_DEFNS_FN:
  GLOBAL_VAR_DEFNS_FN = \"${GLOBAL_VAR_DEFNS_FN}\"
Full path to this file is:
  GLOBAL_VAR_DEFNS_FP = \"${GLOBAL_VAR_DEFNS_FP}\"
For more detailed information, set DEBUG to \"TRUE\" in the experiment
configuration file (\"${EXPT_CONFIG_FN}\")."

var_defns_file_contents="\
#
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
# Section 1:
# This section contains definitions of the various constants defined in
# the file ${CONSTANTS_FN}.
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#
${constant_defns}
#
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
# Section 2:
# This section contains (most of) the primary experiment variables, i.e. 
# those variables that are defined in the default configuration file 
# (${EXPT_DEFAULT_CONFIG_FN}) and that can be reset via the user-specified 
# experiment configuration file (${EXPT_CONFIG_FN}).
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#
${var_defns}"
#
# Append derived/secondary variable definitions (as well as comments) to 
# the contents of the variable definitions file.
#
ensmem_names_str=$(printf "${escbksl_nl_or_null}\"%s\" " "${ENSMEM_NAMES[@]}")
ensmem_names_str=$(printf "( %s${escbksl_nl_or_null})" "${ensmem_names_str}")

fv3_nml_ensmem_fps_str=$(printf "${escbksl_nl_or_null}\"%s\" " "${FV3_NML_ENSMEM_FPS[@]}")
fv3_nml_ensmem_fps_str=$(printf "( %s${escbksl_nl_or_null})" "${fv3_nml_ensmem_fps_str}")

var_defns_file_contents=${var_defns_file_contents}"\
#
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
# Section 3:
# This section defines variables that have been derived from the primary
# set of experiment variables above (we refer to these as \"derived\" or
# \"secondary\" variables).
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------
#

#
#-----------------------------------------------------------------------
#
# Full path to workflow (re)launch script, its log file, and the line 
# that gets added to the cron table to launch this script if the flag 
# USE_CRON_TO_RELAUNCH is set to \"TRUE\".
#
#-----------------------------------------------------------------------
#
WFLOW_LAUNCH_SCRIPT_FP='${WFLOW_LAUNCH_SCRIPT_FP}'
WFLOW_LAUNCH_LOG_FP='${WFLOW_LAUNCH_LOG_FP}'
CRONTAB_LINE='${CRONTAB_LINE}'
#
#-----------------------------------------------------------------------
#
# Directories.
#
#-----------------------------------------------------------------------
#
SR_WX_APP_TOP_DIR='${SR_WX_APP_TOP_DIR}'
HOMErrfs='$HOMErrfs'
USHDIR='$USHDIR'
SCRIPTSDIR='$SCRIPTSDIR'
JOBSDIR='$JOBSDIR'
SORCDIR='$SORCDIR'
SRC_DIR='${SRC_DIR}'
PARMDIR='$PARMDIR'
MODULES_DIR='${MODULES_DIR}'
EXECDIR='$EXECDIR'
FIXam='$FIXam'
FIXclim='$FIXclim'
FIXLAM='$FIXLAM'
FIXgsm='$FIXgsm'
FIXaer='$FIXaer'
FIXlut='$FIXlut'
COMROOT='$COMROOT'
COMOUT_BASEDIR='${COMOUT_BASEDIR}'
TEMPLATE_DIR='${TEMPLATE_DIR}'
UFS_WTHR_MDL_DIR='${UFS_WTHR_MDL_DIR}'
UFS_UTILS_DIR='${UFS_UTILS_DIR}'
SFC_CLIMO_INPUT_DIR='${SFC_CLIMO_INPUT_DIR}'
TOPO_DIR='${TOPO_DIR}'
UPP_DIR='${UPP_DIR}'

EXPTDIR='$EXPTDIR'
LOGDIR='$LOGDIR'
CYCLE_BASEDIR='${CYCLE_BASEDIR}'
GRID_DIR='${GRID_DIR}'
OROG_DIR='${OROG_DIR}'
SFC_CLIMO_DIR='${SFC_CLIMO_DIR}'

NDIGITS_ENSMEM_NAMES='${NDIGITS_ENSMEM_NAMES}'
ENSMEM_NAMES=${ensmem_names_str}
FV3_NML_ENSMEM_FPS=${fv3_nml_ensmem_fps_str}
#
#-----------------------------------------------------------------------
#
# Files.
#
#-----------------------------------------------------------------------
#
GLOBAL_VAR_DEFNS_FP='${GLOBAL_VAR_DEFNS_FP}'

DATA_TABLE_FN='${DATA_TABLE_FN}'
DIAG_TABLE_FN='${DIAG_TABLE_FN}'
FIELD_TABLE_FN='${FIELD_TABLE_FN}'
MODEL_CONFIG_FN='${MODEL_CONFIG_FN}'
NEMS_CONFIG_FN='${NEMS_CONFIG_FN}'

DATA_TABLE_TMPL_FP='${DATA_TABLE_TMPL_FP}'
DIAG_TABLE_TMPL_FP='${DIAG_TABLE_TMPL_FP}'
FIELD_TABLE_TMPL_FP='${FIELD_TABLE_TMPL_FP}'
FV3_NML_BASE_SUITE_FP='${FV3_NML_BASE_SUITE_FP}'
FV3_NML_YAML_CONFIG_FP='${FV3_NML_YAML_CONFIG_FP}'
FV3_NML_BASE_ENS_FP='${FV3_NML_BASE_ENS_FP}'
MODEL_CONFIG_TMPL_FP='${MODEL_CONFIG_TMPL_FP}'
NEMS_CONFIG_TMPL_FP='${NEMS_CONFIG_TMPL_FP}'

CCPP_PHYS_SUITE_FN='${CCPP_PHYS_SUITE_FN}'
CCPP_PHYS_SUITE_IN_CCPP_FP='${CCPP_PHYS_SUITE_IN_CCPP_FP}'
CCPP_PHYS_SUITE_FP='${CCPP_PHYS_SUITE_FP}'

FIELD_DICT_FN='${FIELD_DICT_FN}'
FIELD_DICT_IN_UWM_FP='${FIELD_DICT_IN_UWM_FP}'
FIELD_DICT_FP='${FIELD_DICT_FP}'

DATA_TABLE_FP='${DATA_TABLE_FP}'
FIELD_TABLE_FP='${FIELD_TABLE_FP}'
FV3_NML_FN='${FV3_NML_FN}'
FV3_NML_FP='${FV3_NML_FP}'
NEMS_CONFIG_FP='${NEMS_CONFIG_FP}'

FV3_EXEC_FP='${FV3_EXEC_FP}'

LOAD_MODULES_RUN_TASK_FP='${LOAD_MODULES_RUN_TASK_FP}'

THOMPSON_MP_CLIMO_FN='${THOMPSON_MP_CLIMO_FN}'
THOMPSON_MP_CLIMO_FP='${THOMPSON_MP_CLIMO_FP}'
#
#-----------------------------------------------------------------------
#
# Flag for creating relative symlinks (as opposed to absolute ones).
#
#-----------------------------------------------------------------------
#
RELATIVE_LINK_FLAG='${RELATIVE_LINK_FLAG}'
#
#-----------------------------------------------------------------------
#
# Parameters that indicate whether or not various parameterizations are 
# included in and called by the physics suite.
#
#-----------------------------------------------------------------------
#
SDF_USES_RUC_LSM='${SDF_USES_RUC_LSM}'
SDF_USES_THOMPSON_MP='${SDF_USES_THOMPSON_MP}'
#
#-----------------------------------------------------------------------
#
# Grid configuration parameters needed regardless of grid generation
# method used.
#
#-----------------------------------------------------------------------
#
GTYPE='$GTYPE'
TILE_RGNL='${TILE_RGNL}'

LON_CTR='${LON_CTR}'
LAT_CTR='${LAT_CTR}'
NX='${NX}'
NY='${NY}'
NHW='${NHW}'
STRETCH_FAC='${STRETCH_FAC}'

RES_IN_FIXLAM_FILENAMES='${RES_IN_FIXLAM_FILENAMES}'
#
# If running the make_grid task, CRES will be set to a null string during
# the grid generation step.  It will later be set to an actual value after
# the make_grid task is complete.
#
CRES='$CRES'
"
#
#-----------------------------------------------------------------------
#
# Append to the variable definitions file the defintions of grid parameters
# that are specific to the grid generation method used.
#
#-----------------------------------------------------------------------
#
grid_vars_str=""
if [ "${GRID_GEN_METHOD}" = "GFDLgrid" ]; then

  grid_vars_str="\
#
#-----------------------------------------------------------------------
#
# Grid configuration parameters for a regional grid generated from a
# global parent cubed-sphere grid.  This is the method originally 
# suggested by GFDL since it allows GFDL's nested grid generator to be 
# used to generate a regional grid.  However, for large regional domains, 
# it results in grids that have an unacceptably large range of cell sizes
# (i.e. ratio of maximum to minimum cell size is not sufficiently close
# to 1).
#
#-----------------------------------------------------------------------
#
ISTART_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG='${ISTART_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG}'
IEND_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG='${IEND_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG}'
JSTART_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG='${JSTART_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG}'
JEND_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG='${JEND_OF_RGNL_DOM_WITH_WIDE_HALO_ON_T6SG}'
"

elif [ "${GRID_GEN_METHOD}" = "ESGgrid" ]; then

  grid_vars_str="\
#
#-----------------------------------------------------------------------
#
# Grid configuration parameters for a regional grid generated independently 
# of a global parent grid.  This method was developed by Jim Purser of 
# EMC and results in very uniform grids (i.e. ratio of maximum to minimum 
# cell size is very close to 1).
#
#-----------------------------------------------------------------------
#
DEL_ANGLE_X_SG='${DEL_ANGLE_X_SG}'
DEL_ANGLE_Y_SG='${DEL_ANGLE_Y_SG}'
NEG_NX_OF_DOM_WITH_WIDE_HALO='${NEG_NX_OF_DOM_WITH_WIDE_HALO}'
NEG_NY_OF_DOM_WITH_WIDE_HALO='${NEG_NY_OF_DOM_WITH_WIDE_HALO}'
PAZI='${PAZI}'
"

fi
var_defns_file_contents="${var_defns_file_contents}${grid_vars_str}"
#
#-----------------------------------------------------------------------
#
# Continue appending variable definitions to the variable definitions 
# file.
#
#-----------------------------------------------------------------------
#
lbc_spec_fcst_hrs_str=$(printf "${escbksl_nl_or_null}\"%s\" " "${LBC_SPEC_FCST_HRS[@]}")
lbc_spec_fcst_hrs_str=$(printf "( %s${escbksl_nl_or_null})" "${lbc_spec_fcst_hrs_str}")

all_cdates_str=$(printf "${escbksl_nl_or_null}\"%s\" " "${ALL_CDATES[@]}")
all_cdates_str=$(printf "( %s${escbksl_nl_or_null})" "${all_cdates_str}")

var_defns_file_contents=${var_defns_file_contents}"\
#
#-----------------------------------------------------------------------
#
# Flag in the \"${MODEL_CONFIG_FN}\" file for coupling the ocean model to 
# the weather model.
#
#-----------------------------------------------------------------------
#
CPL='${CPL}'
#
#-----------------------------------------------------------------------
#
# Name of the ozone parameterization.  The value this gets set to depends 
# on the CCPP physics suite being used.
#
#-----------------------------------------------------------------------
#
OZONE_PARAM='${OZONE_PARAM}'
#
#-----------------------------------------------------------------------
#
# If USE_USER_STAGED_EXTRN_FILES is set to \"FALSE\", this is the system 
# directory in which the workflow scripts will look for the files generated 
# by the external model specified in EXTRN_MDL_NAME_ICS.  These files will 
# be used to generate the input initial condition and surface files for 
# the FV3-LAM.
#
#-----------------------------------------------------------------------
#
EXTRN_MDL_SYSBASEDIR_ICS='${EXTRN_MDL_SYSBASEDIR_ICS}'
#
#-----------------------------------------------------------------------
#
# If USE_USER_STAGED_EXTRN_FILES is set to \"FALSE\", this is the system 
# directory in which the workflow scripts will look for the files generated 
# by the external model specified in EXTRN_MDL_NAME_LBCS.  These files 
# will be used to generate the input lateral boundary condition files for 
# the FV3-LAM.
#
#-----------------------------------------------------------------------
#
EXTRN_MDL_SYSBASEDIR_LBCS='${EXTRN_MDL_SYSBASEDIR_LBCS}'
#
#-----------------------------------------------------------------------
#
# Shift back in time (in units of hours) of the starting time of the ex-
# ternal model specified in EXTRN_MDL_NAME_LBCS.
#
#-----------------------------------------------------------------------
#
EXTRN_MDL_LBCS_OFFSET_HRS='${EXTRN_MDL_LBCS_OFFSET_HRS}'
#
#-----------------------------------------------------------------------
#
# Boundary condition update times (in units of forecast hours).  Note that
# LBC_SPEC_FCST_HRS is an array, even if it has only one element.
#
#-----------------------------------------------------------------------
#
LBC_SPEC_FCST_HRS=${lbc_spec_fcst_hrs_str}
#
#-----------------------------------------------------------------------
#
# The number of cycles for which to make forecasts and the list of 
# starting dates/hours of these cycles.
#
#-----------------------------------------------------------------------
#
NUM_CYCLES='${NUM_CYCLES}'
ALL_CDATES=${all_cdates_str}
#
#-----------------------------------------------------------------------
#
# Parameters that determine whether FVCOM data will be used, and if so, 
# their location.
#
# If USE_FVCOM is set to \"TRUE\", then FVCOM data (in the file FVCOM_FILE
# located in the directory FVCOM_DIR) will be used to update the surface 
# boundary conditions during the initial conditions generation task 
# (MAKE_ICS_TN).
#
#-----------------------------------------------------------------------
#
USE_FVCOM='${USE_FVCOM}'
FVCOM_DIR='${FVCOM_DIR}'
FVCOM_FILE='${FVCOM_FILE}'
#
#-----------------------------------------------------------------------
#
# Computational parameters.
#
#-----------------------------------------------------------------------
#
NCORES_PER_NODE='${NCORES_PER_NODE}'
PE_MEMBER01='${PE_MEMBER01}'
#
#-----------------------------------------------------------------------
#
# IF DO_SPP is set to "TRUE", N_VAR_SPP specifies the number of physics 
# parameterizations that are perturbed with SPP.  If DO_LSM_SPP is set to
# "TRUE", N_VAR_LNDP specifies the number of LSM parameters that are 
# perturbed.  LNDP_TYPE determines the way LSM perturbations are employed
# and FHCYC_LSM_SPP_OR_NOT sets FHCYC based on whether LSM perturbations
# are turned on or not.
#
#-----------------------------------------------------------------------
#
N_VAR_SPP='${N_VAR_SPP}'
N_VAR_LNDP='${N_VAR_LNDP}'
LNDP_TYPE='${LNDP_TYPE}'
FHCYC_LSM_SPP_OR_NOT='${FHCYC_LSM_SPP_OR_NOT}'
"
#
# Done with constructing the contents of the variable definitions file,
# so now write the contents to file.
#
printf "%s\n" "${var_defns_file_contents}" >> ${GLOBAL_VAR_DEFNS_FP}

print_info_msg "$VERBOSE" "
Done generating the global experiment variable definitions file."
#
#-----------------------------------------------------------------------
#
# Print message indicating successful completion of script.
#
#-----------------------------------------------------------------------
#
print_info_msg "
========================================================================
Function ${func_name}() in \"${scrfunc_fn}\" completed successfully!!!
========================================================================"
#
#-----------------------------------------------------------------------
#
# Restore the shell options saved at the start of this script/function.
#
#-----------------------------------------------------------------------
#
{ restore_shell_opts; } > /dev/null 2>&1

}
#
#-----------------------------------------------------------------------
#
# Call the function defined above.
#
#-----------------------------------------------------------------------
#
setup


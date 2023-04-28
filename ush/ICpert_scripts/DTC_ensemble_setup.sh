#!/bin/bash

# Treat undefined variables as errors.
set -u
# Print out all commands to screen.
#set -x

#
# Absolute path, file name, and directory of current script/function.
#
scrfunc_fp=$( readlink -f "${BASH_SOURCE[0]}" )
scrfunc_fn=$( basename "${scrfunc_fp}" )
scrfunc_dir=$( dirname "${scrfunc_fp}" )

echo
echo "scrfunc_fp = \"${scrfunc_fp}\""
echo "scrfunc_fn = \"${scrfunc_fn}\""
echo "scrfunc_dir = \"${scrfunc_dir}\""
#
#-----------------------------------------------------------------------
#
# Set various useful directory variables.
#
#-----------------------------------------------------------------------
#
srwapp_homedir=$( readlink -f "${scrfunc_dir}/../../.." )
ushdir="${srwapp_homedir}/regional_workflow/ush"
icpert_scripts_dir="${ushdir}/ICpert_scripts"
expt_basedir=$( readlink -f "${srwapp_homedir}/../expt_dirs" )

echo
echo "srwapp_homedir = \"${srwapp_homedir}\""
echo "ushdir = \"${ushdir}\""
echo "icpert_scripts_dir = \"${icpert_scripts_dir}\""
echo "expt_basedir = \"${expt_basedir}\""
#
#-----------------------------------------------------------------------
#
# Source the DTC Ensemble Design Task's default configuration file.  If
# a custom configuration file exists, source that as well.  Finally,
# source the bash utilities.
#
#-----------------------------------------------------------------------
#
source "${icpert_scripts_dir}/DTC_ensemble_config_defaults.sh"
if [ -f "${icpert_scripts_dir}/DTC_ensemble_config.sh" ]; then
  source "${icpert_scripts_dir}/DTC_ensemble_config.sh"
fi
source "${ushdir}/source_util_funcs.sh"

echo
echo "do_test_run = \"${do_test_run}\""
echo "RRFS_do_stoch = \"${RRFS_do_stoch}\""
echo "RRFS_do_get_obs = \"${RRFS_do_get_obs}\""
echo "GEFS_staging_dir = \"${GEFS_staging_dir}\""
echo "obs_basedir = \"${obs_basedir}\""
#
#-----------------------------------------------------------------------
#
# Make sure that required environment variables are defined and, if 
# applicable, have valid values.
#
#-----------------------------------------------------------------------
#
if [ -z ${do_test_run+x} ] || \
   [ -z ${RRFS_do_stoch+x} ] || \
   [ -z ${RRFS_do_get_obs+x} ]; then
  print_err_msg_exit "
One or more of the following required environment variables are undefined:
  do_test_run = ${do_test_run:-"<undefined>"}
  RRFS_do_stoch = ${RRFS_do_stoch:-"<undefined>"}
  RRFS_do_get_obs = ${RRFS_do_get_obs:-"<undefined>"}
"
fi

check_var_valid_value "do_test_run" "valid_vals_BOOLEAN"
check_var_valid_value "RRFS_do_stoch" "valid_vals_BOOLEAN"
check_var_valid_value "RRFS_do_get_obs" "valid_vals_BOOLEAN"
#
#-----------------------------------------------------------------------
#
# Set secondary variables based on above settings.
#
#-----------------------------------------------------------------------
#
# Variable for naming experiments depending on whether a test run is
# being performed.
#
uscore_test_or_null=""
if [ "${do_test_run}" = "TRUE" ]; then
  uscore_test_or_null="_test"
fi
#
# Predefined grid, range of cycles, forecast length, and number of (RRFS)
# ensemble members.
#
date_first_cycl="20220430"
if [ "${do_test_run}" = "TRUE" ]; then
  predef_grid_name=${predef_grid_name:-"RRFS_CONUScompact_25km"}
  date_last_cycl=${date_last_cycl:-"20220430"}
  fcst_len_hrs=${fcst_len_hrs:-"6"}
  num_RRFS_ens_members=${num_RRFS_ens_members:-"03"}
else
  predef_grid_name=${predef_grid_name:-"RRFS_CONUScompact_3km"}
  date_last_cycl=${date_last_cycl:-"20220512"}
  fcst_len_hrs=${fcst_len_hrs:-"36"}
  num_RRFS_ens_members=${num_RRFS_ens_members:-"10"}
fi
#
# Array containing all the cycles for which the RRFS analog experiment
# will be run.
#
all_cycles=( $(eval echo ${date_first_cycl}00 ${date_last_cycl:0:6}{01..12}00) )
if [ "${do_test_run}" = "TRUE" ]; then
  all_cycles=( $(eval echo ${date_first_cycl}00 ) )
fi

echo
echo "uscore_test_or_null = \"${uscore_test_or_null}\""
echo "predef_grid_name = \"${predef_grid_name}\""
echo "date_first_cycl = \"${date_first_cycl}\""
echo "date_last_cycl = \"${date_last_cycl}\""
echo "fcst_len_hrs = \"${fcst_len_hrs}\""
echo "num_RRFS_ens_members = \"${num_RRFS_ens_members}\""
echo "all_cycles = ( ${all_cycles[@]} )"
#
#-----------------------------------------------------------------------
#
# Variables needed by RRFS analog experiment.
#
#-----------------------------------------------------------------------
#
if [ "${RRFS_do_stoch}" = "TRUE" ]; then
  RRFS_no_or_null=""
else
  RRFS_no_or_null="no"
fi
#
# Absolute paths to the RRFS analog (either without or with stochastic
# IC perturbations) workflow and to the GEFS individual member workflows.
#
RRFS_analog_expt_subdir="RRFS_ICperts_${RRFS_no_or_null}stoch${uscore_test_or_null}"
RRFS_analog_exptdir="${expt_basedir}/${RRFS_analog_expt_subdir}"

echo
echo "RRFS_no_or_null = \"${RRFS_no_or_null}\""
echo "RRFS_analog_expt_subdir = \"${RRFS_analog_expt_subdir}\""
echo "RRFS_analog_exptdir = \"${RRFS_analog_exptdir}\""
#
#-----------------------------------------------------------------------
#
# Parameters needed when creating and running GEFS individual member
# workflows.
#
#-----------------------------------------------------------------------
#
# Base experiment directory under which the experiment subdirectories
# for individual GEFS members will be created.
#
GEFS_expt_basedir="${expt_basedir}"
#
# List of all ensemble members for which an (non-ensemble) experiment
# will be generated.  Each member experiment will be used to generate
# initial conditions on the native RRFS grid from the GEFS external
# model file for that member.  Note that to emulate what is being done
# in the RRFS (i.e. for the RRFS analogs we're running to be as similar
# as possible to the actual RRFS), we take GEFS members 01 through 
# num_RRFS_ens_members-1, where num_RRFS_ens_members is the number of
# RRFS ensemble members.  Note also that member 01 of the RRFS is the
# unperturbed control forecast to which no IC or stochastic physics
# perturbations are applied.
#
nm1=$( printf "%02d" $((10#${num_RRFS_ens_members}-1)) )
# Important note:
# When using the bashism "{$start..$end} to create an array, there must
# be no spaces between the opening { and the starting digit and no spaces
# between the ending digit and the closing }.
GEFS_all_mems=( $(eval echo "{01..${nm1}}" ) )

echo
echo "GEFS_expt_basedir = \"${GEFS_expt_basedir}\""
echo "GEFS_all_mems = ( ${GEFS_all_mems[@]} )"
#
#-----------------------------------------------------------------------
#
# Export variables set above for use by scripts that source this script.
#
#-----------------------------------------------------------------------
#
export srwapp_homedir \
       ushdir \
       icpert_scripts_dir \
       expt_basedir \
       GEFS_staging_dir \
       obs_basedir \
\
       do_test_run \
       uscore_test_or_null \
       account \
       date_first_cycl \
       date_last_cycl \
       fcst_len_hrs \
       predef_grid_name \
       num_RRFS_ens_members \
       all_cycles \
\
       RRFS_do_stoch \
       RRFS_do_get_obs \
       RRFS_no_or_null \
       RRFS_analog_expt_subdir \
       RRFS_analog_exptdir \
\
       GEFS_all_mems \
       GEFS_expt_basedir


#!/bin/bash

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
# Load modules.
#
module load intel/2022.1.2
module load nco
#
# Source the DTC Ensemble Design task setup file.
#
source "${scrfunc_dir}/DTC_ensemble_setup.sh"
#
# Load a conda environment that has the netcdf4 python package needed in
# the python scripts that the shell scripts below call.  This needs to
# be done here because the default regional_workflow conda environment
# does not contain the netcdf4 python package.
#
source "${icpert_scripts_dir}/conda_setup.sh"
#
# Bash arrays to make it possible to loop through different file types.
#
file_groups=("gfs_data" "sfc_data" "gfs_bndy")
halo0_or_000_array=("halo0" "halo0" "000")
#
# Define the directories in which the GEFS ensemble means and perturbations
# (on the SRW/RRFS native grid) will be stored.  Then, if they already
# exist, move (rename) them and start with empty ones.
#
ens_means_dir="${GEFS_expt_basedir}/ens_means"
ens_perts_dir="${GEFS_expt_basedir}/ens_perts"

export VERBOSE="TRUE"
check_for_preexist_dir_file "${ens_means_dir}" "rename"
check_for_preexist_dir_file "${ens_perts_dir}" "rename"

mkdir -p "${ens_means_dir}"
mkdir -p "${ens_perts_dir}"
#
# Use the output from the make_ics task of the GEFS member workflows to
# calculate the means and perturbations of the GEFS fields.
#
source "${icpert_scripts_dir}/calc_GEFS_means_perts.sh"
#
# Interpolate certain soil parameters in the GEFS perturbations from the
# 4 soil layers in the GEFS data to the 9 soil layers in the HRRR data.
#
source "${icpert_scripts_dir}/add_soil_layers.sh"
#
# Apply the GEFS perturbations calculated above to the existing HRRR ICs
# files in the RRFS analog workflow (which should already be created).
#
source "${icpert_scripts_dir}/apply_GEFS_perts_to_HRRR.sh"


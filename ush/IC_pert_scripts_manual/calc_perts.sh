#!/bin/bash

set -x

module load intel/2022.1.2
module load nco

#match this to the expt subdir in config.sh_IC_perts_GEFS
#GEFS_expt_dir=/scratch2/BMC/fv3lam/ens_design_RRFS/expt_dirs_GEFS_perts
GEFS_expt_dir=/scratch2/BMC/fv3lam/mayfield/ens_IC_pert_test/expt_dirs_GEFS_perts

cd $GEFS_expt_dir

mkdir ens_mean
mkdir ens_perts

# calculate ensemble means
#for cyc in 202205{27..31} 202206{01..09} ; do
#for cyc in 20220430 202205{01..12} ; do
for cyc in 20220430 ; do
    nces -O GEFS_mem{01..09}/${cyc}00/INPUT/gfs_data.tile7.halo0.nc ens_mean/${cyc}00_ens_mean_gfs_data.tile7.halo0.nc
    nces -O GEFS_mem{01..09}/${cyc}00/INPUT/sfc_data.tile7.halo0.nc ens_mean/${cyc}00_ens_mean_sfc_data.tile7.halo0.nc
    nces -O GEFS_mem{01..09}/${cyc}00/INPUT/gfs_bndy.tile7.000.nc ens_mean/${cyc}00_ens_mean_gfs_bndy.tile7.000.nc
done

wait

# calculate perturbations (member minus mean)
#for cyc in 202205{27..31} 202206{01..09} ; do
#for cyc in 20220430 202205{01..12} ; do
for cyc in 20220430 ; do
    for mem in {01..09} ; do
        ncdiff GEFS_mem${mem}/${cyc}00/INPUT/gfs_data.tile7.halo0.nc ens_mean/${cyc}00_ens_mean_gfs_data.tile7.halo0.nc ens_perts/${cyc}00_GEFS_pert_mem${mem}_gfs_data.tile7.halo0.nc
        ncdiff GEFS_mem${mem}/${cyc}00/INPUT/sfc_data.tile7.halo0.nc ens_mean/${cyc}00_ens_mean_sfc_data.tile7.halo0.nc ens_perts/${cyc}00_GEFS_pert_mem${mem}_sfc_data.tile7.halo0.nc
        ncdiff GEFS_mem${mem}/${cyc}00/INPUT/gfs_bndy.tile7.000.nc ens_mean/${cyc}00_ens_mean_gfs_bndy.tile7.000.nc ens_perts/${cyc}00_GEFS_pert_mem${mem}_gfs_bndy.tile7.000.nc
    done
done

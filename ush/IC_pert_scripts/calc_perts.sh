#!/bin/bash

set -x

module load intel/2022.1.2
module load nco

mkdir ens_mean
mkdir ens_perts

# calculate ensemble means
for cyc in 202205{27..31} 202206{01..09} ; do
    nces -O GEFS_mem{01..09}/${cyc}18/INPUT/gfs_data.tile7.halo0.nc ens_mean/${cyc}18_ens_mean_gfs_data.tile7.halo0.nc
    nces -O GEFS_mem{01..09}/${cyc}18/INPUT/sfc_data.tile7.halo0.nc ens_mean/${cyc}18_ens_mean_sfc_data.tile7.halo0.nc
    nces -O GEFS_mem{01..09}/${cyc}18/INPUT/gfs_bndy.tile7.000.nc ens_mean/${cyc}18_ens_mean_gfs_bndy.tile7.000.nc
done

# calculate perturbations (member minus mean)
for cyc in 202205{27..31} 202206{01..09} ; do
    for mem in {01..09} ; do
        ncdiff GEFS_mem${mem}/${cyc}18/INPUT/gfs_data.tile7.halo0.nc ens_mean/${cyc}18_ens_mean_gfs_data.tile7.halo0.nc ens_perts/${cyc}18_GEFS_pert_mem${mem}_gfs_data.tile7.halo0.nc
        ncdiff GEFS_mem${mem}/${cyc}18/INPUT/sfc_data.tile7.halo0.nc ens_mean/${cyc}18_ens_mean_sfc_data.tile7.halo0.nc ens_perts/${cyc}18_GEFS_pert_mem${mem}_sfc_data.tile7.halo0.nc
        ncdiff GEFS_mem${mem}/${cyc}18/INPUT/gfs_bndy.tile7.000.nc ens_mean/${cyc}18_ens_mean_gfs_bndy.tile7.000.nc ens_perts/${cyc}18_GEFS_pert_mem${mem}_gfs_bndy.tile7.000.nc
    done
done

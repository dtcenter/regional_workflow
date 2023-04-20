#!/bin/bash --login

set -x

module load intel/2022.1.2

#expt_dir_perts=/scratch2/BMC/fv3lam/ens_design_RRFS/expt_dirs_IC_perts
expt_dir_perts=/scratch2/BMC/fv3lam/mayfield/ens_IC_pert_test/expt_dirs_GEFS_perts

cp soil_regrid.py $expt_dir_perts

#for cyc in 202205{27..31} 202206{01..09} ; do
#for cyc in 20220430 202205{01..12} ; do
for cyc in 20220430 ; do
    for mem in {01..09} ; do
        python ${expt_dir_perts}/soil_regrid.py ${expt_dir_perts}/ens_perts/${cyc}00_GEFS_pert_mem${mem}_sfc_data.tile7.halo0.nc 
    done
done


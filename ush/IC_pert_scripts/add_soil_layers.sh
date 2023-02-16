#!/bin/bash --login

set -x

module load intel/2022.1.2

expt_dir_perts=/scratch2/BMC/fv3lam/ens_design_RRFS/expt_dirs_IC_perts

for cyc in 202205{27..31} 202206{01..09} ; do
    for mem in {01..09} ; do
        python ${expt_dir_perts}/soil_regrid.py ${expt_dir_perts}/ens_perts/${cyc}18_GEFS_pert_mem${mem}_sfc_data.tile7.halo0.nc 
    done
done


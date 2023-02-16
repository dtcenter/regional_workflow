#!/bin/bash

# this script copies GEFS 30h forecasts into the workflow to calculate initial conditions,
# replacing the default GFS analysis

expt_dir=/scratch2/BMC/fv3lam/ens_design_RRFS/expt_dirs_IC_perts
gefs_data_dir=/scratch2/BMC/fv3lam/ens_design_RRFS/data/GEFS/pgrb2_combined

for cyc in 202205{27..31} 202206{01..09} ; do
    gefs_cyc=$(date -d "$cyc -1 day" +%Y%m%d)

    for mem in {01..09} ; do
        mv ${expt_dir}/GEFS_mem${mem}/${cyc}18/FV3GFS/for_ICS/gfs.t18z.pgrb2.0p25.f000 ${expt_dir}/GEFS_mem${mem}/${cyc}18/FV3GFS/for_ICS/gfs.t18z.pgrb2.0p25.f000_bkp
        cp ${gefs_data_dir}/${gefs_cyc}.gep${mem}.t12z.pgrb2.0p50.f030 ${expt_dir}/GEFS_mem${mem}/${cyc}18/FV3GFS/for_ICS/gfs.t18z.pgrb2.0p25.f000

    done

done

#!/bin/bash

# this script copies GEFS 30h forecasts (init 18z 2 days before) into the workflow to calculate initial conditions,
# replacing the default 00z GFS analysis
#run this AFTER get_extrn_ics and BEFORE make_ics

expt_dir=/scratch2/BMC/fv3lam/ens_design_RRFS/expt_dirs_GEFS_perts
gefs_data_dir=/scratch2/BMC/fv3lam/ens_design_RRFS/data/GEFS/pgrb2_combined_bn

#for cyc in 202205{27..31} 202206{01..09} ; do
for cyc in 20220430 202205{01..12} ; do
    gefs_cyc=$(date -d "$cyc -2 day" +%Y%m%d)

    for mem in {01..09} ; do
        mv ${expt_dir}/GEFS_mem${mem}/${cyc}00/FV3GFS/for_ICS/gfs.t00z.pgrb2.0p25.f000 ${expt_dir}/GEFS_mem${mem}/${cyc}00/FV3GFS/for_ICS/gfs.t00z.pgrb2.0p25.f000_bkp
        cp ${gefs_data_dir}/${gefs_cyc}.gep${mem}.t18z.pgrb2.0p50.f030 ${expt_dir}/GEFS_mem${mem}/${cyc}00/FV3GFS/for_ICS/gfs.t00z.pgrb2.0p25.f000

    done

done

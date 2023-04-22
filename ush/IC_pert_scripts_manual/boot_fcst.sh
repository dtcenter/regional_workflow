#!/bin/sh

set -x


cd ../../ufs-srweather-app
module use modulefiles
module load wflow_hera
cd ../expt_dirs/IC_perts

#for cyc in 202205{27..31}18 202206{01..09}18 ; do
for cyc in 2022052718 ; do
    tasks="run_fcst_mem02"
     for mem in {03..10} ; do
        tasks="${tasks},run_fcst_mem${mem}"
    done
    rocotoboot -d FV3LAM_wflow.db -w FV3LAM_wflow.xml -c ${cyc}00 -t ${tasks}
done

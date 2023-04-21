#!/bin/sh

set -x


cd ../../ufs-srweather-app
module use modulefiles
module load wflow_hera
cd ../expt_dirs/IC_perts

#for cyc in 202205{27..31}18 202206{01..09}18 ; do
for cyc in 2022052718 ; do
    for mem in 01 ; do
        tasks="run_post_mem${mem}_f000"
        for hr in {00..36} ; do
            tasks="${tasks},run_post_mem${mem}_f0${hr}"
        done
        rocotorewind -d FV3LAM_wflow.db -w FV3LAM_wflow.xml -c ${cyc}00 -t ${tasks}
    done
done

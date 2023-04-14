#!/bin/bash --login

YYYY=2022
MM=05
HH=18
FHR=030

mkdir pgrb2_combined_differences

for DD in {01..12} ; do

    for mem in {01..10} ; do 

        FILE1="pgrb2_combined/${YYYY}${MM}${DD}.gep${mem}.t${HH}z.pgrb2.0p50.f${FHR}"
        FILE2="pgrb2_combined_duplicates_check/${YYYY}${MM}${DD}.gep${mem}.t${HH}z.pgrb2.0p50.f${FHR}"
        OUTFILE="pgrb2_combined_differences/${YYYY}${MM}${DD}.gep${mem}.t${HH}z.pgrb2.0p50.f${FHR}"

        wgrib2 ${FILE2} -var -lev -rpn "sto_1" -import_grib ${FILE1} -rpn "rcl_1:print_corr:print_rms" | \
        grep -v "rpn_corr=1" > ${OUTFILE}

     done

done

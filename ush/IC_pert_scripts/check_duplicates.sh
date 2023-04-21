#!/bin/bash --login

YYYY=2022
MM=05
HH=18
FHR=030

mkdir pgrb2_combined_duplicates_check

for DD in {01..12} ; do

    for mem in {01..10} ; do 

        INFILE="pgrb2_combined/${YYYY}${MM}${DD}.gep${mem}.t${HH}z.pgrb2.0p50.f${FHR}"
        OUTFILE="pgrb2_combined_duplicates_check/${YYYY}${MM}${DD}.gep${mem}.t${HH}z.pgrb2.0p50.f${FHR}"

        wgrib2 ${INFILE} -submsg 1 | ./unique.pl | wgrib2 -i ${INFILE} -GRIB ${OUTFILE} 

     done

done

#!/bin/bash --login
#SBATCH --account=fv3lam
#SBATCH --partition=service 
#SBATCH --job-name=ens_gefs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=5:00:00

#for 30h gefs perturbations to a 00z experiment init, use the 18z init forecasts from 2 days before

set -x


YYYY=2022
MM=05
HH=18
FHR=030

mkdir pgrb2_combined

for DD in {01..12} ; do

    mkdir ${YYYY}${MM}${DD}
    cd  ${YYYY}${MM}${DD}

    # Set the links to the files
    LINKA="https://noaa-gefs-pds.s3.amazonaws.com/gefs.${YYYY}${MM}${DD}/${HH}/atmos/pgrb2ap5"
    LINKB="https://noaa-gefs-pds.s3.amazonaws.com/gefs.${YYYY}${MM}${DD}/${HH}/atmos/pgrb2bp5"

    membersa=''
    membersb=''

    for mem in {01..10} ; do
        membersa="${membersa} ${LINKA}/gep${mem}.t${HH}z.pgrb2a.0p50.f${FHR}"
        membersb="${membersb} ${LINKB}/gep${mem}.t${HH}z.pgrb2b.0p50.f${FHR}"
    done

    # Get the files
    for mema in ${membersa}; do
        wget ${mema}
    done

    for memb in ${membersb}; do
        wget ${memb}
    done

     wait
     #combine the "a" and "b" grib2 files
     for mem in {01..10} ; do 
         cat gep${mem}.t${HH}z.pgrb2a.0p50.f${FHR} gep${mem}.t${HH}z.pgrb2b.0p50.f${FHR} > ../pgrb2_combined/${YYYY}${MM}${DD}.gep${mem}.t${HH}z.pgrb2.0p50.f${FHR}
     done

    cd ..
done

#!/bin/bash --login
#SBATCH --account=fv3lam
#SBATCH --partition=service 
#SBATCH --job-name=ens_gefs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=5:00:00

#for 30h gefs perturbations to a 00z experiment init, use the 12z init forecasts from 1 day before

set -x

module load hpss

YYYY=2022
MM=05

mkdir pgrb2_combined

#for DD in 23 {26..31} ; do
#for DD in {01..07} ; do
for DD in {01..11} ; do

    mkdir ${YYYY}${MM}${DD}
    cd  ${YYYY}${MM}${DD}

    HPSSDIR=/NCEPPROD/2year/hpssprod/runhistory/rh${YYYY}/${YYYY}${MM}/${YYYY}${MM}${DD}

    for hh in 12 ; do 
      HPSSFILEa=${HPSSDIR}/com_gefs_prod_gefs.${YYYY}${MM}${DD}_${hh}.atmos_pgrb2ap5.tar
      HPSSFILEb=${HPSSDIR}/com_gefs_prod_gefs.${YYYY}${MM}${DD}_${hh}.atmos_pgrb2bp5.tar

      membersa=''
      membersb=''
      for fhr in 036 ; do
        for mem in {01..10} ; do 
          membersa="${membersa} ./atmos/pgrb2ap5/gep${mem}.t${hh}z.pgrb2a.0p50.f${fhr}"
          membersb="${membersb} ./atmos/pgrb2bp5/gep${mem}.t${hh}z.pgrb2b.0p50.f${fhr}"
        done
      done
      htar -xvf $HPSSFILEa $membersa
      htar -xvf $HPSSFILEb $membersb

      wait
      #combine the "a" and "b" grib2 files
      for fhr in 036 ; do
        for mem in {01..10} ; do 
            cat ./atmos/pgrb2ap5/gep${mem}.t${hh}z.pgrb2a.0p50.f${fhr} ./atmos/pgrb2bp5/gep${mem}.t${hh}z.pgrb2b.0p50.f${fhr} > ../pgrb2_combined/${YYYY}${MM}${DD}.gep${mem}.t${hh}z.pgrb2.0p50.f${fhr}
        done
      done

    done
    cd ..
done

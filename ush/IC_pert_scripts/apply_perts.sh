#!/bin/bash

#SBATCH --account=comgsi
#SBATCH --partition=service
#SBATCH --job-name=add_perts
#SBATCH --ntasks=1
#SBATCH --time=6:00:00
#SBATCH --mem=48g
#SBATCH --output=./add_perts.o.log
#SBATCH --error=./add_perts.e.log

# This script adds perturbations derived from GEFS initialization data, after it was processed
# through the make_ics (chgres_cubed) task of the SRW App workflow.

set -x

module load intel/2022.1.2
module load nco

perts_dir=/scratch2/BMC/fv3lam/ens_design_RRFS/expt_dirs_IC_perts/ens_perts

for cyc in 202205{27..31} 202206{01..09} ; do
    for mem in {1..9} ; do

        # Add GEFS perturbations 01 through 09 to RRFS members 02 through 10.
        mem_GEFS=$(printf "%02d" $mem)
        mem_RRFS=$(printf "%02d" $((mem + 1)))

        RRFS_dir=/scratch2/BMC/fv3lam/ens_design_RRFS/expt_dirs/IC_perts/${cyc}18

        # use the RRFS mem01 ICs as the base and add the pert from GEFS members, place result into RRFS mem02..10 directories
        #ncbo -O --op_typ=add ${perts_dir}/${cyc}18_GEFS_pert_mem${mem_GEFS}_gfs_data.tile7.halo0.nc ${RRFS_dir}/mem01/INPUT/gfs_data.tile7.halo0.nc ${RRFS_dir}/mem${mem_RRFS}/INPUT/gfs_data.tile7.halo0.nc
        # use the modified surface file with 9 soil layers to match RRFS ICs (HRRR)
        ncbo -O --op_typ=add ${perts_dir}/${cyc}18_GEFS_pert_mem${mem_GEFS}_sfc_data.tile7.halo0.nc_soil_9_layers ${RRFS_dir}/mem01/INPUT/sfc_data.tile7.halo0.nc ${RRFS_dir}/mem${mem_RRFS}/INPUT/sfc_data.tile7.halo0.nc
        #ncbo -O --op_typ=add ${perts_dir}/${cyc}18_GEFS_pert_mem${mem_GEFS}_gfs_bndy.tile7.000.nc ${RRFS_dir}/mem01/INPUT/gfs_bndy.tile7.000.nc ${RRFS_dir}/mem${mem_RRFS}/INPUT/gfs_bndy.tile7.000.nc

        #try restoring non-perturbed sfc/bndy files
        #cp ${RRFS_dir}/mem01/INPUT/gfs_bndy.tile7.000.nc ${RRFS_dir}/mem${mem_RRFS}/INPUT/gfs_bndy.tile7.000.nc
        #cp ${RRFS_dir}/mem01/INPUT/sfc_data.tile7.halo0.nc ${RRFS_dir}/mem${mem_RRFS}/INPUT/sfc_data.tile7.halo0.nc
    done
done


#!/bin/bash

#SBATCH --account=comgsi
#SBATCH --partition=service
#SBATCH --job-name=add_perts
#SBATCH --ntasks=1
#SBATCH --time=6:00:00
#SBATCH --mem=48g
#SBATCH --output=./add_perts.o.log
#SBATCH --error=./add_perts.e.log

# This script adds perturbations derived from GEFS initialization data,
# after it was processed through the make_ics (chgres_cubed) task of the
# SRW App workflow.

#mem01 on the hrrr initialized members will remain unperturbed as the control.
#mem02..10 will be perturbed from the GEFS members 01..09, respectively

print_info_msg "
Applying the GEFS perturbations (on the native SRW grid) to the HRRR-
generated ICs of the RRFS analog experiment.  The RRFS analog experiment
is located at:
  RRFS_analog_exptdir = \"${RRFS_analog_exptdir}\""

for cyc in ${all_cycles[@]}; do
  echo
  echo "cyc = \"${cyc}\""
  for mem in ${GEFS_all_mems[@]}; do
    echo "  mem = \"${mem}\""
    mem_GEFS=$(printf "%02d" $mem)

    # Add GEFS perturbations 01 through 09 to RRFS members 01 through 09.
    mem_RRFS=$(printf "%02d" $mem)

    dn="${RRFS_analog_exptdir}/${cyc}/mem${mem_RRFS}/INPUT"
    for (( i=0; i<${#file_groups[@]}; i++ )); do
      file_group="${file_groups[$i]}"
      halo0_or_000="${halo0_or_000_array[$i]}"
      echo "    file_group = \"${file_group}\""
      # Save original IC file derived from HRRR output.
      fp="${dn}/${file_group}.tile7.${halo0_or_000}.nc"
      fp_no_pert="${fp}.no_pert"
      mv_vrfy "${fp}" "${fp_no_pert}"
      # Add GEFS perturbation to ICs derived from HRRR file to obtain
      # GEFS-perturbed (HRRR) ICs.
      python ${icpert_scripts_dir}/add_ic_pert.py \
        "${ens_perts_dir}/${cyc}_GEFS_pert_mem${mem_GEFS}_${file_group}.tile7.${halo0_or_000}.nc" \
        "${fp_no_pert}" "${fp}"
    done

  done
done


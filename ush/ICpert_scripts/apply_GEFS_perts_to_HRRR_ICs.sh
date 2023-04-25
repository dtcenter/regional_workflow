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

  for mem_GEFS in ${GEFS_all_mems[@]}; do

    echo "  mem_GEFS = \"${mem_GEFS}\""
    mem_RRFS=$(printf "%02d" $((10#${mem_GEFS}+1)) )

    dn="${RRFS_analog_exptdir}/${cyc}/mem${mem_RRFS}/INPUT"
    for (( i=0; i<${#file_groups[@]}; i++ )); do

      file_group="${file_groups[$i]}"
      halo0_or_000="${halo0_or_000_array[$i]}"
      echo "    file_group = \"${file_group}\""

      # Save original IC file derived from HRRR output.
      fn="${file_group}.tile7.${halo0_or_000}.nc"
      fp="${dn}/${fn}"
      fp_no_pert="${fp}.no_pert"
      fp_with_pert="${fp}.with_pert"

      if [ -f "${fp_with_pert}" ]; then
        rm_vrfy "${fp_with_pert}"
      fi

      if [ ! -f "${fp}" ] && [ ! -f "${fp_no_pert}" ]; then
        print_err_msg_exit "\
The original HRRR-based file (fp) or its renamed version (fp_no_pert)
must exist, but neither do:
  fp = \"${fp}\"
  fp_no_pert = \"${fp_no_pert}\""
      elif [ -f "${fp}" ] && [ -f "${fp_no_pert}" ]; then
        rm_vrfy "${fp}"
      elif [ -f "${fp}" ] && [ ! -f "${fp_no_pert}" ]; then
        mv_vrfy "${fp}" "${fp_no_pert}"
      fi
      #
      # Add GEFS perturbation to the ICs file derived from HRRR output 
      # to obtain GEFS-perturbed (HRRR) ICs.
      #
      python "${icpert_scripts_dir}/add_ic_pert.py" \
             "${ens_perts_dir}/${cyc}_GEFS_pert_mem${mem_GEFS}_${fn}" \
             "${fp_no_pert}" "${fp_with_pert}" || { \
      print_err_msg_exit "
Call to python script \"add_ic_pert.py\" failed for the following cycle
(cyc), GEFS member (mem_GEFS; and corresponding RRFS member mem_RRFS),
and file group (file_group):
  cyc = \"${cyc}\"
  mem_GEFS = \"${mem_GEFS}\"
  mem_RRFS = \"${mem_RRFS}\"
  file_group = \"${file_group}\""
      }

      ln_vrfy -fs --relative "${fp_with_pert}" "${fp}"

    done

  done

done

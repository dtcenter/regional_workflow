#!/bin/bash

dir_prefix="${GEFS_expt_basedir}/GEFS_mem"

# calculate ensemble means
print_info_msg "
Calculating GEFS ensemble means and placing result in directory:
  ens_means_dir = \"${ens_means_dir}\""

for cyc in ${all_cycles[@]}; do
  echo
  echo "cyc = \"${cyc}\""
  for (( i=0; i<${#file_groups[@]}; i++ )); do
    file_group="${file_groups[$i]}"
    halo0_or_000="${halo0_or_000_array[$i]}"
    echo "  file_group = \"${file_group}\""
    fn="${file_group}.tile7.${halo0_or_000}.nc"
    rel_fp="${cyc}/INPUT/${fn}"
    all_mem_fns=( $( printf "${dir_prefix}%s${uscore_test_or_null}/${rel_fp} " "${GEFS_all_mems[@]}" ) )
    nces -O ${all_mem_fns[@]} "${ens_means_dir}/${cyc}_ens_mean_${fn}"
  done
done

wait

# calculate perturbations (member minus mean)
print_info_msg "
Calculating GEFS ensemble perturbations and placing result in directory:
  ens_perts_dir = \"${ens_perts_dir}\""

for cyc in ${all_cycles[@]}; do
  echo
  echo "cyc = \"${cyc}\""
  for mem_GEFS in ${GEFS_all_mems[@]}; do
    echo "  mem_GEFS = \"${mem_GEFS}\""
    for (( i=0; i<${#file_groups[@]}; i++ )); do
      file_group="${file_groups[$i]}"
      halo0_or_000="${halo0_or_000_array[$i]}"
      echo "    file_group = \"${file_group}\""
      fn="${file_group}.tile7.${halo0_or_000}.nc"
      rel_fp="${cyc}/INPUT/${fn}"
      ncdiff "${dir_prefix}${mem_GEFS}${uscore_test_or_null}/${rel_fp}" \
             "${ens_means_dir}/${cyc}_ens_mean_${fn}" \
             "${ens_perts_dir}/${cyc}_GEFS_pert_mem${mem_GEFS}_${fn}"
    done
  done
done

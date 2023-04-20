#!/bin/bash

#
# Absolute path, file name, and directory of current script/function.
#
scrfunc_fp=$( readlink -f "${BASH_SOURCE[0]}" )
scrfunc_fn=$( basename "${scrfunc_fp}" )
scrfunc_dir=$( dirname "${scrfunc_fp}" )

echo 
echo "scrfunc_fp = \"${scrfunc_fp}\""
echo "scrfunc_fn = \"${scrfunc_fn}\""
echo "scrfunc_dir = \"${scrfunc_dir}\""
#
# Source the DTC Ensemble Design task setup file.
#
source "${scrfunc_dir}/DTC_ensemble_setup.sh"
#
# Generate an experiment for each GEFS member.  Note that the GEFS member
# numbering starts at 2 because the first member of the RRFS analog
# workflow is an unperturbed control member.
#
for mem in ${GEFS_all_mems[@]}; do

  GEFS_expt_subdir="GEFS_mem${mem}${uscore_test_or_null}"

  print_info_msg "
Creating experiment for GEFS member (mem):
  mem = \"${mem}\"
Experiment name is:
  GEFS_expt_subdir = \"${GEFS_expt_subdir}\"
"
  export "GEFS_expt_subdir"
  cp_vrfy "${icpert_scripts_dir}/config.sh.GEFS_member" \
          "${ushdir}/config.sh"
  ${ushdir}/generate_FV3LAM_wflow.sh

done


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
# Generate the RRFS analog experiment.
#
print_info_msg "
Creating RRFS analog experiment.  Experiment name is:
  RRFS_analog_expt_subdir = \"${RRFS_analog_expt_subdir}\"
"
cp_vrfy "${icpert_scripts_dir}/config.sh.RRFS_analog" \
        "${ushdir}/config.sh"
${ushdir}/generate_FV3LAM_wflow.sh


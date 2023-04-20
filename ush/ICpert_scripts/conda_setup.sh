#!/bin/bash

#
# Load a conda environment that has the netcdf4 python package needed in
# the python scripts that the shell scripts below call.
#
#cd_vrfy "${srwapp_homedir}/modulefiles"
#module use -a "${srwapp_homedir}/modulefiles"
#module load wflow_hera
#conda activate pygraf
#
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/scratch2/BMC/det/mayfield/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/scratch2/BMC/det/mayfield/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/scratch2/BMC/det/mayfield/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/scratch2/BMC/det/mayfield/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

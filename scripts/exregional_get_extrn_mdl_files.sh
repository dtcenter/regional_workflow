#!/bin/bash

#
#-----------------------------------------------------------------------
#
# Source the variable definitions file and the bash utility functions.
#
#-----------------------------------------------------------------------
#
. ${GLOBAL_VAR_DEFNS_FP}
. $USHDIR/source_util_funcs.sh
#
#-----------------------------------------------------------------------
#
# Save current shell options (in a global array).  Then set new options
# for this script/function.
#
#-----------------------------------------------------------------------
#
{ save_shell_opts; set -u +x; } > /dev/null 2>&1
#
#-----------------------------------------------------------------------
#
# Get the full path to the file in which this script/function is located 
# (scrfunc_fp), the name of that file (scrfunc_fn), and the directory in
# which the file is located (scrfunc_dir).
#
#-----------------------------------------------------------------------
#
scrfunc_fp=$( $READLINK -f "${BASH_SOURCE[0]}" )
scrfunc_fn=$( basename "${scrfunc_fp}" )
scrfunc_dir=$( dirname "${scrfunc_fp}" )
#
#-----------------------------------------------------------------------
#
# Print message indicating entry into script.
#
#-----------------------------------------------------------------------
#
print_info_msg "
========================================================================
Entering script:  \"${scrfunc_fn}\"
In directory:     \"${scrfunc_dir}\"

This is the ex-script for the task that copies or fetches external model
input data from disk, HPSS, or a URL, and stages them to the
workflow-specified location so that they may be used to generate initial
or lateral boundary conditions for the FV3.
========================================================================"
#
#-----------------------------------------------------------------------
#
# Specify the set of valid argument names for this script/function.  Then 
# process the arguments provided to this script/function (which should 
# consist of a set of name-value pairs of the form arg1="value1", etc).
#
#-----------------------------------------------------------------------
#
valid_args=( \
"extrn_mdl_cdate" \
"extrn_mdl_name" \
"extrn_mdl_staging_dir" \
"time_offset_hrs" \
)
process_args valid_args "$@"
#
#-----------------------------------------------------------------------
#
# For debugging purposes, print out values of arguments passed to this
# script.  Note that these will be printed out only if VERBOSE is set to
# TRUE.
#
#-----------------------------------------------------------------------
#
print_input_args valid_args


#
#-----------------------------------------------------------------------
#
# Set up variables for call to retrieve_data.py
#
#-----------------------------------------------------------------------
#
set -x
if [ "${ICS_OR_LBCS}" = "ICS" ]; then
  if [ ${time_offset_hrs} -eq 0 ] ; then
    anl_or_fcst="anl"
  else
    anl_or_fcst="fcst"
  fi
  fcst_hrs=${time_offset_hrs}
  file_names=${EXTRN_MDL_FILES_ICS[@]}
  if [ ${extrn_mdl_name} = FV3GFS ] ; then
    file_type=$FV3GFS_FILE_FMT_ICS
  fi
  input_file_path=${EXTRN_MDL_SOURCE_BASEDIR_ICS:-$EXTRN_MDL_SYSBASEDIR_ICS}

elif [ "${ICS_OR_LBCS}" = "LBCS" ]; then
  anl_or_fcst="fcst"
  first_time=$((time_offset_hrs + LBC_SPEC_INTVL_HRS))
  last_time=$((time_offset_hrs + FCST_LEN_HRS))
  fcst_hrs="${first_time} ${last_time} ${LBC_SPEC_INTVL_HRS}"
  file_names=${EXTRN_MDL_FILES_LBCS[@]}
  if [ ${extrn_mdl_name} = FV3GFS ] ; then
    file_type=$FV3GFS_FILE_FMT_LBCS
  fi
  input_file_path=${EXTRN_MDL_SOURCE_BASEDIR_LBCS:-$EXTRN_MDL_SYSBASEDIR_LBCS}
fi

data_stores="${EXTRN_MDL_DATA_STORES}"

yyyymmddhh=${extrn_mdl_cdate:0:10}
yyyy=${yyyymmddhh:0:4}
yyyymm=${yyyymmddhh:0:6}
yyyymmdd=${yyyymmddhh:0:8}
mm=${yyyymmddhh:4:2}
dd=${yyyymmddhh:6:2}
hh=${yyyymmddhh:8:2}


input_file_path=$(eval echo ${input_file_path})
#
#-----------------------------------------------------------------------
#
# Set up optional flags for calling retrieve_data.py
#
#-----------------------------------------------------------------------
#
additional_flags=""


if [ -n "${file_type:-}" ] ; then 
  additional_flags="$additional_flags \
  --file_type ${file_type}"
fi

if [ -n "${file_names:-}" ] ; then
  additional_flags="$additional_flags \
  --file_templates ${file_names[@]}"
fi

if [ -n "${input_file_path:-}" ] ; then
  data_stores="disk $data_stores"
  additional_flags="$additional_flags \
  --input_file_path ${input_file_path}"
fi

#
#-----------------------------------------------------------------------
#
# Call ush script to retrieve files
#
#-----------------------------------------------------------------------
#
cmd="
python3 -u ${USHDIR}/retrieve_data.py \
  --debug \
  --anl_or_fcst ${anl_or_fcst} \
  --config ${USHDIR}/templates/data_locations.yml \
  --cycle_date ${extrn_mdl_cdate} \
  --data_stores ${data_stores} \
  --external_model ${extrn_mdl_name} \
  --fcst_hrs ${fcst_hrs[@]} \
  --output_path ${extrn_mdl_staging_dir} \
  --summary_file ${EXTRN_MDL_VAR_DEFNS_FN} \
  $additional_flags"

$cmd || print_err_msg_exit "\
Call to retrieve_data.py failed with a non-zero exit status.

The command was:
${cmd}
"
#
#-----------------------------------------------------------------------
#
# Specific to DTC Ensemble Task.
# 
# Replace external model files obtained by the GET_EXTRN_ICS task (which
# are the 00Z GFS analysis) with GEFS 30h forecasts (initialized at 18Z
# 2 days before).  In the DTC Ensemble Task, we use these GEFS files
# (instead of the GFS ones) with perturbations added (later below) to
# calculate the initial conditions.
#
#-----------------------------------------------------------------------
#
# Try to obtain the GEFS member number from the name of the experiment.
# This is just the two digits within the experiment name.
#
gefs_mem=""
gefs_mem=$( printf "%s" "${EXPT_SUBDIR}" | $SED -n -r -e "s/^GEFS_mem([0-9]{2}).*$/\1/p" )

if [ ! -z "${gefs_mem}" ] && [[ ! "${gefs_mem}" =~ ^[0-9]{2}$ ]]; then
  print_err_msg_exit "\
The variable \"gefs\"_mem must either be a 2-digit string representing the 
GEFS member number or an empty string; otherwise, something is wrong:
  gefs_mem = \"${gefs_mem}\""
fi
#
# If gefs_mem is not empty, it means the current workflow is for a GEFS
# individual member (as opposed to being the RRFS analog).  In that case,
# perform the external model file replacement (replace GFS files with 
# GEFS files).
#
if [ "${ICS_OR_LBCS}" = "ICS" ] && [ ! -z "${gefs_mem}" ]; then

  print_info_msg "
Replacing GFS external model IC files with GEFS external model IC files
for GEFS member:
  gefs_mem = \"${gefs_mem}\""

  gfs_fp="${EXPTDIR}/${CDATE}/FV3GFS/for_ICS/gfs.t00z.pgrb2.0p25.f000"
  gfs_fp_orig="${gfs_fp}.orig"
#
# At least one of the GFS file (gfs_fp) and the renamed ("orig") version
# of it (gfs_fp_orig) must exist.  If not, print out an error message
# and exit.
#
  if [ ! -f "${gfs_fp}" ] && [ ! -f "${gfs_fp_orig}" ]; then
    print_err_msg_exit "\
The GFS external model file (gfs_fp) or its renamed version (gfs_fp_orig)
must exist, but neither do:
  gfs_fp = \"${gfs_fp}\"
  gfs_fp_orig = \"${gfs_fp_orig}\""
  fi
#
# If a renamed ("orig") GFS file already exists (e.g. due to a previous
# call to this script), move it so it doesn't get overwritten in the
# next step.
#
  check_for_preexist_dir_file "${gfs_fp_orig}" "rename"
#
# If the GFS file exists, rename it.  Note that it may not exist due to
# a previous call to this script.
#
  if [ -f "${gfs_fp}" ]; then
    mv_vrfy "${gfs_fp}" "${gfs_fp_orig}"
  fi

  gefs_cyc=$(date -d "${CDATE:0:8} -2 day" +%Y%m%d)
  gefs_fn="${gefs_cyc}.gep${gefs_mem}.t18z.pgrb2.0p50.f030"
  gefs_fp="${GEFS_STAGING_DIR}/${gefs_fn}"
  print_info_msg "
Copying GEFS file (gefs_fp) into GFS file (gfs_fp):
  gefs_fp = \"${gefs_fp}\"
  gfs_fp = \"${gfs_fp}\""

fi
#
#-----------------------------------------------------------------------
#
# Restore the shell options saved at the beginning of this script/function.
#
#-----------------------------------------------------------------------
#
{ restore_shell_opts; } > /dev/null 2>&1


#
#-----------------------------------------------------------------------
#
# This file defines a function that sets
#
#-----------------------------------------------------------------------
#
function set_vx_fhr_list() {
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
  local scrfunc_fp=$( $READLINK -f "${BASH_SOURCE[0]}" )
  local scrfunc_fn=$( basename "${scrfunc_fp}" )
  local scrfunc_dir=$( dirname "${scrfunc_fp}" )
#
#-----------------------------------------------------------------------
#
# Get the name of this function.
#
#-----------------------------------------------------------------------
#
  local func_name="${FUNCNAME[0]}"
#
#-----------------------------------------------------------------------
#
# Specify the set of valid argument names for this script/function.  Then
# process the arguments provided to this script/function (which should
# consist of a set of name-value pairs of the form arg1="value1", etc).
#
#-----------------------------------------------------------------------
#
  local valid_args=( \
        "obtype" \
        "field" \
        "field_is_APCPgt01h" \
        "accum" \
        "fhr_min" \
        "fhr_int" \
        "fhr_max" \
        "cdate" \
        "obs_dir" \
        "obs_filename_prefix" \
        "obs_filename_suffix" \
        "outvarname_fhr_list" \
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
# Declare local variables.
#
#-----------------------------------------------------------------------
#
  local fhr \
        fhr_array \
        fhr_list \
        hh_init \
        hh_valid \
        hhmmss_valid \
        hrs_since_init \
        i \
        num_fcst_hrs \
        num_missing_obs_files \
        obs_fn \
        obs_fp \
        yyyymmdd_init \
        yyyymmdd_valid \
        yyyymmddhh_valid
#
#-----------------------------------------------------------------------
#
# Loop through all forecast hours.  For each one for which the obs file
# exists, add the forecast hour to fhr_list.  fhr_list will be a scalar
# containing a comma-separated list of forecast hours for which obs 
# files exist.  Also, use the variable num_missing_obs_files to keep
# track of the number of obs files that are missing.
#
#-----------------------------------------------------------------------
#
# Create array containing set of forecast hours for which we will check
# for the existence of corresponding observations file.
#
fhr_array=($( seq ${fhr_min} ${fhr_int} ${fhr_max} ))
echo
echo "fhr_min = ${fhr_min}"
echo "fhr_int = ${fhr_int}"
echo "fhr_max = ${fhr_max}"
echo "fhr_array = |${fhr_array[@]}|"
#
# Get the yyymmdd and hh corresponding to the forecast's initial time
# (cdate).
#
yyyymmdd_init=${cdate:0:8}
hh_init=${cdate:8:2}

fhr_list=""
num_missing_obs_files=0
num_fcst_hrs=${#fhr_array[@]}
for (( i=0; i<${num_fcst_hrs}; i++ )); do

echo
echo "i = $i"
  fhr_orig="${fhr_array[$i]}"
echo "  fhr_orig = $fhr_orig"

  if [ "${field_is_APCPgt01h}" = "TRUE" ]; then
    fhr=$(( ${fhr_orig} - ${accum} + 1 ))
    num_back_hrs=${accum}
  else
    fhr=${fhr_orig}
    num_back_hrs=1
  fi


  skip_this_fhr="FALSE"
  for (( j=0; j<${num_back_hrs}; j++ )); do
echo
echo "  j = $j"

echo "    fhr = $fhr"

  hrs_since_init=$(( ${hh_init} + ${fhr} ))
echo "    hrs_since_init = ${hrs_since_init}"

  hh_valid=$( date --date="${yyyymmdd_init} + ${hrs_since_init} hours" +"%H" )
echo "    hh_valid = ${hh_valid}"
  hhmmss_valid=$( date --date="${yyyymmdd_init} + ${hrs_since_init} hours" +"%H%M%S" )
echo "    hhmmss_valid = ${hhmmss_valid}"
  yyyymmdd_valid=$( date --date="${yyyymmdd_init} + ${hrs_since_init} hours" +"%Y%m%d" )
echo "    yyyymmdd_valid = ${yyyymmdd_valid}"
  yyyymmddhh_valid=$( date --date="${yyyymmdd_init} + ${hrs_since_init} hours" +"%Y%m%d%H" )
echo "    yyyymmddhh_valid = ${yyyymmddhh_valid}"

  case "${obtype}" in
    "CCPA")
      obs_subdir="${yyyymmdd_valid}"
      obs_fn_time_str="${hh_valid}"
      ;;
    "MRMS")
      obs_subdir="${yyyymmdd_valid}"
      obs_fn_time_str="${yyyymmdd_valid}-${hhmmss_valid}"
      ;;
    "NDAS")
      obs_subdir=""
      obs_fn_time_str="${yyyymmddhh_valid}"
      ;;
    *)
      print_err_msg_exit "\
A method for setting the observations subdirectory (obs_subdir) and file
name time string (obs_fn_time_str) has not been specified for this 
observation type (obtype):
  obtype = \"${obtype}\""
      ;;
  esac

#  obs_fn="${obs_filename_prefix}${yyyymmdd_valid}-${hhmmss_valid}${obs_filename_suffix}"
  obs_fn="${obs_filename_prefix}${obs_fn_time_str}${obs_filename_suffix}"


echo "    obs_fn = ${obs_fn}"
  obs_fp="${obs_dir}/${obs_subdir}/${obs_fn}"
echo "    obs_fp = ${obs_fp}"

  if [ ! -f "${obs_fp}" ]; then
    skip_this_fhr="TRUE"
    num_missing_obs_files=$(( ${num_missing_obs_files} + 1 ))
    print_info_msg "\
The observation file (obs_fp) for the current forecast hour (fhr;
relative to the cycle date cdate) is missing:
  fhr_orig = "${fhr_orig}"
  fhr = "$fhr"
  cdate = "$cdate"
  obs_fp = "${obs_fp}"
Not including the current forecast hour from the list of hours passed
to the METplus configuration file."
echo "    fhr_list = |${fhr_list}|"
echo "    num_missing_obs_files = ${num_missing_obs_files}"
    break
  fi

    fhr=$(( $fhr + 1 ))

  done

  if [ "${skip_this_fhr}" != "TRUE" ]; then
    fhr_list="${fhr_list},${fhr_orig}"
  fi

echo
echo "  fhr_list = |${fhr_list}|"
echo "  num_missing_obs_files = ${num_missing_obs_files}"

done
#
# Remove leading comma from fhr_list.
#
fhr_list=$( echo "${fhr_list}" | $SED "s/^,//g" )
echo
echo "fhr_list = |${fhr_list}|"
echo "num_missing_obs_files = ${num_missing_obs_files}"
#
#-----------------------------------------------------------------------
#
# If the number of missing obs files is greater than the user-specified
# variable NUM_MISSING_OBS_FILES_MAX, print out an error message and 
# exit.
#
#-----------------------------------------------------------------------
#
if [ "${num_missing_obs_files}" -gt "${NUM_MISSING_OBS_FILES_MAX}" ]; then
  print_err_msg_exit "\
The number of missing obs files (num_obs_missig) is greater than the
maximum allowed number (NUM_MISSING_OBS_MAS):
  num_missing_obs_files = ${num_missing_obs_files}
  NUM_MISSING_OBS_FILES_MAX = ${NUM_MISSING_OBS_FILES_MAX}"
fi
#
#-----------------------------------------------------------------------
#
# Set output variables.
#
#-----------------------------------------------------------------------
#
  if [ ! -z "${outvarname_fhr_list}" ]; then
    printf -v ${outvarname_fhr_list} "%s" "${fhr_list}"
  fi
#
#-----------------------------------------------------------------------
#
# Restore the shell options saved at the beginning of this script/function.
#
#-----------------------------------------------------------------------
#
  { restore_shell_opts; } > /dev/null 2>&1

}

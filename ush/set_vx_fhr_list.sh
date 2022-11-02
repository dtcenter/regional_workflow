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
        "obs_fn_template" \
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
  local actual_value \
        fhr \
        fhr_array \
        fhr_list \
        hh_init \
        hh_valid_tmpl \
        hhmmss_valid_tmpl \
        hrs_since_init \
        i \
        j \
        num_fcst_hrs \
        num_missing_obs_files \
        num_supported_timestrs \
        obs_fn \
        obs_fp \
        remainder \
        regex_search \
        skip_this_fhr \
        supported_timestr \
        supported_timestrs \
        timestr \
        yyyymmdd_init \
        yyyymmdd_init_tmpl \
        yyyymmdd_valid_tmpl \
        yyyymmddhh_init_tmpl \
        yyyymmddhh_valid_tmpl
#
#-----------------------------------------------------------------------
#
# List of supported METplus time string templates.
#
#-----------------------------------------------------------------------
#
yyyymmddhh_init_tmpl="{init?fmt=%Y%m%d%H}"
yyyymmddhh_valid_tmpl="{valid?fmt=%Y%m%d%H}"
yyyymmdd_valid_tmpl="{valid?fmt=%Y%m%d}"
hhmmss_valid_tmpl="{valid?fmt=%H%M%S}"
hh_valid_tmpl="{valid?fmt=%H}"
supported_timestrs=( "${yyyymmddhh_init_tmpl}" \
                     "${yyyymmddhh_valid_tmpl}" \
                     "${yyyymmdd_valid_tmpl}" \
                     "${hhmmss_valid_tmpl}" \
                     "${hh_valid_tmpl}" )
num_supported_timestrs=${#supported_timestrs[@]}
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

  fhr="${fhr_array[$i]}"
  skip_this_fhr="FALSE"
  hrs_since_init=$(( ${hh_init} + ${fhr} ))
#
# Set the name of/relative path to the observation file from the provided
# templates.
#
  obs_fn="${obs_fn_template}"
  remainder="${obs_fn_template}"
  timestr="not_empty"
  while [ ! -z "$timestr" ]; do

    regex_search="(.*)(\{.*\})(.*)"
    timestr=$( printf "%s" "${remainder}" | \
               $SED -n -r -e "s|${regex_search}|\2|p" )
    remainder=$( printf "%s" "${remainder}" | \
                 $SED -n -r -e "s|${regex_search}|\1\3|p" )

    if [ ! -z "$timestr" ]; then
      regex_search="${timestr}"
      regex_search=$( echo "${regex_search}" | $SED -r -e "s/\?/\\\?/g" -e "s/\{/\\\{/g" -e "s/\}/\\\}/g" )

      actual_value=""
      for (( j=0; k<${num_supported_timestrs}; j++ )); do
        supported_timestr="${supported_timestrs[$j]}"
        if [ "${timestr}" = "${supported_timestr}" ]; then
          case "${supported_timestr}" in

            '{init?fmt=%Y%m%d%H}')
              actual_value="${cdate}"
              break
              ;;

            '{valid?fmt=%Y%m%d%H}')
              actual_value=$( date --date="${yyyymmdd_init} + ${hrs_since_init} hours" +"%Y%m%d%H" )
              break
              ;;

            '{valid?fmt=%Y%m%d}')
              actual_value=$( date --date="${yyyymmdd_init} + ${hrs_since_init} hours" +"%Y%m%d" )
              break
              ;;

            '{valid?fmt=%H%M%S}')
              actual_value=$( date --date="${yyyymmdd_init} + ${hrs_since_init} hours" +"%H%M%S" )
              break
              ;;

            '{valid?fmt=%H}')
              actual_value=$( date --date="${yyyymmdd_init} + ${hrs_since_init} hours" +"%H" )
              break
              ;;

          esac
        fi
      done

      if [ -z "${actual_value}" ]; then
        print_err_msg_exit "\
  A method for replacing the current METplus time string (timestr) has not
  been specified:
    timestr = \"${timestr}\""
      else
        obs_fn=$( echo "${obs_fn}" | \
                  $SED -n -r "s|(.*)(${regex_search})(.*)|\1${actual_value}\3|p" )
      fi

    fi

  done
#
# Get the full path to the observation file and check if it exists.
#
  obs_fp="${obs_dir}/${obs_fn}"

  if [ -f "${obs_fp}" ]; then
    print_info_msg "\
Found observation file (obs_fp) for the current forecast hour (fhr;
relative to the cycle date cdate):
  fhr = \"$fhr\"
  cdate = \"$cdate\"
  obs_fp = \"${obs_fp}\"
"
    fhr_list="${fhr_list},${fhr}"
  else
    skip_this_fhr="TRUE"
    num_missing_obs_files=$(( ${num_missing_obs_files} + 1 ))
    print_info_msg "\
The observation file (obs_fp) for the current forecast hour (fhr;
relative to the cycle date cdate) is missing:
  fhr = \"$fhr\"
  cdate = \"$cdate\"
  obs_fp = \"${obs_fp}\"
Not including the current forecast hour from the list of hours passed
to the METplus configuration file."
    break
  fi

done
#
# Remove leading comma from fhr_list.
#
fhr_list=$( echo "${fhr_list}" | $SED "s/^,//g" )
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

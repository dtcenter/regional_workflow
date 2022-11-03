#
#-----------------------------------------------------------------------
#
# This file defines a function that 
#
#-----------------------------------------------------------------------
#
function eval_METplus_timestr_tmpl() {
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
        "init_time" \
        "fhr" \
        "tmpl" \
        "outvarname_formatted_time" \
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
  local formatted_time \
        hh_init \
        hh_valid_tmpl \
        hhmmss_valid_tmpl \
        i \
        is_valid_tmpl \
        len \
        mn_init \
        num_supported_tmpls \
        ss_init \
        str \
        supported_metplus_timestr_tmpls \
        supported_tmpl \
        valid_time \
        yyyymmdd_init \
        yyyymmdd_valid_tmpl \
        yyyymmddhh_init_tmpl \
        yyyymmddhh_valid_tmpl
#
#-----------------------------------------------------------------------
#
# Set list of supported METplus time string templates.
#
#-----------------------------------------------------------------------
#
tmpl_init_yyyymmddhh="{init?fmt=%Y%m%d%H}"
tmpl_init_yyyymmddhh_shiftm0="{init?fmt=%Y%m%d%H?shift=-0}"
tmpl_init_yyyymmddhh_shiftm43200="{init?fmt=%Y%m%d%H?shift=-43200}"
tmpl_init_hh='{init?fmt=%H}'
tmpl_init_hh_shift0='{init?fmt=%H?shift=0}'
tmpl_init_hh_shiftm0='{init?fmt=%H?shift=-0}'
tmpl_init_hh_shiftm43200='{init?fmt=%H?shift=-43200}'
tmpl_valid_yyyymmddhh="{valid?fmt=%Y%m%d%H}"
tmpl_valid_yyyymmdd="{valid?fmt=%Y%m%d}"
tmpl_valid_hhmmss="{valid?fmt=%H%M%S}"
tmpl_valid_hh="{valid?fmt=%H}"
tmpl_lead_hhh="{lead?fmt=%HHH}"
tmpl_lead_hhh_shift0="{lead?fmt=%HHH?shift=0}"
tmpl_lead_hhh_shiftm0="{lead?fmt=%HHH?shift=-0}"
tmpl_lead_hhh_shift43200="{lead?fmt=%HHH?shift=43200}"

supported_metplus_timestr_tmpls=( \
  "${tmpl_init_yyyymmddhh}" \
  "${tmpl_init_yyyymmddhh_shiftm0}" \
  "${tmpl_init_yyyymmddhh_shiftm43200}" \
  "${tmpl_init_hh}" \
  "${tmpl_init_hh_shift0}" \
  "${tmpl_init_hh_shiftm0}" \
  "${tmpl_init_hh_shiftm43200}" \
  "${tmpl_valid_yyyymmddhh}" \
  "${tmpl_valid_yyyymmdd}" \
  "${tmpl_valid_hhmmss}" \
  "${tmpl_valid_hh}" \
  "${tmpl_lead_hhh}" \
  "${tmpl_lead_hhh_shift0}" \
  "${tmpl_lead_hhh_shiftm0}" \
  "${tmpl_lead_hhh_shift43200}" \
  )
num_supported_tmpls=${#supported_metplus_timestr_tmpls[@]}
#
#-----------------------------------------------------------------------
#
# Run checks on input arguments.
#
#-----------------------------------------------------------------------
#
if [ -z "$tmpl" ]; then
  print_err_msg_exit "\
The specified METplus time string template (tmpl) cannot be empty:
  tmpl = \"${tmpl}\""
fi

is_valid_tmpl="FALSE"
for (( i=0; i<${num_supported_tmpls}; i++ )); do
  supported_tmpl="${supported_metplus_timestr_tmpls[$i]}"
  if [ "${tmpl}" = "${supported_tmpl}" ]; then
    is_valid_tmpl="TRUE"
  fi
done

if [ "${is_valid_tmpl}" != "TRUE" ]; then
  str=$( printf "  %s\n" "${supported_metplus_timestr_tmpls[@]}" )
  print_err_msg_exit "\
The specified METplus time string template (tmpl) is not supported:
  tmpl = \"${tmpl}\"
Supported templates are:
$str"
fi

len=${#init_time}
if [[ ${init_time} =~ ^[0-9]+$ ]]; then
  if [ "$len" -ne 10 ] && [ "$len" -ne 12 ] && [ "$len" -ne 14 ]; then
    print_err_msg_exit "\
The specified initial time string (init_time) must contain exactly 10,
12, or 14 integers (but contains $len):
  init_time = \"${init_time}\""
  fi
else
  print_err_msg_exit "\
The specified initial time string (init_time) must consist of only
integers and cannot be empty:
  init_time = \"${init_time}\""
fi

if ! [[ $fhr =~ ^[0-9]+$ ]]; then
  print_err_msg_exit "\
The specified forecast hour (fhr) must consist of only integers and
cannot be empty:
  fhr = \"${fhr}\""
fi

yyyymmdd_init=${init_time:0:8}
hh_init=${init_time:8:2}

mn_init="00"
if [ "$len" -gt "10" ]; then
  mn_init=${init_time:10:2}
fi

ss_init="00"
if [ "$len" -gt "12" ]; then
  ss_init=${init_time:12:2}
fi
#
#-----------------------------------------------------------------------
#
# Get the initial and valid times in string formats that can be input
# into the "date" command.
#
#
#-----------------------------------------------------------------------
#
#init_time=$( date --date="${yyyymmdd_init} + ${hh_init} hours + \
#                           ${mn_init} minutes + ${ss_init} seconds" +"%Y-%m-%d %T" )
#valid_time=$( date --date="${yyyymmdd_init} + $((${hh_init} + ${fhr})) hours + \
#                           ${mn_init} minutes + ${ss_init} seconds" +"%Y-%m-%d %T" )
init_time=$( printf "%s" "${yyyymmdd_init} + ${hh_init} hours + ${mn_init} minutes + ${ss_init} seconds" )
valid_time=$( printf "%s" "${init_time} + ${fhr} hours" )

formatted_time=""
for (( i=0; i<${num_supported_tmpls}; i++ )); do
  supported_tmpl="${supported_metplus_timestr_tmpls[$i]}"
  if [ "${tmpl}" = "${supported_tmpl}" ]; then
    case "${supported_tmpl}" in

     ${tmpl_init_yyyymmddhh}|${tmpl_init_yyyymmddhh_shiftm0})
        formatted_time=$( date --date="${init_time}" +"%Y%m%d%H" )
        break
        ;;

     ${tmpl_init_yyyymmddhh_shiftm43200})
        formatted_time=$( date --date="${init_time} - 12 hours" +"%Y%m%d%H" )
        break
        ;;

      ${tmpl_init_hh}|${tmpl_init_hh_shift0}|${tmpl_init_hh_shiftm0})
        formatted_time=$( date --date="${init_time}" +"%H" )
        break
        ;;

      ${tmpl_init_hh_shiftm43200})
        formatted_time=$( date --date="${init_time} - 43200 seconds" +"%H" )
        break
        ;;

      ${tmpl_valid_yyyymmddhh})
        formatted_time=$( date --date="${valid_time}" +"%Y%m%d%H" )
        break
        ;;

      ${tmpl_valid_yyyymmdd})
        formatted_time=$( date --date="${valid_time}" +"%Y%m%d" )
        break
        ;;

      ${tmpl_valid_hhmmss})
        formatted_time=$( date --date="${valid_time}" +"%H%M%S" )
        break
        ;;

      ${tmpl_valid_hh})
        formatted_time=$( date --date="${valid_time}" +"%H" )
        break
        ;;

      ${tmpl_lead_hhh}|${tmpl_lead_hhh_shift0}|${tmpl_lead_hhh_shiftm0})
        formatted_time=$(( ($( date --date="${valid_time}" +"%s" ) \
                          - $( date --date="${init_time}" +"%s" ) \
                           )/${secs_per_hour} ))
        formatted_time=$( printf "%03d" "${formatted_time}" )
        break
        ;;

      ${tmpl_lead_hhh_shift43200})
        formatted_time=$(( ($( date --date="${valid_time}" +"%s" ) \
                          - $( date --date="${init_time}" +"%s" ) \
                          + 43200)/${secs_per_hour} ))
        formatted_time=$( printf "%03d" "${formatted_time}" )
        break
        ;;

    esac
  fi
done

if [ -z "${formatted_time}" ]; then
  str=$( printf "  %s\n" "${supported_metplus_timestr_tmpls[@]}" )
  print_err_msg_exit "\
The specified METplus time string template (tmpl) could not be evaluated
for the given initial time (init_time) and forecast hour (fhr):
  tmpl = \"${tmpl}\"
  init_time = \"${init_time}\"
  fhr = \"${fhr}\""
fi
#
#-----------------------------------------------------------------------
#
# Set output variables.
#
#-----------------------------------------------------------------------
#
  if [ ! -z "${outvarname_formatted_time}" ]; then
    printf -v ${outvarname_formatted_time} "%s" "${formatted_time}"
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

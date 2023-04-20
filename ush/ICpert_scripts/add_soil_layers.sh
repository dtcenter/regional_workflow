#!/bin/bash

print_info_msg "
Interpolating soil variables from the 4 layers in NOAH LSM (in GFS output)
to the 9 layers in RUC LSM (in HRRR output)..."

for cyc in ${all_cycles[@]}; do

  echo
  echo "cyc = \"${cyc}\""

  for mem in ${GEFS_all_mems[@]}; do

    echo "  mem = \"${mem}\""
    fp="${ens_perts_dir}/${cyc}_GEFS_pert_mem${mem}_sfc_data.tile7.halo0.nc" 
    fp_4layers="${fp}.4_soil_layers"
    fp_9layers="${fp}.9_soil_layers"

    if [ -f "${fp_9layers}" ]; then
      rm_vrfy "${fp_9layers}"
    fi

    if [ ! -f "${fp}" ] && [ ! -f "${fp_4layers}" ]; then
      print_err_msg_exit "\
The original GFS 4-soil-layer file (fp) or its renamed version (fp_4layers)
must exist, but neither do:
  fp = \"${fp}\"
  fp_4layers = \"${fp_4layers}\""
    elif [ -f "${fp}" ] && [ -f "${fp_4layers}" ]; then
      rm_vrfy "${fp}"
    elif [ -f "${fp}" ] && [ ! -f "${fp_4layers}" ]; then
      mv_vrfy "${fp}" "${fp_4layers}"
    fi

    python "${icpert_scripts_dir}/soil_regrid.py" \
           "${fp_4layers}" "${fp_9layers}" || { \
    print_err_msg_exit "
Call to python script \"soil_regrid.py\" failed for:
  cyc = \"${cyc}\"
  mem = \"${mem}\""
      }

    ln_vrfy -fs --relative "${fp_9layers}" "${fp}"

  done

done

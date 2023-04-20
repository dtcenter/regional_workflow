import sys
import numpy as np
import netCDF4 as nc

filename_gefs = sys.argv[1]
filename_hrrr = sys.argv[2]
filename_rrfs = sys.argv[3]


with nc.Dataset(filename_gefs) as gefs, nc.Dataset(filename_hrrr) as hrrr, nc.Dataset(
    filename_rrfs, "w"
) as rrfs:

    # copy all data into new file except for soil
    rrfs.setncatts(hrrr.__dict__)
    for name, dimension in hrrr.dimensions.items():
        rrfs.createDimension(
            name, (len(dimension) if not dimension.isunlimited() else None)
        )

    for name, variable in hrrr.variables.items():
        rrfs.createVariable(name, variable.datatype, variable.dimensions)
        rrfs[name].setncatts(hrrr[name].__dict__)
        if name in [
            "sphum",
            "graupel",
            "ice_wat",
            "liq_wat",
            "rainwat",
            "snowwat",
            "smc",
            "slc",
            "q2m",
            "sphum_bottom",
            "sphum_left",
            "sphum_right",
            "sphum_top",
            "graupel_bottom",
            "graupel_left",
            "graupel_right",
            "graupel_top",
            "ice_wat_bottom",
            "ice_wat_left",
            "ice_wat_right",
            "ice_wat_top",
            "liq_wat_bottom",
            "liq_wat_left",
            "liq_wat_right",
            "liq_wat_top",
            "rainwat_bottom",
            "rainwat_left",
            "rainwat_right",
            "rainwat_top",
            "snowwat_bottom",
            "snowwat_left",
            "snowwat_right",
            "snowwat_top",
            "zorl",
            "alvsf",
            "alvwf",
            "alnsf",
            "alnwf",
        ]:
            rrfs.variables[name][:] = np.maximum(
                0, hrrr.variables[name][:] + gefs.variables[name][:]
            )
        elif name in [
            "delp",
            "ice_aero",
            "liq_aero",
            "o3mr",
            "t",
            "ps",
            "u_s",
            "u_w",
            "v_s",
            "v_w",
            "w",
            "zh",
            "t2m",
            "stc",
            "tisfc",
            "tsea",
            "uustar",
            "o3mr_bottom",
            "o3mr_left",
            "o3mr_right",
            "o3mr_top",
            "ice_aero_bottom",
            "ice_aero_left",
            "ice_aero_right",
            "ice_aero_top",
            "liq_aero_bottom",
            "liq_aero_left",
            "liq_aero_right",
            "liq_aero_top",
            "t_bottom",
            "t_left",
            "t_right",
            "t_top",
            "u_s_bottom",
            "u_s_left",
            "u_s_right",
            "u_s_top",
            "u_w_bottom",
            "u_w_left",
            "u_w_right",
            "u_w_top",
            "v_s_bottom",
            "v_s_left",
            "v_s_right",
            "v_s_top",
            "v_w_bottom",
            "v_w_left",
            "v_w_right",
            "v_w_top",
            "w_bottom",
            "w_left",
            "w_right",
            "w_top",
            "zh_bottom",
            "zh_left",
            "zh_right",
            "zh_top",
            "ps_bottom",
            "ps_left",
            "ps_right",
            "ps_top",
        ]:
            rrfs.variables[name][:] = hrrr.variables[name][:] + gefs.variables[name][:]
        else:
            rrfs.variables[name][:] = hrrr.variables[name][:]

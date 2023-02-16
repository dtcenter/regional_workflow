import netCDF4 as nc
import numpy as np
import sys

filename = sys.argv[1]

# define an interpolation matrix
weights = np.array(
    [
        [1.0, 0.0, 0.0, 0.0],
        [1.0, 0.0, 0.0, 0.0],
        [1.0, 0.0, 0.0, 0.0],
        [0.5, 0.5, 0.0, 0.0],
        [0.0, 1.0, 0.0, 0.0],
        [0.0, 0.0, 1.0, 0.0],
        [0.0, 0.0, 0.5, 0.5],
        [0.0, 0.0, 0.0, 1.0],
        [0.0, 0.0, 0.0, 1.0],
    ]
)

with nc.Dataset(filename) as gefs, nc.Dataset(
    filename + "_soil_9_layers", "w"
) as gefs_rrfs:

    # copy all data into new file except for soil
    gefs_rrfs.setncatts(gefs.__dict__)
    for name, dimension in gefs.dimensions.items():
        if name not in ["zaxis_1"]:
            gefs_rrfs.createDimension(
                name, (len(dimension) if not dimension.isunlimited() else None)
            )

    for name, variable in gefs.variables.items():
        #if name not in ["smc", "slc", "stc", "zaxis_1", "t2m", "q2m"]:
        if name not in ["smc", "slc", "stc", "zaxis_1"]:
            gefs_rrfs.createVariable(name, variable.datatype, variable.dimensions)
            gefs_rrfs[name].setncatts(gefs[name].__dict__)
            gefs_rrfs.variables[name][:] = gefs.variables[name][:]

    # add data with new soil layers
    gefs_rrfs.createDimension("zaxis_1", 9)

    for name, variable in gefs.variables.items():
        if name in ["zaxis_1"]:
            gefs_rrfs.createVariable(name, variable.datatype, variable.dimensions)
            gefs_rrfs[name].setncatts(gefs[name].__dict__)
            gefs_rrfs.variables[name][:] = np.arange(1, 10)

        #if name in ["t2m", "q2m"]:
        #    gefs_rrfs.createVariable(name, variable.datatype, variable.dimensions)
        #    gefs_rrfs[name].setncatts(gefs[name].__dict__)
        #    gefs_rrfs.variables[name][:] = gefs.variables[name][:]

        if name in ["smc", "slc", "stc"]:
            gefs_rrfs.createVariable(name, variable.datatype, variable.dimensions)
            gefs_rrfs[name].setncatts(gefs[name].__dict__)

            # interpolate 4 layer gefs soil data to 9 layers using weight matrix
            soil_data = np.einsum("ij,kjmn->kimn", weights, gefs.variables[name][:])

            gefs_rrfs.variables[name][:] = soil_data

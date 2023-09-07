#!/bin/sh
#convert grib2 00.50 grib to Lambert projection, for the hiwt wpo project paintball plots

set +x

module load grib-bins
module list

outdir=/path/to/output/directory

for cyc in 2021053{0..9} 2021060{0..7}; do
   cd /glade/campaign/ral/jntp/briannen/ensemble_design_RRFS/obs_data/mrms/proc/${cyc}
    mkdir -p ${outdir}/${cyc}
    for hr in {00..23} ; do
        wgrib2 MergedReflectivityQCComposite_00.50_${cyc}-${hr}0000.grib2 -set_grib_type same -new_grid_winds earth -new_grid lambert:262.5:38.5:38.5:28.5 237.826355:1746:3000 21.885885:1014:3000 /glade/scratch/kalb/Ensemble_design/mrms/${cyc}/MergedReflectivityQCComposite_Lambert_${cyc}-${hr}0000.grib2
        echo "wgrib2 MergedReflectivityQCComposite_00.50_${cyc}-${hr}0000.grib2 -set_grib_type same -new_grid_winds earth -new_grid lambert:262.5:38.5:38.5:28.5 237.826355:1746:3000 21.885885:1014:3000 MergedReflectivityQCComposite_Lambert_${cyc}-${hr}0000.grib2"
    done
    cd ..
done

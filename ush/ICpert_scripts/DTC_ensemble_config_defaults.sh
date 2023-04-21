#!/bin/bash

#
#-----------------------------------------------------------------------
#
# This file serves as a central location for settings specific to DTC's
# Ensemble Design project.  It is sourced by other scripts.
#
#-----------------------------------------------------------------------
#
# Flag for running the RRFS analog workflow with stochastic physics.
#
#RRFS_do_stoch="FALSE"
RRFS_do_stoch="TRUE"
#
# Flag for running the GET_OBS_... tasks as part of the RRFS analog
# workflow.
#
RRFS_do_get_obs="FALSE"
#
# Directory in which GEFS output from 30-hour forecasts are staged.  This
# is output from the ensemble forecast that starts at 18Z two days prior
# to the start day of the forecasts in the RRFS analog workflow.
#
GEFS_staging_dir=${GEFS_staging_dir:-"/scratch2/BMC/fv3lam/ens_design_RRFS/data/GEFS/pgrb2_combined_bn"}
#
# Flag for performing a test run.  Relative to the full 10 RRFS member
# (9 GEFS member) ensemble on the 3km CONUS grid for 13 cycles with a
# forecast length of 36 hours, this entails one or more of the following
# changes:
#
# 1) using fewer members
# 2) using a coarser grid
# 3) running for fewer cycles
# 4) using a shorter forecast length
#
do_test_run="FALSE"
#
# Overrides to test run settings.  The following settings will be enforced
# regardless of the value of dt_test_run above.
#
#predef_grid_name="RRFS_CONUScompact_3km"
#date_last_cycl="20220512"
#fcst_len_hrs="36"
#num_RRFS_ens_members="10"

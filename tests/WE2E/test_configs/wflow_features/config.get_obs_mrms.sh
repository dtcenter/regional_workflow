#
# TEST PURPOSE/DESCRIPTION:
# ------------------------
#
# This test is to ensure that the workflow can pull the necessary MRMS
# observation files from NOAA's HPSS.  A relatively long forecast length
# and multiple cycle days and hours are used to ensure that the obs
# directories are properly set up.
#

RUN_ENVIR="community"
PREEXISTING_DIR_METHOD="rename"

DATE_FIRST_CYCL="20190701"
DATE_LAST_CYCL="20190702"
CYCL_HRS=( "00" "06" )
#
# For testing purposes (to verify that the obs directories are set up
# correctly), make the forecast length long enough that one of the cycles
# spans three distinct days.  In this case, the 06hr cycle with a length
# of 44 hours will span 20190701, 20190702, and 20190703.
#
FCST_LEN_HRS="44"
#
# Activate the task for pulling MRMS observations from NOAA HPSS and 
# specify the directory in which they should be placed.
#
RUN_TASK_GET_OBS_MRMS="TRUE"
MRMS_OBS_DIR='$EXPTDIR/obs/mrms/proc'
#
# Do not run the forecast and related tasks.
#
RUN_TASK_MAKE_GRID="FALSE"
RUN_TASK_MAKE_OROG="FALSE"
RUN_TASK_MAKE_SFC_CLIMO="FALSE"
RUN_TASK_GET_EXTRN_ICS="FALSE"
RUN_TASK_GET_EXTRN_LBCS="FALSE"
RUN_TASK_MAKE_ICS="FALSE"
RUN_TASK_MAKE_LBCS="FALSE"
RUN_TASK_RUN_FCST="FALSE"
RUN_TASK_RUN_POST="FALSE"

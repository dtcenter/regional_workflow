#
# TEST PURPOSE/DESCRIPTION:
# ------------------------
#
# This test is to ensure that 
#

RUN_ENVIR="community"
PREEXISTING_DIR_METHOD="rename"

POST_OUTPUT_DOMAIN_NAME="RRFS_CONUS_25km"

FCST_LEN_HRS="6"

DATE_FIRST_CYCL="20210508"
DATE_LAST_CYCL="20210508"
CYCL_HRS=( "00" )

RUN_TASK_MAKE_GRID="FALSE"
RUN_TASK_MAKE_OROG="FALSE"
RUN_TASK_MAKE_SFC_CLIMO="FALSE"
RUN_TASK_GET_EXTRN_ICS="FALSE"
RUN_TASK_GET_EXTRN_LBCS="FALSE"
RUN_TASK_MAKE_ICS="FALSE"
RUN_TASK_MAKE_LBCS="FALSE"
RUN_TASK_RUN_FCST="FALSE"
RUN_TASK_RUN_POST="FALSE"

RUN_TASK_GET_OBS_CCPA="FALSE"
#CCPA_OBS_DIR="/scratch2/BMC/fv3lam/ens_design_RRFS/obs_data/ccpa/proc"
CCPA_OBS_DIR="/scratch2/BMC/det/Gerard.Ketefian/UFS_CAM/DTC_ensemble_task/obs_data/ccpa/proc"

RUN_TASK_GET_OBS_MRMS="FALSE"
#MRMS_OBS_DIR="/scratch2/BMC/fv3lam/ens_design_RRFS/obs_data/mrms/proc"
MRMS_OBS_DIR="/scratch2/BMC/det/Gerard.Ketefian/UFS_CAM/DTC_ensemble_task/obs_data/mrms/proc"

RUN_TASK_GET_OBS_NDAS="FALSE"
#NDAS_OBS_DIR="/scratch2/BMC/fv3lam/ens_design_RRFS/obs_data/ndas/proc"
NDAS_OBS_DIR="/scratch2/BMC/det/Gerard.Ketefian/UFS_CAM/DTC_ensemble_task/obs_data/ndas/proc"

IS_ENS_FCST="FALSE"
RUN_TASKS_VXDET="TRUE"
RUN_TASKS_VXENS="TRUE"
NUM_ENS_MEMBERS="2"
ENS_TIME_LAG_HRS=( "0" "12")

VX_FCST_MODEL_NAME="FV3_RRFSE"
NET='RRFSE_CONUS'
VX_FIELDS=( "SFC" )
#
# Forecast files are staged (i.e. not generated as part of this experiment
# by running the forecast model) and use a naming convention different
# from the default in the SRW App.  Thus, we must explicitly specify the
# base directory of these files as well as their subdirectory and file
# templates.
#
MET_FCST_INPUT_DIR="/scratch1/BMC/hmtb/beck/ens_design_RRFS/data"
FCST_SUBDIR_TEMPLATE='{init?fmt=%Y%m%d%H?shift=-${time_lag}}${SLASH_ENSMEM_SUBDIR_OR_NULL}/postprd'
FCST_FN_TEMPLATE='${NET}.t{init?fmt=%H?shift=-${time_lag}}z.bgdawpf{lead?fmt=%HHH?shift=${time_lag}}.tm00.grib2'
FCST_SUBDIR_METPROC_TEMPLATE='{init?fmt=%Y%m%d%H}${SLASH_ENSMEM_SUBDIR_OR_NULL}/metprd/pcp_combine_fcst_cmn'
FCST_FN_METPROC_TEMPLATE='${NET}.t{init?fmt=%H}z.bgdawpf{lead?fmt=%HHH}.tm00_a${ACCUM}h.nc'

METPLUS_PATH="/contrib/METplus/METplus-4.1.1"
MET_INSTALL_DIR="/contrib/met/10.1.1"
#
# The following are for the old versions of the vx tasks.  Should remove
# at some point.
#
INCLUDE_OLD_VX_TASKS_IN_XML="FALSE"

RUN_TASK_VX_GRIDSTAT="TRUE"
RUN_TASK_VX_POINTSTAT="TRUE"
RUN_TASK_VX_ENSGRID="TRUE"
RUN_TASK_VX_ENSPOINT="TRUE"

WTIME_VX_ENSPOINT="08:00:00"
WTIME_VX_ENSGRID="08:00:00"

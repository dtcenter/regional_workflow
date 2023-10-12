#!/bin/ksh

MV_BATCH="/d2/projects/METViewer/src/apps/METviewer/bin/mv_batch.sh"

HOST="mohawk"
DB_NAME="mv_rrfse_icpert_stoch"
USER="mvuser"
PASS="mvuser"

R_TMPL="\/opt\/vxwww\/tomcat\/webapps\/metviewer\/R_tmpl"
R_WORK="\/opt\/vxwww\/tomcat\/webapps\/metviewer\/R_work"
PLOTS="\/d2\/projects\/ens_design_RRFS\/harrold\/xml_generic\/plots"
DATA="\/d2\/projects\/ens_design_RRFS\/harrold\/xml_generic\/data"
SCRIPTS="\/d2\/projects\/ens_design_RRFS\/harrold\/xml_generic\/scripts"

MODEL_1="RRFSE_CONUS_ICperts_nostoch.rrfs_conuscompact_3km"
MODEL_2="RRFSE_CONUS_ICperts_stoch.rrfs_conuscompact_3km"

TMPL_INFO="plot_rrfs_spring"

MOD_1_LEGEND="no stoch"
MOD_2_LEGEND="stoch"

TITLE="(30 April - 12 May 2022)"

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_10mW_rankhist.xml > ${TMPL_INFO}_10mW_rankhist.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_2mDPT_rankhist.xml > ${TMPL_INFO}_2mDPT_rankhist.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_2mT_rankhist.xml > ${TMPL_INFO}_2mT_rankhist.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_3hAPCP_rankhist.xml > ${TMPL_INFO}_3hAPCP_rankhist.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_500mbHGT_rankhist.xml > ${TMPL_INFO}_500mbHGT_rankhist.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_500mbT_rankhist.xml > ${TMPL_INFO}_500mbT_rankhist.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_500mbW_rankhist.xml > ${TMPL_INFO}_500mbW_rankhist.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_850mbDPT_rankhist.xml > ${TMPL_INFO}_850mbDPT_rankhist.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_850mbT_rankhist.xml > ${TMPL_INFO}_850mbT_rankhist.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_850mbW_rankhist.xml > ${TMPL_INFO}_850mbW_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_10mW_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_2mDPT_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_2mT_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_3hAPCP_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_500mbHGT_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_500mbT_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_500mbW_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_850mbDPT_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_850mbT_rankhist.xml

${MV_BATCH} ${TMPL_INFO}_850mbW_rankhist.xml

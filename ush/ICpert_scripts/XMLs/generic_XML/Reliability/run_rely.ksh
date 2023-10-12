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

MODEL_1="RRFSE_CONUS_ICperts_nostoch.rrfs_conuscompact_3km_prob"
MODEL_2="RRFSE_CONUS_ICperts_stoch.rrfs_conuscompact_3km_prob"

TMPL_INFO="plot_rrfs_spring"

MOD_1_LEGEND="no stoch"
MOD_2_LEGEND="stoch"

INIT_DATES="<val>2022-04-30 00:00:00<\/val><val>2022-05-01 00:00:00<\/val><val>2022-05-02 00:00:00<\/val><val>2022-05-03 00:00:00<\/val><val>2022-05-04 00:00:00<\/val><val>2022-05-05 00:00:00<\/val><val>2022-05-06 00:00:00<\/val><val>2022-05-07 00:00:00<\/val><val>2022-05-08 00:00:00<\/val><val>2022-05-09 00:00:00<\/val><val>2022-05-10 00:00:00<\/val><val>2022-05-11 00:00:00<\/val><val>2022-05-12 00:00:00<\/val>"

TITLE="(30 April - 12 May 2022)"

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_10mW_05_rely.xml > ${TMPL_INFO}_10mW_05_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_10mW_10_rely.xml > ${TMPL_INFO}_10mW_10_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_2mDPT_288_rely.xml > ${TMPL_INFO}_2mDPT_288_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_2mDPT_293_rely.xml > ${TMPL_INFO}_2mDPT_293_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_2mT_293_rely.xml > ${TMPL_INFO}_2mT_293_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_2mT_298_rely.xml > ${TMPL_INFO}_2mT_298_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_2mT_303_rely.xml > ${TMPL_INFO}_2mT_303_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_3hAPCP_0_rely.xml > ${TMPL_INFO}_3hAPCP_0_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_3hAPCP_2.54_rely.xml > ${TMPL_INFO}_3hAPCP_2.54_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_500mbHGT_5400_rely.xml > ${TMPL_INFO}_500mbHGT_5400_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_500mbHGT_5880_rely.xml > ${TMPL_INFO}_500mbHGT_5880_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_500mbT_258_rely.xml > ${TMPL_INFO}_500mbT_258_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_500mbT_263_rely.xml > ${TMPL_INFO}_500mbT_263_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_500mbW_15_rely.xml > ${TMPL_INFO}_500mbW_15_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_500mbW_21_rely.xml > ${TMPL_INFO}_500mbW_21_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_850mbDPT_278_rely.xml > ${TMPL_INFO}_850mbDPT_278_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_850mbDPT_283_rely.xml > ${TMPL_INFO}_850mbDPT_283_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_850mbT_293_rely.xml > ${TMPL_INFO}_850mbT_293_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_850mbT_298_rely.xml > ${TMPL_INFO}_850mbT_298_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_850mbW_05_rely.xml > ${TMPL_INFO}_850mbW_05_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_850mbW_15_rely.xml > ${TMPL_INFO}_850mbW_15_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_REFC_20_rely.xml > ${TMPL_INFO}_REFC_20_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_REFC_30_rely.xml > ${TMPL_INFO}_REFC_30_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_RETOP_20_rely.xml > ${TMPL_INFO}_RETOP_20_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_RETOP_30_rely.xml > ${TMPL_INFO}_RETOP_30_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_VIS_1609_rely.xml > ${TMPL_INFO}_VIS_1609_rely.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g" plot_VIS_8045_rely.xml > ${TMPL_INFO}_VIS_8045_rely.xml

${MV_BATCH} ${TMPL_INFO}_10mW_05_rely.xml

${MV_BATCH} ${TMPL_INFO}_10mW_10_rely.xml

${MV_BATCH} ${TMPL_INFO}_2mDPT_288_rely.xml

${MV_BATCH} ${TMPL_INFO}_2mDPT_293_rely.xml

${MV_BATCH} ${TMPL_INFO}_2mT_293_rely.xml

${MV_BATCH} ${TMPL_INFO}_2mT_298_rely.xml

${MV_BATCH} ${TMPL_INFO}_2mT_303_rely.xml

${MV_BATCH} ${TMPL_INFO}_3hAPCP_0_rely.xml

${MV_BATCH} ${TMPL_INFO}_3hAPCP_2.54_rely.xml

${MV_BATCH} ${TMPL_INFO}_500mbHGT_5400_rely.xml

${MV_BATCH} ${TMPL_INFO}_500mbHGT_5880_rely.xml

${MV_BATCH} ${TMPL_INFO}_500mbT_258_rely.xml

${MV_BATCH} ${TMPL_INFO}_500mbT_263_rely.xml

${MV_BATCH} ${TMPL_INFO}_500mbW_15_rely.xml

${MV_BATCH} ${TMPL_INFO}_500mbW_21_rely.xml

${MV_BATCH} ${TMPL_INFO}_850mbDPT_278_rely.xml

${MV_BATCH} ${TMPL_INFO}_850mbDPT_283_rely.xml

${MV_BATCH} ${TMPL_INFO}_850mbT_293_rely.xml

${MV_BATCH} ${TMPL_INFO}_850mbT_298_rely.xml

${MV_BATCH} ${TMPL_INFO}_850mbW_05_rely.xml

${MV_BATCH} ${TMPL_INFO}_850mbW_15_rely.xml

${MV_BATCH} ${TMPL_INFO}_REFC_20_rely.xml

${MV_BATCH} ${TMPL_INFO}_REFC_30_rely.xml

${MV_BATCH} ${TMPL_INFO}_RETOP_20_rely.xml

${MV_BATCH} ${TMPL_INFO}_RETOP_30_rely.xml

${MV_BATCH} ${TMPL_INFO}_VIS_1609_rely.xml

${MV_BATCH} ${TMPL_INFO}_VIS_8045_rely.xml

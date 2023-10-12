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

FHR_LEAD="<val label=\"0\" plot_val=\"\">0<\/val><val label=\"1\" plot_val=\"\">10000<\/val><val label=\"2\" plot_val=\"\">20000<\/val><val label=\"3\" plot_val=\"\">30000<\/val><val label=\"4\" plot_val=\"\">40000<\/val><val label=\"5\" plot_val=\"\">50000<\/val><val label=\"6\" plot_val=\"\">60000<\/val><val label=\"7\" plot_val=\"\">70000<\/val><val label=\"8\" plot_val=\"\">80000<\/val><val label=\"9\" plot_val=\"\">90000<\/val><val label=\"10\" plot_val=\"\">100000<\/val><val label=\"11\" plot_val=\"\">110000<\/val><val label=\"12\" plot_val=\"\">120000<\/val><val label=\"13\" plot_val=\"\">130000<\/val><val label=\"14\" plot_val=\"\">140000<\/val><val label=\"15\" plot_val=\"\">150000<\/val><val label=\"16\" plot_val=\"\">160000<\/val><val label=\"17\" plot_val=\"\">170000<\/val><val label=\"18\" plot_val=\"\">180000<\/val><val label=\"19\" plot_val=\"\">190000<\/val><val label=\"20\" plot_val=\"\">200000<\/val><val label=\"21\" plot_val=\"\">210000<\/val><val label=\"22\" plot_val=\"\">220000<\/val><val label=\"23\" plot_val=\"\">230000<\/val><val label=\"24\" plot_val=\"\">240000<\/val><val label=\"25\" plot_val=\"\">250000<\/val><val label=\"26\" plot_val=\"\">260000<\/val><val label=\"27\" plot_val=\"\">270000<\/val><val label=\"28\" plot_val=\"\">280000<\/val><val label=\"29\" plot_val=\"\">290000<\/val><val label=\"30\" plot_val=\"\">300000<\/val><val label=\"31\" plot_val=\"\">310000<\/val><val label=\"32\" plot_val=\"\">320000<\/val><val label=\"33\" plot_val=\"\">330000<\/val><val label=\"34\" plot_val=\"\">340000<\/val><val label=\"35\" plot_val=\"\">350000<\/val><val label=\"36\" plot_val=\"\">360000<\/val>"

TITLE="(30 April - 12 May 2022)"

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_10mW_05_AUC_rfmt.xml > ${TMPL_INFO}_10mW_05_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_10mW_10_AUC_rfmt.xml > ${TMPL_INFO}_10mW_10_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_2mDPT_288_AUC_rfmt.xml > ${TMPL_INFO}_2mDPT_288_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_2mDPT_293_AUC_rfmt.xml > ${TMPL_INFO}_2mDPT_293_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_2mT_293_AUC_rfmt.xml > ${TMPL_INFO}_2mT_293_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_2mT_298_AUC_rfmt.xml > ${TMPL_INFO}_2mT_298_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_3hAPCP_0_AUC_rfmt.xml > ${TMPL_INFO}_3hAPCP_0_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_3hAPCP_2.54_AUC_rfmt.xml > ${TMPL_INFO}_3hAPCP_2.54_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_500mbHGT_ge5400_AUC_rfmt.xml > ${TMPL_INFO}_500mbHGT_ge5400_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_500mbHGT_ge5880_AUC_rfmt.xml > ${TMPL_INFO}_500mbHGT_ge5880_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_500mbT_ge258_AUC_rfmt.xml > ${TMPL_INFO}_500mbT_ge258_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_500mbT_ge268_AUC_rfmt.xml > ${TMPL_INFO}_500mbT_ge268_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_500mbW_ge15_AUC_rfmt.xml > ${TMPL_INFO}_500mbW_ge15_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_500mbW_ge21_AUC_rfmt.xml > ${TMPL_INFO}_500mbW_ge21_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_850mbDPT_ge278_AUC_rfmt.xml > ${TMPL_INFO}_850mbDPT_ge278_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_850mbDPT_ge283_AUC_rfmt.xml > ${TMPL_INFO}_850mbDPT_ge283_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_850mbT_ge293_AUC_rfmt.xml > ${TMPL_INFO}_850mbT_ge293_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_850mbT_ge298_AUC_rfmt.xml > ${TMPL_INFO}_850mbT_ge298_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_850mbW_ge05_AUC_rfmt.xml > ${TMPL_INFO}_850mbW_ge05_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_850mbW_ge15_AUC_rfmt.xml > ${TMPL_INFO}_850mbW_ge15_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_REFC_20_AUC_rfmt.xml > ${TMPL_INFO}_REFC_20_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_REFC_30_AUC_rfmt.xml > ${TMPL_INFO}_REFC_30_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_RETOP_20_AUC_rfmt.xml > ${TMPL_INFO}_RETOP_20_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_RETOP_30_AUC_rfmt.xml > ${TMPL_INFO}_RETOP_30_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_VIS_1609_AUC_rfmt.xml > ${TMPL_INFO}_VIS_1609_AUC_rfmt.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_VIS_8054_AUC_rfmt.xml > ${TMPL_INFO}_VIS_8054_AUC_rfmt.xml


${MV_BATCH} ${TMPL_INFO}_10mW_05_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_10mW_10_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_2mDPT_288_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_2mDPT_293_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_2mT_293_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_2mT_298_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_3hAPCP_0_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_3hAPCP_2.54_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_500mbHGT_ge5400_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_500mbHGT_ge5880_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_500mbT_ge258_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_500mbT_ge268_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_500mbW_ge15_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_500mbW_ge21_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_850mbDPT_ge278_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_850mbDPT_ge283_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_850mbT_ge293_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_850mbT_ge298_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_850mbW_ge05_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_850mbW_ge15_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_REFC_20_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_REFC_30_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_RETOP_20_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_RETOP_30_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_VIS_1609_AUC_rfmt.xml
${MV_BATCH} ${TMPL_INFO}_VIS_8054_AUC_rfmt.xml

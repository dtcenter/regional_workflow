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

INIT_DATES="<val>2022-04-30 00:00:00<\/val><val>2022-05-01 00:00:00<\/val><val>2022-05-02 00:00:00<\/val><val>2022-05-03 00:00:00<\/val><val>2022-05-04 00:00:00<\/val><val>2022-05-05 00:00:00<\/val><val>2022-05-06 00:00:00<\/val><val>2022-05-07 00:00:00<\/val><val>2022-05-08 00:00:00<\/val><val>2022-05-09 00:00:00<\/val><val>2022-05-10 00:00:00<\/val><val>2022-05-11 00:00:00<\/val><val>2022-05-12 00:00:00<\/val>"

FHR_LEAD="<val label=\"0\" plot_val=\"\">0<\/val><val label=\"1\" plot_val=\"\">10000<\/val><val label=\"2\" plot_val=\"\">20000<\/val><val label=\"3\" plot_val=\"\">30000<\/val><val label=\"4\" plot_val=\"\">40000<\/val><val label=\"5\" plot_val=\"\">50000<\/val><val label=\"6\" plot_val=\"\">60000<\/val><val label=\"7\" plot_val=\"\">70000<\/val><val label=\"8\" plot_val=\"\">80000<\/val><val label=\"9\" plot_val=\"\">90000<\/val><val label=\"10\" plot_val=\"\">100000<\/val><val label=\"11\" plot_val=\"\">110000<\/val><val label=\"12\" plot_val=\"\">120000<\/val><val label=\"13\" plot_val=\"\">130000<\/val><val label=\"14\" plot_val=\"\">140000<\/val><val label=\"15\" plot_val=\"\">150000<\/val><val label=\"16\" plot_val=\"\">160000<\/val><val label=\"17\" plot_val=\"\">170000<\/val><val label=\"18\" plot_val=\"\">180000<\/val><val label=\"19\" plot_val=\"\">190000<\/val><val label=\"20\" plot_val=\"\">200000<\/val><val label=\"21\" plot_val=\"\">210000<\/val><val label=\"22\" plot_val=\"\">220000<\/val><val label=\"23\" plot_val=\"\">230000<\/val><val label=\"24\" plot_val=\"\">240000<\/val><val label=\"25\" plot_val=\"\">250000<\/val><val label=\"26\" plot_val=\"\">260000<\/val><val label=\"27\" plot_val=\"\">270000<\/val><val label=\"28\" plot_val=\"\">280000<\/val><val label=\"29\" plot_val=\"\">290000<\/val><val label=\"30\" plot_val=\"\">300000<\/val><val label=\"31\" plot_val=\"\">310000<\/val><val label=\"32\" plot_val=\"\">320000<\/val><val label=\"33\" plot_val=\"\">330000<\/val><val label=\"34\" plot_val=\"\">340000<\/val><val label=\"35\" plot_val=\"\">350000<\/val><val label=\"36\" plot_val=\"\">360000<\/val>"

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_10mW_bias.xml > ${TMPL_INFO}_10mW_bias.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_2mDPT_bias.xml > ${TMPL_INFO}_2mDPT_bias.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_2mT_bias.xml > ${TMPL_INFO}_2mT_bias.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_500mbHGT_bias.xml > ${TMPL_INFO}_500mbHGT_bias.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_500mbT_bias.xml > ${TMPL_INFO}_500mbT_bias.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_500mbW_bias.xml > ${TMPL_INFO}_500mbW_bias.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_850mbDPT_bias.xml > ${TMPL_INFO}_850mbDPT_bias.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_850mbT_bias.xml > ${TMPL_INFO}_850mbT_bias.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_850mbW_bias.xml > ${TMPL_INFO}_850mbW_bias.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/INIT_DATES/${INIT_DATES}/g; s/FHR_LEAD/${FHR_LEAD}/g" plot_VIS_bias.xml > ${TMPL_INFO}_VIS_bias.xml

${MV_BATCH} ${TMPL_INFO}_10mW_bias.xml

${MV_BATCH} ${TMPL_INFO}_2mDPT_bias.xml

${MV_BATCH} ${TMPL_INFO}_2mT_bias.xml

${MV_BATCH} ${TMPL_INFO}_500mbHGT_bias.xml

${MV_BATCH} ${TMPL_INFO}_500mbT_bias.xml

${MV_BATCH} ${TMPL_INFO}_500mbW_bias.xml

${MV_BATCH} ${TMPL_INFO}_850mbDPT_bias.xml

${MV_BATCH} ${TMPL_INFO}_850mbT_bias.xml

${MV_BATCH} ${TMPL_INFO}_850mbW_bias.xml

${MV_BATCH} ${TMPL_INFO}_VIS_bias.xml

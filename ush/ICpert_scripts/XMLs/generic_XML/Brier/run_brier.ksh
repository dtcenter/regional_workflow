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

FHR_LEAD_1="<val label=\"0\" plot_val=\"\">0<\/val><val label=\"1\" plot_val=\"\">10000<\/val><val label=\"2\" plot_val=\"\">20000<\/val><val label=\"3\" plot_val=\"\">30000<\/val><val label=\"4\" plot_val=\"\">40000<\/val><val label=\"5\" plot_val=\"\">50000<\/val><val label=\"6\" plot_val=\"\">60000<\/val><val label=\"7\" plot_val=\"\">70000<\/val><val label=\"8\" plot_val=\"\">80000<\/val><val label=\"9\" plot_val=\"\">90000<\/val><val label=\"10\" plot_val=\"\">100000<\/val><val label=\"11\" plot_val=\"\">110000<\/val><val label=\"12\" plot_val=\"\">120000<\/val><val label=\"13\" plot_val=\"\">130000<\/val><val label=\"14\" plot_val=\"\">140000<\/val><val label=\"15\" plot_val=\"\">150000<\/val><val label=\"16\" plot_val=\"\">160000<\/val><val label=\"17\" plot_val=\"\">170000<\/val><val label=\"18\" plot_val=\"\">180000<\/val><val label=\"19\" plot_val=\"\">190000<\/val><val label=\"20\" plot_val=\"\">200000<\/val><val label=\"21\" plot_val=\"\">210000<\/val><val label=\"22\" plot_val=\"\">220000<\/val><val label=\"23\" plot_val=\"\">230000<\/val><val label=\"24\" plot_val=\"\">240000<\/val><val label=\"25\" plot_val=\"\">250000<\/val><val label=\"26\" plot_val=\"\">260000<\/val><val label=\"27\" plot_val=\"\">270000<\/val><val label=\"28\" plot_val=\"\">280000<\/val><val label=\"29\" plot_val=\"\">290000<\/val><val label=\"30\" plot_val=\"\">300000<\/val><val label=\"31\" plot_val=\"\">310000<\/val><val label=\"32\" plot_val=\"\">320000<\/val><val label=\"33\" plot_val=\"\">330000<\/val><val label=\"34\" plot_val=\"\">340000<\/val><val label=\"35\" plot_val=\"\">350000<\/val><val label=\"36\" plot_val=\"\">360000<\/val>"

FHR_LEAD_3="<val label=\"3\" plot_val=\"\">30000<\/val><val label=\"6\" plot_val=\"\">60000<\/val><val label=\"9\" plot_val=\"\">90000<\/val><val label=\"12\" plot_val=\"\">120000<\/val><val label=\"15\" plot_val=\"\">150000<\/val><val label=\"18\" plot_val=\"\">180000<\/val><val label=\"21\" plot_val=\"\">210000<\/val><val label=\"24\" plot_val=\"\">240000<\/val><val label=\"27\" plot_val=\"\">270000<\/val><val label=\"30\" plot_val=\"\">300000<\/val><val label=\"33\" plot_val=\"\">330000<\/val><val label=\"36\" plot_val=\"\">360000<\/val>"

TITLE="(30 April - 12 May 2022)"

# For APCP, use FHR_LEAD_3
sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_3}/g" plot_3hAPCP_00_brier.xml > ${TMPL_INFO}_3hAPCP_00_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_3}/g" plot_3hAPCP_2.54_brier.xml > ${TMPL_INFO}_3hAPCP_2.54_brier.xml

# For non-APCP, use FHR_LEAD_1
sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_10mW_05_brier.xml > ${TMPL_INFO}_10mW_05_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_10mW_10_brier.xml > ${TMPL_INFO}_10mW_10_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_2mDPT_288_brier.xml > ${TMPL_INFO}_2mDPT_288_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_2mDPT_293_brier.xml > ${TMPL_INFO}_2mDPT_293_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_2mT_293_brier.xml > ${TMPL_INFO}_2mT_293_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_2mT_298_brier.xml > ${TMPL_INFO}_2mT_298_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_500mbHGT_ge5400_brier.xml > ${TMPL_INFO}_500mbHGT_ge5400_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_500mbHGT_ge5880_brier.xml > ${TMPL_INFO}_500mbHGT_ge5880_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_500mbT_ge258_brier.xml > ${TMPL_INFO}_500mbT_ge258_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_500mbT_ge268_brier.xml > ${TMPL_INFO}_500mbT_ge268_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_500mbW_ge15_brier.xml > ${TMPL_INFO}_500mbW_ge15_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_500mbW_ge21_brier.xml > ${TMPL_INFO}_500mbW_ge21_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_850mbDPT_278_brier.xml > ${TMPL_INFO}_850mbDPT_278_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_850mbDPT_283_brier.xml > ${TMPL_INFO}_850mbDPT_283_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_850mbT_293_brier.xml > ${TMPL_INFO}_850mbT_293_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_850mbT_298_brier.xml > ${TMPL_INFO}_850mbT_298_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_850mbW_05_brier.xml > ${TMPL_INFO}_850mbW_05_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_850mbW_15_brier.xml > ${TMPL_INFO}_850mbW_15_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_REFC_20_brier.xml > ${TMPL_INFO}_REFC_20_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_REFC_30_brier.xml > ${TMPL_INFO}_REFC_30_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_RETOP_20_brier.xml > ${TMPL_INFO}_RETOP_20_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_RETOP_30_brier.xml > ${TMPL_INFO}_RETOP_30_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_VIS_ge8054_brier.xml > ${TMPL_INFO}_VIS_ge8054_brier.xml

sed "s/PLOTS/${PLOTS}/g; s/HOST/${HOST}/g; s/USER/${USER}/g; s/PASS/${PASS}/g; s/R_TMPL/${R_TMPL}/g; s/R_WORK/${R_WORK}/g; s/DATA/${DATA}/g; s/SCRIPTS/${SCRIPTS}/g; s/DB_NAME/${DB_NAME}/g; s/MODEL_1/${MODEL_1}/g; s/MODEL_2/${MODEL_2}/g; s/TMPL_INFO/${TMPL_INFO}/g; s/MOD_1_LEGEND/${MOD_1_LEGEND}/g; s/MOD_2_LEGEND/${MOD_2_LEGEND}/g; s/TITLE/${TITLE}/g; s/FHR_LEAD/${FHR_LEAD_1}/g" plot_VIS_lt1609_brier.xml > ${TMPL_INFO}_VIS_lt1609_brier.xml

${MV_BATCH} ${TMPL_INFO}_3hAPCP_00_brier.xml

${MV_BATCH} ${TMPL_INFO}_3hAPCP_2.54_brier.xml

${MV_BATCH} ${TMPL_INFO}_10mW_05_brier.xml

${MV_BATCH} ${TMPL_INFO}_10mW_10_brier.xml

${MV_BATCH} ${TMPL_INFO}_2mDPT_288_brier.xml

${MV_BATCH} ${TMPL_INFO}_2mDPT_293_brier.xml

${MV_BATCH} ${TMPL_INFO}_2mT_293_brier.xml

${MV_BATCH} ${TMPL_INFO}_2mT_298_brier.xml

${MV_BATCH} ${TMPL_INFO}_500mbHGT_ge5400_brier.xml

${MV_BATCH} ${TMPL_INFO}_500mbHGT_ge5880_brier.xml

${MV_BATCH} ${TMPL_INFO}_500mbT_ge258_brier.xml

${MV_BATCH} ${TMPL_INFO}_500mbT_ge268_brier.xml

${MV_BATCH} ${TMPL_INFO}_500mbW_ge15_brier.xml

${MV_BATCH} ${TMPL_INFO}_500mbW_ge21_brier.xml

${MV_BATCH} ${TMPL_INFO}_850mbDPT_278_brier.xml

${MV_BATCH} ${TMPL_INFO}_850mbDPT_283_brier.xml

${MV_BATCH} ${TMPL_INFO}_850mbT_293_brier.xml

${MV_BATCH} ${TMPL_INFO}_850mbT_298_brier.xml

${MV_BATCH} ${TMPL_INFO}_850mbW_05_brier.xml

${MV_BATCH} ${TMPL_INFO}_850mbW_15_brier.xml

${MV_BATCH} ${TMPL_INFO}_REFC_20_brier.xml

${MV_BATCH} ${TMPL_INFO}_REFC_30_brier.xml

${MV_BATCH} ${TMPL_INFO}_RETOP_20_brier.xml

${MV_BATCH} ${TMPL_INFO}_RETOP_30_brier.xml

${MV_BATCH} ${TMPL_INFO}_VIS_ge8054_brier.xml

${MV_BATCH} ${TMPL_INFO}_VIS_lt1609_brier.xml

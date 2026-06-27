
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION — extension
*
* > THIS SCRIPT
* AIM: Wrapper que carga config + datos y ejecuta table_tF_inference.do
*
* > NOTES
* 1: Correr desde la raiz del proyecto (C:\Users\gquij\projects\replication)




** SETUP ---------------------------------------------------------------------------------------------------------------------------------------------
version    14.2
set more   off
set        matsize 11000
clear      all



** LOG EXPLICITO
capture log close _all
log using "C:/Users/gquij/projects/replication/_run_tF_inference_out.log", text replace name(tflog)



** DIRECTORIES
cd "C:/Users/gquij/projects/replication"
do "code/config_proj.do"



** APUNTAR STATA AL ado/plus LOCAL DEL PROYECTO (donde estan xtivreg2, ivreg2, etc.)
sysdir set PLUS "$DIR_PRJ/ado/plus"
adopath ++ "$DIR_PRJ/ado/plus"



** DATA INPUT
cd   "$DIR_PRJ_DSPC"
use  panel_forAnalysis, clear



** SAMPLE TIME PERIOD
scalar yearFirst = 2006
scalar yearLast  = 2016



** PANEL SETUP - xtivreg2 necesita xtset
xtset muni_code year



** RUN tF INFERENCE
cd   "$DIR_PRJ_CANL_REG"
do   table_tF_inference.do



log close tflog

* END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------

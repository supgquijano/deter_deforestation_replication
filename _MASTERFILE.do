
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: RUN FULL ANALYSIS
*
* > NOTES
* 1: RUNTIME < 1 MINUTE





** SETUP ---------------------------------------------------------------------------------------------------------------------------------------------

** THE BASICS
version    14.2
set more   off
set        matsize 11000
clear      all
*macro drop _all



** DIRECTORIES [GLOBALS]
if "$DIR_PRJ_DSPC" == "" {
  local dofileFullPath = "`c(pwd)'" + "/code/" + "config_proj.do"
  do                     "`dofileFullPath'"
}
*





** DATA INPUT & PREP ---------------------------------------------------------------------------------------------------------------------------------

** DATA INPUT
cd   "$DIR_PRJ_DSPC"
use  panel_fromR, clear



** DATA PREP [ANNUAL PANEL]
cd   "$DIR_PRJ_CSPC"
do   dataPrep_forAnalysis

cd   "$DIR_PRJ_DSPC"
save panel_forAnalysis, replace



** DATA PREP [MONHTLY PANEL]
cd   "$DIR_PRJ_CSPC"
do   dataPrep_forAnalysis_monthly

cd   "$DIR_PRJ_DSPC"
save panel_forAnalysis_monthly, replace



** SETUP
** sample time period
scalar yearFirst = 2006
scalar yearLast  = 2016





** SUPPORT STATS -------------------------------------------------------------------------------------------------------------------------------------

** DEFORESTATION INCREMENT DISTRIBUTION
/* supports ln(.) transformation used in 'dataPrep_forAnalysis' 
    _ln(x +    1):          shifts observations with x==0 past (to the right of) the smallest non-zero observed value
	  _ln(x + 0.01): does not shift  observations with x==0 past (to the right of) the smallest non-zero observed value                               */

cd "$DIR_PRJ_DANL_STS"
log using supportStats_distribDeforestation, text replace

count if(prodes_deforest > 0 & prodes_deforest < 1)
count if(prodes_deforest > 0 & prodes_deforest < 0.01)

log close 



** BASELINE FOREST AREA
/* obs: supports heterogeneity specifications */
cd "$DIR_PRJ_DANL_STS"
log using supportStats_distribBaselineForest, text replace

summarize prodes03_forest, d
scalar    forest03_p50 = r(p50)

log close 





** REGRESSIONS ---------------------------------------------------------------------------------------------------------------------------------------

** TABLE 1 - FIRST STAGE - CLOUD COVERAGE ON LAW ENFORCEMENT
cd         "$DIR_PRJ_DSPC"
use        panel_forAnalysis, clear

set more   off
global     modelName        "table1_stage1_cloudsEnforcement"
cd                          "$DIR_PRJ_DANL_REG"
local      dofileFullPath = "$DIR_PRJ_CANL_REG" + "/" + "$modelName" + ".do"
do                          "`dofileFullPath'"
macro drop modelName



** FIGURE 3 - FIRST STAGE - CLOUD COVERAGE ON LAW ENFORCEMENT, MONTHLY
cd         "$DIR_PRJ_DSPC"
use        panel_forAnalysis_monthly, clear

set more   off
global     modelName        "figure3_stage1_cloudsEnforcement_monthly"
cd                          "$DIR_PRJ_DANL_REG"
local      dofileFullPath = "$DIR_PRJ_CANL_REG" + "/" + "$modelName" + ".do"
do                          "`dofileFullPath'"
macro drop modelName



** TABLE 2 - IMPACT OF LAW ENFORCEMENT ON DEFORESTATION - benchmark
cd         "$DIR_PRJ_DSPC"
use        panel_forAnalysis, clear

set more   off
global     modelName        "table2_stage2_enforcementDeforestation"
cd                          "$DIR_PRJ_DANL_REG"
local      dofileFullPath = "$DIR_PRJ_CANL_REG" + "/" + "$modelName" + ".do"
do                          "`dofileFullPath'"
macro drop modelName



** TABLE 3 - ROBUSTNESS
cd         "$DIR_PRJ_DSPC"
use        panel_forAnalysis, clear

set more   off
global     modelName        "table3_robustness"
cd                          "$DIR_PRJ_DANL_REG"
local      dofileFullPath = "$DIR_PRJ_CANL_REG" + "/" + "$modelName" + ".do"
do                          "`dofileFullPath'"
macro drop modelName



** TABLE 4 - REDUCED FORM AND PLACEBO
cd         "$DIR_PRJ_DSPC"
use        panel_forAnalysis, clear

set more   off
global     modelName        "table4_placebo"
cd                          "$DIR_PRJ_DANL_REG"
local      dofileFullPath = "$DIR_PRJ_CANL_REG" + "/" + "$modelName" + ".do"
do                          "`dofileFullPath'"
macro drop modelName



** FIGURE 4 - PLACEBO - CLOUD COVERAGE ON DEFORESTATION, PRE-DETER
cd         "$DIR_PRJ_DSPC"
use        panel_forAnalysis, clear

set more   off
global     modelName        "figure4_placebo_preDeterClouds"
cd                          "$DIR_PRJ_DANL_REG"
local      dofileFullPath = "$DIR_PRJ_CANL_REG" + "/" + "$modelName" + ".do"
do                          "`dofileFullPath'"
macro drop modelName





** APPENDIX ------------------------------------------------------------------------------------------------------------------------------------------

** TABLE A.1 - SUMMARY STATS 
cd "$DIR_PRJ_DSPC"
use panel_forAnalysis, clear

cd "$DIR_PRJ_CANL_STS"
do tableA1_sumStats



** TABLE B.2 - COUNTERFACTUALS
cd         "$DIR_PRJ_DSPC"
use        panel_forAnalysis, clear

set more   off
global     modelName        "tableB2_counterfactual"
cd                          "$DIR_PRJ_DANL_SIM"
local      dofileFullPath = "$DIR_PRJ_CANL_SIM" + "/" + "$modelName" + ".do"
do                          "`dofileFullPath'"
macro drop modelName



** FIGURE B.2 - COUNTERFACTUALS
set more   off
global     modelName        "figureB2_gph_counterfactual"
cd                          "$DIR_PRJ_CANL_GRP"
local      dofileFullPath = "$DIR_PRJ_CANL_GRP" + "/" + "$modelName" + ".do"
do                          "`dofileFullPath'"
macro drop modelName



** TABLE C.3 - ROBUSTNESS ALTERNATIVE WEATHER VARIABLES (COMPLETE)                                                                                                                 */
cd         "$DIR_PRJ_DSPC"
use        panel_forAnalysis, clear

set more   off
global     modelName        "tableC3_robustness_altWeather"
cd                          "$DIR_PRJ_DANL_REG"
local      dofileFullPath = "$DIR_PRJ_CANL_REG" + "/" + "$modelName" + ".do"
do                          "`dofileFullPath'"
macro drop modelName





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

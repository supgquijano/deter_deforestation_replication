
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: PREPARE DATASET FOR ANALYSIS (MONTHLY PANEL)
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING





** MONTHLY DATASET PREP ------------------------------------------------------------------------------------------------------------------------------

** MONTHLY DATA IMPORT & MERGE WITH SPATIAL SAMPLE
cd         "$DIR_PRJ_DSPC"
use        panel_forAnalysis, clear

bysort     muni_code: keep if _n==1
keep       muni_code region_micro_code
merge 1:m  muni_code using panelMonthly_fromR.dta
keep if    _merge==3
drop       _merge


** TIME SERIES SETUP
tostring   month, replace
replace    month="01" if month=="1"
replace    month="02" if month=="2"
replace    month="03" if month=="3"
replace    month="04" if month=="4"
replace    month="05" if month=="5"
replace    month="06" if month=="6"
replace    month="07" if month=="7"
replace    month="08" if month=="8"
replace    month="09" if month=="9"
destring   month, replace

gen        year_month = ym(year, month)
format     year_month %tm
tsset      muni_code year_month





** VAR CONSTRUCTION ----------------------------------------------------------------------------------------------------------------------------------

** CLUSTERS FOR ERROS
egen       cl_microYearMonth = concat(region_micro_code year month), punct("_")
label var  cl_microYearMonth   "[two-way cluster] microregion-year-month"


** DETER CLOUDS LEADS/LAGS
gen        deter_cloud_lag1 = L.deter_cloud
gen        deter_cloud_lag2 = L2.deter_cloud
gen        deter_cloud_f1   = f.deter_cloud
gen        deter_cloud_f2   = f2.deter_cloud

label var  deter_cloud_lag2 "t-2"  /* labels chosen for use in graph output (fig3) -- not consistent with dataset pattern */
label var  deter_cloud_lag1 "t-1"
label var  deter_cloud      "t"
label var  deter_cloud_f2   "t+2"
label var  deter_cloud_f1   "t+1"





** EXPORT PREP ---------------------------------------------------------------------------------------------------------------------------------------

** ORDER
#delimit ;
  order muni*
	      region*
				year*
				month
				prodes_deforest*
				deter_cloud*
				nasa_cloud
				fines*
				prodes_nonobs
				prodes_cloud
				weather*
				price*
				prodes03*
				cl_*
  ;
#delimit cr



** CHECK POINT
mdesc
sort muni_code year_month





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

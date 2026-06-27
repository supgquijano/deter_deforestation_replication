
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: PREPARE DATASET FOR ANALYSIS (ANNUAL PANEL) 
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING





** TIME SERIES SETUP ---------------------------------------------------------------------------------------------------------------------------------

tsset muni_code year





** VAR FORMATTING ------------------------------------------------------------------------------------------------------------------------------------

** UNITS
replace muni_area = muni_area * 0.01



** LABELS
lab var muni_code                   "municipality IBGE code (7-digit)"
lab var muni_area                   "municipal area (sq km; calc from sp data under SAD69polyconic)"
lab var year                        "year of reference"
lab var deter_cloud                 "DETER cloud coverage (share of municipal area; PRODES year)"
lab var nasa_cloud                  "NASA cloud coverage (share of municipal area; PRODES year)"
lab var fines_count                 "number of flora-related fines (count; PRODES year)"
lab var fines_value                 "value of flora-related fines (BRL; PRODES year)"
lab var prodes_deforest             "increment in deforested area (sq km; PRODES year)"
lab var prodes03_deforest           "[xsection] 2003 increment in deforested area (sq km)"
lab var prodes03_forest             "[xsection] 2003 forest cover (share of municipal area)"
lab var prodes03_cleared            "[xsection] 2003 cleared area (share of municipal area)"
lab var weather_rain                "total precipitation (Uni Delaware) (mm; PRODES year)"
lab var weather_temp                "average temperature (Uni Delaware) (degrees Celsius; PRODES year)"
lab var priceNdx_brzl_y_cattle      "real price index, beef cattle (calendar year)"
lab var priceNdx_brzl_y_sugar       "real price index, sugarcane (calendar year)"
lab var priceNdx_brzl_y_corn        "real price index, corn (calendar year)"
lab var priceNdx_brzl_y_soybean     "real price index, soybean (calendar year)"
lab var priceNdx_brzl_y_cassava     "real price index, cassava (calendar year)"
lab var priceNdx_brzl_y_rice        "real price index, rice (calendar year)"
lab var priceWgtNdx_brzl_s1_cattle  "weighted real price index, beef cattle (sem1, calendar year)"
lab var priceWgtNdx_brzl_s1_sugar   "weighted real price index, sugarcane (sem1, calendar year)"
lab var priceWgtNdx_brzl_s1_corn    "weighted real price index, corn (sem1, calendar year)"
lab var priceWgtNdx_brzl_s1_soybean "weighted real price index, soybean (sem1, calendar year)"
lab var priceWgtNdx_brzl_s1_cassava "weighted real price index, cassava (sem1, calendar year)"
lab var priceWgtNdx_brzl_s1_rice    "weighted real price index, rice (sem1, calendar year)"
lab var priceWgtNdx_brzl_s2_cattle  "weighted real price index, beef cattle (sem2, calendar year)"
lab var priceWgtNdx_brzl_s2_sugar   "weighted real price index, sugarcane (sem2, calendar year)"
lab var priceWgtNdx_brzl_s2_corn    "weighted real price index, corn (sem2, calendar year)"
lab var priceWgtNdx_brzl_s2_soybean "weighted real price index, soybean (sem2, calendar year)"
lab var priceWgtNdx_brzl_s2_cassava "weighted real price index, cassava (sem2, calendar year)"
lab var priceWgtNdx_brzl_s2_rice    "weighted real price index, rice (sem2, calendar year)"
lab var protection                  "protected territory, PA or IL (share of municipal area, PRODES year)"





** AUXILIARY VAR CONSTRUCTION ------------------------------------------------------------------------------------------------------------------------

** SAMPLE STATS
bysort muni_code: egen prodes02to16_deforest_mean   = mean(prodes_deforest) if((year >= 2002) & (year <= 2016))
label var              prodes02to16_deforest_mean     "[xsection] 2002 through 2016 average increment in deforested area (sq km)"

bysort muni_code: egen prodes01to16_deforest_mean   = mean(prodes_deforest) if((year >= 2001) & (year <= 2016))
label var              prodes01to16_deforest_mean     "[xsection] 2001 through 2016 average increment in deforested area (sq km)"

bysort muni_code: egen prodes02to16_deforest_sd     = sd(prodes_deforest) if((year >= 2002) & (year <= 2016))
label var              prodes02to16_deforest_sd       "[xsection] 2002 through 2016 st dev in increment in deforested area (sq km)"

bysort muni_code: egen aux_prodes06to16_deforest_sd = sd(prodes_deforest) if((year >= 2006) & (year <= 2016))
bysort muni_code: egen prodes06to16_deforest_sd     = max(aux_prodes06to16_deforest_sd)
label var              prodes06to16_deforest_sd       "[xsection] 2006 through 2016 st dev in increment in deforested area (sq km)"
drop   aux_*




** SAMPLE SELECTION ----------------------------------------------------------------------------------------------------------------------------------

** TEMPORAL SAMPLE
tab year  /* fully balanced */



** DEPVAR NON-MISSING
tab  year            if(prodes_deforest == .)
list muni_code       if(prodes_deforest == . & year == 2016)           /* 7 munis MA: just barely inside BLA (ie. no relevant PRODES coverage) */

drop if prodes_deforest == .



** DEPVAR VARIATION

cd "$DIR_PRJ_DANL_STS"
log using supportStats_avgForestCover, text replace

tab  year            if(prodes06to16_deforest_sd == 0)                 /* 25 munis */
list muni_code       if(prodes06to16_deforest_sd == 0 & year == 2016)  /* 22 munis MA, 2 munis TO, 1 muni PA */
sum  prodes03_forest if(prodes06to16_deforest_sd == 0 & year >= 2006)  /* avg pre-DETER forest cover: ~2% of muni area (ie. no relevant veg) */

log close 

drop if prodes06to16_deforest_sd == 0





** VAR CONSTRUCTION ----------------------------------------------------------------------------------------------------------------------------------

** NORMALIZATION: DEFORESTATION
** ln
tab year if prodes_deforest == 0

gen     prodes_deforest_log = ln(prodes_deforest + 0.01)  /* adds 1ha: see histograms in descriptive statistics for rationale */
lab var prodes_deforest_log   "[transform: LN] increment in deforested area (PRODES year)"


** ihs
gen     prodes_deforest_ihs = asinh(prodes_deforest)
lab var prodes_deforest_ihs   "[transform: IHS] increment in deforested area (PRODES year)"


** increment/mean
gen     prodes_deforest_dbm = (prodes_deforest/prodes02to16_deforest_mean)
lab var prodes_deforest_dbm   "[transform: DIV BY MEAN 2002-2016] increment in deforested area (PRODES year)"

gen     prodes_deforest_dbm_2001 = (prodes_deforest/prodes01to16_deforest_mean)
lab var prodes_deforest_dbm_2001  "[transform: DIV BY MEAN 2001-2016] increment in deforested area (PRODES year)"


** increment/muni_area
gen     prodes_deforest_dma = (prodes_deforest/muni_area)
lab var prodes_deforest_dma   "[transform: DIV BY MUNI AREA] increment in deforested area (PRODES year)"

gen     prodes_deforest_dma_100 = (prodes_deforest/muni_area)*100
lab var prodes_deforest_dma_100   "[transform: DIV BY MUNI AREA AND MULT BY 100] increment in deforested area (PRODES year)"



** LINEAR TRENDS [for robustness using saturated specifications]
** deforestation stock: pre-DETER total cleared area as share of municipal area
gen       trend_year_03clearedArea = year * prodes03_cleared
label var trend_year_03clearedArea   "[linear trend] year * total cleared area in 2003 as share of municipal area"


** deforestation flow: pre-DETER deforestation increment
gen       trend_year_03deforest    = year * prodes03_deforest
label var trend_year_03deforest      "[linear trend] year * deforestation increment in 2003"


** enforcement distribution: pre-DETER average fine count
bysort    muni_code: egen aux_fines02to04_countAvg = mean(fines_count) if(year >= 2002 & year <= 2004)
bysort    muni_code: egen     fines02to04_countAvg = max(aux_fines02to04_countAvg)
lab var                       fines02to04_countAvg   "[xsection] 2002 through 2004 average number of flora-related fines (count)"
drop                      aux_fines02to04_countAvg

gen       trend_year_02to04fines   = year * fines02to04_countAvg
label var trend_year_02to04fines     "[linear trend] year * 2002 through 2004 average fine count"



** CLUSTERS FOR ERRORS
** state-year
gen       state_code = int(muni_code/100000)
label var state_code   "state IBGE code (2-digit)"

egen      cl_stateYear = concat(state year), punct("_")
label var cl_stateYear   "[two-way cluster] state-year"


** microregion-year
egen      cl_microYear = concat(region_micro_code year), punct("_")
label var cl_microYear   "[two-way cluster] microregion-year"





** EXPORT PREP ---------------------------------------------------------------------------------------------------------------------------------------

** ORDER
#delimit ;
  order muni*
	      region*
				state*
	      year
				prodes_deforest*
				deter_cloud*
				nasa_cloud
				fines*
				prodes_nonobs
				prodes_cloud
				weather*
				price*
				prodes01*
				prodes02*
				prodes03*
				prodes06*
				fines02to04*
				d_priority
				protection
				trend*
				cl_*
  ;
#delimit cr



** CHECK POINT
mdesc
sort muni_code year





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

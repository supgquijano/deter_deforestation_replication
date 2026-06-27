
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: TEST PLACEBO USING PRE-DETER CLOUDS
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING





/* PLACEBO TEST --------------------------------------------------------------------------------------------------------------------------------------
   	   ESTIMATOR           OLS
			 DEPVAR              DEFORESTATION INCREMENT - NORMALIZED VIA IHS
	  	 KEY REGRESSORS      NASA CLOUD COVERAGE
	     CTRLS               WEATHER; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */

** DATA PREP
gen year01 = year == 2001
gen year02 = year == 2002
gen year03 = year == 2003
gen year04 = year == 2004
gen year05 = year == 2005
gen year06 = year == 2006
gen year07 = year == 2007
gen year08 = year == 2008
gen year09 = year == 2009
gen year10 = year == 2010
gen year11 = year == 2011
gen year12 = year == 2012
gen year13 = year == 2013
gen year14 = year == 2014
gen year15 = year == 2015
gen year16 = year == 2016

foreach YY in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 {
	gen       int_lagNasaCloud_year`YY' = L.nasa_cloud * year`YY'
	label var int_lagNasaCloud_year`YY'   "`YY'"
}
*
gen       aux_zero = 0
label var aux_zero "05"



** PLACEBO: PRE-DETER CLOUDS
#delimit ;
  reghdfe prodes_deforest_ihs
	             
					int_lagNasaCloud_year02
					int_lagNasaCloud_year03
					int_lagNasaCloud_year04
					aux_zero
					int_lagNasaCloud_year06
					int_lagNasaCloud_year07
					int_lagNasaCloud_year08
					int_lagNasaCloud_year09
					int_lagNasaCloud_year10
					int_lagNasaCloud_year11
					int_lagNasaCloud_year12
					int_lagNasaCloud_year13
					int_lagNasaCloud_year14
					int_lagNasaCloud_year15
					int_lagNasaCloud_year16
							 
					L.weather_rain
					L.weather_temp
					prodes_nonobs                   prodes_cloud
					priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
					priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
					priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
					priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
					priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
					priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
					i.year 
							 
					if(year >= 2002 & year <= 2016)
					,
					absorb (muni_code)
					cluster(muni_code cl_microYear)
	;
	
	coefplot, vertical 
	
	          omitted keep(aux_zero int_lagNasaCloud_*) yline(0) xline(4) drop(_cons) recast(rbar)
            ciopts(lwidth(3 ..) lcolor(*.2 *.4 *.6)) levels(95 90)
            ytitle("estimated coefficient", alignment(middle) margin(r = 4)) 
            xtitle("year", alignment(middle) margin(t = 4))
            legend(subtitle("confidence interval", size(small)) size(small) order(1 "95" 2 "90") rows(1))			 
            graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
            plotregion( fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
  ;

	graph export figure4_placebo_preDeterClouds.pdf, replace
  ;
  #delimit cr



	
	
** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

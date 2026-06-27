
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: TEST IV INCLUSION RESTRICTION & RUN PLACEBO TESTS, MONTHLY DATA
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING





/* INCLUSION RESTRICTION AND PLACEBOS ----------------------------------------------------------------------------------------------------------------
   	   ESTIMATOR           OLS
			 DEPVAR              FINE COUNT
	  	 KEY REGRESSORS      DETER CLOUD COVERAGE
	     CTRLS               WEATHER; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */

#delimit ;
  reghdfe fines_count
	        
					deter_cloud_lag2             deter_cloud_lag1
					deter_cloud
					deter_cloud_f1               deter_cloud_f2
					
					weather_rain                 weather_temp
					L.weather_rain               L.weather_temp 
					L2.weather_rain              L2.weather_temp 
					f.weather_rain               f.weather_temp 
					f2.weather_rain              f2.weather_temp 
					prodes_nonobs                prodes_cloud
					
					priceWgtNdx_brzl_m_cattle    L.priceWgtNdx_brzl_m_cattle
					priceWgtNdx_brzl_m_rice      L.priceWgtNdx_brzl_m_rice
					priceWgtNdx_brzl_m_corn      L.priceWgtNdx_brzl_m_corn
					priceWgtNdx_brzl_m_soybean   L.priceWgtNdx_brzl_m_soybean
					priceWgtNdx_brzl_m_cassava   L.priceWgtNdx_brzl_m_cassava
					priceWgtNdx_brzl_m_sugar     L.priceWgtNdx_brzl_m_sugar
					i.year_month
					
					if((year >= `=yearFirst') & (year <= `=yearLast'))
					,
					absorb(muni_code)
					cluster(muni_code cl_microYearMonth)
  ;

	coefplot, vertical
	
	          omitted 
						
						keep(deter_cloud_lag2 deter_cloud_lag1 deter_cloud deter_cloud_f1 deter_cloud_f2)
						
						yline(0) xline(3) drop(_cons) recast(rbar) ciopts(lwidth(3 ..) lcolor(*.2 *.4 *.6)) levels(95 90)
						
						ytitle("estimated coefficient",        alignment(middle) margin(r = 4))
						xtitle("DETER clouds leads and lags",  alignment(middle) margin(t = 4))
						legend(subtitle("confidence interval", size(small)) size(small) order(1 "95" 2 "90") rows(1))
						
						graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
						plotregion( fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
	;

	graph export figure3_stage1_cloudsEnforcement_monthly.pdf, replace
	;
#delimit cr





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

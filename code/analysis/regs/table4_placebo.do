
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: RUN REDUCED FORM AND TEST PLACEBO USING CONTEMPORANEOUS/LEAD CLOUDS
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING





/* REDUCED FORM AND PLACEBO TESTS --------------------------------------------------------------------------------------------------------------------
   	   ESTIMATOR           OLS
			 DEPVAR              DEFORESTATION INCREMENT - NORMALIZED VIA IHS
	  	 KEY REGRESSORS      DETER CLOUD COVERAGE
	     CTRLS               WEATHER; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */
	
** REDUCED FORM: LAGGED CLOUDS
#delimit ;
  reghdfe      prodes_deforest_ihs
	             
							 L.deter_cloud
							 
							 L.weather_rain                  L.weather_temp
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 i.year 
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast'))
							 ,
							 absorb (muni_code)
							 cluster(muni_code cl_microYear)
							 
	;
	outreg2 using $modelName, keep(L.deter_cloud)
														ctitle("depvar: IHS(deforest)")
														stats(coef se) 
														dec(4)
														nocons
														noaster
									          addtext("FE: municipality & year",        "yes",
												     "controls: full",              "yes")
												    excel
														replace;
#delimit cr



** PLACEBO: CONTEMPORANEOUS CLOUDS
#delimit ;
  reghdfe      prodes_deforest_ihs
	             
							 deter_cloud
							 
							 weather_rain                    weather_temp
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 i.year 
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast'))
							 ,
							 absorb (muni_code)
							 cluster(muni_code cl_microYear)
							 
	;
	outreg2 using $modelName, keep(deter_cloud)
														ctitle("depvar: IHS(deforest)")
														stats(coef se) 
														dec(4)
														nocons
														noaster
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes")
												    excel
														append;
#delimit cr
	
	
	
** PLACEBO: LEAD CLOUDS
#delimit ;
  reghdfe      prodes_deforest_ihs
	             
							 f.deter_cloud
							 
							 f.weather_rain                  f.weather_temp
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 i.year 
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast'))
							 ,
							 absorb (muni_code)
							 cluster(muni_code cl_microYear)
							 
	;
	outreg2 using $modelName, keep(f.deter_cloud)
														ctitle("depvar: IHS(deforest)")
														stats(coef se) 
														dec(4)
														nocons
														noaster
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes")
												    excel
														append;
#delimit cr
	
	
	
** PLACEBO: ALL CLOUDS
#delimit ;
  reghdfe      prodes_deforest_ihs
	             
							 L.deter_cloud                   L.weather_rain                  L.weather_temp
							 deter_cloud      							 weather_rain                    weather_temp
							 f.deter_cloud                   f.weather_rain                  f.weather_temp
							 
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 i.year 
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast'))
							 ,
							 absorb (muni_code)
							 cluster(muni_code cl_microYear)
							 
	;
	outreg2 using $modelName, keep(L.deter_cloud 
	                               deter_cloud 
																 f.deter_cloud)
														ctitle("depvar: IHS(deforest)")
														stats(coef se) 
														dec(4)
														nocons
														noaster
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes")
												    excel
														append;
#delimit cr





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

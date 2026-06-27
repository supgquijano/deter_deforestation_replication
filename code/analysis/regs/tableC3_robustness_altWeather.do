
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: TEST ROBUSTNESS TO USE OF ALTERNATIVE WEATHER DATASETS [COMPLETE TABLE FOR APPENDIX]
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING





/* ROBUSTNESS: USE OF ALTERNATIVE WEATHER DATASETS ---------------------------------------------------------------------------------------------------
   	   ESTIMATOR           2SLS
			 DEPVAR              DEFORESTATION INCREMENT - NORMALIZED VIA IHS
	  	 KEY REGRESSORS      FINE COUNT INSTRUMENTED VIA DETER CLOUD COVERAGE [LAGGED]
	     CTRLS               WEATHER [LAGGED] [ALTERNATIVE DATASETS]; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */

** RAIN MW & TEMP CPCG
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain                  L.weather_temp_CPCG
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
							 fe
							 cluster(muni_code cl_microYear)
							 ffirst
							 savefirst
							 savefprefix(S1_wthMWCP_)

	;

	outreg2 using $modelName, keep(L.fines_count)
								            ctitle("depvar: IHS(deforest)", "2SLS", "stage 2")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
														noaster
								            addstat("first-stage F-statistic",   e(widstat))
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes",
																		"rainfall dataset",                "MW",
																		"temperature dataset",           "CPC")
								            excel
								            replace
  ;
#delimit cr



** RAIN CPCG & TEMP MW
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain_CPCG             L.weather_temp
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
							 fe
							 cluster(muni_code cl_microYear)
							 ffirst
							 savefirst
							 savefprefix(S1_wthCPMW_)
	;

	outreg2 using $modelName, keep(L.fines_count)
								            ctitle("depvar: IHS(deforest)", "2SLS", "stage 2")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
														noaster
								            addstat("first-stage F-statistic",   e(widstat))
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes",
																		"rainfall dataset",              "CPC",
																		"temperature dataset",             "MW")
								            excel
								            append
  ;
#delimit cr


** RAIN REANALYSIS & TEMP MW
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain_Reanalysis       L.weather_temp
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
							 fe
							 cluster(muni_code cl_microYear)
							 ffirst
							 savefirst
							 savefprefix(S1_wthRAMW_)
	;

	outreg2 using $modelName, keep(L.fines_count)
								            ctitle("depvar: IHS(deforest)", "2SLS", "stage 2")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
														noaster
								            addstat("first-stage F-statistic",   e(widstat))
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes",
																		"rainfall dataset",        "NCEP",
																		"temperature dataset",             "MW")
								            excel
								            append
  ;
#delimit cr





/* ROBUSTNESS: USE OF ALTERNATIVE WEATHER DATASETS, FIRST STAGE --------------------------------------------------------------------------------------
   	   ESTIMATOR           2SLS
			 DEPVAR              FINE COUNT [LAGGED]
	  	 KEY REGRESSORS      DETER CLOUD COVERAGE [LAGGED]
			 CTRLS               WEATHER [LAGGED]; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
	     SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */


** RAIN MW & TEMP CPCG
#delimit ;
	estimates restore S1_wthMWCP_L_fines_count ;
  
	outreg2 using $modelName, keep(L.deter_cloud)
								            ctitle("depvar: enforcement", "2SLS", "stage 1")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
														noaster
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes",
																		"rainfall dataset",                "MW",
																		"temperature dataset",           "CPC")
						            		excel
						            		append
	;
#delimit cr



** RAIN CPCG & TEMP MW
#delimit ;
	estimates restore S1_wthCPMW_L_fines_count ;
  
	outreg2 using $modelName, keep(L.deter_cloud)
								            ctitle("depvar: enforcement", "2SLS", "stage 1")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
														noaster
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes",
																		"rainfall dataset",              "CPC",
																		"temperature dataset",             "MW")
						            		excel
						            		append
	;
#delimit cr


** RAIN REANALYSIS & TEMP MW
#delimit ;
	estimates restore S1_wthRAMW_L_fines_count ;
  
	outreg2 using $modelName, keep(L.deter_cloud)
								            ctitle("depvar: enforcement", "2SLS", "stage 1")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
														noaster
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes",
																		"rainfall dataset",        "NCEP",
																		"temperature dataset",             "MW")
						            		excel
						            		append
	;
#delimit cr





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

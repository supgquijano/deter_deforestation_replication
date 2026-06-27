
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: TEST ROBUSTNESS TO SATURATED SPECIFICATIONS USING LINEAR TRENDS, SAMPLE RESTRICTION, POLICY CONTROLS, ALTERNATIVE WEATHER CONTROLS, AND
*      ALTERNATIVE TWO-WAY CLUSTERING
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING





/* ROBUSTNESS TESTS ----------------------------------------------------------------------------------------------------------------------------------
   	   ESTIMATOR           2SLS
			 DEPVAR              DEFORESTATION INCREMENT - NORMALIZED VIA IHS
	  	 KEY REGRESSORS      FINE COUNT INSTRUMENTED VIA DETER CLOUD COVERAGE [LAGGED]
	     CTRLS               WEATHER; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE -- OTHERS AS ROBUSTNESS TEST
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR                  -- CLUSTERING AS ROBUSTNESS TEST
   --------------------------------------------------------------------------------------------------------------------------------------------- */

** STAGE 2 -------------------------------------------------------------------------------------------------------------------------------------------

** DEFORESTATION STOCK
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain                  L.weather_temp
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 i.year
							 
							 trend_year_03clearedArea
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast'))
							 ,
							 fe
							 cluster(muni_code cl_microYear)
							 ffirst
							 savefirst
							 savefprefix(S1_trdStock_)
	;

	outreg2 using $modelName, keep(L.fines_count)
						            		ctitle("Trends:", "deforest", "stock", "2SLS", "stage 2")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
											      noaster
								            addstat("first-stage F-statistic",                 e(widstat))
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
						            		excel
						            		replace
  ;
#delimit cr



** DEFORESTATION FLOW   
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain                  L.weather_temp
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 i.year
							 
							 trend_year_03deforest
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast'))
							 ,
							 fe
							 cluster(muni_code cl_microYear)
							 ffirst
							 savefirst
							 savefprefix(S1_trdFlow_)
	;

	outreg2 using $modelName, keep(L.fines_count)
						            		ctitle("Trends:", "deforest", "flow", "2SLS", "stage 2")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
											      noaster
								             addstat("first-stage F-statistic",                 e(widstat))
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
						            		excel
						            		append
  ;
#delimit cr



** ENFORCEMENT DISTRIBUTION
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain                  L.weather_temp
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 i.year
							 
							 trend_year_02to04fines
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast'))
							 ,
							 fe
							 cluster(muni_code cl_microYear)
							 ffirst
							 	 savefirst
							 savefprefix(S1_trdFines_)
	;

	outreg2 using $modelName, keep(L.fines_count)
						            		ctitle("Trends:", "enforcement", "distribution", "2SLS", "stage 2")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
											      noaster
								            addstat("first-stage F-statistic",                 e(widstat))
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
						            		excel
						            		append
  ;
#delimit cr



** FOREST: Q3+Q4
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain                  L.weather_temp
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 i.year 
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast') & (prodes03_forest > `=forest03_p50'))
							 ,
							 fe
							 cluster(muni_code cl_microYear)
							 ffirst
							 	 savefirst
							 savefprefix(S1_forestQ34_)
	;

	outreg2 using $modelName, keep(L.fines_count)
								            ctitle("2003 forest",  "> median", "sample", "2SLS", "stage 2")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
											      noaster
								            addstat("first-stage F-statistic",                 e(widstat))
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
								            excel
														append
  ;
#delimit cr


** WITH POLICY CONTROLS
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain                  L.weather_temp
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 i.year
							 
							 d_priorityMuni   							 protection
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast'))
							 ,
							 fe
							 cluster(muni_code cl_microYear)
							 ffirst
							 savefirst
							 savefprefix(S1_ctrlPolicy_)
	;

	outreg2 using $modelName, keep(L.fines_count
	                               d_priorityMuni protection)
														ctitle("Additional", "policy", "controls", "2SLS", "stage 2")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
											      noaster
								             addstat("first-stage F-statistic",                 e(widstat))
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
								            excel
								            append
  ;
#delimit cr



** RAIN CPCG & TEMP CPCG
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain_CPCG             L.weather_temp_CPCG
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
							 savefprefix(S1_wthCPCP_)
	;

	outreg2 using $modelName, keep(L.fines_count)
								            ctitle("Alternative", "weather", "variables", "2SLS", "stage 2")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
											      noaster
								             addstat("first-stage F-statistic",                 e(widstat))
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
								            excel
								            append
  ;
#delimit cr



** MUNI & STATE-YEAR CLUSTERING
#delimit ;
  xi: xtivreg2 prodes_deforest_ihs
	             
							 (L.fines_count = L.deter_cloud)
							 
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
							 fe
							 cluster(muni_code cl_stateYear)
							 ffirst
							 savefirst
							 savefprefix(S1_clStYr_)
	;

	outreg2 using $modelName, keep(L.fines_count)
								            ctitle("Two-way", "cluster", "muni & state-year", "2SLS", "stage 2")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
											      noaster
								             addstat("first-stage F-statistic",                 e(widstat))
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
								            excel
								            append
  ;
#delimit cr





** STAGE 1 -------------------------------------------------------------------------------------------------------------------------------------------

** DEFORESTATION STOCK
#delimit ;
  estimates restore S1_trdStock_L_fines_count ;

	outreg2 using $modelName, keep(L.deter_cloud)
						            		ctitle("Trends:", "deforest", "stock", "2SLS", "stage 1")
														stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
											      noaster
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
						            		excel
						            		append
	;
#delimit cr



** DEFORESTATION FLOW   
#delimit ;
	estimates restore S1_trdFlow_L_fines_count ;

	outreg2 using $modelName, keep(L.deter_cloud)
						            		ctitle("Trends:", "deforest", "flow", "2SLS", "stage 1")
														stats(coef se)
						            		dec(4)
						            		nocons
						            		nor2
											      noaster
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
						            		excel
						            		append
	;
#delimit cr



** ENFORCEMENT DISTRIBUTION
#delimit ;
  estimates restore S1_trdFines_L_fines_count ;

	outreg2 using $modelName, keep(L.deter_cloud)
						            		ctitle("Trends:", "enforcement", "distribution", "2SLS", "stage 1")
														stats(coef se) 
														dec(4)
						            		nocons
						            		nor2
											      noaster
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
						            		excel
						            		append
	;
#delimit cr



** FOREST: Q3+Q4
#delimit ;
	estimates restore S1_forestQ34_L_fines_count ;
  
	outreg2 using $modelName, keep(L.deter_cloud)
						            		ctitle("forest 2003", "> median", "sample", "2SLS", "stage 1")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
											      noaster
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
						            		excel
						            		append
	;
#delimit cr


** WITH POLICY CONTROLS
#delimit ;
	estimates restore S1_ctrlPolicy_L_fines_count ;
	
	outreg2 using $modelName, keep(L.deter_cloud d_priorityMuni protection)
						            		ctitle("Additional", "policy", "controls", "2SLS", "stage 1")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
											      noaster
								           addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
                            excel
                            append
	;
#delimit cr



** RAIN CPCG & TEMP CPCG
#delimit ;
	estimates restore S1_wthCPCP_L_fines_count ;
  
	outreg2 using $modelName, keep(L.deter_cloud)
						            		ctitle("Alternative", "weather", "variable", "2SLS", "stage 1")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
											      noaster
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
						            		excel
						            		append
	;
#delimit cr



** MUNI & STATE-YEAR CLUSTERING
#delimit ;
	estimates restore S1_clStYr_L_fines_count ;
  
	outreg2 using $modelName, keep(L.deter_cloud)
								            ctitle("Two-way", "cluster", "muni & state-year", "2SLS", "stage 2")
						            		stats(coef se) 
						            		dec(4)
						            		nocons
						            		nor2
											      noaster
								            addtext("FE: municipality & year",                      "yes",
												            "controls: full",                            "yes")
						            		excel
						            		append
	;
#delimit cr





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

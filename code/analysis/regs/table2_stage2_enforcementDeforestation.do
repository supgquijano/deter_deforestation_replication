
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: TEST IMPACT OF ENFORCEMENT ON DEFORESTATION [CONTAINS BENCHMARK SPECIFICATIONS]
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING




/* MAIN RESULTS: IMPACT OF ENFORCEMENT ON DEFORESTATION ----------------------------------------------------------------------------------------------
   	   ESTIMATOR           2SLS
			 DEPVAR              DEFORESTATION INCREMENT - NORMALIZED VIA IHS
	  	 KEY REGRESSORS      FINE COUNT INSTRUMENTED VIA DETER CLOUD COVERAGE [LAGGED]
	     CTRLS               WEATHER [LAGGED]; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */

** 2SLS
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
							 cluster(muni_code cl_microYear)
							 ffirst
	;

	estimates store S2_benchmarkIHS ;
			
	outreg2 using $modelName, keep(L.fines_count)
	                          ctitle("depvar: IHS(deforest)", "2SLS", "stage 2")
	                          stats(coef se) 
	                          dec(4)
	                          nocons
	                          nor2
							  noaster
								            addstat("first-stage F-statistic",   e(widstat))
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes")
	                          excel
	                          replace
  ;
#delimit cr



/* MAIN RESULTS: IMPACT OF ENFORCEMENT ON DEFORESTATION ----------------------------------------------------------------------------------------------
   	   ESTIMATOR           2SLS
			 DEPVAR              DEFORESTATION INCREMENT - NORMALIZED VIA LN
	  	 KEY REGRESSORS      FINE COUNT INSTRUMENTED VIA DETER CLOUD COVERAGE [LAGGED]
	     CTRLS               WEATHER [LAGGED]; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */

** 2SLS
#delimit ;
  xi: xtivreg2 prodes_deforest_log
	             
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
							 cluster(muni_code cl_microYear)
							 ffirst
							 savefirst
							 savefprefix(S1_benchmark_)
	;

	estimates store S2_benchmarkLOG ;

	outreg2 using $modelName, keep(L.fines_count)
								            ctitle("depvar: ln(deforest)", "2SLS", "stage 2")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
											noaster
								            addstat("first-stage F-statistic",   e(widstat))
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes")
								            excel
								            append
  ;
#delimit cr





/* MAIN RESULTS: IMPACT OF ENFORCEMENT ON DEFORESTATION ----------------------------------------------------------------------------------------------
   	   ESTIMATOR           2SLS
			 DEPVAR              DEFORESTATION INCREMENT - NORMALIZED VIA DIVIDE BY MUNI AREA
	  	 KEY REGRESSORS      FINE COUNT INSTRUMENTED VIA DETER CLOUD COVERAGE [LAGGED]
	     CTRLS               WEATHER [LAGGED]; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */

** 2SLS
#delimit ;
  xi: xtivreg2 prodes_deforest_dma_100
	             
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
							 cluster(muni_code cl_microYear)
							 ffirst
	;

	estimates store S2_benchmarkDMA ;

	outreg2 using $modelName, keep(L.fines_count)
								            ctitle("depvar: deforest/muni area", "2SLS", "stage 2")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
											noaster
								            addstat("first-stage F-statistic",   e(widstat))
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes")
								            excel
								            append
  ;
#delimit cr






/* MAIN RESULTS: IMPACT OF ENFORCEMENT ON DEFORESTATION ----------------------------------------------------------------------------------------------
   	   ESTIMATOR           2SLS
			 DEPVAR              DEFORESTATION INCREMENT - NORMALIZED VIA DIVIDE BY MEAN
	  	 KEY REGRESSORS      FINE COUNT INSTRUMENTED VIA DETER CLOUD COVERAGE [LAGGED]
	     CTRLS               WEATHER [LAGGED]; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */

** 2SLS
#delimit ;
  xi: xtivreg2 prodes_deforest_dbm
	             
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
							 cluster(muni_code cl_microYear)
							 ffirst
	;

	estimates store S2_benchmarkDBM ;

	outreg2 using $modelName, keep(L.fines_count)
								            ctitle("depvar: deforest/mean", "2SLS", "stage 2")								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
											noaster
								            addstat("first-stage F-statistic",   e(widstat))
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes")
								            excel
								            append
  ;
#delimit cr






/* MAIN RESULTS: IMPACT OF ENFORCEMENT ON DEFORESTATION ----------------------------------------------------------------------------------------------
   	   ESTIMATOR           OLS 
			 DEPVAR              DEFORESTATION INCREMENT - NORMALIZED VIA IHS
	  	 KEY REGRESSORS      FINE COUNT INSTRUMENTED VIA DETER CLOUD COVERAGE [LAGGED]
	     CTRLS               WEATHER [LAGGED]; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
   --------------------------------------------------------------------------------------------------------------------------------------------- */

** OLS
#delimit ;
	reghdfe   prodes_deforest_ihs
	          
						L.fines_count 
						
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
						absorb(muni_code)
						cluster(muni_code cl_microYear)
	;

	outreg2 using $modelName, keep(L.fines_count)
														ctitle("depvar: IHS(deforest)", "OLS", "")
														stats(coef se) 
														dec(4)
														nocons
														nor2
														noaster
								            addtext("FE: municipality & year",        "yes",
												            "controls: full",              "yes")
												    excel
														append
	;
#delimit cr




/* MAIN RESULTS: IMPACT OF ENFORCEMENT ON DEFORESTATION, FIRST STAGE ---------------------------------------------------------------------------------
   	   ESTIMATOR           2SLS
			 DEPVAR              FINE COUNT [LAGGED]
	  	 KEY REGRESSORS      DETER CLOUD COVERAGE [LAGGED]
	     CTRLS               WEATHER [LAGGED]; PRODES VISIBILITY; AGRICULTURAL PRICES; MUNI/YEAR FE
  	   SE                  ROBUST; CLUSTERED AT MUNI & MICROREGION-YEAR
			 OBS                 STAGE 1 OUTPUT IDENTICAL ACROSS ALTERNATIVE DEPVARS, SO ONLY RECORDED IN OUTPUT ONCE
   --------------------------------------------------------------------------------------------------------------------------------------------- */

** 2SLS
estimates restore S1_benchmark_L_fines_count

#delimit ;
	outreg2 using $modelName, keep(L.deter_cloud 
	                               L.weather_rain L.weather_temp
	                               prodes_nonobs  prodes_cloud)
								            ctitle("depvar: enforcement", "2SLS", "stage 1")
								            stats(coef se) 
								            dec(4)
								            nocons
								            nor2
											      noaster
								            addtext("FE: municipality & year",        "yes",
												    "controls: agricultural prices",  "yes")
								            excel
								            append
	;
#delimit cr





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

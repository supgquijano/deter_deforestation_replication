
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: TEST IV INCLUSION RESTRICTION
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

** CLOUDS t & ENFORCEMENT t
#delimit ;
  reghdfe fines_count 
	         
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
						
					if((year >= `=yearFirst') & (year <= `=yearLast'))
					,
					absorb(muni_code)
					cluster(muni_code cl_microYear)
  ;

  outreg2 using $modelName, keep(deter_cloud)
														ctitle("depvar: enforcement t")
														stats(coef se) 
														dec(4)
														nocons  	
														noaster
								            addtext("FE: municipality & year", "yes",
												            "controls: full",          "yes")
												    excel
														replace
	;
#delimit cr



** CLOUDS t-1 & ENFORCEMENT t
#delimit ;
  reghdfe fines_count 
	         
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
						
					if((year >= `=yearFirst') & (year <= `=yearLast'))
					,
					absorb(muni_code)
					cluster(muni_code cl_microYear)
  ;

  outreg2 using $modelName, keep(L.deter_cloud)
														ctitle("depvar: enforcement t")
														stats(coef se) 
														dec(4)
														nocons  	
														noaster
								            addtext("FE: municipality & year", "yes",
												            "controls: full",          "yes")
												    excel
														append
	;
#delimit cr



** CLOUDS t+1 & ENFORCEMENT t
#delimit ;
  reghdfe fines_count 
	         
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
						
					if((year >= `=yearFirst') & (year <= `=yearLast'))
					,
					absorb(muni_code)
					cluster(muni_code cl_microYear)
  ;

  outreg2 using $modelName, keep(f.deter_cloud)
														ctitle("depvar: enforcement t")
														stats(coef se) 
														dec(4)
														nocons  	
														noaster
								            addtext("FE: municipality & year", "yes",
												            "controls: full",          "yes")
												    excel
														append
	;
#delimit cr



** CLOUDS t-1/t/t+1 & ENFORCEMENT t
#delimit ;
  reghdfe fines_count 
	         
					deter_cloud                     L.deter_cloud                   f.deter_cloud
						
					weather_rain                    weather_temp
					L.weather_rain                  L.weather_temp
					f.weather_rain                  f.weather_temp
	        prodes_nonobs                   prodes_cloud
					priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
					priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
					priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
					priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
					priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
					priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
					i.year
						
					if((year >= `=yearFirst') & (year <= `=yearLast'))
					,
					absorb(muni_code)
					cluster(muni_code cl_microYear)
  ;

  outreg2 using $modelName, keep(deter_cloud L.deter_cloud f.deter_cloud)
														ctitle("depvar: enforcement t")
														stats(coef se) 
														dec(4)
														nocons  	
														noaster
								            addtext("FE: municipality & year", "yes",
												            "controls: full",          "yes")
												    excel
														append
	;
#delimit cr





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

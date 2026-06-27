
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: BUILD DESCRIPTIVE STATS 
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING



** SUMMARY STATS -------------------------------------------------------------------------------------------------------------------------------------

** MEAN AND SD: DEPVAR AND KEY REGRESSORS
** calculation
forvalues selYear = 2006(1)2016 {
	#delimit ;
		estpost summarize prodes_deforest
		                  fines_count
						  deter_cloud 
						  nasa_cloud
						  prodes_cloud
						  prodes_nonobs
						  weather_rain
					      weather_temp
						
						  if(year == `selYear')
						  ,
						  quietly
						  ;
		
		matrix aux_varSum_mean = e(mean)' ;                            /* returns 8x1 matrix containing var means in rows */
		matrix aux_varSum_stdv = e(sd)'   ;                            /* returns 8x1 matrix containing var sds   in rows */
		
		matrix varSum_`selYear' = (  round(aux_varSum_mean[1,1], 0.01) /* returns 16x1 matrix containing var means and sds in alternating rows */
															 \ round(aux_varSum_stdv[1,1], 0.01) 
													     
															 \ round(aux_varSum_mean[2,1], 0.01) 
															 \ round(aux_varSum_stdv[2,1], 0.01)
													     
															 \ round(aux_varSum_mean[3,1], 0.01)
															 \ round(aux_varSum_stdv[3,1], 0.01)
															 													
															 \ round(aux_varSum_mean[4,1], 0.01)
															 \ round(aux_varSum_stdv[4,1], 0.01)
															 													
															 \ round(aux_varSum_mean[5,1], 0.01)
															 \ round(aux_varSum_stdv[5,1], 0.01)
															 													
															 \ round(aux_varSum_mean[6,1], 0.01)
															 \ round(aux_varSum_stdv[6,1], 0.01)
															 													
															 \ round(aux_varSum_mean[7,1], 0.01)
															 \ round(aux_varSum_stdv[7,1], 0.01)
															 
															 \ round(aux_varSum_mean[8,1], 0.01)
															 \ round(aux_varSum_stdv[8,1], 0.01)
															 												
															)
													    ;

		matrix colnames varSum_`selYear' = "`selYear'" ;
	#delimit cr
}
*

** FULL SAMPLE 
#delimit ;
		estpost summarize prodes_deforest
		                  fines_count
						  deter_cloud 
						  nasa_cloud
						  prodes_cloud
						  prodes_nonobs
						  weather_rain
						  weather_temp
						
						
						  if(year >= 2006)
						  ,
						  quietly
						  ;

		matrix aux_varSum_mean = e(mean)' ;                            /* returns 8x1 matrix containing var means in rows */
		matrix aux_varSum_stdv = e(sd)'   ;                            /* returns 8x1 matrix containing var sds   in rows */
		
		matrix varSum_fullSample = ( round(aux_varSum_mean[1,1], 0.01) /* returns 16x1 matrix containing var means and sds in alternating rows */
															 \ round(aux_varSum_stdv[1,1], 0.01) 
													     
															 \ round(aux_varSum_mean[2,1], 0.01) 
															 \ round(aux_varSum_stdv[2,1], 0.01)
													     
															 \ round(aux_varSum_mean[3,1], 0.01)
															 \ round(aux_varSum_stdv[3,1], 0.01)
															 													
															 \ round(aux_varSum_mean[4,1], 0.01)
															 \ round(aux_varSum_stdv[4,1], 0.01)
															 													
															 \ round(aux_varSum_mean[5,1], 0.01)
															 \ round(aux_varSum_stdv[5,1], 0.01)
															 													
															 \ round(aux_varSum_mean[6,1], 0.01)
															 \ round(aux_varSum_stdv[6,1], 0.01)
															 													
															 \ round(aux_varSum_mean[7,1], 0.01)
															 \ round(aux_varSum_stdv[7,1], 0.01)
															 
															 \ round(aux_varSum_mean[8,1], 0.01)
															 \ round(aux_varSum_stdv[8,1], 0.01)
															 													
															
															)
													    ;

		matrix colnames varSum_fullSample = "fullSample" ;
	#delimit cr



** prep
#delimit ;
  matrix varSum = (varSum_fullSample, 
	                 varSum_2006, varSum_2007, varSum_2008, varSum_2009, varSum_2010, 
	                 varSum_2011, varSum_2012, varSum_2013, varSum_2014, varSum_2015, varSum_2016)
	;

  matrix rownames varSum = deforest_mean             deforest_sd
													 fines_mean                fines_sd
													 deterCloud_mean           deterCloud_sd
													 nasaCloud_mean            nasaCloud_sd
													 prodesCloud_mean          prodesCloud_sd
													 prodesNonobs_mean         prodesNonobs_sd
													 weatherRain_mean          weatherRain_sd
													 weatherTemp_mean          weatherTemp_sd
													
  ;
#delimit cr


** export 
cd "$DIR_PRJ_DANL_STS"
if fileexists("tableA1_sumStats.xlsx") == 1 {
  erase "tableA1_sumStats.xlsx"
}
*
putexcel set   "tableA1_sumStats", modify
putexcel       B2 = matrix(varSum), names
putexcel clear

matrix drop _all





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

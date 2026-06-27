
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: SIMULATE ANNUAL SAMPLE DEFORESTATION INCREMENT UNDER HYPOTHETICAL SCENARIOS
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING





** PREP ----------------------------------------------------------------------------------------------------------------------------------------------

** BENCHMARK SPECIFICATION USING ICM-BASED NORMALIZATION 
/* obs: postestimation 'predict' does not work if estimation automatically ommits categories > must rerun benchmark using year dummies, not FE      */

** auxiliary vars
forvalues y = 2007(1)2015 {                  /* benchmark ommits year vars for 2002 through 2006, as well as for 2016 */
  gen       d_year`y' = (year == `y')
	label var d_year`y' "d==1 if year is `y'"
}
*

** benchmark replication
#delimit ;
  xi: xtivreg2 prodes_deforest_dma
	             
							 (L.fines_count = L.deter_cloud)
							 
							 L.weather_rain                  L.weather_temp
							 prodes_nonobs                   prodes_cloud
							 priceWgtNdx_brzl_s1_cattle      L.priceWgtNdx_brzl_s1_cattle    L.priceWgtNdx_brzl_s2_cattle
							 priceWgtNdx_brzl_s1_sugar       L.priceWgtNdx_brzl_s1_sugar     L.priceWgtNdx_brzl_s2_sugar
							 priceWgtNdx_brzl_s1_corn        L.priceWgtNdx_brzl_s1_corn      L.priceWgtNdx_brzl_s2_corn
							 priceWgtNdx_brzl_s1_soybean     L.priceWgtNdx_brzl_s1_soybean   L.priceWgtNdx_brzl_s2_soybean
							 priceWgtNdx_brzl_s1_cassava     L.priceWgtNdx_brzl_s1_cassava   L.priceWgtNdx_brzl_s2_cassava
							 priceWgtNdx_brzl_s1_rice        L.priceWgtNdx_brzl_s1_rice      L.priceWgtNdx_brzl_s2_rice
							 d_year2007-d_year2015
							 
							 if((year >= (`=yearFirst' + 1)) & (year <= `=yearLast'))
							 ,
							 fe
							 cluster(muni_code cl_microYear)
	;
	estimates store S2_replication ;
	matrix           B_replication = e(b) ;
#delimit cr





** SIMULATION: SHUT DOWN DETER SYSTEM ----------------------------------------------------------------------------------------------------------------
/* obs: IV postestimation only calculates idiosyncratic component of the error term > fitted_y derived from [fitted_y = y - predict_e]              */
/* obs: see paper for mathematical derivation of expected values - basis for estimation procedure that follows                                      */

** ESTIMATION
estimates restore S2_replication

predict   PREDICT_e                , e
label var PREDICT_e                 "[predict] idiosyncratic component of the error term"

gen       FITTED_deforest_dma      = prodes_deforest_dma - PREDICT_e
label var FITTED_deforest_dma        "[fitted] normalized deforestation increment (normalization: inc/mean)"

gen       CFdif_deforest_shutDeter = (muni_area * B_replication[1,1] * (L.fines02to04_countAvg - L.fines_count)) if(year>(`=yearFirst'))
label var CFdif_deforest_shutDeter   "[counterfactual] difference in deforestation increment under DETER system shutdown (sq km)"

gen       CFdif_deforest_shutFull  = (muni_area * B_replication[1,1] * (0                      - L.fines_count)) if(year>(`=yearFirst'))
label var CFdif_deforest_shutFull    "[counterfactual] difference in deforestation increment under FULL system shutdown (sq km)"

gen       CFlvl_deforest_shutDeter = (muni_area * FITTED_deforest_dma) + CFdif_deforest_shutDeter
label var CFlvl_deforest_shutDeter   "[counterfactual] total deforestation increment under DETER system shutdown (sq km)"

gen       CFlvl_deforest_shutFull  = (muni_area * FITTED_deforest_dma) + CFdif_deforest_shutFull
label var CFlvl_deforest_shutFull    "[counterfactual] total deforestation increment under FULL system shutdown (sq km)"



** OUTPUT 
* table
table year, c(sum prodes_deforest sum CFlvl_deforest_shutDeter sum CFlvl_deforest_shutFull)

collapse (sum) prodes_deforest CFlvl_deforest_shutDeter CFlvl_deforest_shutFull, by(year)
save $modelName, replace
export excel $modelName.xlsx, firstrow(var) replace 



** CLEANUP
estimates drop S2_replication
matrix    drop B_replication





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------


* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: GENERATE GRAPHIC OUTPUT FOR SIMULATED ANNUAL SAMPLE DEFORESTATION INCREMENT UNDER HYPOTHETICAL SCENARIOS
*
* > NOTES
* 1: SUBSCRIPT FOR MASTERFILE SOURCING





** PREP ----------------------------------------------------------------------------------------------------------------------------------------------

** DATA INPUT
cd  "$DIR_PRJ_DANL_SIM"
use tableB2_counterfactual, clear



** OUTPUT UNITS
gen observed_thKM2            = prodes_deforest          / 1000
gen simulated_thKM2_shutDeter = CFlvl_deforest_shutDeter / 1000
gen simulated_thKM2_shutFull  = CFlvl_deforest_shutFull  / 1000





** PLOTS ---------------------------------------------------------------------------------------------------------------------------------------------

** LINE GRAPHS
#delimit ;
	twoway (line observed_thKM2            year, sort lcolor(cranberry) lwidth(medthick) lpattern(solid))
				 (line simulated_thKM2_shutFull  year, sort lcolor(orange)    lwidth(medthick) lpattern(longdash))
				 (line simulated_thKM2_shutDeter year, sort lcolor(orange)    lwidth(medthick) lpattern(shortdash))

				 if (year >= 2007 & year <= 2016)
				 ,
				 
			 
				 ytitle("deforestation (thousand square kilometers)", size(small) alignment(middle) margin(r = 4)) 
				 ylabel(0(5)45,      format(%9.0f) labsize(small) glcolor(gs13) glwidth(thin) angle(horizontal) noticks)
				 
				 xtitle("", size(small) alignment(middle) margin(t = 4))
				 xlabel(2007(1)2016, format(%9.0f) labsize(small) nogrid)
							
				 legend(label(1 "observed") holes(3) label(2 "simulated - full shutdown") label(3 "simulated - DETER shutdown") 
				        region(col(white)) linegap(4) size(small) rows(2))
				 
				 graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
				 plotregion( fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
				 ;
#delimit cr



** OUTPUT
cd            "$DIR_PRJ_DANL_GRP"
local         graphName_pdf = "$modelName" + ".pdf"
graph export `graphName_pdf', replace





** END OF SCRIPT -------------------------------------------------------------------------------------------------------------------------------------

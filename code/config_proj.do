
* > PROJECT INFO
* TITLE: DETERRING DEFORESTATION
* 
* > THIS SCRIPT
* AIM: SET GLOBALS FOR DIRECTORY REFERENCING
*
* > NOTES
* 1: -





** PROJECT DIRECTORIES -------------------------------------------------------------------------------------------------------------------------------

** PROJECT ROOT
global DIR_PRJ = "`c(pwd)'"


	** CODE
	global DIR_PRJ_CODE = "$DIR_PRJ" + "/" + "code"

		global DIR_PRJ_CSPC = "$DIR_PRJ" + "/" + "code" + "/" + "projectSpecific"

		global DIR_PRJ_CANL = "$DIR_PRJ" + "/" + "code" + "/" + "analysis"

			global DIR_PRJ_CANL_GRP = "$DIR_PRJ_CANL" + "/" + "graphics"
			global DIR_PRJ_CANL_REG = "$DIR_PRJ_CANL" + "/" + "regs"
			global DIR_PRJ_CANL_SIM = "$DIR_PRJ_CANL" + "/" + "sims"
			global DIR_PRJ_CANL_STS = "$DIR_PRJ_CANL" + "/" + "stats"


  ** DATA
	global DIR_PRJ_DATA = "$DIR_PRJ" + "/" + "data"
	
		global DIR_PRJ_TEMP = "$DIR_PRJ" + "/" + "data" + "/" + "_temp"

		global DIR_PRJ_DSPC = "$DIR_PRJ" + "/" + "data" + "/" + "projectSpecific"
		
		global DIR_PRJ_DANL = "$DIR_PRJ" + "/" + "results"
		/* adapted to meet CodeOcean dir structure without altering original project globals */
			global DIR_PRJ_DANL_GRP = "$DIR_PRJ_DANL" + "/" + "graphics"
			global DIR_PRJ_DANL_REG = "$DIR_PRJ_DANL" + "/" + "regs"
			global DIR_PRJ_DANL_SIM = "$DIR_PRJ_DANL" + "/" + "sims"
			global DIR_PRJ_DANL_STS = "$DIR_PRJ_DANL" + "/" + "stats"




** DOWNLOAD SSC PACKAGES -----------------------------------------------------------------------------------------------------------------------------
/* SSC packages downloaded via CodeOcean Environment setup */

/*
* change the ado directory to be inside the project
sysdir set PLUS "$DIR_PRJ/ado/plus"

* list of required packages
local ssc_packages "estout" "xtivreg2" "ivreg2" "mdesc" "outreg2" "ranktest" "coefplot"

// if !missing("`ssc_packages'") {
// 		foreach pkg in "`ssc_packages'" {
// 		* install using ssc, but avoid re-installing if already present
// 				capture which `pkg'
// 				if _rc == 111 {                 
// 					 dis "Installing `pkg'"
// 					 quietly ssc install `pkg', replace
// 					 }
// 		}
// }
*/

* END OF SCRIPT --------------------------------------------------------------------------------------------------------------------------------------

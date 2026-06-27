**********************************
*** This section does "tf" ***
**********************************

program define tf, eclass
	ereturn clear
	version 12.0

	local lversion = "01"
	
	local ivreg2_command = "`0'" 

	
	if "`ivreg2_command'"== ", version" {
		di in gr "`lversion'"
		ereturn clear
		ereturn local version `lversion'
		exit	
	}
	
	
	// check ivreg2 version
	quietly ivreg2, version
	// if e(version) != "04.1.11" {
	//	di as err "Please install ivreg2 version 04.1.11"
	//	exit
	//}
	
	local unsupported = 0
	
	// If the user uses these options, just do ivreg2 and exit. 
	local options "gmm2s liml fuller kclass coviv cue b0 bw kernel wmatrix smatrix orthog endog redundant small noconstant nocollin noid partial level nofooter noheader replay dkraay kiefer hascons eform depname plus"
	foreach option of local options {
		if strpos("`0'", "`option'") != 0 {
			ivreg2 `ivreg2_command'
			di as err "Displaying ivreg2 results only. No tF adjustment."
			di as err "ivreg3 does not currently support the `option' option."
			local unsupported = 1
			exit
		}
	}
	
	if `unsupported' == 1 {
		exit
	}	
	else {
	
	// ensures proper syntax. if there's a typo or additional option, 
	// this will return an error. 
	syntax [anything(name=0)] [if] [in] [aw fw pw iw/] [,		///
			FIRST FFIRST SAVEFIRST SAVEFPrefix(name)			///
			RF SAVERF SAVERFPrefix(name)						///
			SFIRST SAVESFIRST SAVESFPrefix(name)				///
			Robust CLuster(varlist) 							///
			]
	
	
	// Use ivreg2 first option to check if just-id with 1 endogenous regressor 
	
	if "`first'" == "" & strpos("`ivreg2_command'", ",") == 0 {
		local ivreg2_command_first = "`ivreg2_command', first"
	}
	else if "`first'" == "" & strpos("`ivreg2_command'", ",") != 0 {
		local ivreg2_command_first = "`ivreg2_command' first"
	}
	else {
		local ivreg2_command_first = "`ivreg2_command'"
	}
	
	// run ivreg2, suppress output
	quietly ivreg2 `ivreg2_command_first'
	
	
	// Generate tempvar to mark sample
   tempvar temp1
   gen `temp1'=e(sample)
	
	// if just a first-stage, exit after doing first-stage
	if "`e(model)'" == "ols" {
		ivreg2 `ivreg2_command'
		exit
	}
	
	// Check to see if just-id with 1 endogenous regressor.
	matrix A = e(first)
	matrix C = A["df", 1]
	// if not, simply display ivreg2 output.
	if e(jdf) != 0 | C[1,1] != 1 {
		ivreg2 `0'
		di as err "The model either has multiple endogenous regressors or is not just-identified."
		di as err "Displaying ivreg2 results only. No tF adjustment."
		cap drop _est__ivreg2_`instd'
		exit
	}

	// Otherwise, we branch into doing tF.
	
	// first, get some locals from ivreg2 
	local N = e(N)
	local insts = e(insts)
	local depvar = e(depvar)
	local varnm = abbrev("`e(instd)'", 10)
	local depvar_ab = abbrev("`depvar'", 10)
	local ex_inst = e(exexog)
	local in_insts = e(inexog)
	local beta_hat = e(b)[1,1]
	local round_beta_hat = round(`beta_hat', 0.00001)
	local instd = e(instd)
	local se_bhat = _se[`instd']
	
	matrix b = e(b)
	matrix V = e(V)
	
	// and display unadjusted ivreg2 results
	di as text " "
	di as text " "
	di as text "IV (2SLS) estimation"
	di as text "{hline 20}"
	di as text " " 
	
	di as text "{col 54}" "Number of obs" "{col 68}" "=" "{col 71}" as result %8.0f `N'
	di as text "{col 54}" "F(" e(Fdf1) ", " e(Fdf2) ")" "{col 68}" "=" "{col 71}" as result %8.4f e(F)
	di as text "{col 54}" "Prob > F" "{col 68}" "=" "{col 71}" as result %8.4f e(Fp)
	di as text "Total (centered) SS" "{col 24}" "=" "{col 27}" as result %9.5f e(yyc) "{col 54}" as text "Centered R2" "{col 68}" "=" "{col 71}" as result %8.4f e(r2c)
	di as text "Total (uncentered) SS" "{col 24}" "=" "{col 27}" as result %9.5f e(yy) "{col 54}" as text "Uncentered R2" "{col 68}" "=" "{col 71}" as result %8.4f e(r2u)
	di as text "Residual SS" "{col 24}" "=" "{col 27}" as result %9.5f e(rss) "{col 54}" as text "Root MSE" "{col 68}" "=" "{col 71}" as result %8.4f e(rmse)
	di as text " "
	
	// Get options for the correct first-stage. 
	if "`weight'" != "" {
		local weight_exp = "[`weight' = `exp']"
	}
	else if "`weight'" == "" {
		local weight_exp = ""
	}


	// Modify `if' to ensure it's the same sample
     if "`if'" != "" {
         local if = "`if' & `temp1' ==1"
     }
     else if "`if'" == "" {
         local if = "if `temp1' ==1"
     }
	
	if "`cluster'" ~= "" {
		local first_stage = "`e(instd)' `e(insts)' `if' `in' `weight_exp', cluster(`cluster')"
	}
	else if "`robust'" ~= "" {
		local first_stage = "`e(instd)' `e(insts)' `if' `in' `weight_exp', robust"
	}
	else if "`robust'`cluster'"=="" {
		local first_stage = "`e(instd)' `e(insts)' `if' `in' `weight_exp'"
	}
	
	
	
	
	// display unadj. 2SLS results
	ereturn clear 
	ereturn post b V 
	ereturn display 
	
	// run and display first-stage
	di as text " "
	di as text " "
	ivreg2 `first_stage'

	
	// Get the F-statistic that we need.
	local z_beta = _b["`ex_inst'"]
	local z_se = _se["`ex_inst'"]
	local F = (`z_beta'/`z_se')^2
	di as text "First-Stage F-Stat: " as result %9.5f `F'
	
	// do tF adjustments
	
	// first for 95% (alpha = 0.05)
	
	local sig_level = 0.05
	local q = (invnormal(1 - (`sig_level'/2)))^2
	
	mata: a = fileexists("IV_CriticalValues_matrix_95.mmat")
	mata: st_local("a", strofreal(a))
	
	if `a' != 1 {
		mata: alpha = strtoreal(st_local("sig_level"))
		mata: createZ(alpha, "IV_CriticalValues_matrix_95.mmat")
	}
	
	// Based on F-statistic get the inflation factor
	mata: F = strtoreal(st_local("F"))
	mata: file_in = fopen("IV_CriticalValues_matrix_95.mmat", "r")
	mata: S = fgetmatrix(file_in)
	mata: zF = spline3eval(S, F)
	mata: sig_level = st_local("sig_level")
	mata: cF = zF/(F - (invnormal(1 - (strtoreal(sig_level)/2))^2))
	mata: if (F>104.67) cF = (invnormal(1 - (strtoreal(sig_level)/2)))^2;;
	mata: st_local("cF", strofreal(cF))
	
	// calculate the tF adjusted SE and 95% CI
	if (`F'< ((invnormal(1 - (`sig_level'/2)))^2)) {
		local tF_se = `se_bhat' * (sqrt(`cF')/((invnormal(1 - (`sig_level'/2)))))
		local tf_LB = .
		local tf_UB = .
	}
	else if (`F' < 104.67 & `F' >= ((invnormal(1 - (`sig_level'/2)))^2)) {
		local tF_se = `se_bhat' * (sqrt(`cF')/((invnormal(1 - (`sig_level'/2)))))
	}
	// if F>104.67, result will duplicate ivreg2 result
	else if (`F' >= 104.67) {
		local tF_se = `se_bhat'
	}
	
	if `F' >= ((invnormal(1 - (`sig_level'/2)))^2) {
		local tf_LB = `beta_hat' - ((invnormal(1 - (`sig_level'/2))))*`tF_se'
		local tf_UB = `beta_hat' + ((invnormal(1 - (`sig_level'/2))))*`tF_se'
	}
	
	
	// next for 99% (alpha = 0.01)
	
	local sig_level = 0.01
	local q = (invnormal(1 - (`sig_level'/2)))^2

	
	mata: a = fileexists("IV_CriticalValues_matrix_99.mmat")
	mata: st_local("a", strofreal(a))
	
	if `a' != 1 {
		mata: alpha = strtoreal(st_local("sig_level"))
		mata: createZ(alpha, "IV_CriticalValues_matrix_99.mmat")
	}
		
	// Based on F-statistic get the inflation factor
	mata: F = strtoreal(st_local("F"))
	mata: file_in = fopen("IV_CriticalValues_matrix_99.mmat", "r")
	mata: S = fgetmatrix(file_in)
	mata: zF = spline3eval(S, F)
	mata: sig_level = st_local("sig_level")
	mata: cF = zF/(F - (invnormal(1 - (strtoreal(sig_level)/2))^2))
	mata: if (F>252.34) cF = (invnormal(1 - (strtoreal(sig_level)/2)))^2;;
	mata: st_local("cF_99", strofreal(cF))

	if (`F'< (2.726^2)) {
		local tF_se_01 = `se_bhat' * (sqrt(`cF_99')/((invnormal(1 - (`sig_level'/2)))))
		local tf_LB_01 = .
		local tf_UB_01 = .
	}
	else if (`F' < 252.34 & `F' >= (2.726^2)) {
		local tF_se_01 = `se_bhat' * (sqrt(`cF_99')/((invnormal(1 - (`sig_level'/2)))))
	}
	// if F>252.34, result will duplicate ivreg2 result
	else if (`F' >= 252.34) {
		local tF_se_01 = `se_bhat'
	}
	
	if `F' >= (2.726^2) {
		local tf_LB_01 = `beta_hat' - ((invnormal(1 - (`sig_level'/2))))*`tF_se_01'
		local tf_UB_01 = `beta_hat' + ((invnormal(1 - (`sig_level'/2))))*`tF_se_01'
	}
	
	
	// define some locals to return and display
	local critical_value_05 = sqrt(`cF')
	local critical_value_01 = sqrt(`cF_99')
	
	local unadj_LB = `beta_hat' - ((invnormal(1 - (`sig_level'/2))))*`se_bhat'
	local unadj_UB = `beta_hat' + ((invnormal(1 - (`sig_level'/2))))*`se_bhat' 	
	
	// display tF adjusted results

	di as text " "
	di as text " "
	di as text "tF adjusted Results at the 5% Level"
	di as text "{hline 35}"
	
	if `tf_LB'==. {
		display as text "{hline 13}{c +}{hline 67}"
		display as text "{col 13}" " {c |}" "{col 27}" "Unadj." "{col 37}" "Crit. Val." "{col 50}" "0.05 tF" "{col 69}" "Adj."
		display as text %12s "`depvar_ab'" " {c |}" "{col 18}" as text "Coef." "{col 26}" "Std. Err." "{col 38}" "for |t|" "{col 49}" "Std. Err." "{col 60}" "[95% Conf." "{col 73}" "Interval]" 
		display as text "{hline 13}{c +}{hline 67}"
		display as text %12s "`varnm'" "{col 13}" " {c |}" as result `beta_hat' "{col 26}" `se_bhat' "{col 40}" "inf" "{col 52}" "inf" "{col 63}"  "-inf" "{col 75}" "inf"
		display as text "{hline 13}{c +}{hline 67}"
	}
	else {
		display as text "{hline 13}{c +}{hline 67}"
		display as text "{col 13}" " {c |}" "{col 27}" "Unadj." "{col 37}" "Crit. Val." "{col 50}" "0.05 tF" "{col 69}" "Adj."
		display as text %12s "`depvar_ab'" " {c |}" "{col 18}" as text "Coef." "{col 26}" "Std. Err." "{col 38}" "for |t|" "{col 49}" "Std. Err." "{col 60}" "[95% Conf." "{col 73}" "Interval]" 
		display as text "{hline 13}{c +}{hline 67}"
		display as text %12s "`varnm'" "{col 13}" " {c |}" as result `beta_hat' "{col 26}" `se_bhat' "{col 38}" `critical_value_05' "{col 49}" `tF_se' "{col 61}" `tf_LB' "{col 72}" `tf_UB'
		display as text "{hline 13}{c +}{hline 67}"
	}
	

	di as text " "
	
	
	di as text "tF adjusted Results at the 1% Level"
	di as text "{hline 35}"
	
	if `tf_LB_01'==. {
		display as text "{hline 13}{c +}{hline 67}"
		display as text "{col 13}" " {c |}" "{col 27}" "Unadj." "{col 37}" "Crit. Val." "{col 50}" "0.01 tF" "{col 69}" "Adj."
		display as text %12s "`depvar_ab'" " {c |}" "{col 18}" as text "Coef." "{col 26}" "Std. Err." "{col 38}" "for |t|" "{col 49}" "Std. Err." "{col 60}" "[99% Conf." "{col 73}" "Interval]" 
		display as text "{hline 13}{c +}{hline 67}"
		display as text %12s "`varnm'" "{col 13}" " {c |}" as result `beta_hat' "{col 26}" `se_bhat' "{col 40}" "inf" "{col 52}" "inf" "{col 63}"  "-inf" "{col 75}" "inf"
		display as text "{hline 13}{c +}{hline 67}"
	}
	else {
		display as text "{hline 13}{c +}{hline 67}"
		display as text "{col 13}" " {c |}" "{col 27}" "Unadj." "{col 37}" "Crit. Val." "{col 50}" "0.01 tF" "{col 69}" "Adj."
		display as text %12s "`depvar_ab'" " {c |}" "{col 18}" as text "Coef." "{col 26}" "Std. Err." "{col 38}" "for |t|" "{col 49}" "Std. Err." "{col 60}" "[99% Conf." "{col 73}" "Interval]" 
		display as text "{hline 13}{c +}{hline 67}"
		display as text %12s "`varnm'" "{col 13}" " {c |}" as result `beta_hat' "{col 26}" `se_bhat' "{col 38}" `critical_value_01' "{col 49}" `tF_se_01' "{col 61}" `tf_LB_01' "{col 72}" `tf_UB_01'
		display as text "{hline 13}{c +}{hline 67}"
	}
	
	
	di as text " "
	di as text "Instrumented: `instd'"
	di as text "Excluded instrument: `ex_inst'"
	di as text "Included instrument: `in_insts'"
	
	// do not return ivreg2 results in e()
	ereturn clear 
	
	cap drop _est__ivreg2_`instd'
	
	// return tF things in e()
	ereturn local N = `N'
	ereturn local F = `F'
	ereturn local tF_LB_05 = "`tf_LB'"
	ereturn local tF_UB_05 = "`tf_UB'"
	ereturn local beta_hat = `beta_hat'
	ereturn local tF_se_beta_hat_05 = `tF_se'
	ereturn local instd = "`instd'"
	ereturn local insts = "`insts'"
	ereturn local depvar = "`depvar'"
	ereturn local tF_critical_value_05 = `critical_value_05'
	ereturn local tF_critical_value_01 = `critical_value_01'
	ereturn local unadj_se = `se_bhat'
	ereturn local unadj_LB = `unadj_LB'
	ereturn local unadj_UB = `unadj_UB'
	ereturn local tF_LB_01 = "`tf_LB_01'"
	ereturn local tF_UB_01 = "`tf_UB_01'"
	ereturn local tF_se_beta_hat_01 = `tF_se_01'
	
	// close any files still open in mata
	forvalues i=0(1)50 {
		capture mata: fclose(`i')
	}
	}
end

**********************************************
*** This section generates critical values ***
**********************************************
version 12
mata:
void createZ(real scalar alph, file_name) 
{	
	// set some constants
	//alph = 0.05
	q = invnormal(1 - (alph/2))^2
	obs = 400000 
	
	// empty mata matrix
	real matrix A
	A = J(obs, 5, .)
	
	// list of epsilon to loop through
	eps_list = range(0.0000001, 0.00009, 0.0000001) // this is a list of epsilon to loop through
	eps = 0.00000009 // this is an initial epsilon value
	

    // Initialize, this chunck of code fills in the first row of matrix A
	// F1
    A[1,1] = q :+ eps // this fills in row 1, column 1 (e.g. the first F1)
	// z(F1)
    A[1,2] = ((q):^3):-(((3:*(q)):-(((q):^2):/2):+(((q):^3):/6)):*(A[1,1]:-(q)))
	// f0
    A[1,3] = (A[1,1]):/((sqrt((A[1,2]):/(A[1,1]:-(q)))):-(sqrt(A[1,1])))
	// F
    A[1,4] = ((A[1,3]):+(invnormal((1:-alph):+(normal((-sqrt(A[1,1])):-(A[1,3])))))):^2
    F = A[1,4]
	// z(F)
    A[1,5] = (((A[1,4]):*((sqrt(A[1,4]):-A[1,3]):^2)):/(A[1,3]:^2)):*(A[1,4]:-q)

    j = 1 // set a counter for the loop
    // Iterate. Now F becomes the new F1 (for A[2, 1]), and we iterate to fill in the data.
    for(i = 2; i <= obs; i++)
	{
		if(j>898) break // we can only iterate for the number of epsilons we have in the list
		// when f0 becomes negative, re-initialize with new epsilon
		if(A[(i:-1), 3]:<0) {
			eps = eps_list[j]
			j = j+1
			A[i,1] = q :+ eps
     		A[i,2] = ((q):^3):-(((3:*(q)):-(((q):^2):/2):+(((q):^3):/6)):*(A[i,1]:-(q)))
		}
		// keep doing the algorithm and computing values
		else {
			// set F1
			A[i, 1] = A[(i:-1), 4]
			// set zF1
			A[i, 2] = A[(i:-1), 5]
		}
		
		// set f0
		A[i, 3] = (A[i,1]):/((sqrt((A[i, 2]):/(A[i,1]:-(q)))):-(sqrt(A[i,1])))
		// set F
		A[i, 4] = ((A[i,3]):+(invnormal((1:-alph):+(normal((-sqrt(A[i,1])):-(A[i,3])))))):^2
		// set zF
		A[i, 5] = (((A[i,4]):*((sqrt(A[i,4]):-A[i,3]):^2)):/(A[i,3]:^2)):*(A[i,4]:-q)
	}
	
	// keep only rows without missing values
	A = select(A, rowmissing(A):==0)
	
	// sort by F 
	A = sort(A, 4)
	
	// pull F and zF as vectors
	F = A[., 4]
	Z = A[., 5]
	
	// spline3
	S = spline3(F, Z)
	
	file_out = fopen(file_name, "w")
	fputmatrix(file_out, S)
	fclose(file_out)
}
end

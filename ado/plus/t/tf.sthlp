{smcl}
{* 3March2022}{...}
{hline}
help for {hi:tf}
{hline}

{title:An additional option for ivreg2: tF critical values and standard error adjustments (from Lee, McCrary, Moreira, and Porter (2022)) for just-identified IV models}

{p 4}Full syntax: {cmd:tf} presumes you are using the same syntax as {cmd:ivreg2}
  
{p 4}Replay syntax: Current version of {cmd:tf} does not support replay syntax

{p 4}Version syntax: 

{p 8 14}{cmd:tf}, {cmd:version}

{p} The most up-to-date implementation of {cmd:tf} uses {cmd:ivreg2}
(from Baum, C.F., Schaffer, M.E., and Stillman, S. 2007), version 4.1.11.
Current version of {cmd:tf} provides tF critical values and adjusted standard errors for 2SLS for models with a single excluded instrument. In all other cases, the {cmd:ivreg2} output will be provided.

The current version of {cmd:tf} is not compatible with tsset, time-series operators, factor variables, by rolling, statsby, xi, bootstrap, and jackknife. For purposes of post-estimation prediction, please use {cmd:ivreg2}.


{title:Contents}
{p 2}{help ivreg3##s_description:Description}{p_end}
{p 2}{help ivreg3##s_savedresults:Saved results}{p_end}
{p 2}{help ivreg3##s_example:Example}{p_end}
{p 2}{help ivreg3##s_references:References}{p_end}
{p 2}{help ivreg3##s_acknowledgements:Acknowledgements}{p_end}
{p 2}{help ivreg3##s_authors:Authors}{p_end}
{p 2}{help ivreg3##s_citation:Citation}{p_end}

{marker s_description}{title:Description}

{p}{cmd:tf} provides the tF critical value and standard error adjustments for the 
5 percent and 1 percent levels of significance for t-ratio-based hypothesis tests 
and confidence intervals for the single endogenous regressor and just-identified IV model, 
as decribed in Lee, McCrary, Moreira, and Porter (2022). {cmd:tf} uses the
widely-employed {cmd:ivreg2} routine (from Baum, C.F., Schaffer, M.E., and Stillman, S. 2007),
and uses the same syntax. {cmd:tf} detects whether the 2SLS regression is one with a single endogenous regressor and is just-identified.
If so, it reports the tF critical value (which depends on the first-stage F statistic) in order to obtain valid inference using the conventionally computed t-ratio; 
it also reports adjusted ".05 tF standard errors" and ".01 tF standard errors". If it is not a just-identified model with a single endogenous regressor, 
then {cmd:tf} reports the requested {cmd:ivreg2} output. 
See the help file for ivreg2 and Baum, C. F., Schaffer, M.E., and Stillman, S. 2007.

{p} While the tF procedure is valid for a wide range of error structures, the current version of {cmd:tf} supports robust and (one- and two-way) cluster. 
For other error structures, one can use Tables 3a and 3b from Lee, McCrary, Moreira, and Porter (2022).

{p} The current version of {cmd:tf} supports significance (confidence) levels of 0.05 (0.95) and 0.01 (0.99).
Critical values/standard error adjustments for other levels can be derived from the description in Lee, McCrary, Moreira, and Porter (2022).

{marker s_savedresults}{title:Saved Results}


{p}When {cmd:tf} is invoked, it clears all {cmd:ivreg2} results in e() and instead saves the following results:

Scalars
{col 4}{cmd:e(N)}{col 30}Number of Observations
{col 4}{cmd:e(F)}{col 30}F statistic
{col 4}{cmd:e(tF_LB_05)}{col 30}Lower bound of tF-adjusted, 95% confidence interval
{col 4}{cmd:e(tF_UB_05)}{col 30}Upper bound of tF-adjusted, 95% confidence interval
{col 4}{cmd:e(beta_hat)}{col 30}Coefficient on IV structural parameter
{col 4}{cmd:e(tF_se_beta_hat_05)}{col 30}tF-adjusted standard error for the 5% sig. level
{col 4}{cmd:e(tF_critical_value_05)}{col 30}tF critical value for the 5% significance level
{col 4}{cmd:e(tF_critical_value_01)}{col 30}tF critical value for the 1% significance level
{col 4}{cmd:e(unadj_se)}{col 30}Unadjusted standard error (usual 2SLS standard error)
{col 4}{cmd:e(unadj_LB)}{col 30}Lower bound for 95% confidence interval from 2SLS
{col 4}{cmd:e(unadj_UB)}{col 30}Upper bound for 95% confidence interval from 2SLS
{col 4}{cmd:e(tF_LB_01)}{col 30}Lower bound of tF-adjusted, 99% confidence interval
{col 4}{cmd:e(tF_UB_01)}{col 30}Upper bound of tF-adjusted, 99% confidence interval
{col 4}{cmd:e(tF_se_beta_hat_01)}{col 30}tF-adjusted standard error for the 1% sig. level

Macros
{col 4}{cmd:e(instd)}{col 18}instrumented (RHS endogeneous) variable
{col 4}{cmd:e(insts)}{col 18}instruments
{col 4}{cmd:e(depvar)}{col 18}Name of dependent variable


{marker s_example}{title:Example}

{p 8 12}{stata "use http://fmwww.bc.edu/ec-p/data/hayashi/griliches76.dta": . use http://fmwww.bc.edu/ec-p/data/hayashi/griliches76.dta }{p_end}

{p 8 12}(Wages of Very Young Men, Zvi Griliches, J.Pol.Ec. 1976)

{col 0}(Instrumental variables, just-identified case.)

{p 8 12} {stata "xi i.year" : . xi i.year}

{p 8 12}{stata "tf lw s expr tenure rns smsa _I* (iq=med)" : . tf lw s expr tenure rns smsa _I* (iq=med)}


{marker s_references}{title:References}


{p}Baum, C. F., Schaffer, M.E., and Stillman, S. 2007. Enhanced routines for instrumental variables/GMM estimation and testing.
The Stata Journal, Vol. 7, No. 4, pp. 465-506.  http://ideas.repec.org/a/tsj/stataj/v7y2007i4p465-506.html. Working paper
version: Boston College Department of Economics Working Paper No. 667.  http://ideas.repec.org/p/boc/bocoec/667.html.
Citations in published work.

{p}Baum, C.F., Schaffer, M.E., Stillman, S. 2010.  ivreg2: Stata module for extended instrumental variables/2SLS, GMM and
AC/HAC, LIML and k-class regression.  http://ideas.repec.org/c/boc/bocode/s425401.html

{p} Lee, David S., Justin McCrary, Marcelo J. Moreira, and Jack Porter. 2022. "Valid t-Ratio Inference for IV." American Economic Review, 112 (10): 3260-90.


{marker s_acknowledgements}{title:Acknowledgements}

{p} tf is not an official Stata command. Importantly, it uses and presumes you have installed ivreg2 from Version 4.1.11 onward. For details on ivreg2, see

{p}Baum, C.F., Schaffer, M.E., Stillman, S. 2010. ivreg2: Stata module for extended instrumental variables/2SLS, GMM and
AC/HAC, LIML and k-class regression. http://ideas.repec.org/c/boc/bocode/s425401.html


{marker s_authors}{title:Authors}

       David S. Lee, Princeton University, USA
       davidlee@princeton.edu
	
       Justin McCrary, Columbia University, USA
       jmccrary@law.columbia.edu
	
       Marcelo J. Moreira, Getulio Vargas Foundation, Brazil
       mjmoreira@gfv.br
	
       Jack Porter, University of Wisconsin-Madison, USA
       jrporter@ssc.wisc.edu
	
{marker s_citation}{title:Citation}

{p} Lee, David S., Justin McCrary, Marcelo J. Moreira, and Jack Porter. 2022. "Valid t-Ratio Inference for IV." American Economic Review, 112 (10): 3260-90.


{p 0 4}For supplementary material, including updates to the online appendix and the stata code, please visit {browse "http://www.princeton.edu/~davidlee/wp/SupplementarytF.html":http://www.princeton.edu/~davidlee/wp/SupplementarytF.html}

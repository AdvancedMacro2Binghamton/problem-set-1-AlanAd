
**************************************************************************
************** 		    	Alan Adelman           ***********************
**************            Advanced Macro II        ***********************
**************                 HW #1               ***********************
**************************************************************************

*** [ Analysis File Input ] is a wide panel of Waves 2001 and 2007 of PSID for just two variables (Earnings and Quintile Indicator)
*** [ Analysis File Output ] is an earnings transitions matrix and Lorenz Curve of earnings

clear all
scalar drop _all
estimates drop _all

cd "[set path]\problem-set-1-AlanAd\analysis\input"

local indir "[set path]\problem-set-1-AlanAd\build_data\output"
local outdir "[set path]\problem-set-1-AlanAd\analysis\output"


use "`indir'\PSID_wide_panel.dta", clear


* Generate 5 quantile categorical variables for Reported Earnings
* Earnings reported for the two-years prior to interview.
* E.g. 2001 wave asks about 1999 earnings.


* Generate quantiles
xtile quint01= earn01 , nq(5)
xtile quint07= earn07, nq(5)


** Export Mobility Table 
**		(Probability (Frequency) of moving from a quantile in 2001 to a quantile in 2007)
matrix A= J(5,5,0)

	quietly	forval k = 1/5{
					tempname tot_q`k'
					count if quint01 == `k' & quint07 <.
					scalar tot_q`k' = r(N)
				
				forval j =1/5{
					tempname trans_q`k'_`j'
					count if quint01 ==`k' & quint07 ==`j'
					scalar trans_q`k'_`j' = r(N)
					
					tempname prob_`k'_`j'
					scalar prob_`k'_`j' = trans_q`k'_`j'/tot_q`k'
					
					matrix A[`k',`j']=scalar(prob_`k'_`j')
				}
}
*

preserve 
clear
svmat double A
outsheet using "`outdir'\Earn_Mobility.csv", comma replace
restore


* Graph Lorenz Curve

local wave "01 07"
quietly foreach w of local wave{
	
	sort earn`w'
	gen pct`w'= _n/_N if earn`w'<.
	egen tot_earn`w' = total(earn`w')
	gen share`w' =.
	replace share`w'= earn`w'/tot_earn`w' if _n==1
	
		forval i = 2/`=_N' {
			replace share`w' = earn`w'/tot_earn`w' + share`w'[_n-1] if _n==`i'
			}
}
*
	
twoway (scatter share01 pct01) (scatter share07 pct07) (function y=x, range(0 1) lpattern(dash)), title(Lorenz Curve) subtitle(PSID Earnings Waves 2001 and 2007) ///
					legend(order(1 "Lorenz Curve 2001" 2 "Lorenz Curve 2007" 3 "Y=X 45 Degree Line"))
					
graph export "`outdir'\Lorenz_Main.pdf", as(pdf) replace

*** The SAME graph can be estimated with these commands, then using a simple twoway with the new variables generated:

/* 			glcurve earn01, pvar (pct01) glvar(share01) lorenz
			glcurve earn07, pvar (pct07) glvar(share07) lorenz
																*/
																
*-----------------------------------**
** Calculate GINI for 2001 and 2007 **
*-----------------------------------**


local wave = " 01  07 "
quietly foreach w of local wave {
	sort earn`w'
	gen sumearn`w'=.
	replace sumearn`w' = (`=_N' + 1 - 1)*earn`w'[_n==1]

		forval i =2/`=_N' {
			
			replace sumearn`w'=  ((`=_N' + 1 - `i')*earn`w') if _n==`i'
				}

	egen numG`w' = total(sumearn`w')
	
	gen Gini`w' = (`=_N' + 1 - 2*(numG`w'/tot_earn`w'))/(`=_N'-1)  /* GINI Coefficient, same as ineqdeco function */
}
*

preserve 
keep Gini01 Gini07
drop if _n>1
outsheet using "`outdir'\Gini_Coef.csv", comma replace
restore

*** The SAME GINI Coefficients can be calculated using these two commands:

/*
		ineqdeco earn01  <<< Outputs: Gini01 >>>
		ineqdeco earn07  <<< Outputs: Gini07 >>>
						*/

*Save
saveold "`outdir'\PSID_analysis_panel.dta", replace

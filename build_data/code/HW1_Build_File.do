
**************************************************************************
************** 		    	Alan Adelman           ***********************
**************            Advanced Macro II        ***********************
**************                 HW #1               ***********************
**************************************************************************

*** [ Build File Input ] is a wide panel of Waves 2001 and 2007 of PSID for just two variables (Earnings in 2001 and Earnings in 2007)
*** [ Build File Output ] is a clean wide panel with just earnings and earnings quintile indicators for 2001 and 2007

cd "[set path]\problem-set-1-AlanAd\build_data\input"

local indir "[set path]\problem-set-1-AlanAd\build_data\code"
local outdir "[set path]\problem-set-1-AlanAd\build_data\output"

do "`indir'\Decode_PSID.do"

egen id = concat( ER30001 ER30002 )  /* Generate Unique ID */
sort id
by id: gen dup = cond(_N==1,0,_n)
drop if dup>1   

rename ER33627A  earn01
rename ER33926A earn07

 
* Drop Individuals From Baseline Whose Earnings are Inapplicable
* Meaning the individual did not work in 2003, was not in FU in 2003, under age 18 in 2005,
* 		Or worked in own unincorporated business that broke even in 2003, OR Posted Business Loss in Baseline (Negative Values)
drop if earn01<=0

* Drop Individuals Who Don't Know Earnings or Refused to Answer
drop if earn01 == 9999998
drop if earn07 == 9999998
drop if earn01 == 9999999
drop if earn07 == 9999999

order id earn*
keep id earn* 

saveold "`outdir'\PSID_wide_panel.dta", replace

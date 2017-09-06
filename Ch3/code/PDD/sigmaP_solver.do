
//生产COV数据，用于进一步的协方差计算
use DD_daily,clear
keep date stock_serialnumber ret_av
sort date stock_serialnumber
reshape wide ret_av,i(date) j(stock_serialnumber)
save ret_av_by_stock,replace

use DD_daily,clear
sort banktype yearqt stockid date 
egen id_banktype_yqt=group(banktype yearqt)
keep date banktype yearqt id_banktype_yqt stock_serialnumber stockid ret_av
sort date
merge m:1 date using ret_av_by_stock.dta
drop _merge
sort banktype yearqt date 
drop banktype yearqt stock_serialnumber stockid
drop date ret_av
save COV_compute.dta,replace

**********BEGIN HERE
//协方差矩阵计算过程
use COV_compute,clear
set more off
forvalues i=1/15 {
global t=`i'+1
  forvalues j=$t/16 {

statsby,by(id_banktype_yqt) clear: cor ret_av`i' ret_av`j',c
rename cov_12 cov_`i'_`j'
keep id_banktype_yqt cov_`i'_`j'
save covdata_`i'_`j'.dta,replace
use COV_compute,clear
}
}

use COV_compute,clear
set more off
forvalues i=1/16 {
statsby,by(id_banktype_yqt) clear: cor ret_av`i' ret_av`i',c
rename cov_12 cov_`i'_`i'
keep id_banktype_yqt cov_`i'_`i'
save covdata_`i'_`i'.dta,replace
use COV_compute,clear
}

use COV_compute,clear
keep id_banktype_yqt
duplicates drop id_banktype_yqt,force
forvalues i=1/15 {
global t=`i'+1
  forvalues j=$t/16 {
merge 1:1 id_banktype_yqt using covdata_`i'_`j'.dta
drop _merge
save COV_result.dta,replace
 }
}

forvalues i=1/16 {
merge 1:1 id_banktype_yqt using covdata_`i'_`i'.dta
drop _merge
save COV_result.dta,replace
}

**********BEGIN HERE
//生成sigmaP
use DD_quarterly,clear
keep id_banktype_yqt stock_serialnumber av_p
sort id_banktype_yqt stock_serialnumber
reshape wide av_p,i(id_banktype_yqt) j(stock_serialnumber)
save av_p_by_stock,replace

merge 1:1 id_banktype_yqt using COV_result.dta
drop _merge

save sigmaP.dta,replace

forvalues i=1/15 {
global t=`i'+1
  forvalues j=$t/16 {
gen part1_`i'_`j'=2*av_p`i'*av_p`j'*cov_`i'_`j'
}
}

forvalues i=1/16 {
gen part2_`i'_`i'=av_p`i'*av_p`i'*cov_`i'_`i'
}

egen part1=rowtotal(part1_*)
egen part2=rowtotal(part2_*)
gen sigmap=sqrt(part1+part2)
keep id_banktype_yqt sigmap
save sigmaP.dta,replace
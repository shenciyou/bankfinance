//初始化利率宏观变量
insheet using rate.csv,clear
destring hs300,replace force
replace hs300=. if hs300==-1
tostring date,replace
gen date2=date(date,"YMD")
format date2 %td
drop date
rename date2 date
label var date "日期"
gen year=year(date)
gen quarter=quarter(date)
tostring year,gen(year2)
tostring quarter,gen(quarter2)
replace quarter2=substr("00"+quarter2,-2,2)
gen yearqt=year2+quarter2
drop year quarter year2 quarter2
drop if yearqt==".0."
sort yearqt date
gen id=_n
tsset id
gen lag_term=l.term
gen lag_def=l.def
gen lag_hs300=l.hs300
gen lag_rate=l.rate
drop if id==1
drop id
save rate,replace

//生成16个deltadd变量
use DD_daily,clear
sort stockid date
drop id
egen id=group(stockid)
by id,sort:gen time=_n
tsset id time
gen deltadd=d.dd
keep date stock_serialnumber deltadd
sort date stock_serialnumber
reshape wide deltadd,i(date) j(stock_serialnumber)
save deltadd_by_stock,replace

//merge利率宏观变量
use deltadd_by_stock,clear
gen year=year(date)
gen quarter=quarter(date)
tostring year,gen(year2)
tostring quarter,gen(quarter2)
replace quarter2=substr("00"+quarter2,-2,2)
gen yearqt=year2+quarter2
drop year quarter year2 quarter2
order date yearqt
egen sumdeltadd=rowtotal(deltadd*) 
sort yearqt date
merge 1:1 yearqt date using rate.dta
drop if _merge==2
drop _merge
egen nonmisscount=rownonmiss(deltadd*)
drop if nonmisscount==0
save deltadd_by_stock,replace


//计算rsquare
use deltadd_by_stock,clear
forvalues i=1/16 {
gen sumdeltadd_except`i'=sumdeltadd-deltadd`i'
replace sumdeltadd_except`i'=sumdeltadd_except`i'/(nonmisscount-1)
egen nonmisscount_`i'=rownonmiss(deltadd`i' sumdeltadd_except`i')
}
sort yearqt
egen id=group(yearqt)
egen idmax=max(id)
global idmax=idmax
matrix rsquare=J($idmax,16,.)
set more off
forvalues i=1/16 {
forvalues j=1/$idmax {

egen tempcount=mean(nonmisscount_`i') if id==`j'
egen count=mean(tempcount)
local count=count
drop tempcount count
if  `count'==2 {
reg deltadd`i' sumdeltadd_except`i' if id==`j'
matrix rsquare[`j',`i']=e(r2)
}
}
}
matrix list rsquare
drop *
svmat double rsquare
forvalues i=1/16 {
replace rsquare`i'=ln(rsquare`i'/(1-rsquare`i'))
}
gen id=_n
reshape long rsquare,i(id) j(stock_serialnumber)
sort id stock_serialnumber
save rsquare,replace
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

//计算betasystem，采取的分位数点为0.1
use deltadd_by_stock,clear

forvalues i=1/16 {
egen corenonmisscount_`i'=rownonmiss(deltadd`i' sumdeltadd)
egen nonmisscount_`i'=rownonmiss(deltadd`i' sumdeltadd term def hs300 rate)
}


sort yearqt
egen id=group(yearqt)
egen idmax=max(id)
global idmax=idmax
global percentile=50
matrix beta=J($idmax,16,.)
matrix temp=J(6,1,.)
set more off
forvalues i=1/16 {
forvalues j=1/$idmax {

egen tempcount=mean(nonmisscount_`i') if id==`j'
egen count=mean(tempcount)
local count=count
egen tempcorecount=mean(corenonmisscount_`i') if id==`j'
egen corecount=mean(tempcorecount)
local corecount=corecount
drop tempcount tempcorecount count corecount
if `corecount'==2 & `count'!=2{
qreg sumdeltadd deltadd`i' lag_term lag_def lag_hs300 lag_rate if id==`j',q(0.5)
matrix temp=e(b)
matrix beta[`j',`i']=temp[1,1]
}
}
}

matrix list beta
drop *
svmat double beta
gen id=_n
save betapercentile,replace

//计算deltacovar
use deltadd_by_stock,clear
sort yearqt
egen id=group(yearqt)
forvalues i=1/16 {
by id,sort:egen p10_deltadd`i'=pctile(deltadd`i'),p(10)
by id,sort:egen p50_deltadd`i'=pctile(deltadd`i'),p(50)
by id,sort:gen p1050_deltadd`i'=p10_deltadd`i'-p50_deltadd`i'
}
duplicates drop id,force
merge 1:1 id using betapercentile
drop _merge
keep yearqt id p1050_deltadd* beta*
forvalues i=1/16 {
gen deltacovar`i'=beta`i'*p1050_deltadd`i'
}
keep id deltacovar*
reshape long deltacovar,i(id) j(stock_serialnumber)
sort id stock_serialnumber
save deltacovar,replace

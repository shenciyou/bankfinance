/*初始化合并KMVdata.xls*/
insheet using KMVdata1.csv,clear
tostring stockid,replace
replace stockid=substr("000000"+stockid,-9,6)
tostring date,replace
gen date2=date(date,"YMD")
format date2 %td
drop date
rename date2 date
label var date "日期"
gen year=year(date)
gen month=month(date)
gen quarter=quarter(date)
order stockid stockname date year month quarter
sort stockid date year month quarter
egen id=group(stockid)
by id,sort:gen num=_n
tsset id num
egen id_stockid_yq=group(stockid year quarter)
sort id num
by id:gen ret=ln(close/l.close)
sort stockid date year month quarter
by id_stockid_yq,sort:egen sigma=sd(ret)
gen sigma_yq=sigma*sqrt(62.5)
by id_stockid_yq,sort:egen stockvalue_yq=mean(stockvalue)
save KMVdata1.dta,replace

insheet using KMVdata2.csv,clear
tostring stockid,replace
replace stockid=substr("000000"+stockid,-9,6)
tostring date,replace
gen date2=date(date,"YMD")
format date2 %td
drop date
rename date2 date
label var date "日期"
gen year=year(date)
gen month=month(date)
gen quarter=quarter(date)
order stockid stockname date year month quarter
sort stockid date year month quarter
replace sd=sd*10000
replace ld=ld*10000
gen dp=sd+0.5*ld
save KMVdata2.dta,replace

insheet using KMVdata3.csv,clear
tostring date,replace
gen date2=date(date,"YMD")
format date2 %td
drop date
rename date2 date
label var date "日期"
gen year=year(date)
gen month=month(date)
gen quarter=quarter(date)
sort year month quarter
egen id=group(year quarter)
by id,sort:egen rf_year_mean=mean(rf)
duplicates drop id,force
drop id date month
gen rf_yq=rf_year_mean/4
keep year quarter rf_yq
order year quarter rf_yq
export excel using KMVdata3.xlsx,replace firstrow(variables)
save KMVdata3.dta,replace
//使用EXCEL补全季度rf数据
insheet using KMVdata3_add.csv,clear
replace rf_yq=rf_yq/100
drop if year<1990
save KMVdata3.dta,replace

//合并进程
use KMVdata1,clear
sort stockid year quarter 
merge m:1 stockid year quarter using KMVdata2.dta
keep if _merge==3
drop _merge
sort stockid date year month quarter
drop id num id_stockid_yq
merge m:1 year quarter using KMVdata3.dta
keep if _merge==3
drop _merge
sort stockid date year month quarter
save KMVdata.dta,replace

//将合并的数据准备给Matlab处理
use KMVdata.dta,clear
sort stockid date year month quarter
egen id_stockid_yq=group(stockid year quarter)
duplicates drop id_stockid_yq,force
drop date month close stockvalue ret sigma sd ld
save KMVdata_for_Matlab.dta,replace
export excel using KMVdata_for_Matlab.xls,replace firstrow(variables)

//Matlab算完DD后返回KMVresult文件

//补充BV数据
insheet using KMVdata2-2.csv,clear
tostring stockid,replace
replace stockid=substr("000000"+stockid,-9,6)
tostring date,replace
gen date2=date(date,"YMD")
format date2 %td
drop date
rename date2 date
label var date "日期"
gen year=year(date)
gen month=month(date)
gen quarter=quarter(date)
order stockid stockname date year month quarter
sort stockid date year month quarter
replace bv=bv*10000
sort stockid year quarter
egen id_stockid_yq=group(stockid year quarter)
tostring year,gen(year2)
tostring quarter,gen(quarter2)
replace quarter2=substr("00"+quarter2,-2,2)
gen yearqt=year2+quarter2
drop year2 quarter2
sort stockid yearqt
save KMVdata2-2.dta,replace


//将返回KMVresult文件处理成季度的以及日度的DD初步文件
insheet using KMVresult.csv,clear
tostring stockid,replace
replace stockid=substr("000000"+stockid,-6,6)
sort stockid year quarter
egen id_stockid_yq=group(stockid year quarter)
save KMVdata_quarterly.dta,replace

use KMVdata.dta,clear
sort stockid date year month quarter
egen id_stockid_yq=group(stockid year quarter)
by id_stockid_yq,sort:gen num=_n
by id_stockid_yq,sort:gen nummax=_N
by id_stockid_yq,sort:gen numdelta=num-nummax
merge m:1 year id_stockid_yq using KMVdata_quarterly.dta
drop _merge
sort stockid date year month quarter
replace av=. if numdelta!=0
replace dd=. if numdelta!=0
replace edf=. if numdelta!=0
tsset id_stockid_yq num
sort id_stockid_yq num
save KMVdata_daily.dta,replace
export excel using KMVdata_daily.xls,replace firstrow(variables)

//*季度DD数据处理进程*//
/*处理季度的DD数据并保存为DD_quarterly.dta*/
use KMVdata_quarterly.dta,clear
merge 1:1 stockid year quarter using KMVdata2-2.dta
keep if _merge==3
drop _merge
gen mvtbv=sv/bv

gen banktype=.
replace banktype=1 if stockid=="601398"|stockid=="601288"|stockid=="601988"|stockid=="601939"|stockid=="601328"
replace banktype=2 if stockid=="601818"|stockid=="000001"|stockid=="600015"|stockid=="600016"|stockid=="600000"|stockid=="601166"|stockid=="600036"|stockid=="601998"
replace banktype=3 if stockid=="601169"|stockid=="601009"|stockid=="002142"
drop yearqt
tostring year,gen(year2)
tostring quarter,gen(quarter2)
replace quarter2=substr("00"+quarter2,-2,2)
gen yearqt=year2+quarter2
drop year2 quarter2
sort stockid yearqt

sort banktype yearqt stockid
egen id_banktype_yqt=group(banktype yearqt)
by id_banktype_yqt,sort:egen add=mean(dd)
by id_banktype_yqt,sort:gen num=_n
by id_banktype_yqt,sort:egen sum_sv=sum(sv)
by id_banktype_yqt,sort:gen sv_p=sv/sum_sv
by id_banktype_yqt,sort:egen wdd=sum(sv_p*dd)
by id_banktype_yqt,sort:egen sum_av=sum(av)
by id_banktype_yqt,sort:gen av_p=av/sum_av

sort yearqt stockid
egen id_bankall_yqt=group(yearqt)
by id_bankall_yqt,sort:egen add_all=mean(dd)
by id_bankall_yqt,sort:gen num_all=_n
by id_bankall_yqt,sort:egen sum_sv_all=sum(sv)
by id_bankall_yqt,sort:gen sv_p_all=sv/sum_sv_all
by id_bankall_yqt,sort:egen wdd_all=sum(sv_p_all*dd)
by id_bankall_yqt,sort:egen sum_av_all=sum(av)
by id_bankall_yqt,sort:gen av_p_all=av/sum_av_all
save DD_quarterly.dta,replace

****duplicates drop id_banktype_yqt,force
****sort id_banktype_yqt

//*日度DD数据处理进程*//
/*先通过EXCEL插值处理日度的DD数据，然后再导入KMVdata_daily_add.csv并处理，最后保存为DD_daily.dta*/
insheet using KMVdata_daily_add.csv,clear
rename stockvalue sv
rename stockvalue_yq sv_yq
tostring stockid,replace
replace stockid=substr("000000"+stockid,-6,6)
tostring date,replace
gen date2=date(date,"YMD")
format date2 %td
drop date
rename date2 date
label var date "日期"
order stockid date year month quarter
sort stockid date year month quarter
drop num
egen id=group(stockid)
by id,sort:gen num=_n
tsset id num
by id:gen ret_av=ln(av/l.av)
sort stockid date year month quarter
tostring year,gen(year2)
tostring quarter,gen(quarter2)
replace quarter2=substr("00"+quarter2,-2,2)
gen yearqt=year2+quarter2
drop year year2 quarter*
sort stockid yearqt date

merge m:1 stockid yearqt using KMVdata2-2.dta

keep if _merge==3
drop _merge
gen mvtbv=sv/bv

gen banktype=.
replace banktype=1 if stockid=="601398"|stockid=="601288"|stockid=="601988"|stockid=="601939"|stockid=="601328"
replace banktype=2 if stockid=="601818"|stockid=="000001"|stockid=="600015"|stockid=="600016"|stockid=="600000"|stockid=="601166"|stockid=="600036"|stockid=="601998"
replace banktype=3 if stockid=="601169"|stockid=="601009"|stockid=="002142"


sort banktype date stockid
egen id_banktype_date=group(banktype date)
by id_banktype_date,sort:egen add=mean(dd)
by id_banktype_date,sort:gen num=_n
by id_banktype_date,sort:egen sum_sv=sum(sv)
by id_banktype_date,sort:gen sv_p=sv/sum_sv
by id_banktype_date,sort:egen wdd=sum(sv_p*dd)
by id_banktype_date,sort:egen sum_av=sum(av)
by id_banktype_date,sort:gen av_p=av/sum_av

sort date stockid
egen id_bankall_date=group(date)
by id_bankall_date,sort:egen add_all=mean(dd)
by id_bankall_date,sort:gen num_all=_n
by id_bankall_date,sort:egen sum_sv_all=sum(sv)
by id_bankall_date,sort:gen sv_p_all=sv/sum_sv_all
by id_bankall_date,sort:egen wdd_all=sum(sv_p_all*dd)
by id_bankall_date,sort:egen sum_av_all=sum(av)
by id_bankall_date,sort:gen av_p_all=av/sum_av_all

save DD_daily.dta,replace

//给16个银行编号
use DD_daily,clear
duplicates drop stockid,force
keep banktype stockid stockname
sort banktype stockid
gen stock_serialnumber=_n
save stock_serialnumber.dta,replace
export excel using stock_serialnumber.xls,replace firstrow(variables)
use DD_daily,clear
merge m:1 stockid using stock_serialnumber.dta
drop _merge
save DD_daily.dta,replace
use DD_quarterly,clear
merge m:1 stockid using stock_serialnumber.dta
drop _merge
save DD_quarterly.dta,replace


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

//DD_daily的PDD计算
use DD_daily,clear
sort banktype yearqt stockid
egen id_banktype_yqt=group(banktype yearqt)
merge m:1 id_banktype_yqt using sigmaP.dta
drop _merge


sort banktype date stockid
by id_banktype_date,sort:egen pdd_dp=sum(dp)
by id_banktype_date,sort:egen pdd_av=sum(av)
gen pdd=(ln(pdd_av/pdd_dp)+(rf-sigmap^2))/sigmap

sort date stockid
by id_bankall_date,sort:egen pdd_dp_all=sum(dp)
by id_bankall_date,sort:egen pdd_av_all=sum(av)
gen pdd_all=(ln(pdd_av_all/pdd_dp_all)+(rf-sigmap^2))/sigmap
save DD_daily,replace

//DD_quarterly的PDD计算
use DD_quarterly,clear
sort banktype yearqt stockid
merge m:1 id_banktype_yqt using sigmaP.dta
drop _merge

sort banktype yearqt stockid
by id_banktype_yqt,sort:egen pdd_dp=sum(dp)
by id_banktype_yqt,sort:egen pdd_av=sum(av)
gen pdd=(ln(pdd_av/pdd_dp)+(rf-sigmap^2))/sigmap

sort yearqt stockid
by id_bankall_yqt,sort:egen pdd_dp_all=sum(dp)
by id_bankall_yqt,sort:egen pdd_av_all=sum(av)
gen pdd_all=(ln(pdd_av_all/pdd_dp_all)+(rf-sigmap^2))/sigmap
save DD_quarterly,replace
******DD保存点******

//*季度DD数据处理进程之描述性统计*//
use DD_quarterly,clear
sort id_banktype_yqt
duplicates drop id_banktype_yqt,force
gen pdd_minus_add=pdd-add
sum add wdd pdd pdd_minus_add if banktype==1
sum add wdd pdd pdd_minus_add if banktype==2
sum add wdd pdd pdd_minus_add if banktype==3


sum add wdd pdd pdd_minus_add if banktype==1,detail
sum add wdd pdd pdd_minus_add if banktype==2,detail
sum add wdd pdd pdd_minus_add if banktype==3,detail

use DD_quarterly,clear
sort id_bankall_yqt
duplicates drop id_bankall_yqt,force
gen pdd_minus_add_all=pdd_all-add_all
sum add_all wdd_all pdd_all pdd_minus_add_all
sum add_all wdd_all pdd_all pdd_minus_add_all,detail

use DD_quarterly.dta,clear
duplicates drop id_banktype_yqt,force
sort banktype yearqt
export excel using banktype_yqt.xls,replace firstrow(variables)

use DD_quarterly.dta,clear
duplicates drop id_bankall_yqt,force
sort yearqt
export excel using bankall_yqt.xls,replace firstrow(variables)


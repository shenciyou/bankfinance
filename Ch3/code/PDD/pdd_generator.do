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
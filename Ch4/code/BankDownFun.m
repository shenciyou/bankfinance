function[BankDownTotalNumOutput BankDownNumOutput]=BankDownFun(X,Deta,LGD,BankNum,BankDownNum,InterBankDebtSum,CoreCapital,RiskWeightedAsset)

X_data=X.*InterBankDebtSum;     %将归一化X变成实际数值，其单位为元
CoreCapital_T=CoreCapital';
RiskWeightedAsset_T=RiskWeightedAsset';
BankDownNum_temp=BankDownNum+eye(BankNum);        %假设自身银行倒闭

for ii=1:BankNum     %ii银行最先倒闭
   Down_temp=BankDownNum_temp(ii,:);       %在该轮数下，ii银行已经造成其他银行倒闭的情况(包括自身)
    for jj=1:BankNum      %判断jj银行倒闭情况
     if 0==Down_temp(jj)     %若jj银行还没有倒闭
      if (CoreCapital_T(jj)-sum(LGD.*X_data(jj,:).*Down_temp))/(RiskWeightedAsset_T(jj)-Deta.*sum(X_data(jj,:).*Down_temp))<0.06 %银行倒闭的判定规则
          BankDownNum_temp(ii,jj)=1;          %在该轮数下，ii银行已经造成jj银行倒闭
       end
     end
   end
end

BankDownNumOutput=BankDownNum_temp-eye(BankNum);     %当前违约率和当前轮次下，银行ii倒闭所引起其他银行倒闭的情况（不包含银行ii自身）
BankDownTotalNumOutput=sum(BankDownNumOutput');      %当前违约率和当前轮次下，银行ii倒闭所引起其他银行倒闭的总数目
end
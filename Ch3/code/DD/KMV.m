% KMV Main Function
% code by SCY 2015-3-31
%数据导入
clear
[ndata, text, alldata]=xlsread('KMVdata_for_Matlab.xls');
alldata(1,:)=[];
stockid=alldata(:,1);
stockname=alldata(:,2);
year=alldata(:,3);
quarter=alldata(:,4);
sigmaSV=alldata(:,5);
SV=alldata(:,6);
DP=alldata(:,7);
rf=alldata(:,8);
id=alldata(:,9);
%循环迭代
for i=1:size(id)
DPtemp=DP{i};
SVtemp=SV{i};
sigmaSVtemp=sigmaSV{i};
rftemp=rf{i};
[AVtemp,sigmaAVtemp]=KMVOptSearch(SVtemp,DPtemp,rftemp,sigmaSVtemp)
AV{i}=AVtemp;
sigmaAV{i}=sigmaAVtemp;
DDtemp=(AVtemp-DPtemp)/(AVtemp*sigmaAVtemp);
DD{i}=DDtemp;
EDF{i}=normcdf(-DDtemp);
end
AV2=AV';
sigmaAV2=sigmaAV';
DD2=DD';
EDF2=EDF';

%结果输出
xlswrite('KMV迭代结果.xls', {'股票代码'},'Sheet1','A1');
xlswrite('KMV迭代结果.xls', {'股票名称'},'Sheet1','B1');
xlswrite('KMV迭代结果.xls', {'年份'},'Sheet1','C1');
xlswrite('KMV迭代结果.xls', {'季度'},'Sheet1','D1');
xlswrite('KMV迭代结果.xls', {'无风险利率'},'Sheet1','E1');
xlswrite('KMV迭代结果.xls', {'股权价值'},'Sheet1','F1');
xlswrite('KMV迭代结果.xls', {'股权价值波动率'},'Sheet1','G1');
xlswrite('KMV迭代结果.xls', {'资产价值'},'Sheet1','H1');
xlswrite('KMV迭代结果.xls', {'资产价值波动率'},'Sheet1','I1');
xlswrite('KMV迭代结果.xls', {'违约点DP'},'Sheet1','J1');
xlswrite('KMV迭代结果.xls', {'违约距离DD'},'Sheet1','K1');
xlswrite('KMV迭代结果.xls', {'违约概率EDF'},'Sheet1','L1');

xlswrite('KMV迭代结果.xls', stockid,'Sheet1','A2');
xlswrite('KMV迭代结果.xls', stockname,'Sheet1','B2');
xlswrite('KMV迭代结果.xls', year,'Sheet1','C2');
xlswrite('KMV迭代结果.xls', quarter,'Sheet1','D2');
xlswrite('KMV迭代结果.xls', rf,'Sheet1','E2');
xlswrite('KMV迭代结果.xls', SV,'Sheet1','F2');
xlswrite('KMV迭代结果.xls', sigmaSV,'Sheet1','G2');
xlswrite('KMV迭代结果.xls', AV2,'Sheet1','H2');
xlswrite('KMV迭代结果.xls', sigmaAV2,'Sheet1','I2');
xlswrite('KMV迭代结果.xls', DP,'Sheet1','J2');
xlswrite('KMV迭代结果.xls', DD2,'Sheet1','K2');
xlswrite('KMV迭代结果.xls', EDF2,'Sheet1','L2');






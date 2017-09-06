%%Matlab数据预处理模块
clear
clc
tic

%% For the model with Macro-prudential, Monetary Policy and Bank Systematic Risk
data=xlsread('macrodata.xlsx','data','J2:P81');  % Estimation up to 2015Q4
%data=xlsread('macrodata.xlsx','data','J2:P47'); % Estimationup to 2007Q2 


gdp=data(:, 1); 
investment=data(:,2);
m2=data(:,3);
labor=data(:,4);
consumption=data(:,5);
wage=data(:,6);
cpi=data(:,7);

y2=hpfilter(gdp,4);
c2=hpfilter(consumption,4);
i2=hpfilter(investment,4);
w2=hpfilter(wage,4);
[~,y]=hpfilter(log(y2),Inf);
[~,c]=hpfilter(log(c2),Inf);
[~,i]=hpfilter(log(i2),Inf);
[~,w]=hpfilter(log(w2),Inf);

%%[~,y]=hpfilter(log(gdp),Inf);
%%[~,c]=hpfilter(log(consumption),Inf);
%%[~,i]=hpfilter(log(investment),Inf);
%%[~,w]=hpfilter(log(wage),Inf);


[~,m]=hpfilter(log(m2),Inf);
[~,pi]=hpfilter(log(cpi),Inf);
[~,n]=hpfilter(log(labor),Inf);
clear gdp investment m2 labor consumption wage cpi;
clear data y2 c2 i2 w2

%结果输出
xlswrite('datainput.xls', y,'Sheet1','A1');
xlswrite('datainput.xls', m,'Sheet1','B1');
xlswrite('datainput.xls', c,'Sheet1','C1');
xlswrite('datainput.xls', pi,'Sheet1','D1');
xlswrite('datainput.xls', i,'Sheet1','E1');
xlswrite('datainput.xls', w,'Sheet1','F1');
xlswrite('datainput.xls', n,'Sheet1','G1');
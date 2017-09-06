clear
for i=1:1:8  %按年进行批量处理
k=2015-i;  %获取当前年份

eval(['X=xlsread(''lingo.xlsx'',''',num2str(k),''',''A1:P16'');']);
BankNum=16;  %银行数量
Deta=0.25;   %银行同业间拆借资产的风险权重系数
LGDList=[5 10 15 20 40 50 60 65 70 75 80 90 100]/100;      %同业拆借资金的违约损失率
LGDLen=length(LGDList);
Num=10;     %传染轮数最大值设定
LunCi=zeros(BankNum,LGDLen);       %在违约率下，每家银行倒闭所引起的传染轮次（初始化）
BankDownLunCi=zeros(BankNum,LGDLen);    %在违约率下，每家银行倒闭所引起的银行倒闭总数（初始化）
BiLi=zeros(BankNum,LGDLen);   %在违约率下，每家银行倒闭所引起的受影响银行资产比重（初始化）
eval(['TotalAsset=xlsread(''asset.xlsx'',''Sheet1'',''A',num2str(i),':P',num2str(i),''');']);   %银行总资产
eval(['Liability_interbank=xlsread(''liability_interbank.xlsx'',''Sheet1'',''A',num2str(i),':P',num2str(i),''');']);   %银行间负债 
InterBankDebtSum=sum(Liability_interbank);   %所有银行间负债之和
eval(['CoreCapital=xlsread(''corecapital.xlsx'',''Sheet1'',''A',num2str(i),':P',num2str(i),''');']);    %核心资本
eval(['RiskWeightedAsset=xlsread(''rwa.xlsx'',''Sheet1'',''A',num2str(i),':P',num2str(i),''');']);    %风险加权资产总额 
eval(['BankDownResult',num2str(k),'=cell(size(LGDList,2),Num);']);  %银行倒闭情况结果矩阵初始化 
eval(['BankDownTotalResult',num2str(k),'=cell(size(LGDList,2),Num);']);  %银行倒闭数量结果矩阵初始化

for ll=1:LGDLen           %外层循环，循环变量ll=LGD
    LGD=LGDList(ll);
    BankDownTotalNum=zeros(Num,BankNum);
    BankDownNum=zeros(BankNum,BankNum);

  for kk=1:Num       %里层循环，循环变量kk=轮次    
     [BankDownTotalNum(kk,:) BankDownNum] = BankDownFun(X,Deta,LGD,BankNum,BankDownNum,InterBankDebtSum,CoreCapital,RiskWeightedAsset);  %ii银行最先倒闭,在kk轮次下,银行倒闭的情况
   %输出参数1：当前违约率和当前轮次下，银行ii倒闭所引起其他银行倒闭的总数目；输出参数2：当前违约率和当前轮次下，银行ii倒闭所引起其他银行倒闭的情况（不包含银行ii自身）
   eval(['BankDownResult',num2str(k),'{ll,kk}=BankDownNum;']); %数据保存：当前违约率和当前轮次下，银行ii倒闭所引起其他银行倒闭的情况（不包含银行ii自身）    
   eval(['BankDownTotalResult',num2str(k),'{ll,kk}=BankDownTotalNum(kk,:);']); %数据保存：当前违约率和当前轮次下，银行ii倒闭所引起其他银行倒闭的总数目
     %统计当前违约率和所有轮次下，各家银行倒闭所引起的银行倒闭总数的最大值（10轮中的最大值）（覆盖式算法）
    for mm=1:BankNum    %最里层循环，循环变量mm=银行mm   
        if BankDownLunCi(mm,ll)<BankDownTotalNum(kk,mm)
           BankDownLunCi(mm,ll)=BankDownTotalNum(kk,mm);
           LunCi(mm,ll)=kk; %条件满足时，把10轮中造成最大倒闭数量的轮次数输出
           BiLi(mm,ll)=sum(TotalAsset.*BankDownNum(mm,:))/(sum(TotalAsset)-TotalAsset(mm)); %条件满足时，把10轮中造成最大倒闭数量的受影响资产比重输出
          %分子=资产列*已倒闭的银行序号=已倒闭的资产量；分母=sum（资产列）-银行ii自身资产
        end
    end
 end
end

%%结果输出模块
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''银行ii倒闭引起的倒闭银行总数''} ,''Sheet1'',''A1'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''农业银行''} ,''Sheet1'',''A2'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''交通银行''} ,''Sheet1'',''A3'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''工商银行''} ,''Sheet1'',''A4'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''建设银行''} ,''Sheet1'',''A5'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''中国银行''} ,''Sheet1'',''A6'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''平安银行''} ,''Sheet1'',''A7'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''浦发银行''} ,''Sheet1'',''A8'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''华夏银行''} ,''Sheet1'',''A9'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''民生银行''} ,''Sheet1'',''A10'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''招商银行''} ,''Sheet1'',''A11'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''兴业银行''} ,''Sheet1'',''A12'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''光大银行''} ,''Sheet1'',''A13'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''中信银行''} ,''Sheet1'',''A14'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''宁波银行''} ,''Sheet1'',''A15'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''南京银行''} ,''Sheet1'',''A16'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''北京银行''} ,''Sheet1'',''A17'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', LGDList,''Sheet1'',''B1'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', BankDownLunCi,''Sheet1'',''B2'');']);


eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''银行ii倒闭引起的风险传染轮数''} ,''Sheet2'',''A1'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''农业银行''} ,''Sheet2'',''A2'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''交通银行''} ,''Sheet2'',''A3'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''工商银行''} ,''Sheet2'',''A4'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''建设银行''} ,''Sheet2'',''A5'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''中国银行''} ,''Sheet2'',''A6'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''平安银行''} ,''Sheet2'',''A7'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''浦发银行''} ,''Sheet2'',''A8'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''华夏银行''} ,''Sheet2'',''A9'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''民生银行''} ,''Sheet2'',''A10'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''招商银行''} ,''Sheet2'',''A11'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''兴业银行''} ,''Sheet2'',''A12'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''光大银行''} ,''Sheet2'',''A13'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''中信银行''} ,''Sheet2'',''A14'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''宁波银行''} ,''Sheet2'',''A15'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''南京银行''} ,''Sheet2'',''A16'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''北京银行''} ,''Sheet2'',''A17'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', LGDList,''Sheet2'',''B1'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', LunCi,''Sheet2'',''B2'');']);

eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''银行ii倒闭引起的受影响资产比重''} ,''Sheet3'',''A1'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''农业银行''} ,''Sheet3'',''A2'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''交通银行''} ,''Sheet3'',''A3'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''工商银行''} ,''Sheet3'',''A4'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''建设银行''} ,''Sheet3'',''A5'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''中国银行''} ,''Sheet3'',''A6'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''平安银行''} ,''Sheet3'',''A7'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''浦发银行''} ,''Sheet3'',''A8'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''华夏银行''} ,''Sheet3'',''A9'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''民生银行''} ,''Sheet3'',''A10'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''招商银行''} ,''Sheet3'',''A11'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''兴业银行''} ,''Sheet3'',''A12'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''光大银行''} ,''Sheet3'',''A13'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''中信银行''} ,''Sheet3'',''A14'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''宁波银行''} ,''Sheet3'',''A15'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''南京银行''} ,''Sheet3'',''A16'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', {''北京银行''} ,''Sheet3'',''A17'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', LGDList,''Sheet3'',''B1'');']);
eval(['xlswrite(''银行风险传染',num2str(k),'.xls'', BiLi,''Sheet3'',''B2'');']);

eval(['save(''BankDownResult',num2str(k),'.mat'',''BankDownResult',num2str(k),''');']);
eval(['save(''BankDownTotalResult',num2str(k),'.mat'',''BankDownTotalResult',num2str(k),''');']);

clearvars -EXCEPT i
end

%%结果读取模块
for i=1:1:8  %按年进行批量处理
k=2015-i;  %获取当前年份
eval(['load(''BankDownResult',num2str(k),'.mat'');']);
eval(['load(''BankDownTotalResult',num2str(k),'.mat'');']);
end
clearvars i k
save('BankDownResult.mat');  %将银行倒闭结果汇总保存到数据文件中
load('BankDownResult.mat');  %读取汇总的银行倒闭结果
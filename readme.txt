This is my project concerning bankfinance.

主要的软件操作和程序代码见作者GitHub上的bankfinance项目：
https://github.com/shenciyou/bankfinance

主要的代码列表如下：
第三章 系统性风险的测度
1、DD的计算
（1）code_for_DD.do
（2）KMVfun.m
（3）KMVOptSearch.m
（4）KMV.m
2、PDD的计算
（1）sigmaP_solver.do
（2）pdd_generator.do
3、LRSQ的计算
（1）lrsq_generator.do
4、△CoVaR的计算
（1）deltacovar_generator.do
5、静态MES的计算
（1）static_mes.txt
6、动态MES的计算
（1）dynamic_mes.txt
7、描述性统计
（1）descriptive_stat.txt

第四章 系统性风险传染研究
1、银行间双边风险敞口矩阵X的计算
（1）lingo.txt
2、银行间风险传染仿真
（1）BankDownFun.m
（2）riskcontagion.m

第五章 系统重要性银行识别
1、基于SES衍生的SRISK相对系统重要性银行识别
（1）srisk.txt
2、基于熵值指标法的系统重要性银行识别
（1）dsibs.txt（包含熵值法过程核心函数entropy_method.m）

第六章 系统性风险的影响因素
1、银行竞争
（1）code_for_comp.txt
2、货币政策
（1）code_for_mp.txt
3、面板合成
（1）code_for_combine.txt
4、回归分析
（1）code_for_xtreg.txt

第七章 基于DSGE模型的宏观审慎政策和货币政策的协调
1、Dynare工具箱的MOD文件
（1）macrodata_dynare.mod
2、Matlab对Dynare文件的调用
（1）dynarecall.m
3、Matlab数据预处理模块
（1）macrodata_input.m
4、Matlab冲击光滑估计及脉冲响应值输出模块
（1）macrodata_output.m

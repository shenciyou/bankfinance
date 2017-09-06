%%Matlab数据提取模块
%%提取Smoothed Shocks
load('macrodata_dynare_results.mat', 'oo_');
c=struct2cell(oo_.SmoothedShocks);
e_b=cell2mat(c(1,1));
e_w=cell2mat(c(2,1));
e_p=cell2mat(c(3,1));
e_z=cell2mat(c(4,1));
e_a=cell2mat(c(5,1));
e_g=cell2mat(c(6,1));
e_v=cell2mat(c(7,1));
e_s=cell2mat(c(8,1));
%%结果输出
xlswrite('smoothed_shocks.xls', e_b,'Sheet1','A1');
xlswrite('smoothed_shocks.xls', e_w,'Sheet1','B1');
xlswrite('smoothed_shocks.xls', e_p,'Sheet1','C1');
xlswrite('smoothed_shocks.xls', e_z,'Sheet1','D1');
xlswrite('smoothed_shocks.xls', e_a,'Sheet1','E1');
xlswrite('smoothed_shocks.xls', e_g,'Sheet1','F1');
xlswrite('smoothed_shocks.xls', e_v,'Sheet1','G1');
xlswrite('smoothed_shocks.xls', e_s,'Sheet1','H1');


%%MatlabIRF结果输出
xlswrite('irfresult.xls', y_e_b,'Sheet1','A1');
xlswrite('irfresult.xls', m_e_b,'Sheet1','B1');
xlswrite('irfresult.xls', c_e_b,'Sheet1','C1');
xlswrite('irfresult.xls', pi_e_b,'Sheet1','D1');
xlswrite('irfresult.xls', i_e_b,'Sheet1','E1');
xlswrite('irfresult.xls', w_e_b,'Sheet1','F1');
xlswrite('irfresult.xls', n_e_b,'Sheet1','G1');

xlswrite('irfresult.xls', y_e_z,'Sheet1','H1');
xlswrite('irfresult.xls', m_e_z,'Sheet1','I1');
xlswrite('irfresult.xls', c_e_z,'Sheet1','J1');
xlswrite('irfresult.xls', pi_e_z,'Sheet1','K1');
xlswrite('irfresult.xls', i_e_z,'Sheet1','L1');
xlswrite('irfresult.xls', w_e_z,'Sheet1','M1');
xlswrite('irfresult.xls', n_e_z,'Sheet1','N1');

xlswrite('irfresult.xls', y_e_g,'Sheet1','O1');
xlswrite('irfresult.xls', m_e_g,'Sheet1','P1');
xlswrite('irfresult.xls', c_e_g,'Sheet1','Q1');
xlswrite('irfresult.xls', pi_e_g,'Sheet1','R1');
xlswrite('irfresult.xls', i_e_g,'Sheet1','S1');
xlswrite('irfresult.xls', w_e_g,'Sheet1','T1');
xlswrite('irfresult.xls', n_e_g,'Sheet1','U1');

xlswrite('irfresult.xls', y_e_p,'Sheet1','V1');
xlswrite('irfresult.xls', m_e_p,'Sheet1','W1');
xlswrite('irfresult.xls', c_e_p,'Sheet1','X1');
xlswrite('irfresult.xls', pi_e_p,'Sheet1','Y1');
xlswrite('irfresult.xls', i_e_p,'Sheet1','Z1');
xlswrite('irfresult.xls', w_e_p,'Sheet1','AA1');
xlswrite('irfresult.xls', n_e_p,'Sheet1','AB1');

xlswrite('irfresult.xls', y_e_w,'Sheet1','AC1');
xlswrite('irfresult.xls', m_e_w,'Sheet1','AD1');
xlswrite('irfresult.xls', c_e_w,'Sheet1','AE1');
xlswrite('irfresult.xls', pi_e_w,'Sheet1','AF1');
xlswrite('irfresult.xls', i_e_w,'Sheet1','AG1');
xlswrite('irfresult.xls', w_e_w,'Sheet1','AH1');
xlswrite('irfresult.xls', n_e_w,'Sheet1','AI1');

xlswrite('irfresult.xls', y_e_a,'Sheet1','AJ1');
xlswrite('irfresult.xls', m_e_a,'Sheet1','AK1');
xlswrite('irfresult.xls', c_e_a,'Sheet1','AL1');
xlswrite('irfresult.xls', pi_e_a,'Sheet1','AM1');
xlswrite('irfresult.xls', i_e_a,'Sheet1','AN1');
xlswrite('irfresult.xls', w_e_a,'Sheet1','AO1');
xlswrite('irfresult.xls', n_e_a,'Sheet1','AP1');

xlswrite('irfresult.xls', y_e_s,'Sheet1','AQ1');
xlswrite('irfresult.xls', m_e_s,'Sheet1','AR1');
xlswrite('irfresult.xls', c_e_s,'Sheet1','AS1');
xlswrite('irfresult.xls', pi_e_s,'Sheet1','AT1');
xlswrite('irfresult.xls', i_e_s,'Sheet1','AU1');
xlswrite('irfresult.xls', w_e_s,'Sheet1','AV1');
xlswrite('irfresult.xls', n_e_s,'Sheet1','AW1');

xlswrite('irfresult.xls', y_e_v,'Sheet1','AX1');
xlswrite('irfresult.xls', m_e_v,'Sheet1','AY1');
xlswrite('irfresult.xls', c_e_v,'Sheet1','AZ1');
xlswrite('irfresult.xls', pi_e_v,'Sheet1','BA1');
xlswrite('irfresult.xls', i_e_v,'Sheet1','BB1');
xlswrite('irfresult.xls', w_e_v,'Sheet1','BC1');
xlswrite('irfresult.xls', n_e_v,'Sheet1','BD1');
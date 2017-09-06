function [score,weight]=entropy_method(data)
[id,indexnum]=size(data);
[mapdata,range_settings]=mapminmax(data');
range_settings.ymin=0.002; %调整归一化后的最小值
range_settings.ymax=0.996; %调整归一化后的最大值
range_settings.yrange=range_settings.ymax-range_settings.ymin; %调整归一化后的极差
data2=mapminmax(data',range_settings); %使用调整后的极差设定，重新对原数据进行归一化
normaldata=data2'; %归一化后的数据
%% 计算第j个指标下，第i个记录占该指标的比重p(i,j)
for i=1:id
    for j=1:indexnum
        p(i,j)=normaldata(i,j)/sum(normaldata(:,j));
    end
end
%% 计算第j个指标的熵值e(j)
k=1/log(id);
for j=1:indexnum
    e(j)=-k*sum(p(:,j).*log(p(:,j)));
end
d=ones(1,indexnum)-e;  % 计算信息熵冗余度
weight=d./sum(d);    % 求权值w
score=weight*p';         % 求综合得分
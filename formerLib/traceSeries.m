function [ traces ] = traceSeries( P )
%TRACESERIES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
l = size(P,3);
    tr= zeros(1,l);
    for j= 1: l;
       tr(j) = trace( P(:,:,j));
    end
traces =tr;
end


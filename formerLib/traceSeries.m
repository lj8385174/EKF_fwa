function [ traces ] = traceSeries( P )
%TRACESERIES 此处显示有关此函数的摘要
%   此处显示详细说明
l = size(P,3);
    tr= zeros(1,l);
    for j= 1: l;
       tr(j) = trace( P(:,:,j));
    end
traces =tr;
end


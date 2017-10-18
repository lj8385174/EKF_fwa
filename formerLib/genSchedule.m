function [ schedule ] = genSchedule(simulationCount,measureSet,mode)
%根据索引来生成一个测量规划，规划是指从measureSet中选择一个序列，
%并且这个序列要覆盖所有的元素，序列和集合构成双射
%mode  =   1：全排列的编号  2：所有可能（包括重复）编号
%TODO bookmark
if(nargin == 2)
   mode   = 1;
end
if(mode== 1)
    tempSet = measureSet;
    schedule = zeros(size(measureSet));
    index  =1 ;
    for i=size(measureSet,1):-1:1
        thisUnit = mod( simulationCount , i);
        simulationCount = (simulationCount-thisUnit)/i;
        schedule(index,:) =  tempSet(thisUnit+1,:);
        index  =  index +1;
        tempSet(thisUnit+1,:)=[]; 
    %     disp(thisUnit);
    end
else
    schedule = zeros(size(measureSet));
    for i = 1:size(measureSet,1)
        thisUnit  =  mod( simulationCount ,size(measureSet,1));
        simulationCount= (simulationCount-thisUnit)/size(measureSet,1);
        schedule(i,:) = measureSet(thisUnit+1,:);
    end
end
end
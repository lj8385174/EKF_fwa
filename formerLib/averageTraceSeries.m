function [ avgTraces ] = averageTraceSeries( traces )
%每个行向量为一组数据

avgTraces  = ones(size(traces));
avgTraces(:,1) = traces(:,1);
for i =  1:size(traces,1)
    for j = 2:size(traces,2)
       avgTraces(i,j) = mean(traces(i,1:j));
    end
end
end


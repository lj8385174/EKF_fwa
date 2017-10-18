function [result]  =  kalmanSimulationSeries (nodeMap,tempNodeMap,measureSet)
tempResult = struct('covariance',nodeMap.sigmaX,'schedule',[],'traceSeries',[]);
index   =  1;
for i  = 1: size(measureSet,1)
    schedule =   measureSet(i,:); 
    for j =  1:length(tempNodeMap) 
       NodeMap  =  nodeMap;
       NodeMap.sigmaX  =  tempNodeMap(j). covariance;
       result   =  kalmanSimulation(NodeMap,schedule,1);
       tempResult(index) =  struct('covariance',result.covariance(:,:,2),'schedule',[tempNodeMap(j).schedule;schedule],'traceSeries',[tempNodeMap(j).traceSeries,trace(result.covariance(:,:,2))]);
       index   = index +1;
    end
end
result  = tempResult;
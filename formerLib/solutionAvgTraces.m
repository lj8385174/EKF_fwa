%画出当前avgTraces 的变化图
% 
% temp =  solution;
% solution  = solutionOld;
if(~exist('simulationMode','var'))
%simulationMode  1: Permutation measurement Set
%                0: full posible for all steps 
simulationMode = 0;
end
resultCodes  = [];
% clc
disp('traceRecord is ');
disp(solution.traceRecord);
disp('each sub-optimal AvgtraceRecord  trace is ');
for i=2:length(solution.recordOwners)-simulationMode
	for j = 1: length(solution.recordOwners{i})
		if(ismember(solution.recordOwners{i}(j).stepCode,resultCodes))
			continue;
		else
			resultCodes=[resultCodes,solution.recordOwners{i}(j).stepCode];
		end
		disp(strcat(num2str(averageTraceSeries(traceSeries(solution.recordOwners{i}(j).covariance))),'(',num2str(solution.recordOwners{i}(j).stepCode),')'));
	end
	disp('');
end

%solution  =temp;
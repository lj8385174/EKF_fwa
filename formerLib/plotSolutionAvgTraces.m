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
figure(5);
holded  =  0;
for i=2:length(solution.recordOwners)-simulationMode
	for j = 1: length(solution.recordOwners{i})
		if(ismember(solution.recordOwners{i}(j).stepCode,resultCodes))
			continue;
		else
			resultCodes=[resultCodes,solution.recordOwners{i}(j).stepCode];
        end
        color = rand(1,3);
        tr = averageTraceSeries(traceSeries(solution.recordOwners{i}(j).covariance));
		
        plot(tr,'color',color,'Marker','+','Linewidth',2);
          if(holded ==0 )
            hold on 
        end
		plot(tr,'color',color); 
      
	end
	disp('');
end
hold off
%solution  =temp;
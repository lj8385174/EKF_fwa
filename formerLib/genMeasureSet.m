function [measureSet] =   genMeasureSet(nodeAmount,simulationStep,mode)
% mode   >0  : a total permutation set;
% mode   =0  : a random set with length of simulationStep;
% mode   <0  : a random, non-duplicated set with length of simulationStep;
if(nargin ==2 )
   mode = 0; 
end
measureSet1 = zeros(nchoosek(nodeAmount,2),2);
index = 1;
for i= 1:nodeAmount
    for j= 1:nodeAmount
       if(i <= j )
           continue;
       end
       measureSet1(index,:) =[i,j]; 
       index = index+1;
    end
end
if(mode ==0)
    measureSet = measureSet1(ceil(length(measureSet1)*rand(simulationStep,1)),:);
elseif(mode>0) 
    if(simulationStep>size(measureSet1,1))
        error('argument error');
    end
    measureSet  = zeros(simulationStep,2);
    for i = 1:simulationStep
        index  = ceil(size(measureSet1,1)*rand());
        if(index>size(measureSet1,1))
            i  =  i-1;
            continue; 
        end
        measureSet(i,:) = measureSet1(index,:);
        measureSet1(index,:)=[];
    end
else
    if(nchoosek(nodeAmount,2)<simulationStep)
        error('argument error');
    end
    measureSet  = zeros(simulationStep,2);
    for i = 1:simulationStep
        index  = ceil(size(measureSet1,1)*rand());
        if(index>size(measureSet1,1))
            i  =  i-1;
            continue; 
        elseif(index<=0 )
            i  =  i-1;
            continue
        end
        measureSet(i,:) = measureSet1(index,:);
        measureSet1(index,:)=[];
    end
end
for  i = 1: size(measureSet,1)
    if(measureSet(i,1)<measureSet(i,2))
        measureSet(i,:)=measureSet(i,2:-1:1);
    end
end
end
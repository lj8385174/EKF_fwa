function [ result ] = equalSchedule( sc1,sc2  )
%EQUALSCHEDULE determine whether the schedule is euqal
if(sum(sum(abs(sc1-sc2)<100000*eps))==length(sc1)*2)
    result  =1 ;
else 
    result  =0;
end

end


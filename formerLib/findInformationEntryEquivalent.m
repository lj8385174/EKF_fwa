
clear all
close all
clc
co = zeros(49,2);
for i =  2:10

codata  = zeros(1,30);

for j =  1:30
nodeAmount = i;

nodeMap = genNodeMap(nodeAmount);
% nodeMap.X  = [-5,1000,123,-100,0,0,0,2,124,0]';
nodeMap.X =20*rand(nodeAmount*2,1);
nodeMap.sigmaX=diag(200*abs(rand(nodeAmount*2,1)));
% nodeMap.sigmaX=20*abs(rand(nodeAmount*2));
nodeMap.sigmaD= 0.00001*ones(nodeAmount*2);
nodeMap.Q= 2;

%schedule =  [1,2;2,5;1,3;3,5];
schedule  = genMeasureSet(nodeAmount,nodeAmount*(nodeAmount-1)/2,1); 
schedule = [schedule;schedule;schedule;schedule;schedule];
schedule = [schedule;schedule;schedule;schedule;schedule;schedule;schedule];
% schedule = [schedule;schedule;schedule;schedule;schedule;schedule;schedule];
result = kalmanSimulation(nodeMap,schedule,1);

% P151s =reshape( result.covariance(1,9,:)+result.covariance(1,10,:),1,[]);
% P111s = reshape(result.covariance(9,9,:)+result.covariance(10,10,:),1,[]);
% plot(P151s./P111s);
% figure();
% plot([P151s;P111s]');
% 
% P11s= reshape( result.covariance(1,1,:),1,[]);
% figure();
% plot(P11s);


schedule =  ones(size(schedule));
result1 = kalmanSimulation(nodeMap,schedule,1);

% P11s= reshape( result1.covariance(1,1,:),1,[]);
% figure();
% plot(P11s);
% 
% figure();
% plot(traceSeries(result.covariance));
% 
% figure();
% plot(traceSeries(result1.covariance));

%  figure();
% plot(traceSeries(result1.covariance)./traceSeries(result.covariance));
% pause;
% % close  all
a=traceSeries(result1.covariance);
b= traceSeries(result.covariance);
codata(j)  = a(end)/b(end);
end
% co(i,1) = mean( codata );
% co(i,2) = std( codata );
co(i,:) = [mean( codata ), std( codata )];
disp(i);
end
plot(co);
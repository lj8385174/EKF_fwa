%xѰ�Ҵ���λ����Ϣ��������·��
clear all
close all
clc
co = zeros(1,2);
for i = 4:4

codata  = zeros(1,1);

for j =  1:1
nodeAmount = i;

nodeMap = genNodeMap(nodeAmount);
% nodeMap.X  = [-5,1000,123,-100,0,0,0,2,124,0]';
% nodeMap.X  = [1000,0,-1000,323,-2000,0,-3000,1024]';
nodeMap.X =3000*rand(nodeAmount*2,1);
% nodeMap.sigmaX=diag(1*abs(rand(nodeAmount*2,1)));
a=rand(nodeAmount*2,1);
nodeMap.sigmaX = a*a';
nodeMap.sigmaD= 100*ones(nodeAmount*2);
nodeMap.Q= 2;

%schedule =  [1,2;2,5;1,3;3,5];
schedule  = genMeasureSet(nodeAmount,nodeAmount*(nodeAmount-1)/2,1); 
schedule = [schedule;schedule;schedule;schedule;schedule;schedule;schedule];
schedule = [schedule;schedule;schedule;schedule;schedule;schedule;schedule];
schedule = [schedule;schedule;schedule;schedule;schedule;schedule;schedule];
schedule = [schedule;schedule;schedule];
schedule = [schedule;schedule;schedule];
 le  = nodeAmount*(nodeAmount-1)/2;
% le=0;
result = kalmanSimulation(nodeMap,schedule,1,le);

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
result1 = kalmanSimulation(nodeMap,schedule,1,le);

% P11s= reshape( result1.covariance(1,1,:),1,[]);
% figure();
% plot(P11s);
% 
% figure();
% plot(traceSeries(result.covariance));

figure();
plot([traceSeries(result1.covariance);traceSeries(result.covariance)]');
if(j==1)
 figure();
% plot(traceSeries(result1.covariance(1:2:end,1:2:end,:))./traceSeries(result.covariance(1:2:end,1:2:end,:)));
plot(traceSeries(result1.covariance)./traceSeries(result.covariance));
end
% pause;
% close  all
a=traceSeries(result1.covariance);
b= traceSeries(result.covariance);
codata(j)  = a(end)/b(end);
end
% co(i,1) = mean( codata );
% co(i,2) = std( codata );
co(i-2,:) = [mean( codata ), std( codata )];
% disp(i);
end
 figure();
plot(nodeMap.X(1:2:end),nodeMap.X(2:2:end),'+');
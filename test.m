rng(33);
dT = 0.3;
ts = 0:dT:1000;

flightNum =1;
Xs = cell(flightNum,1);
measurements = cell(flightNum,1);
truevalues = cell(flightNum,1);
for i = 1: flightNum
    [X0,para1,dT]=genparas([0,0,2]);
    [Xstmp,mtmp,tvtmp]=genTrueStates(X0,ts,para1);
    Xs{i} = Xstmp;
    measurements{i}=mtmp;
    truevalues{i}=tvtmp;
end

% close all 
% x1 = Xs{1};
% figure(1);
% plot(x1(5:7,:)');
% figure(2)
% truevalue1 =truevalues{1};
% plot(truevalue1.accs');
% figure(3);plot(x1(8:10,:)');
% figure(7);plot(x1(5:7,:)');
% figure(4);plot(truevalue1.omegas');
% figure(5);plot(truevalue1.thetas');
% figure(6);plot(truevalue1.gps');
% figure(8);plot(truevalue1.pit');
% figure(9);plot(truevalue1.mag');
% figure(10);plot(truevalue1.baro');
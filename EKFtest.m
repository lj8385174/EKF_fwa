% do EKF experiment
clear all 
rng(33);
dT = 0.3;
ts = 0:dT:2000;

flightNum =1;
Xs = cell(flightNum,1);
measurements = cell(flightNum,1);
truevalues = cell(flightNum,1);
paragroup  = cell(flightNum,1);
for i = 1: flightNum
    [X0,para1,dT]=genparas([0,0,2]);
    [Xstmp,mtmp,tvtmp]=genTrueStates(X0,ts,para1);
    Xs{i} = Xstmp;
    measurements{i}=mtmp;
    truevalues{i}=tvtmp;
    paragroup{i} = para1;
end

% initial state 
Xest  = cell(flightNum,1);
Pest  = cell(flightNum,1);
sizex = size(Xs{1});
for i = 1 : flightNum
    Xest{i} = zeros(sizex);
    Xest{i}(:,1) = Xs{i}(:,1)+  paragroup{i}.P0^0.5*randn(22,1);
    Pest{i} = zeros(sizex(1),sizex(1),length(ts));
    Pest{i}(:,:,1) = paragroup{i}.P0;
end

% kalman filter
for tindex  = 2 : length(ts)
    for i = 1 : flightNum
        Mn =  [measurements{i}.gps(:,tindex);measurements{i}.baro(:,tindex);measurements{i}.mag(:,tindex);measurements{i}.pit(:,tindex)];
        Qn = paragroup{i}.Q;
        Rn = paragroup{i}.R;
        dtheta = measurements{i}.omegas(:,tindex-1)*dT;
        % dtheta =truevalues{i}.omegas(:,tindex-1)*dT; 
        Vkb  = measurements{i}.accs(:,tindex-1)*dT;
        % Vkb    =  truevalues{i}.accs(:,tindex-1)*dT;
        [Xest{i}(:,tindex),Pest{i}(:,:,tindex)]=EKF(Xest{i}(:,tindex-1),Pest{i}(:,:,tindex-1),Mn,Qn,Rn,dtheta,Vkb,dT,true);
    end
end
save('EKFTest_noMea.mat');
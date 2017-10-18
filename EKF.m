function [Xn,Pn] = EKF(Xl,Pl,Mn,Qn,Rn,dthetal,Vkb,dT,needMeasure)
% EKF without uwb measurment
% Xl : state vector at last epoch
% Pl : covaraince matrix at last epoch 
% Mn : measurements at present. note that all possible measurement emerges a each iteration. The order is gps, baro, mag, tube.
% Qn : state transformation noise covariance
% Rn : measurements noise covariance
% dthetal: incremental theta in the
% Vkb: incremental velocity  
% dT : sample time
if nargin == 8
    needMeasure =true;
end

Fn  = transMatrix(Xl,dthetal,Vkb,dT);
Gn  = noiseTransMatrix(Xl,dT);
% state updating is not necessay to use linearized matrix
Xnprime = stateTrans(Xl,dthetal,Vkb,dT);
Pnprime = Fn*Pl*Fn'+Gn*Qn*Gn';

if needMeasure == true
    Hn = [Hgps();Hpre();Hmag(Xnprime);Htube(Xnprime)];

    Kn = Pnprime*Hn'*(Hn*Pnprime*Hn'+Rn)^(-1);
    v  = Mn  - Hn*Xnprime;
    KHn = Kn*Hn;

    Pn = (eye(size(KHn))-KHn)*Pnprime;
    Xn = Xnprime + Kn*v;
else 
    Pn = Pnprime;
    Xn = Xnprime;
end
% re normalize the quaternion
% the covariance needs to scaled correspondly
Xn(1:4) = Xn(1:4)/ sqrt(sum(Xn(1:4).^2));

Pn(1:4,:) = Pn(1:4,:)/sqrt(sum(Xn(1:4).^2));
Pn(:,1:4) = Pn(:,1:4)/sqrt(sum(Xn(1:4).^2));
function [Xn]  = stateTrans(Xl,theta,Vkb,dT)

% statetransation 
Dab = Xl(11:13);
theta_true = theta - Dab;
Xn = zeros(22,1);
if(norm(theta_true)>eps)
    deltaQ = [cos(norm(theta_true)/2);theta_true/norm(theta_true)*sin(norm(theta_true)/2)]';
else 
    deltaQ = [1,0,0,0];
end
tempQ = quatmultiply(Xl(1:4)',deltaQ);
Xn(1:4) = tempQ';
dVzb = Xl(14);
Qs = Xl(1:4);
cbntemp =cbn(Qs);
trueDeltaV = Vkb- [0;0;dVzb];
Xn(5:7) = Xl(5:7) + cbntemp* trueDeltaV;
Xn(8:10) =  Xl(8:10)+ Xn(5:7)*dT;
Xn(11:22) = Xl(11:22);
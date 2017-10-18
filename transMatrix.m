function [F] = transMatrix(X,theta,Vkb,dT)
% transformation matrix generator
% linearized 
% X: the last state vector.
% theta: incremental angle (\delta theta_{k_b}) without offset canceling 
% Vkb: incremental velocity (\delta V_{k_b}) without offset canceling 
% dT: sample time
F  = zeros(22);

%F1 
F1 = zeros(4);
Dab = X(11:13);
theta_true = theta - Dab;
F1(1:4,1) = [1;theta_true(1)/2;theta_true(2)/2;theta_true(3)/2];
F1(1:4,2) = [-theta_true(1)/2;1;-theta_true(3)/2;theta_true(2)/2];
F1(1:4,3) = [-theta_true(2)/2;theta_true(3)/2;1;-theta_true(1)/2];
F1(1:4,4) = [-theta_true(3)/2;-theta_true(2)/2;theta_true(1)/2;1];

F(1:4,1:4) = F1;
%F2 
F2 = zeros(4,3);
q  = X(1:4);
F2(:,1) =1/2*[q(2),-q(1),-q(4),q(3)]'; 
F2(:,2) =1/2*[q(3),q(4),-q(1),-q(2)]'; 
F2(:,3) =1/2*[q(4),-q(3),q(2),-q(1)]'; 
F(1:4,11:13) = F2;

%F3
F3 = zeros(3,4);
dVzb = X(14);
F3(:,1) = 2*[q(1),-q(4),q(3);q(4),q(1),-q(2);-q(3),q(2),q(1)]*[Vkb(1),Vkb(2),Vkb(3)-dVzb]';
F3(:,2) = 2*[q(2),q(3),q(4);q(3),-q(2),-q(1);q(4),q(1),-q(2)]*[Vkb(1),Vkb(2),Vkb(3)-dVzb]';
F3(:,3) = 2*[-q(3),q(2),q(1);q(2),q(3),q(4);-q(1),q(4),-q(3)]*[Vkb(1),Vkb(2),Vkb(3)-dVzb]';
F3(:,4) = 2*[-q(4),-q(1),q(2);q(1),-q(4),q(3);q(2),q(3),q(4)]*[Vkb(1),Vkb(2),Vkb(3)-dVzb]';

F(5:7,1:4) = F3;

%F4
F4 = zeros(3,1);
F4 = -[2*(q(2)*q(4)+q(1)*q(3)),2*(q(3)*q(4)-q(1)*q(2)),q(1)^2-q(2)^2-q(3)^2+q(4)^2]';
F(5:7,14)  = F4;

F(5:7,5:7)     = eye(3);
F(8:10,5:7)    = eye(3)*dT;
F(8:10,8:10)   = eye(3);
F(11:13,11:13) = eye(3);
F(14,14)       = eye(1);
F(15:16,15:16) = eye(2);
F(17:19,17:19) = eye(3);
F(20:22,20:22) = eye(3);
function [G] = noiseTransMatrix(X,dT)
% noise transformation matrix generator
% linearized 
% X: the last state vector.
% theta: incremental angle (\delta theta_{k_b}) 
% Vkb: incremental velocity (\delta V_{k_b}) 
% dT: sample time
% warning, some 
q  = X(1:4);
G  = zeros(22,18);
G(1:4,1:3)=dT/2*[-q(2),-q(3),-q(4);q(1),-q(4),q(3);q(4),q(1),-q(2);-q(3),q(2),q(1)];
G(5:7,4:6)=dT*[q(1)^2+q(2)^2-q(3)^2-q(4)^2,2*(q(2)*q(3)-q(1)*q(4)),2*(q(2)*q(4)+q(1)*q(3));2*(q(2)*q(3)+q(1)*q(4)),q(1)^2-q(2)^2+q(3)^2-q(4)^2,2*(q(3)*q(4)-q(1)*q(2));2*(q(2)*q(4)-q(1)*q(3)),2*(q(3)*q(4)+q(1)*q(2)),q(1)^2-q(2)^2-q(3)^2+q(4)^2];
G(11:22,7:18) =dT* eye(12); % TODO by this time, I don't think  dT is a right choice, maybe it should be just sqrt(dT).

% G(8:10,7:9) = zeros(3);
% G(11:13,10:12) = eye(3);
% G(14,13) = eye(1);
% G(15:16,14:15) = eye(2);
% G(15:16,14:15) = eye(2);
% G(17:19,16:18) = eye(2);
% G(20:22,19:21) = eye(2);

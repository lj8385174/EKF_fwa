function [H] = Hpre()
% measurement matrix of pressure 
H = zeros(1,22);
H(:,10) =  1;

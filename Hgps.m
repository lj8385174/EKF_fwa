function [H] = Hgps()
% measurement matrix of gps 
H = zeros(5,22);
H(:,5:9) =  eye(5);

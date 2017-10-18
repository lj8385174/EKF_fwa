function [R] = rotationMatrix(theta,phi)

% generate rotation matrix, see 

narginchk(1, 2);
if nargin == 1
    dim = 2;
else 
    error('Not support yet');
    dim = 3 ;
end

if dim == 2
    R  = [cos(theta),sin(theta);-sin(theta),cos(theta)];
end

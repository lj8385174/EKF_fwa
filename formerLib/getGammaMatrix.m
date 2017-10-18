function [ Gamma ] = getGammaMatrix( nodeMap, position )
%GETGAMMAMATRIX get Gamma Matrix  in the paper

%@TODO IT DOESN'T SUPPORT 3D CASE!
%@TODO IT DOESN'T CONTAIN Delta Time!
nodeAmount          =       nodeMap.nodeAmount;

M =  cell(1,nodeAmount);

for     i           =       1:2:nodeAmount*2 
    HfPrime         =       [];
    X = nodeMap.X(i:i+1);
    d = sqrt(sum((X-position).^2)); %compute the distance
    HfPrime         =      ((X-position)/d)';
    M{floor(i/2)+1}   =    HfPrime;
end
Gamma=blkdiag(M{:});
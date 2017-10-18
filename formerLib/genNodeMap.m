function [ nodeMap ] = genNodeMap( nodeAmount,X,sigmaX,sigmaD,Q)
%GENNODEMAP generate node map with known condition. 

if(nargin == 1)
   X = 20*nodeAmount *  rand(nodeAmount*2,1);
   sigmaX=generateCovariance(10*rand(nodeAmount*2,1));
   sigmaD = 0.5* ones(nodeAmount,nodeAmount);
   Q   =  0;
end
nodeMap =  struct('X',X,'sigmaX',sigmaX,'sigmaD',sigmaD,'nodeAmount',nodeAmount,'Q',Q);
end


function [ nodeMap ] = genNodeMap1( nodeAmount,X,sigmaX,sigmaD)
%GENNODEMAP generate node map with known condition. 
% compare to genNodeMap :  larger  sigmaX

if(nargin == 1)
   X = 200*nodeAmount *  rand(nodeAmount*2,1);
   sigmaX=generateCovariance(200*rand(nodeAmount*2,1));
   sigmaD = 2* ones(nodeAmount,nodeAmount);
end
nodeMap =  struct('X',X,'sigmaX',sigmaX,'sigmaD',sigmaD,'nodeAmount',nodeAmount);
end
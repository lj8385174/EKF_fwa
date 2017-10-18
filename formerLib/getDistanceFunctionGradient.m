function [ Hf ] = getDistanceFunctionGradient( nodeMap,position )
%GETDISTANCEFUNCTIONGRADIENT get the gradient matrix of the specified
%nodeMap
%some equation can be found on the book
%@TODO I haven't give the clock diiference column
% position should match the dimension
if(size(nodeMap.X,1)/nodeMap.nodeAmount  ~= length(position))
   exit('dimonsion error'); 
end
dim  = length(position);
Hf = zeros(nodeMap.nodeAmount,length(position));
for i = 1:nodeMap.nodeAmount
    X = nodeMap.X((dim*(i-1)+1):(dim*i));
    d = sqrt(sum((X-position).^2)); %compute the distance
    for j = 1:dim
       Hf(i,j) = -(X(j)-position(j))/d;
    end
end

end


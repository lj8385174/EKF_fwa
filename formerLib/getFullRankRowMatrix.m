function [ result ] = getFullRankRowMatrix( H )
%GETFULLRANKROWMATRIX get the minimum row matrix with equal rank to
%original one .
result  =  H(1,:);
for i = 2:size(H,1)
   tempResult  = [result; H(i,:)];
   if(rank(tempResult)~= rank(result))
       result = tempResult;
   end
end
end


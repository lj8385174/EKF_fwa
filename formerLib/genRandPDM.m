function [ result ] = genRandPDM(dim)
%GENPDM generate uniform distributed Positive Definite Matrix
% dim  is the dimonsion 

while(1)
m  =  rand(dim);
if (rank(m)==dim)
	break;
end
end

result = m*m';
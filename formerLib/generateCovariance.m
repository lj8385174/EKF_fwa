function [Cov]  = generateCovariance(eigs)

% generate a random covariance matrix with given eigs;

% input: eigs will be a vector


if nargin ==0 
    error('need input');
elseif(sum(eigs<0)>0)
    error('eigs should be non-negative');
end 

len     =   length(eigs);

a       =   orth(rand(len));

Cov     =   a*diag(eigs)*a';


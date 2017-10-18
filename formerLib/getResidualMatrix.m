function [ kerQ ] = getResidualMatrix( Q, H  )
%GETRESIDUALMATRIX get the residual of matrix Q  to H 
%row direction 
%H must be full row rank
coefficient  =  ((H*H')^(-1)*H*Q')';
linQ   =  coefficient*H;
kerQ  = Q -linQ;
end


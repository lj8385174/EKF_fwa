function [H] = Htube(X)
% measurement matrix of pressure 
H = zeros(1,22);

Vn = X(5);
Ve = X(6);
Vd = X(7);
wn = X(15);
we = X(16);

dem = norm([Vn,Ve,Vd]-[wn,we,0]);

H(1,5) = 2*(Vn-wn)/dem;
H(1,6) = 2*(Ve-we)/dem;
H(1,7) = 2*(Vd)/dem;

H(1,15) = -2*(Vn-wn)/dem;
H(1,16) = -2*(Ve-we)/dem;
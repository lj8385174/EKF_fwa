function [series]  = randIndices(n,len)
% generate random indices series of length len
% n is the amount can be chosen.
% each index should be different from any others

if(n<len)
    error('argument error: n should not less than len');
end
series  =  zeros(1,len);

index   = 1;
series(index)   =  ceil(rand()*n);
index   =  index  +1;
while(index<=len)
    temp        =  ceil(rand()*n);
    if(sum(series==temp)>0)
        continue;
    else
        series(index) =  temp;
        index      =  index +1;
    end
end
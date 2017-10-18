function [res] = numint(input,dim)
% numerical integral
if nargin == 1
    dim =1 ; % along row, i.  e row is time line  
end
res = zeros(size(input));
if dim == 1
    for i = 2: size(input,1)
        res(i,:) =  res(i-1,:)+input(i-1,:);
    end
else
    assert(dim==2);
    for i = 2: size(input,2)
        res(:,i) =  res(:,i-1)+input(:,i-1);
    end
end
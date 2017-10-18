function [Dab] = genBias(ts,SigmaBias)
% generate true states of bias
Dab = zeros(3,length(ts));
assert(ts(1)==0);
noises = SigmaBias * randn(3,length(ts)-1);
for i = 2: length(ts)
    Dab(:,i) =  Dab(:,i-1)+noises(:,i-1);
end
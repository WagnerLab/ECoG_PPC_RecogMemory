function [p,z]=signtest2(X)
% [p,z]=signtest2(X,Y)
% extension of signtest2 for matrices

nTest   = size(X,2);
p       = zeros(1,nTest);
z       = zeros(1,nTest);

for t = 1:nTest
    [p(t),~,s]  = signtest(X(:,t),[],'method','approximate');
    z(t)        = s.zval;
end

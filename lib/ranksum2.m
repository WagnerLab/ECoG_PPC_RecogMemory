function [p,z]=ranksum2(X,Y)
% [p,z]=ranksum2(X,Y)
% extension of ranksum for matrices
% X and Y must have the same number of columns (independent tests)
% may have different number of rows (observations)


nTest = size(X,2);
if nTest~=size(Y,2); error('matrices have different # of columns');end
p = zeros(1,nTest);
z = zeros(1,nTest);

for t = 1:nTest
    [p(t),~,s] = ranksum(X(:,t),Y(:,t));
    try
        z(t) = s.zval;
    catch
        keyboard
    end
end


% ranksums is in reference to the smallest sample
n1 = size(X,1);
n2 = size(Y,1);
if n1>n2;
    z = z*-1;
end
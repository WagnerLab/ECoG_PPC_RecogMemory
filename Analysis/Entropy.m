function H = Entropy(P)
% P is a pmf by row: sum(P,2)==1
% returns entropy

n = size(P,2);
N = size(P,1);

H = zeros(N,1);

for ii = 1:N
    p = P(ii,:);
    for jj = 1:n
        H(ii) = H(ii) - p(jj)*log2(p(jj));
    end
end

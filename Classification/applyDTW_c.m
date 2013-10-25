
function out = applyDTW_c(x,Y,w)
% applies dtw_c for x against every row of y using argument w, returns the
% loss vector out of with the same number of rows as Y

out = zeros(size(Y,1),1);

parfor ii = 1:size(Y,1)
    out(ii) = dtw_c(x,Y(ii,:),w);   
end
return






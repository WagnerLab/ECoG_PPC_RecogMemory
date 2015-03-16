function [strc] = calc_RTstats(data,strc)
% calculates summary statistcs
% mean, std, median

if min(size(data))>1
    error('Input isnot a vector');
end

strc.RTnum = numel(data);
strc.RTmean = mean(data);
strc.RTstd = std(data);
strc.RTmedian = median(data);


return 

end
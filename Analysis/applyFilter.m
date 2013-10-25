function data = applyFilter(filter,data)
% data = applyFilter(filter,data)
% applies filter every row of data

N = size(data,1);

parfor n = 1:N    
    data(n,:) = filtfilt(filter,1,data(n,:));
end

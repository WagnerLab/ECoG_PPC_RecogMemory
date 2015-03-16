%adjustment for new photodiode problem:
addpath(genpath('/biac4/wagner/biac3/wagner7/ecog/scripts/'))
%%
blocknum = blocklist{2};
basepath = [par.basepath '/RawData/' blocknum '/Pdio' blocknum '_02.mat'];
load(basepath)
%%

% load(['/biac4/wagner/biac3/wagner7/ecog/subj16b/ecog/SS2/RawData/SRb-' ...
%     num2str(blocknum) '/PdioSRb-' num2str(blocknum) '_02_orig.mat'])
%%
anlg2 = abs(anlg) + [0 abs(anlg(1:end-1))] + [abs(anlg(2:end)) 0];
anlg3 = repmat(5, 1, length(anlg));

pdiorate= 24414.1; 


i = find(anlg2<1);
anlg3(i) = 0;

clear anlg2
%%
% pad = 10;%floor(pdiorate/2);
% for i = pad+1:length(anlg3)-pad
%     if ~isempty(find(anlg3(i+1:i+pad))) ||~isempty(find(anlg3(i-pad:i))) 
%         anlg3(i) = 5; 
%     end
% end
% time = (1/pdiorate):(1/pdiorate):(length(anlg3)*(1/pdiorate));
% figure,plot(time,anlg3)

%%
% anlg = anlg3;
% save (['/biac4/wagner/biac3/wagner7/ecog/subj16b/ecog/SS2/RawData/SRb-' ...
%     num2str(blocknum) '/PdioSRb-' num2str(blocknum) '_02.mat'],'anlg')

%%
pad = 750;
anlg4 = abs(anlg) + [zeros(1,floor(pdiorate/pad)) abs(anlg(1:end-floor(pdiorate/pad)))] + ...
    [abs(anlg(floor(pdiorate/pad)+1:end)) zeros(1,floor(pdiorate/pad))];
time = (1/pdiorate):(1/pdiorate):(length(anlg)*(1/pdiorate));

figure;plot(time,anlg4,'bo-')
hold on
anlg5 = zeros(1,length(anlg4));
i = find(anlg4>4);
anlg5(i) = 5;
plot(time,anlg,'c')

plot(time,anlg5,'r-','LineWidth',2)
hold off
figure; plot(time, anlg5)

%%
anlg = anlg5;
save (basepath,'anlg')


function printStats(data,opts,type,center)
% main statistics from time courses

ROIs        = {'IPS','SPL','AG'};
type        = 'BinZStat';
center      = 0;

% number of tests
mMain           = 1;
mInter          = 1*3;
MAIN_alpha      = 0.05/mMain;
INTER_alpha     = 0.05/mInter;

% time bins of interest
BOT         = find((data.Bins(:,1) >= opts.time(1)) & (data.Bins(:,2) <= opts.time(2)));

hemChans        = [data.hemChanId==1 data.hemChanId==2];
hemROIChans     = cell(2,3);
for ii=1:2;
    for jj=1:3
        hemROIChans{ii,jj}   = data.ROIid.*hemChans(:,ii) == jj;
    end
end

SubjROIChans      = cell(3,8);
for ii = 1:3
    for jj=1:8;
        SubjROIChans{ii,jj} = data.ROIid.*(data.subjChans(:)==jj) == ii;
    end
end

time = data.Bins(BOT,:);

%% main

hems = {'Lefts', 'Rights'};
for kk = 1:2
    display(hems{kk})
    ChanMat = cell(3,1);
    % main across channels effects
    for ii = 1:3
        display([ROIs{ii} ' t test results'])
        ChanMat{ii} = data.(type)(hemROIChans{kk,ii},BOT);
        ttestPrint(ChanMat{ii},MAIN_alpha,time,center)
    end
    % roi interactions
    for ii = 1:2
        for jj = ii+1:3
            display([ROIs{ii} '-' ROIs{jj} ' 2 sample t test results'])
            ttest2Print(ChanMat{ii},ChanMat{jj},INTER_alpha,time)
        end
    end
end

fprintf('\n\n')
% across subjects
SubjMat = cell(3);
for ii = 1:3
    for jj = 1:7
        SubjMat{ii}(jj,:) = mean(data.(type)(SubjROIChans{ii,jj},BOT));
    end
end
hemSet{1} = 1:4;
hemSet{2} = 5:7;
for kk=1:2
    display([hems{kk} ' accross subjects'])
    for ii=1:3
        display([ROIs{ii} ' t test results'])
        ttestPrint(SubjMat{ii}(hemSet{kk},:),MAIN_alpha,time,center)
    end
end
%% sub functions

function ttestPrint(Y,alpha,time,center)

XX = mean(Y,2);
[~,p,~,stat]=ttest(XX,center,alpha);
display('Main Effect')
fprintf('T = %g, P = %g \n',stat.tstat,p);

[h,~,~,stat]=ttest(Y,0,alpha);

if sum(h)>0
    X = cell(sum(h)+1,3);
    X{1,1} = 'T Stat'; X{1,2} = 'T1'; X{1,3} = 'T2';
    X(2:end,1) = num2cell(stat.tstat(h==1)');
    X(2:end,2) = num2cell(time(h==1,1));
    X(2:end,3) = num2cell(time(h==1,2));
    display(X);
else
    display('no significant results')
end


function ttest2Print(Y1,Y2,alpha,time)
[h,~,~,stat]=ttest2(Y1,Y2,alpha);
if sum(h)>0
    X = cell(sum(h)+1,3);
    X{1,1} = 'T Stat'; X{1,2} = 'T1'; X{1,3} = 'T2';
    X(2:end,1) = num2cell(stat.tstat(h==1)');
    X(2:end,2) = num2cell(time(h==1,1));
    X(2:end,3) = num2cell(time(h==1,2));
    display(X);
else
    display('no significant results')
end
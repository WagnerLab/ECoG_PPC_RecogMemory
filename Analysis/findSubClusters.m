close all

sig1 = std(out.nDC(out.index==1,1));
sig2 = std(out.nDC(out.index==2,2));
thr  = mean([sig1 sig2]);

cLcol=[];
cLcol(1,:)=[0.6  0.65 0.1];
cLcol(2,:)=[0.1  0.65 0.6];
cLcol(3,:)=[0.6  0.1 0.6];

IPSch = (data.hemChanId==1).*data.ROIid==1;
SPLch = (data.hemChanId==1).*data.ROIid==2;

chans = find(IPSch|SPLch);

CLChans{1}= find(out.CDB(:,1)>=thr);
CLChans{2}= find(out.CDB(:,2)>=thr);
CLChans{3}= find(abs(out.CDB(:,1))<thr);

X = cell(3,1);
X{1}=data.ZStat(chans(CLChans{1}),:);
X{2}=data.ZStat(chans(CLChans{2}),:);
X{3}=data.ZStat(chans(CLChans{3}),:);

figure; clf;
plotNTraces(X,data.trialTime,'ylm','loess',0.15)


cortex = data.lMNIcortex;
chanLocs = data.MNILocs(chans,:);

f2 = figure(2); clf;
set(f2,'Position',[200 200 800 800]);
tight_subplot(1,1,0.001,0.001,0.001);
ctmr_gauss_plot(gca,cortex,[0 0 0],0,'l');

el_add(chanLocs,[0 0 0],25);

for jj = 1:3
    el_color    = cLcol(jj,:);
    for i = 1:numel(CLChans{jj})
        el_add(chanLocs(CLChans{jj}(i),:),el_color,20);
    end
end

loc_view(310,30)

%%
clc
n=hist(data.subjChans(chans(CLChans{1})),4)
n=hist(data.subjChans(chans(CLChans{2})),4)
n=hist(data.subjChans(chans(CLChans{3})),4)
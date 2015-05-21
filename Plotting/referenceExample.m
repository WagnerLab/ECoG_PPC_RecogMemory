% figure to illustrate the


load('/Users/alexg8/Documents/ECOG/Results/ERP_Data/subj16b/ERPsstimLocksubAmpLowPass30origCAR027-May-2013.mat')
%

f(1) = figure(1); clf;
figW = 1000;
figH = 400;
set(gcf,'position',[-1000 200,figW,figH],'PaperPositionMode','auto','color','w')

a1=axes('position',[0.1 0.1 0.38 0.8]);
a2=axes('position',[0.55 0.1 0.38 0.8]);

%
[v,i]=sort(data.chanTotalTstat);
chans = i(ismember(i,data.chanInfo.other));
scores = round(v(ismember(i,data.chanInfo.other)));

X = [];
X{1} = squeeze(data.erp(chans(3),data.Hits,:));
X{2} = squeeze(data.erp(chans(3),data.CRs,:));
s = scores(3);
%X{2} = squeeze(data.erp(chans(end),:,:));

t=data.trialTime;
axes(a1)
yRefLims = [-15 23];
h=plotNTraces(X,t,'oc','loess',0.15,'mean',yRefLims);
yy=get(gca,'children');
set(yy(9),'YData',yRefLims*0.4,'color',0.3*ones(3,1))
set(yy(10),'color',0.3*ones(3,1))
set(gca,'ytick',[-10 0 10 20]);set(gca,'yticklabel',[-10 0 10 20])
set(gca,'fontsize',14)
set(gca,'xtick',[0 0.4 0.8],'xtickLabel', {'stim',0.4,0.8})
ylabel(' \muV ')
title(' Selected Ref. Chan' )
text(0.6,17,sprintf('score = %1g',s),'fontsize',14)

%
axes(a2)
X = [];
X{1} = squeeze(data.erp(chans(end-2),data.Hits,:));
X{2} = squeeze(data.erp(chans(end-2),data.CRs,:));
s = scores(end-2);

yRefLims = [-40 70];
h=plotNTraces(X,t,'oc','loess',0.15,'mean',yRefLims);
yy=get(gca,'children');
set(yy(9),'YData',yRefLims*0.4,'color',0.3*ones(3,1))
set(yy(10),'color',0.3*ones(3,1))
set(gca,'ytick',[-30 0 30 60]);set(gca,'yticklabel',[-30 0 30 60])
set(gca,'fontsize',14)
set(gca,'xtick',[0 0.4 0.8],'xtickLabel', {'stim',0.4,0.8})
text(0.6,45,sprintf('score = %2g',s),'fontsize',14)
title(' Chan not selected ' )

xx=legend([h.h1.mainLine,h.h2.mainLine],'hits','CRs');
set(xx,'box','off','location','best')
                
inkscapePath='/Applications/Inkscape.app/Contents/Resources/bin/inkscape';
SupPlotPath = ['~/Google ','Drive/Research/ECoG ','Manuscript/ECoG ', 'Manuscript Figures/supplement/'];

cPath = pwd;
cd(SupPlotPath)
addpath(cPath)
addpath([cPath '/Plotting/'])

filename = 'Re-referenceExampleL1';
plot2svg([filename '.svg'],gcf)
eval(['!' inkscapePath ' -z ' filename '.svg --export-pdf=' filename '.pdf'])
eval(['! rm ' filename '.svg'])
cd(cPath)
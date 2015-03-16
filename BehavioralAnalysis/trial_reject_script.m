



clear all
close all

load('/biac4/wagner/biac3/wagner7/ecog/subj17b/ecog/SS2/data_for_classification/allBandStruct_binsize50.mat')
load('/biac4/wagner/biac3/wagner7/ecog/subj17b/ecog/SS2/BehavData/behav_perf.mat')

%%
ch = 1;
bins = 1:80;
band = 1;

X = squeeze(S.bin_trials(band,ch,:,bins));

mx = mean(X(:));
sdx = std(X(:));

XZ = (X-mx)/sdx;

trial_covar_mat = cov(XZ');

mean_trial_covar = mean(trial_covar_mat);
lower_var_bound = 2*(mean(mean_trial_covar)-std(mean_trial_covar));
high_var_bound = 2*(mean(mean_trial_covar)+std(mean_trial_covar));

% good trials
gt = (mean_trial_covar < high_var_bound & mean_trial_covar > lower_var_bound); 


%%

tic;
band = 1;
rois = subject_rois_v2('17b');
channels = rois.LPC;
thre = 2;

X = squeeze(S.bin_trials(band,channels,:,:));
[nch ntr nbins]=size(X);

XZ = zscore(X(:,:),[],2);
XZ = reshape(XZ,[nch ntr nbins]);
% collapse across channels
X = permute(XZ,[2 1 3]);
trial_covar_mat = cov(X(:,:)');

trial_var = diag(trial_covar_mat);
%lower_var_bound = thre*(mean(mean_trial_covar)-std(mean_trial_covar));
high_var_bound = mean(trial_var)+thre*std(trial_var);

% good trials
gt2 = (trial_var < high_var_bound);
toc
sum(gt2)


%%
band = 1;
rois = subject_rois_v2('17b');
channels = rois.LPC;
thr = 2;

X = squeeze(S.bin_trials(band,channels,:,:));
[nch ntr nbins]=size(X);

XZ = zscore(X(:,:),[],2);
XZ = reshape(XZ,[nch ntr nbins]);
% collapse across channels
X = permute(XZ,[2 1 3]);


% mean trial
mt = squeeze(mean(X(:,:),1));

% correlation of each trial to the mean trial
mtc = corr(mt',squeeze(X(:,:))');

lower_corr_bound = mean(mtc)-thr*std(mtc);
%high_var_bound = mean(trial_var)+thre*std(trial_var);

% good trials
gt = (mtc > lower_corr_bound);
gt = gt(:);


%%
h = behav_perf.hits & gt;
cr = behav_perf.cr & gt;
ch = 65;

XZh = squeeze(XZ(channels==ch,h,:));
XZcr = squeeze(XZ(channels==ch,cr,:));
mh = mean(XZh);
sdh = std(XZh);
nh = size(XZh,1);
mcr = mean(XZcr);
sdcr = std(XZcr);
ncr = size(XZcr,1);

figure(1);
shadedErrorBar([],mh,sdh/sqrt(nh),{'r','linewidth',2}); hold on;
shadedErrorBar([],mcr,sdcr/sqrt(ncr),{'b','linewidth',2},1); hold off;


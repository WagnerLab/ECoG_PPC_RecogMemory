
datapath = '~/Documents/ECOG/scripts/Doras_rendering_scripts/';
%% SRb
% electrodes with problems: 8, 9 10, 11, 17, 25,29, 36, 40
load([datapath '/render_brains/MNI/MNI_cortex_left.mat']);
load([datapath '/get_mni/subj_data/SRb_data/SRb_mni_elcoord_corrected.mat']);

r = subject_rois_v2('16b');
%%

ch=[r.IPS r.SPL r.AG];
%ch=[13];
factor = 1.0;
f = figure(1); clf;
h = axes;
ctmr_gauss_plot(h,cortex,[0 0 0],0,'l')
loc_view(290,20)
label_add(mni_elcoord(ch,:)./factor,ch,'r',40)
%%
mni_elcoord(ch,:)=mni_elcoord(ch,:)./factor;
%%
save([datapath '/get_mni/subj_data/SRb_data/SRb_mni_elcoord_corrected.mat'])

%% RHb
% electrodes with problems: 65:74
load([datapath '/render_brains/MNI/MNI_cortex_right.mat'])
load([datapath '/get_mni/subj_data/RHb_data/RHb_mni_elcoord.mat'])
r = subject_rois_v2('17b');
%%

ch=[r.IPS r.SPL r.AG];
%ch=[70 71 72 73 74];
factor = 1;
f = figure(1); clf;
h = axes;
ctmr_gauss_plot(h,cortex,[0 0 0],0,'r')
loc_view(63,36)
label_add(mni_elcoord(ch,:)./factor,ch,'r',40)

%%
mni_elcoord(ch,:)=mni_elcoord(ch,:)./factor;
%%
save([datapath '/get_mni/subj_data/RHb_data/RHb_mni_elcoord_corrected.mat'])

%% MD
% electrodes with problems: 69 70 75 76 77 78
load([datapath '/render_brains/MNI/MNI_cortex_left.mat'])
load([datapath '/get_mni/subj_data/MD_data/MD_mni_elcoord_corrected.mat'])
r = subject_rois_v2('18');
%%

ch=[r.IPS r.SPL r.AG];
%ch=76;
factor = 1;
f = figure(1); clf;
h = axes;
ctmr_gauss_plot(h,cortex,[0 0 0],0,'l')
loc_view(310,30)
label_add(mni_elcoord(ch,:)./factor,ch,'r',40)
%%
mni_elcoord(ch,:)=mni_elcoord(ch,:)./factor;
%%
save([datapath '/get_mni/subj_data/MD_data/MD_mni_elcoord_corrected.mat'])

%% RB
% electrodes with problems: 3,5 ,6 7 9 10 11 12 13 19 20 27
load([datapath '/render_brains/MNI/MNI_cortex_right.mat'])
load([datapath '/get_mni/subj_data/RB_data/RB_mni_elcoord_corrected.mat'])
r = subject_rois_v2('19');

%%
ch=[ 11 3 ];
factor = 0.98;
f = figure(1); clf;
h = axes;
ctmr_gauss_plot(h,cortex,[0 0 0],0,'r')
loc_view(63,36)
label_add(mni_elcoord(ch,:)./factor,ch,'r',40)

%%
mni_elcoord(ch,:)=mni_elcoord(ch,:)./factor;
%%
save([datapath '/get_mni/subj_data/RB_data/RB_mni_elcoord_corrected.mat'])

%% LK
% electrodes with problems: 37 40 44 54 55 62
load([datapath '/render_brains/MNI/MNI_cortex_left.mat'])
load([datapath '/get_mni/subj_data/LK_data/LK_mni_elcoord_corrected.mat'])
r = subject_rois_v2('24');
%%
ch=[r.IPS r.SPL r.AG];
%ch = [45];
factor = 1;
f = figure(1); clf;
h = axes;
ctmr_gauss_plot(h,cortex,[0 0 0],0,'l')
loc_view(310,30)
label_add(mni_elcoord(ch,:)./factor,ch,'r',40)
%%
mni_elcoord(ch,:)=mni_elcoord(ch,:)./factor;
%%
save([datapath '/get_mni/subj_data/LK_data/LK_mni_elcoord_corrected.mat'])
%% NC
% LPC elecs: 37    38    55    56    62    63    45    46    47    48    40    39    17    25     9
%                                     64     1     2    52    53    54    60    61
load([datapath '/render_brains/MNI/MNI_cortex_left.mat'])
load([datapath '/get_mni/subj_data/NC_data/NC_mni_elcoord_corrected.mat'])
r = subject_rois_v2('28');
%%
ch=[r.IPS r.SPL r.AG];
ch=55;
factor = 0.98;
figure(1);clf;
ctmr_gauss_plot(gca,cortex,[0 0 0],0,'l')
loc_view(310,30)
label_add(mni_elcoord(ch,:)./factor,ch,'r',40)
%%
mni_elcoord(ch,:)=mni_elcoord(ch,:)./factor;
%%
save([datapath '/get_mni/subj_data/NC_data/NC_mni_elcoord_corrected.mat'])

%% JT2
% LPC elecs:  37    38    45   105   106   107   113    34    35    36    42    43
%            44    39    40   114   122   123   124   125   111   112
load([datapath 'render_brains/MNI/MNI_cortex_right.mat'])
load([datapath '/get_mni/subj_data/JT2_data/JT2_mni_elcoord.mat'])
%%
ch=[r.AG r.IPS r.SPL];
factor = 1%0.98;
figure(1);clf;
ctmr_gauss_plot(gca,cortex,[0 0 0],0,'r')
loc_view(63,36)
label_add(mni_elcoord(ch,:)./factor,ch,'r',40)
%%
mni_elcoord(ch,:)=mni_elcoord(ch,:)./factor;
%%
save('~/Documents/ECOG/scripts/Doras_rendering_scripts/get_mni/subj_data/JT2_data/JT_mni_elcoord_corrected.mat')

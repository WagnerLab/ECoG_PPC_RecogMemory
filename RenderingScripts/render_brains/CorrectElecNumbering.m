


%% check numbering...
close all
ctmr_gauss_plot(cortex,[0 0 0],0,'r')
loc_view(80,40) % to rotate
%loc_view(270,40) % to rotate
for e = 1:64;
e,el_add(x.elecmatrix(e,:),'r',50);pause;end 

%% SRb
filepath = '/biac4/wagner/biac3/wagner7/ecog/subj16b/logs/spm_normalizations/';
newfilename = 'SRb_electrodes_surface_loc_all1_correctnumbering.mat';

% load original elecmatrix
x=load([filepath '/SRb_electrodes_surface_loc_all1.mat']);
load([filepath 'SRb_cortex'])


newidx = [1:8:57, 2:8:58, 59:-8:3, 4:8:60, 61:-8:5,6:8:62, 55:-8:7, 8:8:48];
elecmatrix = nan(114,3);
[s,i]=sort(newidx);
elecmatrix(s,:) = x.elecmatrix(i,:);
save([filepath newfilename],'elecmatrix')


%% RHb

filepath = '/biac4/wagner/biac3/wagner7/ecog/subj17b/logs/';
newfilename = 'RHb_electrodes_surface_loc_all1_correctnumbering.mat';

% load original elecmatrix
x=load([filepath 'RHb_electrodes_surface_loc_all1.mat']);
load([filepath 'RHb_cortex'])

newidx = [57:-8:17,58:-8:18,59:-8:19,60:-8:20, 61:-8:21,62:-8:22, 63,64,...
    55,56,47,48,39,40,31,32,23,24,69:-1:65,74:-1:70];

elecmatrix = nan(74,3);
[s,i]=sort(newidx);
elecmatrix(s,:) = x.elecmatrix(i,:);
save([filepath newfilename],'elecmatrix')

%% MD

filepath = '/biac4/wagner/biac3/wagner7/ecog/subj18/logs/';
newfilename = 'MD_electrodes_surface_loc_all1_correctnumbering.mat';

% load original elecmatrix
x=load([filepath 'MD_electrodes_surface_loc_all1.mat']);
load([filepath 'MD_cortex'])

elecmatrix = nan(108,3);
elecmatrix = x.elecmatrix;
save([filepath newfilename],'elecmatrix')

%% RB

filepath = '/biac4/wagner/biac3/wagner7/ecog/subj19/logs/spm_normalizations/';
newfilename = 'RB_electrodes_surface_loc_all1_correctnumbering.mat';

% load original elecmatrix
x=load([filepath 'RB_electrodes_surface_loc_all1.mat']);
load([filepath 'RB_cortex'])

newidx = [1:8,16:-1:9,17:24,32:-1:25,33:40,48:-1:41,49:56,64:-1:57];
 
elecmatrix = nan(112,3);
[s,i]=sort(newidx);
elecmatrix(s,:) = x.elecmatrix(i,:);
save([filepath newfilename],'elecmatrix')

%%

%%
close all
%ctmr_gauss_plot(cortex,[0 0 0],0,'l')
ctmr_gauss_plot(cortex,[0 0 0],0,'r')
loc_view(80,40) % to rotate
%loc_view(270,40) % to rotate
for e = s;
e,el_add(elecmatrix(e,:),'b',50);pause;end 

%save([filepath newfilename],'elecmatrix')
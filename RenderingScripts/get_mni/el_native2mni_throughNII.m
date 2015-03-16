% output mni_elcoord

% you need:
% elecmatrix: electrode times XYZ in subject space
% spm normalization parameters

% create ./data/temp/

% Dora Hermes - July 2012, edited Alex Gonzalez Aug, 2012

addpath('/Users/alexgonzalez/Documents/MATLAB/Mylib/spm8/')
subj='JT2';
par.anat = ['./subj_data/' subj '_data/' subj '_t1_aligned.nii'];
par.norm_mat = ['./subj_data/' subj '_data/' subj '_t1_aligned_seg_sn.mat']; % normalizationmmatrix from SPM
elecmatfile = ['./subj_data/' subj '_data/' subj '_electrodes_surface_loc_all1_correctnumbering.mat'];
cortexfile = ['./subj_data/' subj '_data/' subj '_cortex.mat'];
load(elecmatfile)
load(cortexfile)

% quick fix for missing electrodes:
% correct for electrodes somehow gone missing through normalization
if (strcmp(subj,'LK'))
    elecmatrix(4,:)=elecmatrix(4,:)-1;
    elecmatrix(10,:)=elecmatrix(10,:)-1;
    elecmatrix(19,:)=elecmatrix(19,:)-2;
    elecmatrix(20,:)=elecmatrix(20,:)-1;
    elecmatrix(111,:)=elecmatrix(111,:)-1;
elseif(strcmp(subj,'RB'))
    elecmatrix(20,:)=elecmatrix(20,:)-1;
    elecmatrix(84,:)=elecmatrix(84,:)-1;
    elecmatrix(104,:)=elecmatrix(104,:)-1;
elseif(strcmp(subj,'SRb'))
    elecmatrix(9,:)=elecmatrix(9,:)-1;
    elecmatrix(56,:)=elecmatrix(56,:)+2; % this one is still missing
elseif(strcmp(subj,'RHb'))
    % one through 16 missing after normalization
    elecmatrix(66,:)=elecmatrix(66,:)+2;
    
elseif(strcmp(subj,'MD'))
    %missing elec: 1,32, 34, 60, 96, 104
    elecmatrix(77,:)=elecmatrix(77,:)-1;
elseif(strcmp(subj,'NC'))
    %missing elec: 49,50,57,58,95,96
    elecmatrix(49,:)=elecmatrix(49,:)+1;
    elecmatrix(50,:)=elecmatrix(50,:)+1;
    elecmatrix(57,:)=elecmatrix(57,:)+1;
    elecmatrix(58,:)=elecmatrix(58,:)+1;
    elecmatrix(95,:)=elecmatrix(95,:)+1;
    elecmatrix(96,:)=elecmatrix(96,:)+1;
elseif(strcmp(subj,'JT2'))
    %missing elec: 15,27,29:33,41,63:67,73,74,80,81,104,121
    %elecs = [15,27,29:33,41,63:67,73,74,80,81,104,121];
    %elecmatrix([15,27,29:33,41,63:67,73,74,80,81,104,121],:) = ...
    %    elecmatrix([15,27,29:33,41,63:67,73,74,80,81,104,121],:)+1;
    
end
% put electrode positions in the T1 space nifti
[~,els,els_ind,outputStruct] = position2reslicedImage_nrs(elecmatrix,par.anat,subj);

%% normalize the T2 space nifti with electrodes
% nii_normels=[pwd '/data/temp/' subj '_electrodesNRs1.nii'];
nii_normels=['./data/temp/' subj '_electrodesNRs1.nii'];
flags.preserve  = 0;
flags.bb        = [-90 -120 -60; 90 96 100];
flags.vox       = [1 1 1];
flags.interp    = 0;
flags.wrap      = [0 0 0];
flags.prefix    = 'w';

job.subj.matname{1}=par.norm_mat;
job.subj.resample{1}=nii_normels;
job.roptions=flags;

spm_run_normalise_write(job);

%% get normalized electrode coordinates

nii_normels=['./data/temp/w' subj '_electrodesNRs1.nii'];

data.Struct=spm_vol(nii_normels);
[m,xyz]=spm_read_vols(data.Struct);% from structure to data matrix

mni_elcoord=nan(max(m(:)),3);

% check for missing electrodes and display in command window
for k=1:max(m(:))
    if isempty(find(m(:)==k,1));
        disp(['electrode ' int2str(k) ' missing'])
    end
end

%missing_elecs = [15,27,29:33,41,63:67,73,74,80,81,104,121];
elec_present = setdiff(1:max(m(:)),missing_elecs);
for k=elec_present
    mni_elcoord(k,:)=xyz(:,find(m(:)==k,1));
end

save(['./subj_data/' subj '_data/' subj '_mni_elcoord.mat'], 'mni_elcoord')


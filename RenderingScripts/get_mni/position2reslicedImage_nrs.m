function [output,els,els_ind,outputStruct] = position2reslicedImage_nrs(els,fname,subj)
% input: 
% els [3x] matrix with x y z coordinates of x electrodes (native space)
% default: 
%
%     Copyright (C) 2009  D. Hermes, Dept of Neurology and Neurosurgery, University Medical Center Utrecht
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%    
%   Version 1.1.0, released 26-11-2009

%% example to load positions of electrodes
% data.elecname='C:\Users\dora\Documents\AiO\gridpatients\ctAnalysisPackage\data\maan\ct\electrodes_loc2_global.mat';
% grid=load(data.elecname);
% els=grid.elecmatrix;

%% select resliced image for electrodes
if ~exist(fname)
    data.Name=spm_select(1,'image','select resliced image for electrodes');
else 
    data.Name=fname;
end
data.Struct=spm_vol(data.Name);
[data.data]=spm_read_vols(data.Struct);% from structure to data matrix
outputStruct=data.Struct;

% convert electrodes from native 2 indices
els_ind=round((els-repmat(data.Struct.mat(1:3,4),1,length(els))')*...
    inv(data.Struct.mat(1:3,1:3)'));

temp.electrode=zeros(size(data.data));

for elec=1:length(els_ind)
    if ~isnan(els_ind(elec,:))
        temp.electrode(els_ind(elec,1),els_ind(elec,2),els_ind(elec,3))=elec;
    end
end
output=temp.electrode;

%% and save new data:
dataOut=data.Struct;
outputdir= './data/temp/';%spm_select(1,'dir','select output directory');
outputnaam=strcat([outputdir subj '_electrodesNRs1.nii']);
dataOut.fname=outputnaam;
disp(strcat(['saving ' outputnaam]));
% save the data
spm_write_vol(dataOut,temp.electrode);

% for filenummer=1:100
%     outputnaam=strcat([outputdir subj '_electrodesNRs' int2str(filenummer) '.nii']);
%     dataOut.fname=outputnaam;
% 
%     if ~exist(dataOut.fname,'file')>0
%         disp(strcat(['saving ' outputnaam]));
%         % save the data
%         spm_write_vol(dataOut,temp.electrode);
%         break
%     end
% end


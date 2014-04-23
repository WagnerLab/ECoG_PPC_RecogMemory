function ctmr_gauss_plot_density(cortex,electrodes,weights,max_set)
% function [electrodes]=ctmr_gauss_plot(cortex,electrodes,weights)
% projects electrode locations onto their cortical spots in the 
% left hemisphere and plots about them using a gaussian kernel
% for only cortex use: 
% ctmr_gauss_plot(cortex,[0 0 0],0)
% rel_dir=which('loc_plot');
% rel_dir((length(rel_dir)-10):length(rel_dir))=[];
% addpath(rel_dir)

%     Copyright (C) 2009  K.J. Miller & D. Hermes, Dept of Neurology and Neurosurgery, University Medical Center Utrecht
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
    
%   Version 1.1.0, released 26-11-2009

%!!!!!!
% Update: 
% Changes made to normalize mesh color relative to electrode
% density. - BLF, Stanford, April 2014.
% Added: max_set, specify the maxima of values (i.e. range of color map)
% -DH, Stanford, April 2014.


%load in colormap
load('loc_colormap')

brain=cortex.vert;
v='l';
% %view from which side?
% temp=1;
% while temp==1
%     disp('---------------------------------------')
%     disp('to view from right press ''r''')
%     disp('to view from left press ''l''');
%     v=input('','s');
%     if v=='l'      
%         temp=0;
%     elseif v=='r'      
%         temp=0;
%     else
%         disp('you didn''t press r, or l try again (is caps on?)')
%     end
% end

if length(weights)~=length(electrodes(:,1))
    error('you sent a different number of weights than electrodes (perhaps a whole matrix instead of vector)')
end
%gaussian "cortical" spreading parameter - in mm, so if set at 10, its 1 cm
%- distance between adjacent electrodes
gsp=50;

c=zeros(length(cortex(:,1)),1);

%BF: make a unit weights vector
null_weights = ones(1,length(weights));
c_norm=zeros(length(cortex(:,1)),1);

for i=1:length(electrodes(:,1))
    b_z=abs(brain(:,3)-electrodes(i,3));
    b_y=abs(brain(:,2)-electrodes(i,2));
    b_x=abs(brain(:,1)-electrodes(i,1));
    %d=weights(i)*exp((-(b_x.^2+b_z.^2+b_y.^2).^.5)/gsp^.5); %exponential fall off 
    d=weights(i)*exp((-(b_x.^2+b_z.^2+b_y.^2))/gsp); %gaussian 
    c=c+d';
    
    %BF: get values for unit weigths
    d_norm= null_weights(i)*exp((-(b_x.^2+b_z.^2+b_y.^2))/gsp); %gaussian
    c_norm = c_norm+d_norm';
    
end

%BF: normalize the unit data to scale from 0-1
c_norm = c_norm ./ max(c_norm);

%BF: scale mesh values relative to the unity(density) estimation.
scale_c = c - (c.*c_norm);

%c=(c/max(c));
%a=tripatch(cortex, 'nofigure', c'); %BF: added 'nofigure' to supress fig window

%BF: use density normalized data
a=tripatch(cortex, '', scale_c'); %BF: added 'nofigure' to supress fig window

shading interp;
a=get(gca);
%%NOTE: MAY WANT TO MAKE AXIS THE SAME MAGNITUDE ACROSS ALL COMPONENTS TO REFLECT
%%RELEVANCE OF CHANNEL FOR COMPARISON's ACROSS CORTICES
d=a.CLim;

if isempty(max_set)
set(gca,'CLim',[-max(abs(d)) max(abs(d))])
else
set(gca,'CLim',[-max_set max_set])
end

l=light;
colormap(cm)
%colormap(jet)
lighting phong; %play with lighting...
material([.3 .8 .1 10 1]);
axis off

set(gcf,'Renderer', 'zbuffer')

if v=='l'
view(270, 0);
set(l,'Position',[-1 0 1])        
elseif v=='r'
view(90, 0);
set(l,'Position',[1 0 1])        
end

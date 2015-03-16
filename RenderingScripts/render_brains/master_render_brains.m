%load ./LK/LK_cortex.mat
%load ./LK/LK_electrodes_surface_loc_all1_correctnumbering.mat

h=figure(1);
ctmr_gauss_plot(gca,cortex,[0 0 0],0,'l')
loc_view(270,30) % to rotate

% el_add(elecmatrix,'r',20)

% label_add(elecmatrix)
elecmatrix = mni_elcoord;
el_add_sizable(elecmatrix,[1:size(elecmatrix,1)]-61,size(elecmatrix,1)/2)

%%
figure(1)
elecidx=perf.rois{6}.LPC;
ctmr_gauss_plot(cortex,elecmatrix(elecidx,:),perf.bac{6}(elecidx))

%%
ctmr_gauss_plot(cortex,[0 0 0],0,'r')
loc_view(60,50) % to rotate
%el_add_sizable(elecmatrix(elecidx,:),perf.bac{6}(elecidx).*(perf.pval{6}(elecidx)<0.05))
%el_add(mni_elcoord,'c',30)
%el_add(elecmatrix(find(perf.pval{6}<0.05),:),'r',30)
%%

elecidx=perf.rois{6}.LPC;
ctmr_gauss_plot(cortex,elecmatrix(elecidx,:),-log10(perf.pval{6}(elecidx)))

%% 
clf
h = axes;
ctmr_gauss_plot(h,cortex,[0 0 0],0,'l')
loc_view(290,20)
el_add(mni_elcoord,'c',10)
%el_add(elecmatrix,'c',30)

function rois = subject_rois(subjnum)
% input is subjnum
% outputs is roi channels
% ROI channels by subjnumect, anatomically defined


if strcmp(subjnum,'04') || strcmp(subjnum,'CM')
    rois.subjnum = subjnum;
    rois.allchannels = [2:64];
    
    rois.pIPS = intersect(rois.allchannels,[52:54]);
    rois.amIPS = intersect(rois.allchannels,[50,51]);
    rois.latIPS = intersect(rois.allchannels,[45]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[55,56,61]);
    rois.AG = intersect(rois.allchannels,[46,47]);
    rois.TPJ = [];
    rois.SMG = [];
    rois.amb = [];
    rois.rois_present = {'pIPS','amIPS','latIPS','IPS','SPL','AG'};
    %rois.rois_present = {'IPS','SPL','AG'};
    
elseif strcmp(subjnum,'10')|| strcmp(subjnum,'KB')  %KB
    rois.subjnum = subjnum;
    rois.allchannels = [1:35];
    
    rois.pIPS = intersect(rois.allchannels,[19,25:27]);
    rois.amIPS = intersect(rois.allchannels,[22,23]);
    rois.latIPS = intersect(rois.allchannels,[17,18,21]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[28,29,32,33,34]);
    rois.AG = intersect(rois.allchannels,[9,10,16,15]);
    rois.TPJ = intersect(rois.allchannels,[5,6]);
    rois.SMG = [11];
    rois.amb = [4,12];
    rois.rois_present = {'pIPS','amIPS','latIPS','IPS','SPL','AG','SMG','TPJ','amb'};
    %rois.rois_present = {'IPS','SPL','AG'};
    %rois.rois_present = {'IPS'};
    
elseif strcmp(subjnum,'16b') || strcmp(subjnum,'SRb')
    rois.subjnum = subjnum;
    rois.allchannels = [1:61,63:114];
    
    rois.pIPS = intersect(rois.allchannels,[4,5,12]);
    rois.amIPS = intersect(rois.allchannels,[20,28]);
    rois.latIPS = intersect(rois.allchannels,[21,29,37]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[1:3,9:11,17:19,26:27]);
    rois.AG = intersect(rois.allchannels,[13:15,22,23,30,31]);
    rois.TPJ = intersect(rois.allchannels,[39,47]);
    rois.SMG = 38;
    rois.amb = 46;
    %rois.rois_present = {'pIPS','amIPS','latIPS','IPS','SPL','AG','SMG','TPJ','amb'};
    rois.rois_present = {'IPS','SPL'};
    %rois.rois_present = {'IPS','SPL','AG'};
    %rois.rois_present = {'AG'};
    %rois.rois_present = {'TPJ','SMG','amb','IPS','SPL','AG'};
    %rois.rois_present = {'IPS','SPL','AG','TPJ','SMG','amb'};
	
elseif strcmp(subjnum,'17b') || strcmp(subjnum,'RHb')
    rois.subjnum = subjnum;
    rois.allchannels = [1:56,58:74];
    
    rois.pIPS = intersect(rois.allchannels,[65:67,70:73]);
    rois.amIPS = intersect(rois.allchannels,[31,40]);
    rois.latIPS = intersect(rois.allchannels,[32,74]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[69]);
    rois.AG = intersect(rois.allchannels,[24]);
    rois.TPJ = [];
    rois.SMG = [22,23];
    rois.amb = [];
    %rois.rois_present = {'pIPS','amIPS','latIPS','IPS','SPL','AG','SMG'};
    rois.rois_present = {'IPS','SPL'};
    %rois.rois_present = {'IPS','SPL','AG'};
    %rois.rois_present = {'AG'};
	%rois.rois_present = {'IPS','SPL','AG','SMG'};
    
elseif strcmp(subjnum,'18') || strcmp(subjnum,'MD')
    rois.subjnum = subjnum;
    rois.allchannels = [1:94,96:108];
    
    rois.AG = [];
    rois.pIPS = intersect(rois.allchannels,[65:67,74]);
    rois.amIPS = intersect(rois.allchannels,[75:77]);
    rois.latIPS = intersect(rois.allchannels,[68:70]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    rois.SMG = [];
    rois.TPJ = [];
    rois.SPL = [];
    rois.amb = [];
    %rois.rois_present = {'pIPS','amIPS','latIPS','IPS'};
    %rois.rois_present = {'AG'};
	rois.rois_present = {'IPS'};
    
elseif strcmp(subjnum,'19') || strcmp(subjnum,'RB')
    rois.subjnum = subjnum;
    rois.allchannels = [1:63, 65:112];
    
    rois.pIPS = intersect(rois.allchannels,[18,19,25,33]);
    rois.amIPS = intersect(rois.allchannels,[12]);
    rois.latIPS = intersect(rois.allchannels,[13:15]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[1:4,9:11]);
    rois.AG = intersect(rois.allchannels,[28,29,36,37]);
    rois.TPJ = intersect(rois.allchannels,[30:32,39,40]);
    rois.SMG = [21:24];
    rois.amb = 20;
    %rois.rois_present = {'pIPS','amIPS','latIPS','IPS','SPL','AG','SMG','TPJ','amb'};
    rois.rois_present = {'IPS','SPL'};	
    %rois.rois_present = {'IPS','SPL','AG'};
    %rois.rois_present = {'AG'};
	%rois.rois_present = {'IPS','SPL','AG','TPJ','SMG','amb'};
    %rois.rois_present = {'AG','TPJ','SMG','amb'};
    %rois.rois_present = {'TPJ','SMG','amb'};
    
elseif strcmp(subjnum,'20') || strcmp(subjnum,'DZa')
    rois.subjnum = subjnum;
    rois.allchannels = 1:118;
    
    rois.pIPS = intersect(rois.allchannels,80);
    rois.amIPS = intersect(rois.allchannels,[72,71]);
    rois.latIPS = intersect(rois.allchannels,[66:67]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[82:84,86:88]);
    rois.AG = intersect(rois.allchannels,[57,62]);
    rois.TPJ = intersect(rois.allchannels,[51,52]);
    rois.SMG = [56,61];
    rois.amb = [78,79];
    %rois.rois_present = {'pIPS','amIPS','latIPS','IPS','SPL','AG','SMG','TPJ','amb'};
    rois.rois_present = {'IPS','SPL'};
	%rois.rois_present = {'IPS','SPL','AG','TPJ','SMG','amb'};
    
elseif strcmp(subjnum,'20b') || strcmp(subjnum,'DZb')
    rois.subjnum = subjnum;
    rois.allchannels = 1:118;
    
    rois.pIPS = intersect(rois.allchannels,[15,16,23,24]);
    rois.amIPS = intersect(rois.allchannels,[32,86,96]);
    rois.latIPS = intersect(rois.allchannels,[87,88]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[95]);
    rois.AG = intersect(rois.allchannels,[22,29:31,72,80]);
    rois.TPJ = intersect(rois.allchannels,[62,63,71]);
    rois.SMG = [70,79];
    rois.amb = [];
    %rois.rois_present = {'pIPS','amIPS','latIPS','IPS','SPL','AG','SMG','TPJ'};
    %rois.rois_present = {'IPS'};
    rois.rois_present = {'IPS','SPL','AG','TPJ','SMG','amb'};
	
elseif strcmp(subjnum,'21') || strcmp(subjnum,'JT')
    rois.subjnum = subjnum;
    rois.allchannels = 1:118;
    
    rois.pIPS = intersect(rois.allchannels,[59,67]);
    rois.amIPS = intersect(rois.allchannels,[53,46]);
    rois.latIPS = intersect(rois.allchannels,[60,54]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[33:35,41:44,49:52,57]);
    rois.AG = intersect(rois.allchannels,[61,68,69,70,76,77,78]);
    rois.TPJ = intersect(rois.allchannels,[63,64,71,72]);
    rois.SMG = [55,56];
    rois.amb = [62];
    %rois.rois_present = {'pIPS','amIPS','latIPS','IPS','SPL','AG','SMG','TPJ','amb'};
	rois.rois_present = {'IPS','SPL','AG','TPJ','SMG','amb'};
    %rois.rois_present = {'IPS','SPL','AG'};
    %rois.rois_present = {'IPS'};
    
elseif strcmp(subjnum,'22') || strcmp(subjnum,'TC')
    rois.subjnum = subjnum;
    rois.allchannels = [1:60,62:90];
    
    rois.pIPS = [];
    rois.amIPS = 76;
    rois.latIPS = [];
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = [];
    rois.AG = [];
    rois.TPJ = 74;
    rois.SMG = 75;
    rois.amb = [];
    %rois.rois_present = {'amIPS','SMG','TPJ','IPS'};
    rois.rois_present = {'IPS','TPJ','SMG'};
	%rois.rois_present = {'IPS'};

elseif strcmp(subjnum,'24') || strcmp(subjnum,'LK')
    rois.subjnum = subjnum;
    rois.allchannels = [1:7,9:122];
    
    rois.pIPS = [42 43];
    rois.amIPS = [37];
    rois.latIPS = [34 35 36];
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = [44 45 50 51 52 53 58 59 60 61];
    rois.AG = [];
    rois.TPJ = [];
    rois.SMG = [];
    rois.amb = [];
    
    rois.rois_present = {'IPS','SPL'};

elseif strcmp(subjnum,'28') || strcmp(subjnum,'NC')
    rois.subjnum = subjnum;
    rois.allchannels = [1:104,106];
    
    rois.pIPS = [37 38];
    rois.amIPS = [55 56 63];
    rois.latIPS = [62];
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = [45 46 47 48 40 39 17 25 9 64 1 2];
    rois.AG = [52 53 54 60 61 ];
    rois.TPJ = [];
    rois.SMG = [];
    rois.amb = [];
    
    rois.rois_present = {'IPS','SPL'};
    %rois.rois_present = {'IPS','SPL','AG'};
	
end

rois.LPC = [rois.IPS rois.SPL rois.AG rois.TPJ rois.SMG rois.amb];
%rois.rois_present(end+1) = {'LPC'};
rois.other = setdiff(rois.allchannels,rois.LPC);


return



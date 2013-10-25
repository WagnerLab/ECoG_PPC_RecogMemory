function rois = subjectsChanInfo(subj)
% input is the subject number or subject's initials
% outputs information about the channels
% ROI channels anatomically defined
% Alex Gonzl.
% updated May 09,2013

if strcmp(subj,'04') || strcmp(subj,'CM')
    rois.subjnum = subj;
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

elseif strcmp(subj,'10')|| strcmp(subj,'KB')  %KB
    rois.subjnum = subj;
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
    
elseif strcmp(subj,'16b') || strcmp(subj,'SRb')
    rois.subjnum = subj;
    rois.refchannel = 62;
    rois.badchannels = [17 56 63 64 15]; % 15 was also noisy
    rois.noisychannels = [7 15 16 38 39];   % as determined by calculating within channel variance
    rois.surfacechannels = [1:78 89:114];
    rois.allchannels = setdiff(1:114,[rois.badchannels,rois.refchannel,rois.noisychannels]);
   
    rois.pIPS = intersect(rois.allchannels,[4,5,12]);
    rois.amIPS = intersect(rois.allchannels,[20,28]);
    rois.latIPS = intersect(rois.allchannels,[21,29,37]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[1:3,9:11,17:19,26:27]);
    rois.AG = intersect(rois.allchannels,[13:15,22,23,30,31]);
    rois.TPJ = intersect(rois.allchannels,[39,47]);
    rois.SMG = 38;
    rois.amb = 46;
    rois.rois_present = {'IPS','SPL','AG'};
	
elseif strcmp(subj,'17b') || strcmp(subj,'RHb')
    rois.subjnum = subj;
    rois.refchannel = 57;
    rois.badchannels = [19,22,30,31,64,1,65,16];
    rois.noisychannels = [19 53 70];
    rois.surfacechannels = [1:74];
    rois.allchannels = setdiff(1:74,[rois.badchannels,rois.refchannel,rois.noisychannels]);
       
    rois.pIPS = intersect(rois.allchannels,[65:67,70:73]);
    rois.amIPS = intersect(rois.allchannels,[31,40]);
    rois.latIPS = intersect(rois.allchannels,[32,74]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[69]);
    rois.AG = intersect(rois.allchannels,[24]);
    rois.TPJ = [];
    rois.SMG = [22,23];
    rois.amb = [];
    rois.rois_present = {'IPS','SPL','AG'};
    
elseif strcmp(subj,'18') || strcmp(subj,'MD')
    rois.subjnum = subj;
    rois.refchannel = 95;
    rois.badchannels = [47 81 96];
    rois.noisychannels = [30 38 39 46 47 98];
    rois.surfacechannels = [1:108];
    rois.allchannels = setdiff(1:108,[rois.badchannels,rois.refchannel,rois.noisychannels]);
    
    rois.AG = [];
    rois.pIPS = intersect(rois.allchannels,[65:67,74]);
    rois.amIPS = intersect(rois.allchannels,[75:77]);
    rois.latIPS = intersect(rois.allchannels,[68:70]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    rois.SMG = [];
    rois.TPJ = [];
    rois.SPL = [];
    rois.amb = [];

elseif strcmp(subj,'19') || strcmp(subj,'RB')
    rois.subjnum = subj;
    rois.refchannel = 64;
    rois.badchannels = [17 63 77 95 35 36 42 43 44 52 53 97 98 99 65:70];
    rois.noisychannels = [38 77 95];
    rois.surfacechannels = [1:114];
    rois.allchannels = setdiff(1:114,[rois.badchannels,rois.refchannel,rois.noisychannels]);
   
    rois.pIPS = intersect(rois.allchannels,[18,19,25,33]);
    rois.amIPS = intersect(rois.allchannels,[12]);
    rois.latIPS = intersect(rois.allchannels,[13:15]);
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[1:4,9:11]);
    rois.AG = intersect(rois.allchannels,[28,29,36,37]);
    rois.TPJ = intersect(rois.allchannels,[30:32,39,40]);
    rois.SMG = [21:24];
    rois.amb = 20;
    
elseif strcmp(subj,'20') || strcmp(subj,'DZa')
    rois.subjnum = subj;
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
    
elseif strcmp(subj,'20b') || strcmp(subj,'DZb')
    rois.subjnum = subj;
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
	
elseif strcmp(subj,'21') || strcmp(subj,'JTold')
    rois.subjnum = subj;
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
    
elseif strcmp(subj,'22') || strcmp(subj,'TC')
    rois.subjnum = subj;
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

elseif strcmp(subj,'24') || strcmp(subj,'LK')
    rois.subjnum = subj;
    rois.refchannel = 8;
    rois.badchannels = [17, 18:24, 81,82,85,97,49, 50 57, 58, 95, 96,64,56];
    rois.noisychannels = [9    10    11    12    13    14    15    16];
    rois.surfacechannels = [1:122];
    rois.allchannels = setdiff(1:122,[rois.badchannels,rois.refchannel,rois.noisychannels]);
    
    rois.pIPS = [42 43];
    rois.amIPS = [37];
    rois.latIPS = [34 35 36];
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);    
    rois.SPL = intersect(rois.allchannels,[44 45 50 51 52 53 58 59 60 61]);    
    rois.AG = [];
    rois.TPJ = [];
    rois.SMG = [];
    rois.amb = [];
    
elseif strcmp(subj,'28') || strcmp(subj,'NC')
    rois.subjnum = subj;
    rois.refchannel = 105;
    rois.badchannels = [36 37 95 97 85 115   116   117   118   119   120   121 ... 
            73    74    75    76    77    78    79    90    91 ...
            92    93    94    95];
    rois.noisychannels = [18:24];
    rois.surfacechannels = [1:106];
    rois.allchannels = setdiff(1:106,[rois.badchannels,rois.refchannel,rois.noisychannels]);
    
    rois.pIPS = [37 38];
    rois.amIPS = [55 56 63];
    rois.latIPS = [62];
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[45 46 47 48 40 39 17 25 9 64 1 2]);
    rois.AG = intersect(rois.allchannels,[52 53 54 60 61 ]);
    rois.TPJ = [];
    rois.SMG = [];
    rois.amb = [];

elseif strcmp(subj,'29') || strcmp(subj,'JT')
    rois.subjnum = subj;
    rois.refchannel = 21;
    rois.badchannels = [15,33,41,65,66,67,73,74,81,121,19,26,1,2,5,49,50,77,85,95,97];
    rois.noisychannels = [18:20 22:24];
    rois.surfacechannels = [1:128];
    rois.allchannels = setdiff(1:128,[rois.badchannels,rois.refchannel,rois.noisychannels]);
    
    rois.pIPS = [37,38,45,113];
    rois.amIPS = [105];
    rois.latIPS = [106 107];
    rois.IPS = intersect(rois.allchannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.allchannels,[97,34,35,36,42,43,44]);
    rois.AG = intersect(rois.allchannels,[39, 40 114   122   123]);
    rois.TPJ = intersect(rois.allchannels,[124 125]);
    rois.SMG = intersect(rois.allchannels,[111 112]);
    rois.amb = [];

end

rois.CARchannels = setdiff(rois.surfacechannels,[rois.badchannels,rois.noisychannels,rois.refchannel]);
rois.LPC = [rois.IPS rois.SPL rois.AG];
rois.other = setdiff(rois.allchannels,rois.LPC);

return
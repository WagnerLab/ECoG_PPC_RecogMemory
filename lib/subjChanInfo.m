function rois = subjChanInfo(subj)
% input is the subject number or subject's initials
% outputs information about the Channels
% ROI Channels anatomically defined
% Alex Gonzl.
% updated May 09,2013

if strcmp(subj,'04') || strcmp(subj,'CM')
    rois.subjnum = subj;
    rois.goodChannels = [2:64];
    
    rois.pIPS = intersect(rois.goodChannels,[52:54]);
    rois.amIPS = intersect(rois.goodChannels,[50,51]);
    rois.latIPS = intersect(rois.goodChannels,[45]);
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.goodChannels,[55,56,61]);
    rois.AG = intersect(rois.goodChannels,[46,47]);
    rois.TPJ = [];
    rois.SMG = [];
    rois.amb = [];

elseif strcmp(subj,'10')|| strcmp(subj,'KB')  %KB
    rois.subjnum = subj;
    rois.goodChannels = [1:35];
    
    rois.pIPS = intersect(rois.goodChannels,[19,25:27]);
    rois.amIPS = intersect(rois.goodChannels,[22,23]);
    rois.latIPS = intersect(rois.goodChannels,[17,18,21]);
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.goodChannels,[28,29,32,33,34]);
    rois.AG = intersect(rois.goodChannels,[9,10,16,15]);
    rois.TPJ = intersect(rois.goodChannels,[5,6]);
    rois.SMG = [11];
    rois.amb = [4,12];
    
elseif strcmp(subj,'16b') || strcmp(subj,'SRb')
    rois.subjnum = subj;
    rois.allChans = 1:114;
    rois.refChannel = 62;
    rois.badChannels = [17 56 63 64 15]; % 15 was also noisy
    rois.noisyChannels = [7 15 16 38 39];   % as determined by calculating within Channel variance
    rois.surfaceChannels = [1:78 89:114];
    rois.goodChannels = setdiff(rois.allChans,[rois.badChannels,rois.refChannel,rois.noisyChannels]);
   
    rois.pIPS = intersect(rois.goodChannels,[4,5,12]);
    rois.amIPS = intersect(rois.goodChannels,[20,28]);
    rois.latIPS = intersect(rois.goodChannels,[21,29,37]);    
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.goodChannels,[1:3,9:11,17:19,26:27]);
    rois.pSPL = 3;
    rois.aSPL = [1 2 9 10 11 18 19 26 27];
    rois.AG = intersect(rois.goodChannels,[13:15,22,23,30,31]);
    rois.TPJ = intersect(rois.goodChannels,[39,47]);
    rois.SMG = intersect(rois.goodChannels,38);
    rois.amb = intersect(rois.goodChannels,46);
	
elseif strcmp(subj,'17b') || strcmp(subj,'RHb')
    rois.subjnum = subj;    
    rois.allChans = 1:74;
    rois.refChannel = 57;
    rois.badChannels = [19,22,30,31,64,1,65,16];
    rois.noisyChannels = [19 53 70];
    rois.surfaceChannels = rois.allChans;
    rois.goodChannels = setdiff(rois.allChans,[rois.badChannels,rois.refChannel,rois.noisyChannels]);
       
    rois.pIPS = intersect(rois.goodChannels,[65:67,70:73]);
    rois.amIPS = intersect(rois.goodChannels,[31,40]);
    rois.latIPS = intersect(rois.goodChannels,[32,74]);
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.pSPL = [];
    rois.aSPL = [69];
    rois.SPL = intersect(rois.goodChannels,[69]);
    rois.AG = intersect(rois.goodChannels,[24]);
    rois.TPJ = [];
    rois.SMG = intersect(rois.goodChannels,[22,23]);
    rois.amb = [];
    
elseif strcmp(subj,'18') || strcmp(subj,'MD')
    rois.subjnum = subj;
    rois.allChans = 1:108;
    rois.refChannel = 95;
    rois.badChannels = [47 81 96];
    rois.noisyChannels = [30 38 39 46 47 98];
    rois.surfaceChannels = rois.allChans;
    rois.goodChannels = setdiff(rois.allChans,[rois.badChannels,rois.refChannel,rois.noisyChannels]);
    
    rois.AG = [];
    rois.pIPS = intersect(rois.goodChannels,[65:67,74]);
    rois.amIPS = intersect(rois.goodChannels,[75:77]);
    rois.latIPS = intersect(rois.goodChannels,[68:70]);
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    rois.SMG = [];
    rois.TPJ = [];
    rois.SPL = [];
    rois.amb = [];
    rois.pSPL = [];
    rois.aSPL = [];
    
elseif strcmp(subj,'19') || strcmp(subj,'RB')
    rois.subjnum = subj;
    rois.allChans = 1:112;
    rois.refChannel = 64;
    rois.badChannels = [17 63 77 95 35 36 42 43 44 52 53 97 98 99 65:70];
    rois.noisyChannels = [38 77 95];
    rois.surfaceChannels = rois.allChans;
    rois.goodChannels = setdiff(rois.allChans,[rois.badChannels,rois.refChannel,rois.noisyChannels]);
   
    rois.pIPS = intersect(rois.goodChannels,[18,19,25,33]);
    rois.amIPS = intersect(rois.goodChannels,[12]);
    rois.latIPS = intersect(rois.goodChannels,[13:15]);
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.goodChannels,[1:4,9:11]);
    rois.AG = intersect(rois.goodChannels,[28,29,36,37]);
    rois.TPJ = intersect(rois.goodChannels,[30:32,39,40]);
    rois.SMG = intersect(rois.goodChannels,[21:24]);
    rois.amb = intersect(rois.goodChannels,20);
    
    rois.aSPL = [2 3 4];
    rois.pSPL = [ 1 9 10 11];
    
elseif strcmp(subj,'20') || strcmp(subj,'DZa')
    rois.subjnum = subj;
    rois.allChans = 1:118;
    rois.goodChannels = 1:118;
    
    rois.pIPS = intersect(rois.goodChannels,80);
    rois.amIPS = intersect(rois.goodChannels,[72,71]);
    rois.latIPS = intersect(rois.goodChannels,[66:67]);
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.goodChannels,[82:84,86:88]);
    rois.AG = intersect(rois.goodChannels,[57,62]);
    rois.TPJ = intersect(rois.goodChannels,[51,52]);
    rois.SMG = [56,61];
    rois.amb = [78,79];
    
elseif strcmp(subj,'20b') || strcmp(subj,'DZb')
    rois.subjnum = subj;
    rois.goodChannels = 1:118;
    
    rois.pIPS = intersect(rois.goodChannels,[15,16,23,24]);
    rois.amIPS = intersect(rois.goodChannels,[32,86,96]);
    rois.latIPS = intersect(rois.goodChannels,[87,88]);
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.goodChannels,[95]);
    rois.AG = intersect(rois.goodChannels,[22,29:31,72,80]);
    rois.TPJ = intersect(rois.goodChannels,[62,63,71]);
    rois.SMG = [70,79];
    rois.amb = [];
	
elseif strcmp(subj,'21') || strcmp(subj,'JTold')
    rois.subjnum = subj;
    rois.allChans = 1:118;
    rois.goodChannels = 1:118;
    
    rois.pIPS = intersect(rois.goodChannels,[59,67]);
    rois.amIPS = intersect(rois.goodChannels,[53,46]);
    rois.latIPS = intersect(rois.goodChannels,[60,54]);
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.goodChannels,[33:35,41:44,49:52,57]);
    rois.AG = intersect(rois.goodChannels,[61,68,69,70,76,77,78]);
    rois.TPJ = intersect(rois.goodChannels,[63,64,71,72]);
    rois.SMG = [55,56];
    rois.amb = [62];    
    
elseif strcmp(subj,'22') || strcmp(subj,'TC')
    rois.subjnum = subj;
    rois.goodChannels = [1:60,62:90];
    
    rois.pIPS = [];
    rois.amIPS = 76;
    rois.latIPS = [];
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = [];
    rois.AG = [];
    rois.TPJ = 74;
    rois.SMG = 75;
    rois.amb = [];

elseif strcmp(subj,'24') || strcmp(subj,'LK')
    rois.subjnum = subj;
    rois.allChans = 1:122;
    rois.refChannel = 8;
    rois.badChannels = [17, 18:24, 81,82,85,97,49, 50 57, 58, 95, 96,64,56];
    rois.noisyChannels = [9    10    11    12    13    14    15    16];
    rois.surfaceChannels = rois.allChans;
    rois.goodChannels = setdiff(rois.allChans,[rois.badChannels,rois.refChannel,rois.noisyChannels]);
    
    rois.pIPS = [34 35 42 43];
    rois.amIPS = [37];
    rois.latIPS = [36];
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);    
    rois.SPL = intersect(rois.goodChannels,[44 45 50 51 52 53 58 59 60 61]);    
    rois.AG = [];
    rois.TPJ = [];
    rois.SMG = [];
    rois.amb = [];
    
    rois.aSPL = [45 53 61];
    rois.pSPL = [44 52 60 51 59];
    
elseif strcmp(subj,'28') || strcmp(subj,'NC')
    rois.subjnum = subj;
    rois.allChans = 1:106;
    rois.refChannel = 105;
    rois.badChannels = [36 37 95 97 85 115   116   117   118   119   120   121 ... 
            73    74    75    76    77    78    79    90    91 ...
            92    93    94    95];
    rois.noisyChannels = [18:24];
    rois.surfaceChannels = rois.allChans;
    rois.goodChannels = setdiff(rois.allChans,[rois.badChannels,rois.refChannel,rois.noisyChannels]);
    
    rois.pIPS = [37 38];
    rois.amIPS = [55 56 63];
    rois.latIPS = [62];
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.goodChannels,[45 46 47 48 40 39 17 25 9 64 1 2]);
    rois.AG = intersect(rois.goodChannels,[52 53 54 60 61 ]);
    rois.TPJ = [];
    rois.SMG = [];
    rois.amb = [];
    
    rois.pSPL = [45 46 47 39 ];
    rois.aSPL = [1 2 9 17 25 40 48 64];
    
elseif strcmp(subj,'29') || strcmp(subj,'JT')
    rois.subjnum = subj;
    rois.allChans = 1:128;
    rois.refChannel = 21;
    rois.badChannels = [15,33,41,65,66,67,73,74,81,121,19,26,1,2,5,49,50,77,85,95,97];
    rois.noisyChannels = [18:20 22:24];
    rois.surfaceChannels = rois.allChans;
    rois.goodChannels = setdiff(rois.allChans,[rois.badChannels,rois.refChannel,rois.noisyChannels]);
    
    rois.pIPS = [37,38,45,113];
    rois.amIPS = [105];
    rois.latIPS = [106 107];
    rois.IPS = intersect(rois.goodChannels,[rois.pIPS rois.amIPS rois.latIPS]);
    
    rois.SPL = intersect(rois.goodChannels,[97,34,35,36,42,43,44]);
    rois.AG = intersect(rois.goodChannels,[39, 40 114   122   123]);
    rois.TPJ = intersect(rois.goodChannels,[124 125]);
    rois.SMG = intersect(rois.goodChannels,[111 112]);
    rois.amb = [];
    
    rois.pSPL = [42:44 35 36];
    rois.aSPL = [34];
end
rois.aIPS = [rois.amIPS, rois.latIPS];
rois.CARChannels = setdiff(rois.surfaceChannels,[rois.badChannels,rois.noisyChannels,rois.refChannel]);
rois.LPC = [rois.IPS rois.SPL rois.AG];
rois.other = setdiff(rois.goodChannels,rois.LPC);

return
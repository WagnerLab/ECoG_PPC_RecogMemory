function [ch subjname]  = subjchannels(subjnum)


% Patient CM
if strcmp(subjnum,'CM') || strcmp(subjnum,'04') 
    ch = [17:24, 45:64];
    subjname = 'CM';
    
 % Patient KB
elseif strcmp(subjnum,'KB')|| strcmp(subjnum,'10') 
    ch = [1:35];
    subjname = 'KB';
    
elseif strcmp(subjnum,'SRb')|| strcmp(subjnum,'16b') 
    ch = [1:61,63:64];
    subjname = 'SRb';
    
    % Patient RHb
elseif strcmp(subjnum,'RHb')|| strcmp(subjnum,'17b') 
    ch = [65:74];
    subjname = 'RHb';
   
    % Patient MD
elseif strcmp(subjnum,'MD')|| strcmp(subjnum,'18') 
    ch = [65:80];
    subjname = 'MD';
   
    % Patient RB
elseif strcmp(subjnum,'RB')|| strcmp(subjnum,'19') 
    ch = setdiff([1:112],[64:112]);
    subjname = 'RB';
    
    % Patient DZa
elseif strcmp(subjnum,'DZa')|| strcmp(subjnum,'20') 
    ch = setdiff([1:112],[1:32, 77, 89:112]);
    subjname = 'DZa';
    
    % Patient DZb
elseif strcmp(subjnum,'DZb')|| strcmp(subjnum,'20b') 
    ch = setdiff(1:96,[23, 24, 73, 74, 75, 81, 82, 83, ...
        84, 85, 89, 90, 91, 101, 105, 106]);
    subjname = 'DZb';
   
    % Patient JT
elseif strcmp(subjnum,'JT')|| strcmp(subjnum,'21') 
    ch = setdiff(1:96,[1:32, 93:96]);
    subjname = 'JT';
    
    % Patient TC
elseif strcmp(subjnum,'TC')|| strcmp(subjnum,'22') 
    ch = setdiff([74 75 76],1:73);
    subjname = 'TC';
else
    display('incorrect subject or experiment!')
    return
end
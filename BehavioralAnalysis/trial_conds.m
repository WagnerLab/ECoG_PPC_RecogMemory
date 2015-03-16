
function out = trial_conds(conds,expt)
% this function creates a struct with condition vectors depending on the
% experiment
% it takes the vector conds, with the codes for what that trials represents
% and then it groups events with the same conditions or collapeses
% conditions of interest


if strcmp(expt,'SS3') ||strcmp(expt,'SS2')
    % condition codes for memory task
    codes.all = 0:6;
    codes.HChits =1;
    codes.LChits =5;
    codes.HCcr =2;
    codes.LCcr =6;
    codes.hits = [1 5];
    codes.cr = [2 6];
    codes.misses = 3;
    codes.fa = 4;
    codes.old = [1 3 5];
    codes.new = [2 4 6];
    
    out.newtrials = logical(conds == codes.new(1) | conds == codes.new(2) |conds == codes.new(3));
    out.oldtrials = logical(conds == codes.old(1) | conds == codes.old(2) |conds == codes.old(3));
    
    out.hittrials = logical(conds == codes.hits(1) |conds == codes.hits(2));
    out.crtrials = logical(conds == codes.cr(1) |conds == codes.cr(2));
    out.HChittrials =  logical(conds == codes.HChits);
    out.LChittrials =  logical(conds == codes.LChits);
    out.HCcrtrials =  logical(conds == codes.HCcr);
    out.LCcrtrials =  logical(conds == codes.LCcr);
    
elseif strcmp(expt,'PC1')
    
    % condition codes for posner task
    codes.all = 1:6;
    codes.allcue = [1 2];
    codes.lcue = 1;
    codes.rcue =2;
    codes.ltarg =[3 4];
    codes.rtarg =[5 6];
    codes.lvtarg = 3;
    codes.lnvtarg = 4;
    codes.rvtarg = 5;
    codes.rnvtarg = 6;
    codes.alltarg = 3:6;
    codes.ntarg = 7;
    
    out.lcue = logical(conds == codes.lcue);
    out.rcue = logical(conds == codes.rcue);
    out.allcue = out.lcue | out.rcue;
    out.lvtarg = logical(conds == codes.lvtarg);
    out.rvtarg = logical(conds == codes.rvtarg);
    out.vtarg = out.lvtarg | out.rvtarg;
    out.lnvtarg = logical(conds == codes.lnvtarg);
    out.rnvtarg = logical(conds == codes.rnvtarg);
    out.nvtarg = out.lnvtarg | out.rnvtarg;
    out.alltarg = out.nvtarg | out.vtarg;
    out.ntarg = logical(conds == codes.ntarg);
    
end


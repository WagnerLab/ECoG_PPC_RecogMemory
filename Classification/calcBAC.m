function bac = calcBAC(c1,c2,aclabels,predlabels)
%input: class1, class2, actual labels, predicted labels

[~,nsh] = size(predlabels);
bac = nan(nsh,1);
for sh = 1:nsh
    
    preds = predlabels(:,sh);
    % true pos/hit
    tp = sum(preds == c1 & aclabels == c1);
    % false pos/false alarm
    fp = sum(preds == c1 & aclabels == c2);
    % false neg/miss
    fn = sum(preds == c2 & aclabels == c1);
    % true neg/cr
    tn = sum(preds == c2 & aclabels == c2);
    
    acc_class1 = tp/(tp+fn);
    acc_class2 = tn/(tn+fp);
    bac(sh) = .5*(acc_class1+acc_class2);
end
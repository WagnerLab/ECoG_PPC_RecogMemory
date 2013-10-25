function perf = class_perf_metrics(actual,predictions)
% This function goes beyond traditional accuracy to measure binary 
% classifiers  perfomance in different ways. All these measurements try to 
% summarize the confusion matrix generated from the predictions and the 
% actual label
%					|	  Actual Class
%					|	1		|	0
%	______________________________________
%	Predicted	1	|	tp		|	fp
%	Class		____|___________|_________
%				0	|	fn		|	tn
%					|			|	
%
% where: tp is true positive	/ correct result	/	hit
%		 fp is false positive	/ unexpected result /	false alarm
%		 fn is false negative	/ missing result	/	miss
%		 tn is true negative	/ corr. absence re	/	correct rejection
%
% Inputs:
%	actual:			Actual Labels (binary), assumes the higher numeric label
%					is the positve class
%	predictions:	Predicted Labels (binary)
%
% Outputs: perf is a structure with fields:
%	1) Accuracy
%		Acc			= (tp+tn)/(tp + fp + fn + tn)
%	2) F1 score: Harmonic mean between precision and recall, this is an
%	unbalanced measure(i.e. there is a class for which you care more about)
%		F1score		= 2 * Precision*Recall/(Precision+Recall)
%		Precsion	= tp/(tp + fp)
%		Recall      = fn/(fn + tn)
%	3) Matthews Correlation Coeffecient: correlation coefficient between
%	the observed and predicted binary classifications
%		MCC			= (tp*tn - fp*fn)/sqrt((tp+fp)(tp+fn)(tn+fp)(tn+fn))
%	4) Balanced Accuracy: equally weights the means of hit rate and cr rate
%		BAC			= 0.5*(hit_rate) + 0.5*(cr_rate)
%		hit_rate	= tp/(tp+fn)
%		cr_rate		= tn/(fp+tn)
%	5) dPrime: Assumes normal distributions for each class and provides a
%	meaure of signal separation using the means of the signals and the
%	noise distribuition
%		d'			= Z(hit_rate) - Z(false_alarm_rate)
%		Z(p)		= norminv(p,0,1); inverse cdf for the normal distrib.
%	6) Area under ROC curve: area under fraction of tp vs fp
%		AUC			= Calculated from Matlab's perfcurve function
%	7) Complete confusion matrix
%	8) Accuracy for class1
%	9) Number of observations for class1
%   10) Accuracy for class2 
%	11) Number of observations for class2 
%
%	Example:
%	x = randn(100,1);
%	y = x + 0.4*randn(100,1);
%	perf = class_perf_metrics(x>0.5,y>0.5);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Alex Gonzalez						
%	Stanford Memory Lab					
%	Last Edited:  June 11, 2012			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

perf = [];
perf.acc = [];		% accuracy
perf.F1score = [];	% f1 score
perf.mcc = [];		% matthews correlation coefficient
perf.bac = [];		% balanced accuracy
perf.dP = [];		% d'
perf.AUC = [];		% area under roc curve
perf.ConfMat = [];  % confusion matrix

% get labels from labels
classlabels = unique(actual);

if numel(classlabels)~=2 
	error('Only binary classification supported')
end

class1 = classlabels(2); % highest numeric label and positive class
class2 = classlabels(1);

% number of observations
Nclass1 = sum(actual==class1);
Nclass2 = sum(actual==class2);
N		= Nclass1 + Nclass2;

% true pos/hit
tp = sum(predictions == class1 & actual == class1);  
% false pos/false alarm
fp = sum(predictions == class1 & actual == class2);  
% false neg/miss
fn = sum(predictions == class2 & actual == class1);   
% true neg/cr
tn = sum(predictions == class2 & actual == class2);  

% Precision and Recal calculations
Precision = tp/(tp+fp);
Recall = tp/(tp+fn);

% accuracy and number of observations for class1
perf.acc_class1 = tp/(tp+fn);
perf.Nclass1 = Nclass1;

% accuracy and number of observations for class2
perf.acc_class2 = tn/(tn+fp);
perf.Nclass2 = Nclass2;

% calculate overall accuracy
perf.acc = (tp+tn)/N;

% calculate matthews correlation coefficient:
perf.mcc = (tp*tn-fp*fn)/(sqrt((tp+fp)*(tp+fn)*(tn+fn)*(tn+fn)));

% calculate f1 score
perf.F1score = 2*Precision*Recall/(Precision+Recall);

% calculate balanced accuracy
perf.bac = .5*(perf.acc_class1+perf.acc_class2);

% calculate d'
hitrate = perf.acc_class1;
farate = 1-perf.acc_class2;

% calculate confusion matrix
perf.ConfMat = confusionmat(double(actual),double(predictions),'order',double([class1 class2]))';

% calculate area under roc curve:
% check that classification isn't completely bias to one class, auc is 0
if (hitrate == 0) || (farate == 1)
	perf.AUC = 0;
else
	[~,~,~,perf.AUC] = perfcurve(double(actual),double(predictions),double(class1));
end

% check that inputs are not ill define for norminv, and correct otherwise
if (hitrate == 0);	hitrate = 1/Nclass1;	end
if (farate == 0);	farate = 1/Nclass2;		end
if (hitrate == 1);	hitrate = 1-1/Nclass1;	end
if (farate == 1);	farate = 1-1/Nclass2;	end

perf.dP = norminv(hitrate,0,1) - norminv(farate,0,1);

return

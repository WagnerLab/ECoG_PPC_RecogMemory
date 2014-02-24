function CVerr = cvglmnet2(x,y,nfolds,foldid,type,family,options,verbous)
% Do crossvalidation of glmnet model. The coordinate descent algorithm
% chooses a set of lambda to optimize over based on the input given in
% the options struct.Parameter tuning should be done in such a way that for
% a fixed alpha, a set of lambda values are evaluated. Basically it does
% not matter if lambda corresponds across alpha values, as each cv-plot
% should inspected seperatly.
% So e.g. to find optimal tuning parameters, fit a total of 10 alpha
% values, beeing alpha = 0:0.1:1.lambdas will then be chosen according to
% the specific alpha.
% Call: CVerr = cvglmnet(x,y,nfolds,foldid,type,family,options,verbous)
% Example:
% x=randn(100,2000);
% y=randn(100,1);
% g2=randsample(2,100,true);
% CVerr=cvglmnet(x,y,100,[],'response','gaussian',glmnetSet,1);
% CVerr=cvglmnet(x,g2,100,[],'response','binomial',glmnetSet,1);
% x         : Covariates
% y         : Response (For now only elastic net = continous data supported
% nfolds    : How many folds to evaluate. nfolds = size(x,1) for LOOCV
% foldid    : Possibility for supplying own folding series. [] for nothing
% type      : Used in the glmnetPredict routine. (Now only "response" works)
% family    : Used in glmnet routine. (Now only "gaussian" and "binomial" work)
% options   : See function glmnetSet()
% verbous   : Print model plot
%
% Written by Bjørn Skovlund Dissing (27-02-2010)
%
% Edited by Alex Gonzalez (June 11, 2012)
% opts.permetric:input allows to find the best lambda for the specified
%			performance criterion. depends on function class_perf_metrics
%			possible inputs: 'bac','acc','AUC','F1score','mcc','dP' and
%			other, check class_perf_metrics for more.
% edited A.gonzl Apr 8. 2013.use only bac for performance

glmnet_object = glmnet(x, y, family,options);
options.lambda = glmnet_object.lambda;
options.nlambda = length(options.lambda);
N = size(x,1);
perfmetric = options.perfmetric;

if (isempty(foldid))
	foldid = randsample([repmat(1:nfolds,1,floor(N/nfolds)) 1:mod(N,nfolds)],N);
else
	nfolds = max(foldid);
end
predmat = glmnetPredict(glmnet_object, type,x, options.lambda);

for i=1:nfolds
	which=foldid==i;
	if verbous, disp(['Fitting fold # ' num2str(i) ' of ' num2str(nfolds)]);end
	cvfit = glmnet(x(~which,:), y(~which),family, options);
    if cvfit.jerr==-1
        nlms = options.nlambda;
        cvfit.a0 = rand(1,nlms)-0.5;
        cvfit.beta = rand(size(x,2),nlms)-.05;
        cvfit.lambda = options.lambda;
    end
	predmat(which,:) = glmnetPredict(cvfit, type,x(which,:),options.lambda);
end
yy=repmat(y,1,length(options.lambda));
if strcmp(family,'gaussian')
	cvraw=(yy-predmat).^2;
elseif strcmp(family,'binomial')
	if     strcmp(type,'response')
		cvraw=-2*((yy==2).*log(predmat)+(yy==1).*log(1-predmat));
	elseif strcmp(type,'class')
		
		% for each lambda calculate perfomance structure:
% 		for l = 1:options.nlambda
% 			perf(l) = class_perf_metrics(y,predmat(:,l));            
%         end
        perf = calc_bac(2,1,y,predmat)';
		cvraw=double(yy~=predmat);
	end
elseif strcmp(family,'multinomial')
	error('Not implemented yet')
end


if strcmp(type,'class') && exist('perfmetric','var')
	% change to find accuracy instead of error.
	CVerr.perfmetric = perfmetric;
	CVerr.perf = perf;
	CVerr.cvm = perf;%[perf.(perfmetric)];
	% if there are several maxima, choose largest lambda of the largest cvm
	CVerr.lambda_min=max(options.lambda(CVerr.cvm>=max(CVerr.cvm)));
	
else
	%glmnet defaults
	CVerr.cvm=mean(cvraw);
	% if there are several minima, choose largest lambda of the smallest cvm
	CVerr.lambda_min=max(options.lambda(CVerr.cvm<=min(CVerr.cvm)));
	
end

% only makes sense for perfmetric acc
CVerr.stderr = sqrt(var(cvraw)/N);
CVerr.cvlo=CVerr.cvm-CVerr.stderr;
CVerr.cvup=CVerr.cvm+CVerr.stderr;

%Find stderr for lambda(min(sterr))
semin=CVerr.cvup(options.lambda==CVerr.lambda_min);

% find largest lambda which has a smaller mse than the stderr belonging to
% the largest of the lambda belonging to the smallest mse
% In other words, this defines the uncertainty of the min-cv, and the min
% cv-err could in essence be any model in this interval.
CVerr.lambda_1se=max(options.lambda(CVerr.cvm<semin));

CVerr.glmnetOptions=options;
CVerr.glmnet_object = glmnet_object;
if verbous, cvglmnetPlot(CVerr);end


function bac = calc_bac(c1,c2,aclabels,predlabels)
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
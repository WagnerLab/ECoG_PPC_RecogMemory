
function params = getClassificationParams(tooboxNum)
% script to set classification parameters

params = [];
params.nFolds               = 10; % number of XVal folds
ClassificationToolboxes     = {'liblinear','libsvm','glmnet','NNDTW'};
params.toolbox              = ClassificationToolboxes{tooboxNum};
params.options              = getClassifierOpts(params.toolbox);
params.normalizeTrials      = false; % normalize data/zscore each sample
params.normalizeFeatures    = false; % normalize data/zscore each feature
params.nTestShuffles        = 1e2; % number of permutation test on shuffle labeled data.
params.featSelect           = '';% {'','svd'} feature selection method options are 
params.bootStrapData        = 'boot'; % bootstrap data such that it is balanced.

% summary string with all selected options
params.extStr = params.options.solverStr;

if strcmp(params.featSelect,'pca')
    params.varexp = 0.99; 
end
if strcmp(params.bootStrapData,'boot')
    params.nBoots       = 100; % number of bootstrap iterations
    params.PctTrials    = 0.99;  % percentage of trials to be included in each bootstrap sample
end

function opts = getClassifierOpts(toolbox)
% get classifications options for a specific toolbox
opts = [];
switch toolbox
    case 'liblinear'
        addpath lib/liblinear-1.93/
        opts.CParamSet      = 0.01;%10.^(-4:0.5:3);%2.^(-10:2:10); % parameter search space
        opts.EParamSet      = [0.01 1 100];%2.^(-10:2:10); % parameter search space
        opts.paramFolds     = 5; % # folds for CV on parameter selection
        opts.solver_type    = '0'; % solver for liblinear
        opts.solverStr      = [toolbox 'S' opts.solver_type];
        opts.trainOpts      = ['-q -s ' opts.solver_type ' -B 1']; % training options
        opts.predictOpts    = '-b 1'; % test options
    case 'libsvm'
        addpath lib/libsvm-3.11/
        opts.Param1Set      = 2.^(-5:3:12); % C param set
        opts.Param2Set      = 2.^(3:-3:-12); % gamma set
        opts.solver_type    = '01'; % first digit is the solver, second is the kernel
        opts.solverStr      = [toolbox 'S' opts.solver_type];
        opts.paramFolds     = 2; % xval for parameter selection
        opts.predictOpts    = [];
        opts.trainOpts      = ['-q -s ' num2str(opts.solver_type(1)) ' -t ' ...
            num2str(opts.solver_type(2))];
        % set degree of polynomial/ quadratic if 
        if strcmp(opts.solver_type(2),'1')
            opts.trainOpts = [opts.trainOpts ' -d 2 '];
        end        
        opts.trainOpts = [opts.trainOpts '-c '];
    case 'glmnet'
        addpath lib/glmnet_matlab
        opts                = glmnetSet; % glmnet
        opts.alpha          = 0.8; % L2-L1 parameter
        opts.lambda         = 10.^(-8:0);
        opts.maxit          = 20; % max number of iterations
        opts.thresh         = 0.01;
        opts.standardize    = false;
        opts.perfmetric     = 'bac';
        opts.solver_type    = ['a' strrep(num2str(opts.alpha),'.','p')];
        opts.solverStr      = [toolbox 'S' opts.solver_type];
        opts.paramFolds     = 4;  % lambda parameter selection fold
    case 'NNDTW'
        opts                = [];
        opts.Kparam         = 1; % number of nearest neighbors        
        opts.maxDistParam   = 20; % maxium distorition allowed on DTW, (w param)
        
        opts.filterData     = false;
        
        if opts.filterData
            % assumption that sampling rate is *436*
            opts.filterOrder    = 10;
            opts.LPCutOff       = 30;
            opts.LP             = fir1(opts.filterOrder, opts.LPCutOff*2/436,window(@hann,opts.filterOrder+1));
            opts.downRate       = 1; % downsampling rate
        end        
        
        opts.solverStr      = [toolbox 'K' num2str(opts.Kparam)]; 
    otherwise
        error ('Toolbox not found')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% liblinear options
% -s type : set type of solver (default 1)
% 	0 -- L2-regularized logistic regression (primal)
% 	1 -- L2-regularized L2-loss support vector classification (dual)
% 	2 -- L2-regularized L2-loss support vector classification (primal)
% 	3 -- L2-regularized L1-loss support vector classification (dual)
% 	4 -- multi-class support vector classification by Crammer and Singer
% 	5 -- L1-regularized L2-loss support vector classification
% 	6 -- L1-regularized logistic regression
% 	7 -- L2-regularized logistic regression (dual)
% -c cost : set the parameter C (default 1)
% -e epsilon : set tolerance of termination criterion
% 	-s 0 and 2
% 		|f'(w)|_2 <= eps*min(pos,neg)/l*|f'(w0)|_2,
% 		where f is the primal function and pos/neg are # of
% 		positive/negative data (default 0.01)
% 	-s 1, 3, 4 and 7
% 		Dual maximal violation <= eps; similar to libsvm (default 0.1)
% 	-s 5 and 6
% 		|f'(w)|_1 <= eps*min(pos,neg)/l*|f'(w0)|_1,
% 		where f is the primal function (default 0.01)
% -B bias : if bias >= 0, instance x becomes [x; bias]; if < 0, no bias term added (default -1)
% -wi weight: weights adjust the parameter C of different classes (see README for details)
% -v n: n-fold cross validation mode
% -q : quiet mode (no outputs)
% col:
% 	if 'col' is setted, training_instance_matrix is parsed in column
% 	format, otherwise is in row format


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% libsvm options
%  "Usage: model = svmtrain(training_label_vector, training_instance_matrix, 'libsvm_options');\n"
% 	"libsvm_options:\n"
% 	"-s svm_type : set type of SVM (default 0)\n"
% 	"	0 -- C-SVC\n"
% 	"	1 -- nu-SVC\n"
% 	"	2 -- one-class SVM\n"
% 	"	3 -- epsilon-SVR\n"
% 	"	4 -- nu-SVR\n"
% 	"-t kernel_type : set type of kernel function (default 2)\n"
% 	"	0 -- linear: u'*v\n"
% 	"	1 -- polynomial: (gamma*u'*v + coef0)^degree\n"
% 	"	2 -- radial basis function: exp(-gamma*|u-v|^2)\n"
% 	"	3 -- sigmoid: tanh(gamma*u'*v + coef0)\n"
% 	"	4 -- precomputed kernel (kernel values in training_instance_matrix)\n"
% 	"-d degree : set degree in kernel function (default 3)\n"
% 	"-g gamma : set gamma in kernel function (default 1/num_features)\n"
% 	"-r coef0 : set coef0 in kernel function (default 0)\n"
% 	"-c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)\n"
% 	"-n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)\n"
% 	"-p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)\n"
% 	"-m cachesize : set cache memory size in MB (default 100)\n"
% 	"-e epsilon : set tolerance of termination criterion (default 0.001)\n"
% 	"-h shrinking : whether to use the shrinking heuristics, 0 or 1 (default 1)\n"
% 	"-b probability_estimates : whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)\n"
% 	"-wi weight : set the parameter C of class i to weight*C, for C-SVC (default 1)\n"
% 	"-v n : n-fold cross validation mode\n"
% 	"-q : quiet mode (no outputs)\n"

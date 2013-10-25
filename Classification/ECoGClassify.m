
function out = ECoGClassify(S)
% some important variables throught the code
% X         =  all data: training and test
% Y         =  classification labels
% N         =  number of trials
% P         =  number of features / predictors
% nFolds    =  number of XVal folds

% AG. last update Sept 23, 2013 -- nearest neighbor dtw decoder

% dependencies:
%   balancedCVfoldsIdx 
%   toolboxes
%   

X = S.X;
Y = double(S.Y);
% make labels 1 and -1:
% assumes label come in as 1 for POS class, -1 for NEG class
Y(Y==0) = -1;

N = numel(Y);
P = size(X,2);

out             = [];
out.settings    = S.classificationParams;
nFolds          = out.settings.nFolds;
toolbox         = out.settings.toolbox;

testIdx         = balancedCVfoldsIdx(Y,nFolds);
out.testIdx     = testIdx;

switch toolbox
    case 'liblinear'
        X           = sparse(X);
        weights     = NaN(nFolds,P+1);  % linear classifier weights
        optParam    = NaN(nFolds,1); % optimal fold parameter
        predcell    = cell(nFolds,1);
        
        opts        = out.settings.options;
        solver      = opts.solver_type;
        Cparams     = opts.CParamSet;
        nCparams    = numel(Cparams);
        Eparams     = opts.EParamSet;
        nEparams    = numel(opts.EParamSet);        
        paramFolds  = opts.paramFolds;
        trainOpts   = opts.trainOpts;
        
        % determine termination criterion        
        m = zeros(nEparams,1);
        for er = 1: nEparams
            m(er) = train(Y, X,['-s 0 -q -c ' num2str(size(X,2)) ' -e ' num2str(Eparams(er)) ' -v 10']);
        end
        [~,id] = max(m);
        terCrit = Eparams(id);
        clear m;
        
        parfor fold = 1:nFolds
            trainIdx = testIdx~=fold;
            
            % hyper parameter selection; using an inner cross validation
            m = NaN(nCparams,1);
            for pr = 1:nCparams
                %optionsSet = [trainOpts ' -c ' num2str(params(pr))];
                %m(pr) = do_binary_cross_validation2(Y(trainIdx), X(trainIdx,:), optionsSet,paramFolds);
                optionsSet  = [trainOpts ' -c ' num2str(Cparams(pr)) ' -v ' num2str(paramFolds) ' -e ' num2str(terCrit)];
                m(pr)       = train(Y(trainIdx), X(trainIdx,:), optionsSet);
            end
            
            grid_maxc_idx   =   find(m==max(m(:)));
            maxc            =   Cparams(grid_maxc_idx(1));
            
            % search around best found parameters in the grid search
            % function, search for min...            
%             f = @(params) (1-do_binary_cross_validation(Y(trainIdx),  X(trainIdx,:), ...
%                 [trainOpts '-c ' num2str(maxc)], paramFolds));
%             maxc = fminsearch(@(params) f(params),maxc);
                        
            optParam(fold)= maxc;
            
            % Final Model for fold
            model = train(Y(trainIdx), X(trainIdx,:), [trainOpts ' -c ' num2str(maxc) ' -e ' num2str(terCrit)]);
            weights(fold,:) = model.w;
            
            % Prediction/Test for fold            
            [~,~,prob_pred] = predict(Y(~trainIdx), X(~trainIdx,:), model,'-b 1');         
            predcell{fold} = prob_pred(:,1);
        end
        
        % rearange  test prediction into their actual index locations
        probEst = nan(N,1);
        for fold =1:nFolds
            probEst(testIdx==fold) = predcell{fold};
        end
        if strcmp(solver, '0')
            probEst = probEst -0.5;
        end
        predictions = probEst>0;
        % if classifier guess in the trial, assign randomly to the classes
        if sum(probEst==0)>0
            nBadtrials = sum(probEst==0);
            predictions(probEst==0) = rand(nBadtrials,1) > 0.5;
        end        
        
        % store output data
        out.predictions = predictions;
        out.probEst     = probEst;
        out.weights     = weights;
        out.optParam    = optParam;
        out.terCrit     = terCrit;   
    case 'libsvm'
        
        optParam1   = NaN(nFolds,1);
        optParam2   = NaN(nFolds,1);
        predcell = cell(nFolds,1);
        
        opts            = out.settings.options;
        params1         = opts.Param1Set;
        params2         = [opts.Param2Set 1/P]; % add 1/P to the gamma search space
        opts.GammaSet   = params2;
        
        paramFolds  = opts.paramFolds;
        trainOpts   = opts.trainOpts;
        parfor fold = 1:nFolds
            trainIdx = testIdx~=fold;
            
            % hyper parameter selection; using an inner fold 3cross validation
            m = NaN(numel(params1),numel(params2));
            for pr1 = 1:numel(params1)
                for pr2 = 1:numel(params2);
                    optionsSet = [trainOpts num2str(params1(pr1)) ' -g ' num2str(params2(pr2))];
                    m(pr1,pr2) = do_binary_cross_validation(Y(trainIdx), X(trainIdx,:), optionsSet, paramFolds );
                end
            end
            
            [i,j]=find(m==max(m(:)));
            maxc = params1(i(1));
            maxgam = params2(j(1));
            
            optParam1(fold) = maxc;%params(1);
            optParam2(fold) = maxgam;%params(2);
            
            optionsSet = [trainOpts num2str(maxc) ' -g ' num2str(maxgam)];
            % Final Model for fold
            model = svmtrain(Y(trainIdx), X(trainIdx,:), optionsSet);
            % Prediction/Test for fold
            pred = do_binary_predict(Y(~trainIdx), X(~trainIdx,:), model);
            predcell{fold} = pred;
        end
        
        predictions = NaN(N,1);
        for fold =1:nFolds
            predictions(testIdx==fold) = predcell{fold};
        end
        out.predictions = predictions;
        out.optParam1 = optParam1;
        out.optParam2 = optParam2;
    case 'glmnet'
        
        opts = out.settings.options;
        nParams     = numel(opts.lambda);
        
        predcell    = cell(nFolds,1);
        betas       = zeros(nFolds,P);
        betasPath   = zeros(nFolds,nParams,P);
        a0          = zeros(nFolds,1);
        minlambdas  = zeros(nFolds,1);
        mL_id       = zeros(nFolds,1);
        paramFolds  = opts.paramFolds;
        
        parfor fold = 1:nFolds
            trainIdx    = testIdx~=fold;
            m           = cvglmnet2(X(trainIdx,:),(Y(trainIdx)==1)+1,paramFolds,[],'class','binomial',opts,0);
            
            % get the best one and retrain on the whole training set            
            minlambdas(fold)    = m.lambda_min; mL_id(fold) = find(m.glmnet_object.lambda==m.lambda_min);
            
            betasPath(fold,:,:) = m.glmnet_object.beta';
            betas(fold,:)       = m.glmnet_object.beta(:,mL_id(fold));
            a0(fold)            = m.glmnet_object.a0  (mL_id(fold));
            predcell{fold}      = glmnetPredict(m.glmnet_object, 'response', X(~trainIdx,:), minlambdas(fold));
        end
        
        probEst = NaN(N,1);
        for fold =1:nFolds
            probEst(testIdx==fold) = predcell{fold};
        end
        probEst = probEst -0.5;
        
        predictions = probEst > 0;
        
        % if classifier guess in the trial, assign randomly to the classes
        if sum(probEst==0)>0
            nBadtrials = sum(probEst==0);
            predictions(probEst==0) = rand(nBadtrials,1) > 0.5;
        end
        
        out.mL_id       = mL_id;
        out.predictions = predictions;
        out.probEst     = probEst;
        out.weights     = [betas a0];
        out.optParam    = minlambdas;
        out.betasPath   = squeeze(median(betasPath)); 
    case 'NNDTW'
                               
        opts        = out.settings.options;        
        Knn         = opts.Kparam;          % number of nearest neighbors
        maxDist     = opts.maxDistParam;    % maximum distortion on dtw (w param)
        
        func        = @(x,y)applyDTW_c(x,y,maxDist);
        if opts.filterData
            LP = opts.LP;
            X = applyFilter(LP,X);
            X = X(:,1:opts.downRate:end);            
        end
        
        votecell = cell(nFolds,1);
        predcell = cell(nFolds,1);
        parfor fold = 1:nFolds
            trainIdx = find(testIdx~=fold);
            
            bestMatches = knnsearch(X(trainIdx,:),X(testIdx==fold,:),'distance',func,'K',Knn);
                    
            votecell{fold} = sum(Y(trainIdx(bestMatches)),2);
            predcell{fold} = median(Y(trainIdx(bestMatches)),2);
        end
        
        % rearange  test prediction into their actual index locations
        probEst = nan(N,1);
        predictions = probEst;
        for fold =1:nFolds
            probEst(testIdx==fold) = votecell{fold};
            predictions(testIdx==fold) = predcell{fold};
        end
        % if classifier guess in the trial, assign randomly to the classes
        if sum(probEst==0)>0
            nBadtrials = sum(probEst==0);
            predictions(probEst==0) = rand(nBadtrials,1) > 0.5;
        end        
        
        % store output data
        out.predictions = predictions;
        out.probEst     = probEst;
        out.weights     = nan;
        
    otherwise
        error('classification toolbox not found')
end
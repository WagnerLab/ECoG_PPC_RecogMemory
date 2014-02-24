function [prob_est_cell,Y,TestIndx] = cvglmnet_batch_folds_shuffle(X,Yorig,opts,nfolds,lambdafolds)


N = size(X,1);
TestIndx = crossvalind('Kfold',N, nfolds);
Y = shuffle(Yorig);
prob_est_cell = cell(nfolds,1);

parfor fold = 1:nfolds
    fprintf([' ' num2str(fold)])
    
    trainIdx = TestIndx~=fold;
    testIdx = TestIndx==fold;
    
    TrainX =  X(trainIdx,:);
    TrainY =  Y(trainIdx);
    TestX = X(testIdx,:);
    
    m = cvglmnet2(TrainX,(TrainY==1)+1,lambdafolds,[],'class','binomial',opts,0);
    prob_est_cell{fold} = glmnetPredict(m.glmnet_object, 'response', TestX,m.lambda_min);
    
end


end
function testIdx = balancedCVfoldsIdx(Y,nFolds)
% outputs a vector of CV indices that is balanced for each condition
% inputs: 
% Y = vector of labels; assumes POS class > NEG class in value 
% nFolds = number of cross validation folds

N = numel(Y);
testIdx = zeros(N,1);

classes = sort(unique(Y),'descend');

for i =  1:numel(classes)
    f = crossvalind('Kfold', sum(Y==classes(i)), nFolds);
    testIdx(Y==classes(i)) = f;
end

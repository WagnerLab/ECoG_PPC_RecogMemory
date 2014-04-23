
load('/Users/alexg8/Documents/ECOG/Results/Spectral_Data/subj16b/BandPassedSignals/BandPasshgamnonLPCleasL1TvalCh1027-May-2013.mat')
t = 4;

SR = data.SR;
bands = zeros(length(t),2);

for i = t
    bands(i,:) = [5 6];
    
    lp = bands(i,2);
    hp = bands(i,1);
    
    amp = zeros(size(data.amp));
    phase = zeros(size(data.amp));
    
    X = 20*log10(data.amp);
    X = bsxfun(@minus,X,mean(X,2));
    parfor ch = 1:10
        channel = num2str(ch);
        display(['Prossesing Channel ' channel])
        x = X(ch,:);
        [amp(ch,:),phase(ch,:)] = compAnalyticSignal(x, lp, hp,SR);        
    end
end


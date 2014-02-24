% timeseries adaptive zscoring, for non-stationary signals
function [out,win_mean,win_std] = ts_adaptivezscore(varargin)
% inputs:
% (1) in:       (1d vector of samples) input signal
% (2) wl:       (# samples) window length in samples
% (3) sld_wl:   (# samples) slding window length in samples
%
% outputs:
% (1) out:      (1d vector of samples) output signal
% (2) win_mean: (1d vector) window means
% (3) win_std:  (1d vector) window standard deviation
%
% Alex Gonzalez
% Stanford Memory Lab
% Nov 28, 2012

x = varargin{1};
nsamps = numel(x);
samps = 1:nsamps;

% defaults
if nargin < 2
    wl = nsamps/100;
    sld_wl = wl;
else
    wl = varargin{2};
    sld_wl = varargin{3};
end

% linear detrending of mean
x = detrend(x,'linear');

if sld_wl==wl
    % determine the sample index in windows
    win_edges = 0:wl:nsamps+wl;
    nwindows  = numel(win_edges)-1;
    [~,samp_win_idx]= histc(samps-.01,win_edges);

    % zscore each window
    win_std = zeros(nwindows,1);
    win_mean = zeros(nwindows,1);
    for w = 1:nwindows
        idx = samp_win_idx==w;
        win_mean(w) = mean(x(idx));
        x(idx) = x(idx) - win_mean(w);
        win_std(w) = std(x(idx));
        x(idx) = x(idx)/win_std(w);
    end
else
    % determine the sample index in windows
    win_start_edges = 0:sld_wl:nsamps;
    win_end_edges = wl:sld_wl:nsamps+wl;
    win_edges = [win_start_edges;win_end_edges]';
    
    % zscore the signal in each window and take mean of overlap
    nwindows = size(win_edges,1);
    win_std = zeros(nwindows,1);
    win_mean = zeros(nwindows,1);
    Xsp = spalloc(nwindows,nsamps,wl*nwindows); % sparse representation
    for w = 1:nwindows;
        idx = find((samps>win_edges(w,1)) & (samps<=win_edges(w,2)));
        win_mean(w) = mean(x(idx));
        win_std(w) = std(x(idx));
        Xsp(w,idx) = (x(idx) - win_mean(w))/win_std(w);
    end
    % take mean of non-zero entries (assumes prob(signal=0)==0)
    x = full(sum(Xsp,1)./sum(Xsp~=0,1)); 
end

out = x(:);

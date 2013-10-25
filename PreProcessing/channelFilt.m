function dataout = channelFilt(data,fs,flow,fhigh,notch)
% dataout = ecogfilt(data,fs,flow,fhigh,notch)
% This function filters channel data with the given parameters. The method
% of filtering is using FIR filter that use hanning windows. Output is
% return as single precission. 
% inputs: 
%   data    -> (number of Channels) x (number of Samples) data matrix
%   fs      -> sampling frequency in samples/s
%   flow    -> low pass cut off frequency
%   fhigh   -> high pass cut off frequency
%   notch   -> notch frequency%
%   (note that flow>fhigh)
%
% outputs:
%   dataout -> filtered channels (same size as data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% channel Filtering
% Author: Alex Gonzalez
% Stanford Memory Lab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% quick input checking (need to generalize and use varargin...)
if exist('flow','var') && exist('fhigh','var')
    if fhigh > flow
        error('High pass cut-off is higher than the low-pass cut off')
    end
end

%conversion to normalized frequency
freqconv  = 2/fs;

% filter order
N = 1000;
Nhp = N*2; % double for high pass

%% create filter for high pass
% uses interpolated FIR filter
if exist('fhigh','var')
    if ~isempty(fhigh)
        f0 = fhigh*freqconv;
        hp=fir1(Nhp,f0,'high',window(@hann,Nhp+1));
    else
        hp =[];
    end
else
    hp =[];
end
%% create filter for low pass
% uses FIR least squares filter
if exist('flow','var')
    if ~isempty(flow)
        f0 = flow*freqconv;
        lp = fir1(N,f0,window(@hann,N+1));
    else
        lp =[];
    end
else
    lp =[];
    
end
%% create filter for notch filter
% uses FIR least squares filter
if exist('notch','var')
    if ~isempty(notch)
        f0 = notch*freqconv;        
        h = fir1(N,f0,window(@hann,N+1));
        nf = 2*h - ((0:N)==(N/2));
    else
        nf = [];
    end
else
    nf = [];
end
%% use filtfilt with fir filters for now phase effects

% assume data is by row
n = size(data,1);
dataout = zeros(size(data));

for i = 1:n
    
    x = double(data(i,:));
    %highpass
    if ~isempty(hp)
        x = filtfilt(hp,1,x);
    end
    % lowpass
    if ~isempty(lp)
        x = filtfilt(lp,1,x);
    end
    % notch
    if ~isempty(nf)
        x = filtfilt(nf,1,x);
    end
    dataout(i,:) = single(x);
    
end

return



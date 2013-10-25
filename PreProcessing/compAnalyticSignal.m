
function [amp ph] = compAnalyticSignal(data, lowpass, hipass, SR)
% bandpass filter and calculate the analytic signal
% data is a signal vector
% amp is the amplitude of the analytic signal
% ph is the phase of the analytic signal
% dependencies channelFilt.m

data = channelFilt(data,SR,lowpass,hipass);

% calculate the analytic signal
data = hilbert(data);

% calcualte the magnitude
amp = abs(data);
ph = angle(data);







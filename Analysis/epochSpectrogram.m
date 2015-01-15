function out = epochSpectrogram(dataMat,epochSampleMarkers, epochLimits)
% Auxiliary function that takes in a spectrogram data matrix and
% epochs it into 'trials'. 
%
% inputs: 
% 	dataMat = 3D arrray containing spectogram for multiple channels
% 			First Dim  	-> Channels
%			Second Dim 	-> Center Frequencies
% 			Third Dim 	-> Time
%	epochSampleMarkers = 1D integer vector indicating the samples at 
%						which the center of the epoch
%	epochLimits = 2 element vector indicating how many samples 
% 				before and after the center should be stored
% outputs:
% 		out = 4D array containing epoched spectrograms
% 			First Dim  	-> Channels
%			Second Dim 	-> Center Frequencies
% 			Third Dim 	-> Epochs
% 			Fourth Dim 	-> Time

nChans = size(dataMat,1);
nFreqs = size(dataMat,2);
nTimeP = size(dataMat,3);

nTrials = numel(epochSampleMarkers);
epochLength = epochLimits(2)-epochLimits(1);

out = zeros(nChans,nFreqs,nTrials,epochLength);

for iTrial = 1:nTrials
	samps = (epochSampleMarkers(iTrial)+epochLimits(1)):...
		(epochSampleMarkers(iTrial)+epochLimits(2));
	out(:,:,iTrial,:) = dataMat(:,:,samps);
end

return
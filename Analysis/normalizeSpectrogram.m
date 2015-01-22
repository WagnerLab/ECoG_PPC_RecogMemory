function [data,avgChanPower] = normalizeSpectrogram(data)
% Auxiliary function that takes in a spectrogram data matrix and
% normalizes it by the mean power in each channel (by band).
%
% inputs: 
% 	dataMat = 3D arrray containing spectogram (power in V^2/Hz) for multiple channels
% 			First Dim  	-> Channels
%			Second Dim 	-> Center Frequencies
% 			Third Dim 	-> Time
%
% outputs:
% 		out = 3D array with same dimensions as the input.
% 			the output is now normalized to the mean power in each band.


avgChanPower    = mean(data,3);
nChans 			= size(data,1);
nFreqs 			= size(data,2);

for iChan = 1:nChans
	for iFreq = 1:nFreqs
		data(iChan,iFreq,:) = data(iChan,iFreq,:)/avgChanPower(iChan,iFreq);
	end
end


return

function [TimeMarkers,Samps,Errors] = matchSampsToTime(origTimeMarkers,Time)

% this function finds the closest sample that matches origTimeMarkers to Time.

nMarkers=  numel(origTimeMarkers);

Samps 		= zeros(nMarkers,1);
Errors      = zeros(nMarkers,1);

for iM = 1:nMarkers
	[Errors(iM),Samps(iM)]=min(abs(origTimeMarkers(iM)-Time));        
end

TimeMarkers = Time(Samps);



function map = cMapGenerate(Colors,levels)
% colors, 3 element vector
%   positive color
%   negative color
%   neutral color
% levels, 4 element vector for linear scaling
% example:
%   levels = [-3 -2; 2 2; 2 3];
%   implies negColor to neutral and neutral to poscolor

nPoints = 1000;
%nLevels = size(levels,1);
nLevels = length(levels);
map = [];
%dL =levels(:,2)-levels(:,1);
dL = diff(levels);
y=floor(dL/sum(dL)*nPoints);

for i = 1:nLevels-1
    %nLevelPts = floor(mean(y([i i+1])));
    nLevelPts=y(i);
    map = [map;
        linspace(Colors(i,1),Colors(i+1,1),nLevelPts)' ...
        linspace(Colors(i,2),Colors(i+1,2),nLevelPts)' ...
        linspace(Colors(i,3),Colors(i+1,3),nLevelPts)'];
end

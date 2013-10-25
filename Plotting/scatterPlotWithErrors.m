function ha = scatterPlotWithErrors(M1,M2,varargin)
% ha = scatterPlotWithErrors(M1,M2,c,lim,refs)
%
% M1, M2 -> are the data matrices are N x 2;
% the centers should be in the first column, and the error deviation in the
% second.
% M1 and M2 must have the same number of rows (N), and 2 columns
% optional inputs in order:
% c = N x 3 matrix of colors for each point (default black)
% lim = 2 x 2 matrix of limits for the scatter plot (defaults to data limits)
%       first row is x limits, second row y limits
% ref = reference lines: a 3 x 1 vector indication the reference for the
%       x axis and y axis, the third input is a flag indicating that a
%       diagonal x = y line should be drawn
%       example:
%       ref = [0.5 0.6 0]
%       vertical line at x = 0.5;   horizontal line at y = 0.6,
%

N = size(M1,1);
if N ~= size(M2,1)
    error ('M1 and M2 have a different number of rows')
end

nOptInputs = numel(varargin);
if nOptInputs < 1
    c = zeros(N,3,'single');
end
if nOptInputs >= 1
    c = varargin{1};
    if (N ~= size(c,1)) || (size(c,2) ~= 3)
        warning('invalid color input, using black for the points')
        c = zeros(N,3,'single');
    end
end
if nOptInputs >= 2
    xLims = varargin{2}(1,:);
    yLims = varargin{2}(2,:);
else
    % x axis limits
    ma = M1(:,1);
    msd = max(M1(:,2));
    xLims = [min(ma)-msd max(ma)+msd];
    % y axis limits
    ma = M2(:,1);
    msd = max(M2(:,2));
    yLims = [min(ma)-msd max(ma)+msd];
end

ha = gca;
xlim(xLims); ylim(yLims)

if nOptInputs >=3
    xRef = varargin{3}(1);
    yRef = varargin{3}(2);
    dRef = varargin{3}(3);
    
    h=refline(0,yRef); set(h,'Color','k','lineWidth',2,'linestyle','--')
    h=plot([xRef xRef],ylim); set(h,'Color','k','lineWidth',2,'linestyle','--')
    
    if dRef~=0
        h=refline(1,0); set(h,'Color','k','lineWidth',2)
    end
end
xlim(xLims); ylim(yLims)
x = M1(:,1); xse = M1(:,2);
y = M2(:,1); yse = M2(:,2);

for ii = 1:N
    plot([1 1].*x(ii),[-yse(ii) yse(ii)] + y(ii),'color',[0.4 0.4 0.4],'linewidth',1)
    plot([-xse(ii) xse(ii)] + x(ii),[1 1].*y(ii),'color',[0.4 0.4 0.4],'linewidth',1)   
    scatter(x(ii),y(ii),70, 'filled','cdata',c(ii,:))
end
set(gca,'LineWidth',2,'FontSize',16)

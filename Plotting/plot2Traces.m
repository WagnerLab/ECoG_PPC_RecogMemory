function h = plot2Traces(X,Y,t,scheme)
% function takes in 2 matrices calculates the mean and SE, and plots them
% returns a handle

switch scheme
    case 'oc'
        color1 = [0.9 0.5 0.1];
        color2 = [0.1 0.8 0.9];
    case 'rb'
        color1 = [0.9 0.2 0.3];
        color2 = [0.3 0.2 0.9];
end

mX = mean(X);
mY = mean(Y);

Z = [X;Y];
stdXY = std(Z);
if ~exist('t','var')
    t = 1:size(Z,2);
end
n = size(Z,1);
seXY = stdXY/sqrt(n-1);

h.f=figure(gcf);clf;hold on;
plot(t,mX+seXY,'color', color1)
plot(t,mX-seXY,'color', color1)
plot(t,mY+seXY,'color', color2)
plot(t,mY-seXY,'color', color2)
xlim([t(1)-0.01 t(end)+0.01])
plot(xlim,[0 0],'--k','linewidth',2)
plot([0 0],ylim,'--k','linewidth',2)

h.h1 = shadedErrorBar(t,mX,seXY,{'color', color1,'linewidth',3},1);
h.h2 = shadedErrorBar(t,mY,seXY,{'color', color2,'linewidth',3},1);
set(h.h1.mainLine,'marker','.','MarkerSize',11)
set(h.h2.mainLine,'marker','.','MarkerSize',11)

end
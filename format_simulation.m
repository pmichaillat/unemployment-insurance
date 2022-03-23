%=================================================================
% customize the default properties of the matlab figures
%=================================================================

set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultlegendinterpreter','latex');
set(groot,'DefaultAxesFontName', 'Times New Roman')
set(groot,'DefaultAxesFontSize', 24)
set(groot,'DefaultTextFontname', 'Times New Roman')
set(groot,'DefaultTextFontSize', 24)
set(groot,'DefaultLineLineWidth', 3)
set(groot,'DefaultAxesYGrid','on')
set(groot,'DefaultAxesXGrid','on')
set(groot,'defaultAxesBox','on')
set(groot,'DefaultAxesTickLength',[0 0])
set(groot,'DefaultLegendBox','off')

co = [0.75    0.25   0.1
    	0.35    0.6    0.15
    	0    		0.35   0.65];
set(groot,'defaultAxesColorOrder',co)

%=================================================================
% plot the sufficient statistics used in the optimal UI formula
%=================================================================

clear all;close all;
format_figure;

% recession dates

recession_b=xlsread('statistics.xlsx','NBER','C34:C36');
recession_e=xlsread('statistics.xlsx','NBER','D34:D36');
shift=(1990-1800)*12;
recession_b=recession_b-shift;
recession_e=recession_e-shift;
recession_b=1+floor(recession_b./3);
recession_e=1+floor(recession_e./3);

% plot Figure 1A

y1=quarter(xlsread('statistics.xlsx','recruiter-producer ratio','C2:C301'));
y2=quarter(xlsread('statistics.xlsx','recruiter-producer ratio','E134:E301'));
y3=quarter(xlsread('statistics.xlsx','recruiter-producer ratio','D2:D301'));
t=quarter(xlsread('statistics.xlsx','recruiter-producer ratio','A2:A301'));

xn=length(t);
xt = [1:20:xn];
xtstr=num2str(t(xt));

x1=[1:xn]';
x2=[45:xn]';

figure(1)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[0.1,0.1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(x1,y1,'-')
plot(x2,y2,'-.')
plot(x1,y3,':')
set(gca,'YTick',[0:0.01:0.04],'YLim',[0,0.04],'YTickLabel',['0%';'1%';'2%';'3%';'4%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf',['fig1A.pdf'])

% plot Figure 1B

y1=quarter(xlsread('statistics.xlsx','recruiter-producer ratio','F2:F301'));
y2=quarter(xlsread('statistics.xlsx','unemployment rate','C2:C301'));

figure(2)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[4,4],-4,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
[AX,H1,H2] = plotyy(x1,y1,x1,y2,'plot');
axes(AX(1))
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gca,'YTick',[0:0.01:0.04],'YLim',[0,0.04],'YTickLabel',['0%';'1%';'2%';'3%';'4%'])
grid on
axes(AX(2))
set(gca,'XTick',[],'XLim',[1,xn])
set(gca,'YTick',[0:0.03:0.12],'YLim',[0,0.12],'YTickLabel',[' 0%';' 3%';' 6%';' 9%';'12%'])
set(H1,'LineWidth',3)
set(H2,'LineWidth',3,'LineStyle','-.')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3)+0.3,pos(4)])
print('-dpdf',['fig1B.pdf'])

% plot Figure 2

y1=quarter(xlsread('statistics.xlsx','effective replacement rate','C2:C301'));

figure(3)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[1,1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(y1,'-')
set(gca,'YTick',[0.2:0.1:0.6],'YLim',[0.2,0.6],'YTickLabel',['20%';'30%';'40%';'50%';'60%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf',['fig2.pdf'])


% plot Figure 3

R=quarter(xlsread('statistics.xlsx','effective replacement rate','C2:C301'));
ur=quarter(xlsread('statistics.xlsx','unemployment rate','C2:C301'));
tau=quarter(xlsread('statistics.xlsx','recruiter-producer ratio','F2:F301'));

y1=0.88-0.32*(R-0.42)-1.5.*tau./ur;

figure(4)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[4,4],-4,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(y1,'-')
set(gca,'YTick',[-0.3:0.3:0.9],'YLim',[-0.3,0.9])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf',['fig3.pdf'])

% plot Figure 5

y1=0.4-0.65.*(tau./ur-0.38);

figure(5)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[1,1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(y1,'-')
set(gca,'YTick',[0:0.2:0.6],'YLim',[0,0.6])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf',['fig5.pdf'])

% plot Figure 6

baily=4.6.*(0.46-1.32.*(R-0.42)).*(0.12-0.26.*(R-0.42));
efficiency=0.88-0.32*(R-0.42)-1.5.*tau./ur;
wedge=0.4-0.65.*(tau./ur-0.38);
y1=baily+wedge.*efficiency-R;

figure(6)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[4,4],-4,'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(y1,'-')
set(gca,'YTick',[-0.4:0.2:0.4],'YLim',[-0.4,0.4])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf',['fig6.pdf'])

% plot Figure A1A

y1=quarter(xlsread('statistics.xlsx','labor market flows','C2:C301'));

figure(7)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[2,2],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(x1,y1,'-')
set(gca,'YTick',[0:0.2:0.8],'YLim',[0,0.8])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf',['figA1A.pdf'])

% plot Figure A1B

y1=quarter(xlsread('statistics.xlsx','vacancy-unemployment ratio','C2:C301'));

figure(8)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[2,2],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(x1,y1,'-')
set(gca,'YTick',[0:0.2:1],'YLim',[0,1])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf',['figA1B.pdf'])

% plot Figure A1C

y1=quarter(xlsread('statistics.xlsx','labor market flows','E2:E301'));
y2=quarter(xlsread('statistics.xlsx','labor market flows','G134:G301'));

figure(9)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[2,2],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(x1,y1,'-')
plot(x2,y2,'-.')
set(gca,'YTick',[0:0.5:2],'YLim',[0,2])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf',['figA1C.pdf'])

% plot Figure A1D

y1=quarter(xlsread('statistics.xlsx','labor market flows','D2:D301'));
y2=quarter(xlsread('statistics.xlsx','labor market flows','F134:F301'));

figure(10)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[0.1,0.1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(x1,y1,'-')
plot(x2,y2,'-.')
set(gca,'YTick',[0:0.01:0.05],'YLim',[0,0.05],'YTickLabel',['0%';'1%';'2%';'3%';'4%';'5%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf',['figA1D.pdf'])

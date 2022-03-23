%=================================================================
% solve the optimal UI formula over time using sufficient statistics
% conduct sensitivity analysis
%=================================================================

clear all;close all;
format_figure;

% solve the optimal UI formula

Rdata=xlsread('statistics.xlsx','effective replacement rate','C2:C301');
UR=xlsread('statistics.xlsx','unemployment rate','C2:C301');
TAU=xlsread('statistics.xlsx','recruiter-producer ratio','F2:F301');

R=[0:0.0001:1]';
TAUU=TAU./UR;
BC=4.6.*(0.46-1.32.*(R-0.42)).*(0.12-0.26.*(R-0.42));
[RX,TAUUY]=ndgrid(R,TAUU);
[BCX,RdataX]=ndgrid(BC,Rdata);
TAUUX=TAUUY+0.01.*(RX-RdataX);
WEDGEX=0.4-0.65.*(TAUUX-0.38);
EFFX=0.88-0.32.*(RX-0.42)-1.5.*TAUUX;
[val,ind]=min(abs(BCX+WEDGEX.*EFFX-RX));
Roptimal=R(ind);

% plot the results

t=quarter(xlsread('statistics.xlsx','recruiter-producer ratio','A2:A301'));
xn=length(t);
xt = [1:20:xn];
xtstr=num2str(t(xt));

recession_b=xlsread('statistics.xlsx','NBER','C34:C36');
recession_e=xlsread('statistics.xlsx','NBER','D34:D36');
shift=(1990-1800)*12;
recession_b=recession_b-shift;
recession_e=recession_e-shift;
recession_b=1+floor(recession_b./3);
recession_e=1+floor(recession_e./3);

y1=quarter(Roptimal);
y2=quarter(Rdata);

figure(1)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[1,1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
plot(y1,'-')
plot(y2,'-.')
set(gca,'YTick',[0.2:0.1:0.6],'YLim',[0.2,0.6],'YTickLabel',['20%';'30%';'40%';'50%';'60%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig7.pdf')

% sensitivity to the elasticity wedge

y3=y1;
y4=y2;

[val,ind]=min(abs(BCX-RX));
y1=quarter(R(ind));

coeff=0.21.*(1.53.*(-0.4)-0.94.*(1.4));
TAUUZ=TAUUY+coeff.*(RX-RdataX);
EFFZ=0.88-0.32.*(RX-0.42)-1.5.*TAUUZ;
WEDGEZ=-0.4;
[val,ind]=min(abs(BCX+WEDGEZ.*EFFZ-RX));
y2=quarter(R(ind));


figure(2)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[1,1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
h1=plot(y3,'-','DisplayName','$1-\epsilon^M/\epsilon^m=0.4$');
h2=plot(y2,'-.','DisplayName','$1-\epsilon^M/\epsilon^m=-0.4$');
h3=plot(y1,':','DisplayName','$1-\epsilon^M/\epsilon^m=0$');
set(gca,'YTick',[0.2:0.1:0.6],'YLim',[0.2,0.7],'YTickLabel',['20%';'30%';'40%';'50%';'60%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
legend([h1 h2 h3],'Location','northwest')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig8A.pdf')

% sensitivity to elasticity of matching

eta=0.5;
TAUUZ=TAUUY+0.21.*(0.41.*eta./(1-eta)-0.56).*(RX-RdataX);
WEDGEZ=0.4-0.65.*(TAUUZ-0.38);
EFFZ=0.88-0.32.*(RX-0.42)-eta./(1-eta).*TAUUZ;
[val,ind]=min(abs(BCX+WEDGEZ.*EFFZ-RX));
y1=quarter(R(ind));

eta=0.7;
TAUUZ=TAUUY+0.21.*(0.41.*eta./(1-eta)-0.56).*(RX-RdataX);
WEDGEZ=0.4-0.65.*(TAUUZ-0.38);
EFFZ=0.88-0.32.*(RX-0.42)-eta./(1-eta).*TAUUZ;
[val,ind]=min(abs(BCX+WEDGEZ.*EFFZ-RX));
y2=quarter(R(ind));

figure(3)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[1,1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
h1=plot(y3,'-','DisplayName','$\eta=0.6$');
h2=plot(y2,'-.','DisplayName','$\eta=0.7$');
h3=plot(y1,':','DisplayName','$\eta=0.5$');
set(gca,'YTick',[0.2:0.1:0.6],'YLim',[0.2,0.7],'YTickLabel',['20%';'30%';'40%';'50%';'60%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
legend([h1 h2 h3],'Location','northwest')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig8D.pdf')

% sensitivity to the nonpecuniary cost of unemployment

Z=0.6;
RU=0.84-Z+(1.10+0.48.*(0.16+Z)).*(RX-0.42);
kappa=(0.16+Z).*0.49;
EFFZ=1-RU+RX-1.5.*TAUUX;
BCZ=(1.01./kappa).*(1-RU).*(0.12-0.26.*(RX-0.42));
[val,ind]=min(abs(BCZ+WEDGEX.*EFFZ-RX));
y1=quarter(R(ind));

Z=0;
RU=0.84-Z+(1.10+0.48.*(0.16+Z)).*(RX-0.42);
kappa=(0.16+Z).*0.49;
EFFZ=1-RU+RX-1.5.*TAUUX;
BCZ=(1.01./kappa).*(1-RU).*(0.12-0.26.*(RX-0.42));
[val,ind]=min(abs(BCZ+WEDGEX.*EFFZ-RX));
y2=quarter(R(ind));


figure(4)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[1,1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
h1=plot(y3,'-','DisplayName','$Z=0.3 \times \phi \times w$');
h2=plot(y2,'-.','DisplayName','$Z=0$');
h3=plot(y1,':','DisplayName','$Z=0.6 \times \phi \times w$');
set(gca,'YTick',[0.2:0.1:0.6],'YLim',[0.2,0.7],'YTickLabel',['20%';'30%';'40%';'50%';'60%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
legend([h1 h2 h3],'Location','northwest')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig8C.pdf')

% sensitivity to the microelasticity of unemployment wrt UI

emb=0.2;
kappa=0.56.*emb;
RU=0.54+(1.11+emb.*0.55).*(RX-0.42);
BCZ=(1.01./kappa).*(1-RU).*(0.12-0.26.*(RX-0.42));
TAUUZ=TAUUY+0.03.*emb.*(RX-RdataX);
WEDGEZ=0.4-0.65.*(TAUUZ-0.38);
EFFZ=1-RU+RX-1.5.*TAUUZ;
[val,ind]=min(abs(BCZ+WEDGEZ.*EFFZ-RX));
y1=quarter(R(ind));

emb=0.6;
kappa=0.56.*emb;
RU=0.54+(1.11+emb.*0.55).*(RX-0.42);
BCZ=(1.01./kappa).*(1-RU).*(0.12-0.26.*(RX-0.42));
TAUUZ=TAUUY+0.03.*emb.*(RX-RdataX);
WEDGEZ=0.4-0.65.*(TAUUZ-0.38);
EFFZ=1-RU+RX-1.5.*TAUUZ;
[val,ind]=min(abs(BCZ+WEDGEZ.*EFFZ-RX));
y2=quarter(R(ind));

figure(5)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[1,1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
h1=plot(y3,'-','DisplayName','$\epsilon^m_b=0.4$');
h2=plot(y2,'-.','DisplayName','$\epsilon^m_b=0.6$');
h3=plot(y1,':','DisplayName','$\epsilon^m_b=0.2$');
set(gca,'YTick',[0.2:0.1:0.6],'YLim',[0.2,0.7],'YTickLabel',['20%';'30%';'40%';'50%';'60%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
legend([h1 h2 h3],'Location','northwest')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig8B.pdf')

% sensitivity to relative risk aversion

gamma=2;
kappa=0.25./(1+0.11.*gamma);
RU=0.54+(1.22+gamma.*0.10).*(RX-0.42);
BCZ=gamma.*(1.01./kappa).*(1-RU).*(0.12-0.26.*(RX-0.42));
EFFZ=1-RU+RX-1.5.*TAUUX;
[val,ind]=min(abs(BCZ+WEDGEX.*EFFZ-RX));
y1=quarter(R(ind));


gamma=0.5;
kappa=0.25./(1+0.11.*gamma);
RU=0.54+(1.22+gamma.*0.10).*(RX-0.42);
BCZ=gamma.*(1.01./kappa).*(1-RU).*(0.12-0.26.*(RX-0.42));
EFFZ=1-RU+RX-1.5.*TAUUX;
[val,ind]=min(abs(BCZ+WEDGEX.*EFFZ-RX));
y2=quarter(R(ind));

figure(6)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[1,1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
h1=plot(y3,'-','DisplayName','$\gamma=1$');
h2=plot(y2,'-.','DisplayName','$\gamma=0.5$');
h3=plot(y1,':','DisplayName','$\gamma=2$');
set(gca,'YTick',[0.2:0.1:0.6],'YLim',[0.2,0.7],'YTickLabel',['20%';'30%';'40%';'50%';'60%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
legend([h1 h2 h3],'Location','northwest')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig8E.pdf')

% sensitivity to consumption drop upon unemployment

drop=0.8;
RUY=-0.61+1.31.*drop;
RU=RUY+(2.30-0.88.*drop-0.48.*RUY).*(RX-0.42);
kappa=0.54.*(1-RUY)./(1.94-0.94.*drop);
BCZ=(1.01./kappa).*(1-RU).*(1-drop-0.30.*drop.*(RX-0.42));
EFFZ=1-RU+RX-1.5.*TAUUX;
[val,ind]=min(abs(BCZ+WEDGEX.*EFFZ-RX));
y1=quarter(R(ind));

drop=0.95;
RUY=-0.61+1.31.*drop;
RU=RUY+(2.30-0.88.*drop-0.48.*RUY).*(RX-0.42);
kappa=0.54.*(1-RUY)./(1.94-0.94.*drop);
BCZ=(1.01./kappa).*(1-RU).*(1-drop-0.30.*drop.*(RX-0.42));
EFFZ=1-RU+RX-1.5.*TAUUX;
[val,ind]=min(abs(BCZ+WEDGEX.*EFFZ-RX));
y2=quarter(R(ind));

figure(7)
clf
hold on
for j=1:3
	area([recession_b(j),recession_e(j)],[1,1],'FaceColor',[0.9,0.9,0.9],'LineStyle','none')
end
h1=plot(y3,'-','DisplayName','$1-c^h/c^e=12\%$');
h2=plot(y2,'-.','DisplayName','$1-c^h/c^e=5\%$');
h3=plot(y1,':','DisplayName','$1-c^h/c^e=20\%$');
set(gca,'YTick',[0.2:0.1:0.6],'YLim',[0.2,0.7],'YTickLabel',['20%';'30%';'40%';'50%';'60%'])
set(gca,'XTick',xt,'XTickLabel',xtstr,'XLim',[1,xn])
legend([h1 h2 h3],'Location','northwest')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig8F.pdf')

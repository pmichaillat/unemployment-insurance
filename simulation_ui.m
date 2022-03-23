%=================================================================
% compute the optimal UI replacement rate in job-rationing matching model
% solve for optimal UI, approximately optimal UI, constant UI (at R=42%), and Baily-Chetty UI
% calibration for 1990--2014
%=================================================================

clear all;close all;

% average values: targets for calirabtion

ur0=0.061;
tau0=0.023;
theta0=mean(xlsread('statistics.xlsx','vacancy-unemployment ratio','C2:C301'));
l0=(1-ur0);

% matching parameters

s=0.028;
eta=0.6;
mu=s.*theta0.^(eta-1).*(l0./ur0);
q=@(theta)mu.*theta.^(-eta);
f=@(theta)mu.*theta.^(1-eta);
l=@(e,theta)e.*f(theta)./(s+e.*f(theta));
rho=q(theta0)./s.*tau0./(1+tau0);
tau=@(theta)(rho.*s)./(q(theta)-rho.*s);
n0=l0./(1+tau0);

% production-function parameter

alpha=0.73;

% wage parameters

zeta=0.5;
omega=alpha.*n0.^(alpha-1)./(1+tau0);
w=@(a)omega.*a.^(1-zeta); 

% consumption

R0=0.42;
dc0=omega.*(1-R0);
cu0=n0^alpha-l0.*dc0;
ce0=cu0+dc0;
ch0=ce0.*0.88;
h0=ch0-cu0;
dc=@(a,R)w(a).*(1-R);
cu=@(a,R,l)w(a).*l./alpha-l.*dc(a,R);
ce=@(a,R,l)cu(a,R,l)+dc(a,R);
ch=@(a,R,l,h)cu(a,R,l)+h;

% utility 

gamma=1;
U=@(c)log(c);
Uprime=@(c)c.^(-gamma);
phi=@(a,R,l,h)(l./Uprime(ce(a,R,l))+(1-l)./Uprime(ch(a,R,l,h))).^(-1);
phi0=phi(1,R0,l0,h0);
Z=0.3.*phi0.*omega;
RU0=1-(Z+U(ce0)-U(ch0))./(phi0.*omega);

% home production

dchdcu=0.2.*(ch0./cu0);
sigma=gamma.*(h0/ch0)*dchdcu./(1-dchdcu);
xi=1/(ch0.^gamma.*h0^sigma);
lambda=@(h)xi.*h.^(1+sigma)./(1+sigma);

% search effort

kappa=0.22;
delta=l0.*(U(ce0)-U(ch0)+Z);
psi=@(e)delta.*e.^(1+1./kappa)./(1+1./kappa);
z=Z-lambda(h0)-psi(1);
dU=@(a,R,l,h)U(ce(a,R,l))-U(ch(a,R,l,h))+z+lambda(h);
e=@(a,R,l,h)(l./delta.*dU(a,R,l,h)./(1-l.*kappa/(1+kappa))).^(kappa./(kappa+1));
em=@(a,R,l,h)l.*kappa.*dU(a,R,l,h)./(dU(a,R,l,h)+psi(e(a,R,l,h)));
ef=@(l)(1-l).*kappa;

% labor market equilibrium

theta=@(a,R,l,h)(s.*l./(1-l)./e(a,R,l,h)./mu).^(1./(1-eta));
n=@(a,R,l,h)l./(1+tau(theta(a,R,l,h)));
wedge=@(a,R,l,h)(1+eta./(1-eta).*alpha./(1-alpha)./(1+ef(l)).*tau(theta(a,R,l,h))./(1-l)).^(-1);

% functions in optimal UI formula

hosiosr=@(a,R,l,h) (dU(a,R,l,h)+psi(e(a,R,l,h)))./(w(a).*phi(a,R,l,h))+R.*(1+ef(l));
hosiosl=@(a,R,l,h) eta./(1-eta).*tau(theta(a,R,l,h))./(1-l);
hosios=@(a,R,l,h) hosiosr(a,R,l,h)-hosiosl(a,R,l,h);
ugap=@(a,R,l,h)1./Uprime(ce(a,R,l))-1./Uprime(ch(a,R,l,h));
formula=@(a,R,l,h) abs(R-l./w(a).*dU(a,R,l,h)./em(a,R,l,h).*ugap(a,R,l,h)-wedge(a,R,l,h)./(1+ef(l)).*hosios(a,R,l,h));
baily=@(a,R,l,h)abs(R-l./w(a).*dU(a,R,l,h)./em(a,R,l,h).*ugap(a,R,l,h));

% simulations of the job-rationing model 

gap=0.0001;
RR=[[0.4:gap:0.58],
		[0.4:gap:0.58],
		[0.4:gap:0.58],
		[0.31:gap:0.49],
		[0.31:gap:0.49],
		[0.31:gap:0.49],
		[0.31:gap:0.49],
		[0.31:gap:0.49]]';

A=[0.96:0.01:1.03];
j=0;

for a=A

	j=j+1
	
	% constant UI

	L1=[0.89:0.00001:0.97]';
	H1=[0.25:0.00001:0.35]';	
	[L2,H2]=ndgrid(L1,H1);
	[UU,idh]=max(U(ch(a,R0,L2,H2))-z-lambda(H2),[],2);
	H1=H1(idh);
	N1=n(a,R0,L1,H1);
	THETA1=theta(a,R0,L1,H1);

	EVAL=abs(a.*alpha.*N1.^(alpha-1)-(1+tau(THETA1)).*w(a));
	[val,idl]=min(EVAL);
	LX(j)=L1(idl);
	HX(j)=H1(idl);
	RX(j)=R0;
	taux=tau(THETA1(idl));
	urx=1-L1(idl);

	% approximately optimal UI

	R1=[0.1:0.00001:0.7];
	tauux=taux./urx;
	TAUU1=tauux+0.01.*(R1-R0);
	WEDGE1=0.4-0.65.*(TAUU1-0.4);
	BC1=4.6.*(0.46-1.32.*(R1-0.42)).*(0.12-0.26.*(R1-0.42));
	EFF1=0.88-0.32.*(R1-0.42)-1.5.*TAUU1;
	FORMULA1=BC1+WEDGE1.*EFF1-R1;
	[val,idR]=min(abs(FORMULA1));
	RA(j)=R1(idR);

	L1=[0.89:0.00002:0.97]';
	H1=[0.25:0.00002:0.4]';
	[L2,H2]=ndgrid(L1,H1);
	[UU,idh]=max(U(ch(a,RA(j),L2,H2))-z-lambda(H2),[],2);
	H1=H1(idh);
	N1=n(a,RA(j),L1,H1);
	THETA1=theta(a,RA(j),L1,H1);

	EVAL=abs(a.*alpha.*N1.^(alpha-1)-(1+tau(THETA1)).*w(a));
	[val,idl]=min(EVAL);
	LA(j)=L1(idl);
	HA(j)=H1(idl);

	% exactly optimal UI

	L1=[0.89:0.0001:0.97]';
	R1=RR(:,j);
	H1=[0.25:0.0001:0.35]';	
	[R2,L2]=ndgrid(R1,L1);
	CU2=cu(a,R2,L2);
	[CU3,H3]=ndgrid(CU2(:),H1);
	[UU,idh]=max(U(CU3+H3)-z-lambda(H3),[],2);
	H2=H1(idh);
	H2=reshape(H2,size(R2));
	N2=n(a,R2,L2,H2);
	THETA2=theta(a,R2,L2,H2);

	EVAL=abs(a.*alpha.*N2.^(alpha-1)-(1+tau(THETA2)).*w(a));
	[val,idl]=min(EVAL,[],2);
	[nr,nc]=size(EVAL);
	idl=sub2ind([nr,nc],[1:nr]',idl);
	R1=R2(idl);
	L1=L2(idl);
	H1=H2(idl);
		
	FORMULA=formula(a,R1,L1,H1);
	[val,idR]=min(FORMULA);
	LY(j)=L1(idR);
	RY(j)=R1(idR);
	HY(j)=H1(idR);

	% Baily-Chetty UI

	L1=[0.89:0.0001:0.97]';
	R1=[0.3:0.0001:0.4]';
	H1=[0.25:0.0001:0.4]';
	[R2,L2]=ndgrid(R1,L1);
	CU2=cu(a,R2,L2);
	[CU3,H3]=ndgrid(CU2(:),H1);
	[UU,idh]=max(U(CU3+H3)-z-lambda(H3),[],2);
	H2=H1(idh);
	H2=reshape(H2,size(R2));
	N2=n(a,R2,L2,H2);
	THETA2=theta(a,R2,L2,H2);
	
	EVAL=abs(a.*alpha.*N2.^(alpha-1)-(1+tau(THETA2)).*w(a));
	[val,idl]=min(EVAL,[],2);
	[nr,nc]=size(EVAL);
	idl=sub2ind([nr,nc],[1:nr]',idl);
	R1=R2(idl);
	L1=L2(idl);
	H1=H2(idl);
		
	BAILY=baily(a,R1,L1,H1);
	[val,idR]=min(BAILY);
	LZ(j)=L1(idR);
	RZ(j)=R1(idR);
	HZ(j)=H1(idR);

end

% recompute all values

URY=1-LY;
CHY=ch(A,RY,LY,HY);
CUY=cu(A,RY,LY);
CEY=ce(A,RY,LY);
EY=e(A,RY,LY,HY);
DUY=dU(A,RY,LY,HY);
THETAY=theta(A,RY,LY,HY);
HOSY=hosios(A,RY,LY,HY);
EMICY=em(A,RY,LY,HY);
WEDGEY=wedge(A,RY,LY,HY);
EMACY=EMICY.*(1-WEDGEY);
TAUY=tau(THETAY);
DROPY=(CEY-CHY)./CEY;

URX=1-LX;
CHX=ch(A,RX,LX,HX);
CUX=cu(A,RX,LX);
CEX=ce(A,RX,LX);
EX=e(A,RX,LX,HX);
DUX=dU(A,RX,LX,HX);
THETAX=theta(A,RX,LX,HX);
HOSX=hosios(A,RX,LX,HX);
EMICX=em(A,RX,LX,HX);
WEDGEX=wedge(A,RX,LX,HX);
EMACX=EMICX.*(1-WEDGEX);
TAUX=tau(THETAX);
DROPX=(CEX-CHX)./CEX;

URZ=1-LZ;
CHZ=ch(A,RZ,LZ,HZ);
CUZ=cu(A,RZ,LZ);
CEZ=ce(A,RZ,LZ);
EZ=e(A,RZ,LZ,HZ);
DUZ=dU(A,RZ,LZ,HZ);
THETAZ=theta(A,RZ,LZ,HZ);
HOSZ=hosios(A,RZ,LZ,HZ);
EMICZ=em(A,RZ,LZ,HZ);
WEDGEZ=wedge(A,RZ,LZ,HZ);
EMACZ=EMICZ.*(1-WEDGEZ);
TAUZ=tau(THETAZ);
DROPZ=(CEZ-CHZ)./CEZ;

URA=1-LA;

% social welfare

SWY=LY.*U(CEY)+(1-LY).*(U(CHY)-z-lambda(HY)-psi(EY));
SWX=LX.*U(CEX)+(1-LX).*(U(CHX)-z-lambda(HX)-psi(EX));
SWZ=LZ.*U(CEZ)+(1-LZ).*(U(CHZ)-z-lambda(HZ)-psi(EZ));
WGAINX=(DUX+psi(EX)).*(1-LX);
WGAINZ=(DUZ+psi(EZ)).*(1-LZ);
DSWX2=(SWY-SWX)./WGAINX;
DSWZ2=(SWY-SWZ)./WGAINZ;

DSWXU=max(flip(DSWX2),0);
DSWZU=max(flip(DSWZ2),0);
FURX=flip(1-LX);
FURZ=flip(1-LZ);

EDGEX=(FURX(1:end-1)+FURX(2:end))./2;
EDGEX=[0,EDGEX,0.2];
EDGEZ=(FURZ(1:end-1)+FURZ(2:end))./2;
EDGEZ=[0,EDGEZ,0.2];

UR=xlsread('statistics.xlsx','unemployment rate','C2:C301');
[BINX,edges] = histcounts(UR,EDGEX);
[BINZ,edges] = histcounts(UR,EDGEZ);
BINX=BINX./sum(BINX);
BINZ=BINZ./sum(BINZ);

'average unemployment gain from 42%'
DSWXU*BINX'
'average unemployment gain from Baily-Chetty'
DSWZU*BINZ'

% plot results

format_simulation;
xmi=min(A);xma=max(A);i=0;
x1=A;

y1=URX;
y2=URA;
y3=URY;


i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':','DisplayName','$R=42\%$')
plot(x1,y2,'-.','DisplayName','Approximate formula')
plot(x1,y3,'-','DisplayName','Exact formula')
xlabel('Technology')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma])
set(gca,'YTick',[0.03:0.02:0.11],'YLim',[0.03,0.11],'YTickLabel',[' 3%';' 5%';' 7%';' 9%';'11%'])
ylabel('Unemployment rate')
legend('show','Location','northeast')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig9A.pdf')

y1=RX;
y2=RA;
y3=RY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':','DisplayName','$R=42\%$')
plot(x1,y2,'-.','DisplayName','Approximate formula')
plot(x1,y3,'-','DisplayName','Exact formula')
xlabel('Technology')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma])
set(gca,'YTick',[0.3:0.1:0.6],'YLim',[0.3,0.6],'YTickLabel',['30%';'40%';'50%';'60%'])
ylabel('Replacement rate')
legend('show','Location','northeast')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig9B.pdf')

y1=RX;
y2=RZ;
y3=RY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':','DisplayName','$R=42\%$')
plot(x1,y2,'-.','DisplayName','Baily-Chetty')
plot(x1,y3,'-','DisplayName','Optimal UI')
xlabel('Technology')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma])
set(gca,'YTick',[0.3:0.1:0.6],'YLim',[0.3,0.6],'YTickLabel',['30%';'40%';'50%';'60%'])
ylabel('Replacement rate')
legend('show','Location','northeast')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig10A.pdf')

%abstract from numerical errors
y1=max(DSWX2,0);
y2=max(DSWZ2,0);

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,'-.','DisplayName','Compared to $R=42\%$')
plot(x1,y2,'-','DisplayName','Compared to Baily-Chetty')
xlabel('Technology')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma])
set(gca,'YTick',[0:0.01:0.05],'YLim',[0,0.05],'YTickLabel',['0%';'1%';'2%';'3%';'4%';'5%'])
ylabel('Welfare gain from optimal UI')
legend('show','Location','northeast')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','fig10B.pdf')

format_big;	

y1=URX;
y2=URZ;
y3=URY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':','DisplayName','$R=42\%$')
plot(x1,y2,'-.','DisplayName','Baily-Chetty')
plot(x1,y3,'-','DisplayName','Optimal UI')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma],'XTickLabel',[])
set(gca,'YTick',[0.03:0.02:0.11],'YLim',[0.03,0.11],'YTickLabel',[' 3%';' 5%';' 7%';' 9%';'11%'])
ylabel('Unemployment rate')
legend('show','Location','northeast')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','figA2A.pdf')

y1=TAUX;
y2=TAUZ;
y3=TAUY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':')
plot(x1,y2,'-.')
plot(x1,y3,'-')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma],'XTickLabel',[])
set(gca,'YTick',[0:0.01:0.04],'YLim',[0,0.04],'YTickLabel',['0%';'1%';'2%';'3%';'4%'])
ylabel('Recruiter-producer ratio')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','figA2B.pdf')

y1=HOSX;
y2=HOSZ;
y3=HOSY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':')
plot(x1,y2,'-.')
plot(x1,y3,'-')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma],'XTickLabel',[])
set(gca,'YTick',[-0.5:.5:1],'YLim',[-0.5,1])
ylabel('Efficiency term')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','figA2C.pdf')


y1=WEDGEX;
y2=WEDGEZ;
y3=WEDGEY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':')
plot(x1,y2,'-.')
plot(x1,y3,'-')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma],'XTickLabel',[])
set(gca,'YTick',[0:0.2:0.8],'YLim',[0,.8])
ylabel('Elasticity wedge')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','figA2D.pdf')

y1=EMACX;
y2=EMACZ;
y3=EMACY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':')
plot(x1,y2,'-.')
plot(x1,y3,'-')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma],'XTickLabel',[])
set(gca,'YTick',[0:0.05:0.2],'YLim',[0,0.2])
ylabel('Macroelasticity')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','figA2E.pdf')

y1=EMICX;
y2=EMICZ;
y3=EMICY;


i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':')
plot(x1,y2,'-.')
plot(x1,y3,'-')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma],'XTickLabel',[])
set(gca,'YTick',[0:0.05:0.2],'YLim',[0,0.2])
ylabel('Microelasticity')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','figA2F.pdf')

y1=DROPX;
y2=DROPZ;
y3=DROPY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':')
plot(x1,y2,'-.')
plot(x1,y3,'-')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma])
set(gca,'YTick',[0.05:0.05:0.2],'YLim',[0.05,0.2],'YTickLabel',[' 5%';'10%';'15%';'20%'])
ylabel('Consumption drop')
xlabel('Technology')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','figA2G.pdf')

y1=EX;
y2=EZ;
y3=EY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':')
plot(x1,y2,'-.')
plot(x1,y3,'-')
xlabel('Technology')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma])
set(gca,'YTick',[0.9:0.05:1.05],'YLim',[0.9,1.05])
ylabel('Job-search effort')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','figA2H.pdf')

y1=HX;
y2=HZ;
y3=HY;

i=i+1;
figure(i)
clf
hold on
plot(x1,y1,':')
plot(x1,y2,'-.')
plot(x1,y3,'-')
xlabel('Technology')
set(gca,'XTick',[0.96,0.98,1,1.02],'XLim',[xmi,xma])
set(gca,'YTick',[0.25:0.05:0.4],'YLim',[0.25,0.4])
ylabel('Home production')
set(gcf,'Units','Inches')
pos = get(gcf,'Position');
set(gcf,'PaperSize',[pos(3),pos(4)])
print('-dpdf','figA2I.pdf')



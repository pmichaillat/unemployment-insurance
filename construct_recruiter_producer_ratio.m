%=================================================================
%  construct the recruiter-producer ratio used in the optimal UI formula
%=================================================================

clear all;close all;

% construct the recruiter-producer ratio from CES data

DATA=xlsread('data_recruiter_producer_ratio.xlsx','CES','A3:D302');
y=DATA(:,1);
m=DATA(:,2);
l=DATA(:,3);
rec=DATA(:,4);
tau=rec./l;
tau97=mean(tau(85:96));
taudata=0.025;
tau=tau./tau97.*taudata;
tau01=mean(tau(133:144));
tauces=tau./(1-tau);
csvwrite('recruiter-producer ratio (CES).csv',[y,m,tauces])

% construct the recruiter-producer ratio from CPS data
%  compute vacancies

DATA=xlsread('data_recruiter_producer_ratio.xlsx','Barnichon (2010)','A3:C302');
v=DATA(:,3);
vshort=v(133:end);
vjolts=xlsread('data_recruiter_producer_ratio.xlsx','JOLTS','C3:C170');
mshort=mean(vshort);
mjolts=mean(vjolts);
v=v./mshort.*mjolts;
csvwrite('vacancies.csv',[y,m,v])

% compute the job-finding rate

DATA=xlsread('data_recruiter_producer_ratio.xlsx','CPS','C3:F303');
u=DATA(1:end-1,1);
u5=DATA(1:end-1,3);
uf=DATA(2:end,1);
u5f=DATA(2:end,3);
f=1-(uf-u5f)./u;
f=-log(1-f);
csvwrite('monthly job-finding rate.csv',[y,m,f])

% compute the vacancy-unemployment ratio

x=v./u;
csvwrite('vacancy-unemployment ratio.csv',[y,m,x])

% compute the vacancy-filling rate

q=f./x;
csvwrite('monthly vacancy-filling rate (CPS).csv',[y,m,q])

% compute the job-separation rate

l=DATA(1:end-1,4);
s0=[0:10^(-6):0.1];
sn=size(s0,2);
[F,S0]=ndgrid(f,s0);
U=repmat(u,1,sn);
UF=repmat(uf,1,sn);
L=repmat(l,1,sn);
H=L+U;
LOSS=abs((1-exp(-F-S0)).*S0.*H./(F+S0)+U.*exp(-F-S0)-UF);
[val,ind]=min(LOSS,[],2);
s=s0(ind)';
csvwrite('monthly job-separation rate.csv',[y,m,s])

% compute the recruiter-producer ratio

q97=mean(q(85:96));
s97=mean(s(85:96));
rho=(q97./s97).*taudata;
taucps=rho.*s./(q-rho.*s);
csvwrite('recruiter-producer ratio (CPS).csv',[y,m,taucps])

% construct the recruiter-producer ratio from JOLTS data

DATA=xlsread('data_recruiter_producer_ratio.xlsx','JOLTS','A3:E170');
ys=DATA(:,1);
ms=DATA(:,2);
v=DATA(:,3);
s=DATA(:,4)./100;
h=DATA(:,5);

% compute the vacancy-filling rate
q=h./v;
csvwrite('monthly vacancy-filling rate (JOLTS).csv',[ys,ms,q])

% get the job-separation rate
csvwrite('monthly job-separation rate (JOLTS).csv',[ys,ms,s])

% compute the recruiter-producer ratio
q01=mean(q(1:12));
s01=mean(s(1:12));
rho=(q01./s01).*tau01;
taujolts=rho.*s./(q-rho.*s);
csvwrite('recruiter-producer ratio (JOLTS).csv',[ys,ms,taujolts])

%  construct synthetic measure of recruiter-producer ratio

tau=tauces./2+taucps./2;
tau(133:end)=2./3.*tau(133:end)+taujolts./3;
csvwrite('synthetic recruiter-producer ratio.csv',[y,m,tau])

% construct the unemployment rate from CPS data

ur=xlsread('data_recruiter_producer_ratio.xlsx','CPS','G3:G302')./100;
csvwrite('unemployment rate.csv',[y,m,ur])

% construct the tau-u ratio

tauu=tau./ur;
csvwrite('tau-u ratio.csv',[y,m,tauu])

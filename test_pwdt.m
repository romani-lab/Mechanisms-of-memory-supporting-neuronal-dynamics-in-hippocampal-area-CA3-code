%This script compares the theoretical predictions and simulated results
% for the probability of W=1 with distinct times for presynaptic and 
% postsynaptic signals.

% m=csvread('./Calculations/pwdtb_btsptcorr_fp084_fa042_c0.csv');
% fp=.084;
% fa=.042;
% c=0;
% N=1000;
% N_rep=100;
% [~,~,~,~,~,~,~,~,~,~,pwdtb,~]= bootstrapBTSPAttractorTcorr(N,fp,fa,c,N_rep);
% pwdtb_data=pwdtb(end:-1:(end-length(m)+1),end:-1:(end-length(m)+1))';
% t1=repmat(1:length(m),[length(m) 1]);
% t2=repmat((1:length(m))',[1 length(m)]);
% dt=abs(t1-t2);
% 
% figure;
% hold on;
% 
% scatter(pwdtb_data(dt==0),m(dt==0),'k');
% scatter(pwdtb_data(dt==1),m(dt==1),'r');
% scatter(pwdtb_data(dt>1),m(dt>1),'b');
% plot([0 1],[0 1],'--','color',[.6 .6 .6]);
% set(gca,'tickdir','out');
% box off;
% xlabel('P(W=1), data');
% ylabel('P(W=1), theory');
% title('c=0, btsp');

% figure; 
% hold on;
% 
% [f0,x0]=ksdensity(m(dt==0));
% [f1,x1]=ksdensity(m(dt==1));
% [f2,x2]=ksdensity(m(dt>1));
% plot(x0,f0,'k');
% plot(x1,f1,'r');
% plot(x2,f2,'b');
% xlabel('input fraction');
% ylabel('probability');
% title('c=0, btsp');

m=csvread('./Calculations/pwdtb_btsptcorr_fp084_fa042_c8.csv');
fp=.084;
fa=.042;
c=.8;
N=1000;
N_rep=100;
[~,~,~,~,~,~,~,~,~,~,pwdtb,~] = bootstrapBTSPAttractorTcorr(N,fp,fa,c,N_rep);
pwdtb_data=pwdtb(end:-1:(end-length(m)+1),end:-1:(end-length(m)+1))';
t1=repmat(1:length(m),[length(m) 1]);
t2=repmat((1:length(m))',[1 length(m)]);
dt=abs(t1-t2);

figure; 
hold on;

[f0,x0]=ksdensity(m(dt==0));
[f1,x1]=ksdensity(m(dt==1));
[f2,x2]=ksdensity(m(dt>1));
plot(x0,f0,'k');
plot(x1,f1,'r');
plot(x2,f2,'b');
xlabel('input fraction');
ylabel('probability');
title('c=.8, btsp');

figure;
hold on;

scatter(pwdtb_data(dt==0),m(dt==0),'k');
scatter(pwdtb_data(dt==1),m(dt==1),'r');
scatter(pwdtb_data(dt>1),m(dt>1),'b');
plot([0 1],[0 1],'--','color',[.6 .6 .6]);
set(gca,'tickdir','out');
box off;
xlabel('P(W=1), data');
ylabel('P(W=1), theory');
title('c=.8, btsp');

% m=csvread('./Calculations/pwdtb_fusitcorr_fp084_fa042_c0.csv');
% fp=.084;
% fa=.042;
% c=0;
% N=1000;
% N_rep=100;
% [~,~,~,~,~,~,~,~,~,~,pwdtb,~] = bootstrapHebbAttractorTcorr(N,fp,fa,c,N_rep);
% pwdtb_data=pwdtb(end:-1:(end-length(m)+1),end:-1:(end-length(m)+1))';
% t1=repmat(1:length(m),[length(m) 1]);
% t2=repmat((1:length(m))',[1 length(m)]);
% dt=abs(t1-t2);
% 
% figure;
% hold on;
% 
% scatter(pwdtb_data(dt==0),m(dt==0),'k');
% scatter(pwdtb_data(dt==1),m(dt==1),'r');
% scatter(pwdtb_data(dt>1),m(dt>1),'b');
% plot([0 1],[0 1],'--','color',[.6 .6 .6]);
% set(gca,'tickdir','out');
% box off;
% xlabel('P(W=1), data');
% ylabel('P(W=1), theory');
% title('Fusi,c=0');

% figure; 
% hold on;
% 
% [f0,x0]=ksdensity(m(dt==0));
% [f1,x1]=ksdensity(m(dt==1));
% [f2,x2]=ksdensity(m(dt>1));
% plot(x0,f0,'k');
% plot(x1,f1,'r');
% plot(x2,f2,'b');
% xlabel('input fraction');
% ylabel('probability');
% title('c=0, fusi');

m=csvread('./Calculations/pwdtb_fusitcorr_fp084_fa042_c8.csv');
fp=.084;
fa=.042;
c=.8;
N=1000;
N_rep=100;
[~,~,~,~,~,~,~,~,~,~,pwdtb,~] = bootstrapHebbAttractorTcorr(N,fp,fa,c,N_rep);
pwdtb_data=pwdtb(end:-1:(end-length(m)+1),end:-1:(end-length(m)+1))';
t1=repmat(1:length(m),[length(m) 1]);
t2=repmat((1:length(m))',[1 length(m)]);
dt=abs(t1-t2);

figure;
hold on;

scatter(pwdtb_data(dt==0),m(dt==0),'k');
scatter(pwdtb_data(dt>1),m(dt>1),'b');
scatter(pwdtb_data(dt==1),m(dt==1),'r');


plot([0 1],[0 1],'--','color',[.6 .6 .6]);
set(gca,'tickdir','out');
box off;
xlabel('P(W=1), data');
ylabel('P(W=1), theory');
title('fusi, c=.8');

figure; 
hold on;

[f0,x0]=ksdensity(m(dt==0));
[f1,x1]=ksdensity(m(dt==1));
[f2,x2]=ksdensity(m(dt>1));
plot(x0,f0,'k');
plot(x1,f1,'r');
plot(x2,f2,'b');
xlabel('input fraction');
ylabel('probability');
title('c=.8, fusi');
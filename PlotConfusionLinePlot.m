%This script plots the probability of W=1 with presynaptic and postsynaptic
%signals at recent, but distinct, time bins as a function of temporal
%autocorrelation.

c=0:.01:.9;
% btsp23=csvread('./Calculations/btsp23_fp0836_fa0836.csv');
% btsp24=csvread('./Calculations/btsp24_fp0836_fa0836.csv');
% fusi23=csvread('./Calculations/fusi23_fp0836_fa0836.csv');
% fusi24=csvread('./Calculations/fusi24_fp0836_fa0836.csv');

% figure;
% hold on;
% plot(c,btsp23,'k');
% plot(c,btsp24,'k--');
% plot(c,fusi23,'m');
% plot(c,fusi24,'m--');
% set(gca,'tickdir','out');
% box off;
% xlabel('c');
% ylabel('correlation');
% legend('btsp23','btsp24','fusi23','fusi24');

btsp23minusw=csvread('./Calculations/btsp23minusw_fp0836_fa0836.csv');
btsp24minusw=csvread('./Calculations/btsp24minusw_fp0836_fa0836.csv');
fusi23minusw=csvread('./Calculations/fusi23minusw_fp0836_fa0836.csv');
fusi24minusw=csvread('./Calculations/fusi24minusw_fp0836_fa0836.csv');

% figure;
% hold on;
% plot(c,btsp23minusw,'k');
% plot(c,btsp24minusw,'k--');
% plot(c,fusi23minusw,'m');
% plot(c,fusi24minusw,'m--');
% set(gca,'tickdir','out');
% box off;
% xlabel('c');
% ylabel('correlation-mean weight');
% legend('btsp23','btsp24','fusi23','fusi24');

figure;
hold on;
plot(c,btsp23minusw,'k');
plot(c,fusi23minusw,'m');
set(gca,'tickdir','out');
box off;
xlabel('c');
ylabel('correlation-mean weight');
legend('btsp23','fusi23');
xlim([0 1]);
ylim([-.3 .5]);
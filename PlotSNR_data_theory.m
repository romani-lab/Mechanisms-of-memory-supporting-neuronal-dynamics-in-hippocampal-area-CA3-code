%Plots the simulated data, full theoretical predictions, and approximate
%theoretical predictions for the simple model of btsp (with variable pre
%and postsynaptic sparsities) and the model with temporally correlated
%spiking activity using simulated data with uncorrelated weights.

dat = load('./Calculations/snrdata_btsp_uncorr_N1000_10logN_10logN.csv');
the = load('./Calculations/snr_btsp_uncorr_N1000_10logN_10logN.csv');
app = load('./Calculations/snrapprox_btsp_uncorr_N1000_10logN_10logN.csv');

clf
fs=12;
p = length(the);
figure;
plot(1:p,dat(1:length(the),:),'o-k')
hold on;
plot(1:p,app,'.-')
set(gca,'Ydir','normal')
set(gca,'TickDir','out')
set(gca,'Box','off')
set(gca,'Xtick',[0,100,200,300])
xlabel('pattern #')
ylabel('SNR')
legend({'simulation','theory'})
axis square
set(gca,'FontSize',fs)
%semilogy(app,'.-')


dat = load('./Calculations/snrdata_btsp_uncorr_N800_10logN_5logN_c8.csv');
the = load('./Calculations/snr_btsp_uncorr_N800_10logN_5logN_c8.csv');
app = load('./Calculations/snrapprox_btsp_uncorr_N800_10logN_5logN_c8.csv');

%clf
p = min(length(the),length(dat));
figure;
plot(1:p,dat((1:p),:),'o-k');
hold
plot(1:p,app(1:p),'.-')
plot(1:p,the(1:p),'.-')
set(gca,'Ydir','normal')
set(gca,'TickDir','out')
set(gca,'Box','off')
set(gca,'Xtick',[0,100,200,300])
xlabel('pattern #')
ylabel('SNR')
legend({'simulation','approximate theory','full theory'})
axis square
set(gca,'FontSize',fs)
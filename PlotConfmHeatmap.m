%Examine the probability of W=1 for neurons that have presynaptic inputs
%and postsynaptic inputs at different times, showing how likely adjacent
%patterns will be to be confused for one another.

c=.8;
N=1600;
fp=10*log(N)/N;
fa=10*log(N)/N;
N_rep=100;
l=20;

[~,~,~,~,~,~,~,~,~,~,pwdtb,~] = bootstrapBTSPAttractorTcorr(N,fp,fa,c,N_rep);
pwdtb_data=pwdtb(end:-1:(end-l+1),end:-1:(end-l+1))';
t1=repmat(1:l,[l 1]);
t2=repmat((1:l)',[1 l]);
dt=abs(t1-t2);
[~,~,~,~,A_att_plateau,W] = computeBTSPAttractorTcorrSparse(N,fp,fa,c);
wa=mean(W(:));
figure; imagesc(pwdtb_data)
colormap redblue; caxis([(1-2*(1-wa)) 1]);
set(gca,'tickdir','out')
box off
colorbar
title('BTSP confusion matrix');
% figure;
% imagesc(flipud(fliplr(A_att_plateau'*A_att_plateau)));
% colorbar;


[~,~,~,~,~,~,~,~,~,~,pwdtb,~] = bootstrapHebbAttractorTcorr(N,fp,fa,c,N_rep);
pwdtb_data=pwdtb(end:-1:(end-l+1),end:-1:(end-l+1))';
t1=repmat(1:l,[l 1]);
t2=repmat((1:l)',[1 l]);
dt=abs(t1-t2);
[~,~,~,~,A_att_plateau,W] = computeHebbAttractorTcorrSparse(N,fp,fa,c);
wa=mean(W(:));
figure; imagesc(pwdtb_data)
colormap redblue; caxis([(1-2*(1-wa)) 1]);
title('Fusi confusion matrix');
set(gca,'tickdir','out')
box off
colorbar
% figure;
% imagesc(flipud(fliplr(A_att_plateau'*A_att_plateau)));
% colorbar;

% c=0;

% [~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,pwdtb,pwdta,pwdtp] = bootstrapBTSPAttractorTcorr(N,fp,fa,c,N_rep);
% pwdtb_data=pwdtb(end:-1:(end-l+1),end:-1:(end-l+1))';
% t1=repmat(1:l,[l 1]);
% t2=repmat((1:l)',[1 l]);
% dt=abs(t1-t2);
% [A_post,A_pre,A_act,A_att,A_att_act,A_att_plateau,W] = computeBTSPAttractorAsymTcorrSparse(N,fp,fa,c);
% wa=mean(W(:));
% figure; imagesc(pwdtb_data)
% colormap redblue; caxis([(1-2*(1-wa)) 1]);
% set(gca,'tickdir','out')
% box off
% colorbar
% title('BTSP confusion matrix, c=0');
% figure;
% imagesc(flipud(fliplr(A_att_plateau'*A_att_plateau)));
% colorbar;


% [~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,pwdtb,pwdta,pwdtp] = bootstrapHebbAttractorTcorr(N,fp,fa,c,N_rep);
% pwdtb_data=pwdtb(end:-1:(end-l+1),end:-1:(end-l+1))';
% t1=repmat(1:l,[l 1]);
% t2=repmat((1:l)',[1 l]);
% dt=abs(t1-t2);
% [A_post,A_pre,A_act,A_att,A_att_act,A_att_plateau,W] = computeHebbAttractorAsymTcorrSparse(N,fp,fa,c);
% wa=mean(W(:));
% figure; imagesc(pwdtb_data)
% colormap redblue; caxis([(1-2*(1-wa)) 1]);
% title('Hebb confusion matrix, c=0');
% set(gca,'tickdir','out')
% box off
% colorbar

% figure;
% imagesc(flipud(fliplr(A_att_plateau'*A_att_plateau)));
% colorbar;
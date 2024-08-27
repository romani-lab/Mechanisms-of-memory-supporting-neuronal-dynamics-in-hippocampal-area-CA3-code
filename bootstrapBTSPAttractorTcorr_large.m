function [capacity,correct_ave,capacity_plateau,correct_ave_plateau,cap_pl,cap_both,SNR_pl,SNR_both,confm,confm_plateau] = bootstrapBTSPAttractorTcorr_large(N,f_plateau,f_act,c,N_rep)
% This bootstraps over the computeBTSPAttractorAsymTcorr function to
% extract things like the average snr, decoding performance, and confusion
% between patterns. This version is designed for larger networks, and does
% not store the results of all bootstrapped simulations simultaneously, but
% accumulates the averages over runs.

%Inputs:
%N - number of neurons
%f_plateau - plateau sparsity
%f_act - activity sparsity
%c - activity autocorrelation
%N_rep - repetitions for bootstrapping

%Outputs:
%capacity, capacity_plateau - capacity computed from resulting
%attractor states using as inputs activity and plateau, just activity, and
%just plateau, respectively

%correct_ave, correct_ave_plateau - probability of
%correct decoding with maximum overlap decoder as a function of how long
%since the pattern presentation

%cap_pl, cap_both - capacity computed from SNR

%SNR_pl, SNR_both - SNR
%confm, confm_plateau - average of the decoded state from the
%initialized state

    SNR_thresh=1;
    P=max(3*ceil(-1./(2*log(1-f_plateau*(f_act+f_plateau)))),100); 

    sigm_pl=zeros(P,1);
    sigv_pl=zeros(P,1);
    sigm_pl_r=0;
    sigv_pl_r=0;

    sigm_both=zeros(P,1);
    sigv_both=zeros(P,1);
    sigm_both_r=0;
    sigv_both_r=0;
    for n=1:N_rep
        [A_post,A_pre,A_act,A_att,A_att_plateau,W] = computeBTSPAttractorTcorrSparse(N,f_plateau,f_act,c);

        %Compute SNR
        mw(n)=mean(W(:));
        %inp_act = (W-mw) * A_act/(N*f_act);
        %sig_act(:,:,n) =((A_post'-f_plateau)/(N*f_plateau) * inp_act);

        rv=randperm(ceil(length(sigm_both)/10),2);

        t=(sum(A_post'.*((W*A_post)'),2)-mw(n)*N^2*(f_plateau)*f_plateau)./(N^2*f_plateau*f_plateau);
        sigm_pl=sigm_pl+(t)./N_rep;
        sigv_pl=sigv_pl+(t).^2./(N_rep);
        t2=(A_post(:,rv(1))'*W*A_post(:,rv(2))-mw(n)*N^2*(f_plateau)*f_plateau)./(N^2*f_plateau*f_plateau);
        sigm_pl_r=sigm_pl_r+t2./N_rep;
        sigv_pl_r=sigv_pl_r+t2.^2./N_rep;

        t=(sum(A_post'.*((W*A_pre)'),2)-mw(n)*N^2*(f_act+f_plateau)*f_plateau)./(N^2*f_act*f_plateau);
        sigm_both=sigm_both+(t)./N_rep;
        sigv_both=sigv_both+(t).^2./(N_rep);
        t2=(A_post(:,rv(1))'*W*A_pre(:,rv(2))-mw(n)*N^2*(f_act+f_plateau)*f_plateau)./(N^2*(f_act+f_plateau)*f_plateau);
        sigm_both_r=sigm_both_r+t2./N_rep;
        sigv_both_r=sigv_both_r+t2.^2./N_rep;

        %Decode from the attractor
        [correct_t,confm_t]=calc_correct(A_post,A_att);
        if n==1
            correct_ave = zeros(size(correct_t));
            confm=zeros(size(confm_t));
        end
        confm=confm+(confm_t)./N_rep;
        correct_ave=correct_ave+correct_t./N_rep;
        
        [correct_t,confm_t]=calc_correct(A_post,A_att_plateau);
        if n==1
            correct_ave_plateau = zeros(size(correct_t));
            confm_plateau=zeros(size(confm_t));
        end
        confm_plateau=confm_plateau+(confm_t)./N_rep;
        correct_ave_plateau=correct_ave_plateau+correct_t./N_rep;
    end
    %This section computes the SNR
    %rv=randperm(ceil(size(sig_both,1)/10),2); %use a random pair of non-equal indices
    SNR_pl=(sigm_pl)./sqrt((sigv_pl-sigm_pl.^2)+(sigv_pl_r-sigm_pl_r.^2));
    SNR_both=(sigm_both)./sqrt((sigv_both-sigm_both.^2)+(sigv_both_r-sigm_both_r.^2));
    %SNR_pl=diag(SNR_pl);
    SNR_pl=SNR_pl(end:-1:2);
    %SNR_both=diag(SNR_both);
    SNR_both=SNR_both(end:-1:2);

    cap_both=find(diff(SNR_both<SNR_thresh)<0);
    if numel(cap_both)==0
        cap_both=0;
    else
        cap_both=cap_both(1);
    end

    cap_pl=find(diff(SNR_pl<SNR_thresh)<0);
    if numel(cap_pl)==0
        cap_pl=0;
    else
        cap_pl=cap_pl(1);
    end

    %This section computes teh average decoding performance based on the
    %attractor states
    %confm=mean(confm,3);
    %correct_ave=mean(correct_ave,2);
    correct_ave=correct_ave(end:-1:1);
    correct_ave=smooth(correct_ave,round(length(correct_ave)/20));
    capacity=find(diff(correct_ave<(.2))>0);
    if numel(capacity)<1
        capacity=0;
    else
        capacity=capacity(1);
    end
    
    
    %confm_plateau=mean(confm_plateau,3);
    %correct_ave_plateau=mean(correct_plateau,2);
    correct_ave_plateau=correct_ave_plateau(end:-1:1);
    correct_ave_plateau=smooth(correct_ave_plateau,round(length(correct_ave_plateau)/20));
    capacity_plateau=find(diff(correct_ave_plateau<(.2))>0);
    if numel(capacity_plateau)<1
        capacity_plateau=0;
    else
        capacity_plateau=capacity_plateau(1);
    end
end

function [correct,confm]=calc_correct(A_post,A_att)
        c_t=A_post'*A_att;
        [~,dec]=max(c_t,[],1);
        %p=length(dec);
        correct=squeeze(dec==repmat(1:size(dec,2),[1 1 size(dec,3)]));
        p=length(correct);
        confm=zeros(p,p);
        indt=sub2ind([p p],1:p,dec);
        confm(indt)=1;
end
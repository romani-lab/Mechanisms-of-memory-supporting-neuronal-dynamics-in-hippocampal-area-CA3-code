function [capacity,correct_ave,capacity_plateau,correct_ave_plateau,cap_pl,cap_both,SNR_pl,SNR_both,confm,confm_plateau,pwdtb,pwdtp] = bootstrapHebbAttractorTcorr(N,f_plateau,f_act,c ...
    ,N_rep)
% This bootstraps over the computeHebbAttractorAsymTcorrSparse function to
% extract things like the average snr, decoding performance, and confusion
% between patterns.

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

%pwdtb, pwdtp - probability that W=1 when the input signal (activity and
%plateau, plateau) are separated in time from the postsynaptic
%signal
    SNR_thresh=5;
    for n=1:N_rep
        [A_post,A_pre,A_act,A_att,A_att_plateau,W] = computeHebbAttractorTcorrSparse(N,f_plateau,f_act,c);

        %Compute SNR
        mw=mean(W(:));
        %inp_pl = (W-mw) * A_post/(N*f_plateau);
        %sig_pl(:,:,n) = ((A_post'-f_plateau)/(N*f_plateau) * inp_pl);
        sig_pl(:,:,n)=(A_post'*W*A_post-mw*N^2*(f_plateau)*f_plateau)./(N^2*(f_plateau)*(f_plateau));
        %inp_both = (W-mw) * A_pre/(N*(f_plateau+f_act));
        %sig_both(:,:,n) = ((A_post'-f_plateau)/(N*f_plateau) * inp_both);
        sig_both(:,:,n)=(A_post'*W*A_pre-mw*N^2*(f_act+f_plateau)*f_plateau)./(N^2*(f_act+f_plateau)*(f_plateau));

        pwdtpn(:,:,n)=A_post'*W*A_post./(sum(A_post',2)*sum(A_post,1));
        pwdtbn(:,:,n)=A_post'*W*A_pre./(sum(A_post',2)*sum(A_pre,1));

        %Decode from the attractor
        c_t=A_post'*A_att;
        [~,dec]=max(c_t,[],1);
        p=length(dec);
        correct=squeeze(dec==repmat(1:size(dec,2),[1 1 size(dec,3)]));
        if n==1
            correct_ave=1/N_rep*(correct);
            confm=zeros(length(dec));
        else
            correct_ave=correct_ave+1/N_rep*(correct);
        end
        indt=sub2ind([p p],1:p,dec);
        confm(indt)=confm(indt)+1/N_rep;
        
        
        c_t=A_post'*A_att_plateau;
        [~,dec]=max(c_t,[],1);
        correct=squeeze(dec==repmat(1:size(dec,2),[1 1 size(dec,3)]));
        if n==1
            correct_ave_plateau=1/N_rep*(correct);
            confm_plateau=zeros(p);
        else
            correct_ave_plateau=correct_ave_plateau+1/N_rep*(correct);
        end
        indt=sub2ind([p p],1:p,dec);
        confm_plateau(indt)=confm(indt)+1/N_rep;
    end
    %This section computes the SNR
    rv=randperm(ceil(size(sig_both,1)/10),2); %use a random pair of non-equal indices
    SNR_pl=mean(sig_pl,3)./sqrt(var(sig_pl,[],3)+var(squeeze(sig_pl(rv(1),rv(2),:))));
    SNR_both=mean(sig_both,3)./sqrt(var(sig_both,[],3)+var(squeeze(sig_both(rv(1),rv(2),:))));
    SNR_pl=diag(SNR_pl);
    SNR_pl=SNR_pl(end:-1:2);
    SNR_both=diag(SNR_both);
    SNR_both=SNR_both(end:-1:2);

    cap_pl=find(diff(SNR_pl<SNR_thresh)<0);
    if numel(cap_pl)==0
        cap_pl=0;
    else
        cap_pl=cap_pl(1);
    end
    cap_both=find(diff(SNR_both<SNR_thresh)<0);
    if numel(cap_both)==0
        cap_both=0;
    else
        cap_both=cap_both(1);
    end

    %This section computes teh average decoding performance based on the
    %attractor states
    correct_ave=correct_ave(end:-1:1);
    correct_ave=smooth(correct_ave,round(length(correct_ave)/20));
    capacity=find(diff(correct_ave<(.2))>0);
    if numel(capacity)<1
        capacity=0;
    else
        capacity=capacity(1);
    end

    correct_ave_plateau=correct_ave_plateau(end:-1:1);
    correct_ave_plateau=smooth(correct_ave_plateau,round(length(correct_ave_plateau)/20));
    capacity_plateau=find(diff(correct_ave_plateau<(.2))>0);
    if numel(capacity_plateau)<1
        capacity_plateau=0;
    else
        capacity_plateau=capacity_plateau(1);
    end

    pwdtp=mean(pwdtpn,3);
    pwdtb=mean(pwdtbn,3);
end
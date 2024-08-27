function [snr,sig,sigv,sigvr,snr_p,sig_p,sigv_p,sigvr_p] = bootstrapBTSPTcorr_indep(N,fp,fa,c,N_rep)
% This bootstraps over the computeBTSPCA3_indep function to
% extract things like the average snr, signal, signal variance

%Inputs:
%N - number of neurons
%fp - plateau sparsity
%fa - sparsity of temporally correlated activity
%c - activity temporal correlation
%N_rep - repetitions for bootstrapping

%Outputs:

%snr, snr_p - SNR
%sig, sig_p - signal
%sigv, sigv_p - signal variance
%sigvr, sigvr_p - signal variance for a random pattern
    mw=zeros(1,N_rep);
    for n=1:N_rep
        [Apost,Apre,Apm,Aa,W] = computeBTSPTcorr_indep(N,fp,fa,c);

        %Compute SNR
        mw(n)=mean(W(:));
        if n==1
            sigm=zeros(size(Apost,2),1);
            sigv=zeros(size(Apost,2),1);
            sigmr=0;
            sigvr=0;
        end
        rv=randperm(ceil(length(sigm)/10),2);
        t=(sum(Apost'.*((W.*Apre)'),2)-mw(n)*N*(fa+fp-fa*fp)*fp);
        sigm=sigm+(t)./N_rep;
        sigv=sigv+(t).^2./N_rep;
        tr=(sum(Apost(:,rv(1))'.*((W.*Apre(:,rv(2)))'),2)-mw(n)*N*(fa+fp-fa*fp)*fp);
        sigmr=sigmr+(tr)./N_rep;
        sigvr=sigvr+(tr).^2./N_rep;

        if n==1
            sigm_p=zeros(size(Apost,2),1);
            sigv_p=zeros(size(Apost,2),1);
            sigmr_p=0;
            sigvr_p=0;
        end
        rv=randperm(ceil(length(sigm)/10),2);
        t=(sum(Apost'.*((W.*Apm)'),2)-mw(n)*N*(fp)*fp);
        sigm_p=sigm_p+(t)./N_rep;
        sigv_p=sigv_p+(t).^2./N_rep;
        tr=(sum(Apost(:,rv(1))'.*((W.*Apm(:,rv(2)))'),2)-mw(n)*N*(fp)*fp);
        sigmr_p=sigmr_p+(tr)./N_rep;
        sigvr_p=sigvr_p+(tr).^2./N_rep;

    end
    %This section computes the SNR
    
    
    
    sigv=(sigv-sigm.^2)*(N_rep/(N_rep-1));
    sigvr=(sigvr-sigmr.^2)*N_rep/(N_rep-1);
    snr=sigm./sqrt(sigv+sigvr);

    %snr=diag(snr);
    snr=snr(end:-1:2);
    sig=sigm(end:-1:2);
    sigv=sigv(end:-1:2);

    
    
    sigv_p=(sigv_p-sigm_p.^2)*N_rep/(N_rep-1);
    sigvr_p=(sigvr_p-sigmr_p.^2)*N_rep/(N_rep-1);
    snr_p=sigm_p./sqrt(sigv_p+sigvr_p);

    %snr=diag(snr);
    snr_p=snr_p(end:-1:2);
    sig_p=sigm_p(end:-1:2);
    sigv_p=sigv_p(end:-1:2);

end

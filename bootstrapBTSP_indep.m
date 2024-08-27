function [cap,snr,sig,sigv,sigvr] = bootstrapBTSP_indep(N,fp,fm,N_rep)
% This bootstraps over the computeBTSP_uncorr function to
% extract things like the average snr, signal, signal variance, capacity

%Inputs:
%N - number of neurons
%fp - postsynaptic sparsity
%fm - presynaptic sparsity
%N_rep - repetitions for bootstrapping

%Outputs:

%cap - capacity computed from SNR based on SNR_thresh defined in function
%snr - SNR
%sig - signal
%sigv - signal variance
%sigvr - signal variance for a random pattern

    SNR_thresh=1;
    mw=zeros(1,N_rep);
    for n=1:N_rep
        [Ap,Am,W] = computeBTSP_indep(N,fp,fm);

        %Compute SNR
        mw(n)=mean(W(:));
        if n==1
            sigm=zeros(size(Ap,2),1);
            sigv=zeros(size(Ap,2),1);
            sigmr=0;
            sigvr=0;
        end
        rv=randperm(ceil(length(sigm)/10),2);
        t=(sum(Ap'.*((W.*Am)'),2)-mw(n)*N*(fm)*fp)./(N*fm*fp);
        sigm=sigm+(t)./N_rep;
        sigv=sigv+(t).^2./(N_rep);
        tr=(sum(Ap(:,rv(1))'.*((W.*Am(:,rv(2)))'),2)-mw(n)*N*(fm)*fp)./(N*fm*fp);
        sigmr=sigmr+(tr)./N_rep;
        sigvr=sigvr+(tr).^2./(N_rep);

    end
    %This section computes the SNR
    
    snr=sigm./sqrt((sigv-sigm.^2)+(sigvr-sigmr.^2));
    
    sigv=sigv-sigm.^2;
    sigvr=sigvr-sigmr.^2;
    %snr=diag(snr);
    snr=snr(end:-1:2);
    sig=sigm(end:-1:2);
    sigv=sigv(end:-1:2);

    cap=find(diff(snr<SNR_thresh)>0);
    if numel(cap)==0
        cap=0;
    else
        cap=cap(1);
    end
end

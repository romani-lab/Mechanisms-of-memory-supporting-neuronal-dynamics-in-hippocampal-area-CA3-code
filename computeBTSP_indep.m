function [Ap,Am,W] = computeBTSP_indep(N,fp,fm)

    %This function takes in:
    %N - number of weights
    %fp - sparsity of plateau events
    %fa - sparsity of spiking activity events
    %and returns:
    %Apost - post-synaptic signal
    %Apre - pre-synaptic signal
    %W - resulting weight matrix

    P=3*ceil(-1./(2*log(1-fp*fm))); 

    s_post_i=[];
    s_post_j=[];
    s_pre_i=[];
    s_pre_j=[];

    for i=1:P
        ntp=binornd(N,fp,1);
        s_post_i=[s_post_i; randperm(N,ntp)'];
        s_post_j=[s_post_j; i*ones([ntp 1])];
        ntm=binornd(N,fm,1);
        s_pre_i=[s_pre_i; randperm(N,ntm)'];
        s_pre_j=[s_pre_j; i*ones([ntm 1])];
    end
    Ap=sparse(s_post_i,s_post_j,ones(size(s_post_i)),N,P);
    Am=sparse(s_pre_i,s_pre_j,ones(size(s_pre_i)),N,P);
    %tic
    %W=computeW(N,A_pre,A_post,f_act+f_plateau,f_plateau);
    W=btsp_for_loop_indep(rand(N,1)<1/3,full(Ap),full(Am),N,P-1);
    %toc
    
end
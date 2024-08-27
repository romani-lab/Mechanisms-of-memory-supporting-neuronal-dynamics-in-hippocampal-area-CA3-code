function [Apost,Apre,Apm,Aa,W] = computeBTSPTcorr_indep(N,fp,fa,c)
    %This function takes in:
    %N - number of neurons
    %fp - sparsity of plateau events
    %fa - sparsity of correlated spiking activity events
    %c - temporal correlation of spiking activity events 
    %and returns:
    %Apost - post-synaptic signal = plateau signal
    %Apre - pre-synaptic signal = activity | plateau
    %Apm - plateau signal (redundant)
    %Aa - activity signal
    %W - resulting weight matrix
    
    P=3*ceil(-1./(2*log(1-fp*(fa+fp)))); 

    s_post_i=[];
    s_post_j=[];
    s_pre_i=[];
    s_pre_j=[];

    for i=1:P
        ntp=binornd(N,fp,1);
        s_post_i=[s_post_i; randperm(N,ntp)'];
        s_post_j=[s_post_j; i*ones([ntp 1])];

        ntm=binornd(N,fp,1);
        s_pre_i=[s_pre_i; randperm(N,ntm)'];
        s_pre_j=[s_pre_j; i*ones([ntm 1])];
    end
    Apost=sparse(s_post_i,s_post_j,ones(size(s_post_i)),N,P);
    Apm=sparse(s_pre_i,s_pre_j,ones(size(s_pre_i)),N,P);
    Aa=markovchain_sparse(N,P,fa,c);
    Apre=Apm|Aa;
    %tic
    %W=computeW(N,A_pre,A_post,f_act+f_plateau,f_plateau);
    W=btsp_for_loop_indep(rand(N,1)<1/3,full(Apost),full(Apre),N,P-1);
    %toc
    
end
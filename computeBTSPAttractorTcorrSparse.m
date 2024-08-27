function [A_post,A_pre,A_act,A_att,A_att_plateau,W] = computeBTSPAttractorAsymTcorrSparse(N,f_plateau,f_act,c)
    %This function takes in:
    %N - number of neurons
    %fp - sparsity of plateau events
    %fa - sparsity of correlated spiking activity events
    %c - temporal correlation of spiking activity events 
    %and returns:
    %A_post - post-synaptic signal = plateau signal
    %A_pre - pre-synaptic signal
    %A_act - activity signal
    %A_att - attractor state from initializing the system with both
    %activity and plateau
    %A_att_act - attractor state from initializing the system with activity
    %A_att_plateau - attractor state from initializing the system with
    %plateau
    %W - resulting weight matrix

    P=max(3*ceil(-1./(2*log(1-f_plateau*(f_act+f_plateau)))),100); 

    s_post_i=[];
    s_post_j=[];

    for i=1:P
        nt=binornd(N,f_plateau,1);
        s_post_i=[s_post_i; randperm(N,nt)'];
        s_post_j=[s_post_j; i*ones([nt 1])];
    end
    A_plateau=sparse(s_post_i,s_post_j,ones(size(s_post_i)),N,P);

    A_act=markovchain_sparse(N,P,f_act,c);

    A_pre=A_act|A_plateau;
    A_post=A_plateau; 

    W=btsp_for_loop(rand(N)<1/3,full(A_post),full(A_pre),N,P-1);

    W_rand=mean(W(:));
    inputs=(W-W_rand)*A_pre;
    i1=inputs;
    i1(A_post==0)=nan;
    m1=nanmean(i1(:,round(.95*P):end),'all');
    v1=nanvar(i1(:,round(.95*P):end),[],'all');
    i0=inputs;
    i0(A_pre==1)=nan;
    m0=nanmean(i0,'all');
    v0=nanvar(i0,[],'all');
    %t=(sqrt(v0(end)).*m1(end)+sqrt(v1(end)).*m0(end))./(sqrt(v0(end)) + sqrt(v1(end)));
    t=m0+3.5*sqrt(v0);
    threshfn=@(W,v) (W-W_rand)*v>t;

    inputs=(W-W_rand)*A_post;
    i1=inputs;
    i1(A_post==0)=nan;
    m1=nanmean(i1(:,round(.95*P):end),'all');
    v1=nanvar(i1(:,round(.95*P):end),[],'all');
    i0=inputs;
    i0(A_act==1)=nan;
    m0=nanmean(i0,'all');
    v0=nanvar(i0,[],'all');
    t_plateau=m0+3.5*sqrt(v0);
    threshfn_plateau=@(W,v) (W-W_rand)*v>t_plateau;

    tau_r=10;
    A_att=A_pre;
    A_att_plateau=A_post;
    %A_t=zeros(size(A_att));
    for i=1:tau_r %~isequal(A_t,A_att)
        %A_t=A_att;
        A_att=threshfn(W,A_att);
        A_att_plateau=threshfn_plateau(W,A_att_plateau);
    end

end
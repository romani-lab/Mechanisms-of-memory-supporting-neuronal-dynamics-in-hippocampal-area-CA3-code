function n_scaling_btsp_cl(task_id)
%This function takes in as a string the random number seed,
%task_id, and saves the resulting bootstrapped analyses.

basedir = './clusterout/';
%cd(basedir)
%newdir = strcat(basedir,task_id);
%mkdir(newdir)
rng(str2double(task_id));

N=1000:1000:10000;

    fp=10*log(N)./N;
    fa=fp;
    c=0*ones(size(N));
    N_rep=100;
    %t=zeros(length(N)+1,1);
    %t(1)=0;
    %tic;
    
    parfor n=1:length(c)
        [capacity_t,correct_ave_t,capacity_t_plateau,correct_ave_t_plateau,cap_pl,cap_both,SNR_pl,SNR_both,confm,confm_plateau] = bootstrapBTSPAttractorTcorr(N(n),fp(n),fa(n),c(n),N_rep);
        %t(n+1)=toc;
        data(n).correct_ave=correct_ave_t;
        data(n).capacity=capacity_t;
        data(n).correct_ave_plateau=correct_ave_t_plateau;
        data(n).capacity_plateau=capacity_t_plateau;
        data(n).cap_pl=cap_pl;
        data(n).cap_both=cap_both;
        data(n).SNR_pl=SNR_pl;
        data(n).SNR_both=SNR_both;
        data(n).confm=confm;
        data(n).confm_plateau=confm_plateau;
    end
    save([basedir 'n_scaling_btsp_out_' task_id '.mat'],'data','N','fp','fa','c','-v7.3');
end
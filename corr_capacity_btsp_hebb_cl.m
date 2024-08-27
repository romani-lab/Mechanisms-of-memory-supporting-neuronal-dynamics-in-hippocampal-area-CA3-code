function corr_capacity_btsp_hebb_cl(task_id)
%This function takes in as a string the random number seed,
%task_id, and saves the resulting bootstrapped analysis.

basedir = './clusterout/';
%cd(basedir)
%newdir = strcat(basedir,task_id);
%mkdir(newdir)
rng(str2double(task_id));

%N=1000:1000:10000;
    N=3000;
    fp=10*log(N)./N;
    fa=fp;
    %c=[(1-1./(1-fa)) 0:.1:.9 .91:.01:1];
    c=[0:.1:.9 .92 .94 .96 .98];
    N_rep=400;
    %t=zeros(length(N)+1,1);
    %t(1)=0;
    %tic;
    
    parfor n=1:length(c)
        [capacity_t,correct_ave_t,capacity_t_plateau,correct_ave_t_plateau,cap_pl,cap_both,SNR_pl,SNR_both,confm,confm_plateau] = bootstrapBTSPAttractorTcorr(N,fp,fa,c(n),N_rep);
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
    
        [capacity_t,correct_ave_t,capacity_t_plateau,correct_ave_t_plateau,cap_pl,cap_both,SNR_pl,SNR_both,confm,confm_plateau] = bootstrapHebbAttractorTcorr(N,fp,fa,c(n),N_rep);
        %t(n+1)=toc;
        data_fusi(n).correct_ave=correct_ave_t;
        data_fusi(n).capacity=capacity_t;
        data_fusi(n).correct_ave_plateau=correct_ave_t_plateau;
        data_fusi(n).capacity_plateau=capacity_t_plateau;
        data_fusi(n).cap_pl=cap_pl;
        data_fusi(n).cap_both=cap_both;
        data_fusi(n).SNR_pl=SNR_pl;
        data_fusi(n).SNR_both=SNR_both;
        data_fusi(n).confm=confm;
        data_fusi(n).confm_plateau=confm_plateau;
    end
    save([basedir 'corr_capacity_btsp_fusi_out_' task_id '.mat'],'data','data_fusi','N','fp','fa','c','-v7.3');
end
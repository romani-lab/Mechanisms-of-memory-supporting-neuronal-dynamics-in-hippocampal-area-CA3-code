function n_scaling_btsp_large_cl(N_str,N_rep_str,task_id)
%This function takes in (as strings) the size of the simulation, N_str, the number of
%repetitions for bootstrapping, N_rep_str, and the random number seed,
%task_id and saves the resulting bootstrapped analysis.


basedir = './clusterout/';
%cd(basedir)
%newdir = strcat(basedir,task_id);
%mkdir(newdir)
rng(str2double(task_id));

N=round(str2double(N_str));
N_rep=round(str2double(N_rep_str));

    fp=10*log(N)./N;
    fa=fp;
    c=0*ones(size(N));

    n=1;
    [capacity_t,correct_ave_t,capacity_t_plateau,correct_ave_t_plateau,cap_pl,cap_both,SNR_pl,SNR_both,confm,confm_plateau] = bootstrapBTSPAttractorTcorr_large(N,fp,fa,c,N_rep);
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

    save([basedir 'n_scaling_btsp_large_out_' N_str '_' N_rep_str '_' task_id '.mat'],'data','N','fp','fa','c','N_rep','-v7.3');
end
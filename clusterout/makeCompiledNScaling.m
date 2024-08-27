load('n_scaling_btsp_out_101.mat')

data_t=data;
c_t=c;
fa_t=fa;
fp_t=fp;
N_t=N;

load('n_scaling_btsp_large_out_16000_100_103.mat');

data_t(end+1)=data;
c_t(end+1)=c;
fa_t(end+1)=fa;
fp_t(end+1)=fp;
N_t(end+1)=N;

load('n_scaling_btsp_large_out_20000_100_103.mat');

data_t(end+1)=data;
c_t(end+1)=c;
fa_t(end+1)=fa;
fp_t(end+1)=fp;
N_t(end+1)=N;

load('n_scaling_btsp_large_out_24000_100_103.mat');

data_t(end+1)=data;
c_t(end+1)=c;
fa_t(end+1)=fa;
fp_t(end+1)=fp;
N_t(end+1)=N;


clear data c fa fp N
data=data_t;
c=c_t;
fa=fa_t;
fp=fp_t;
N=N_t;
N_rep=100*ones(1,length(data));
%N_rep(end)=25;

save('n_scaling_btsp_large_combined.mat',"data","c","N","fa","fp","N_rep",'-v7.3');
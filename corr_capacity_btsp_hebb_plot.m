%Plot attractor capacity vs temporal autocorrelation for BTSP and Hebb
load('./clusterout/corr_capacity_btsp_fusi_out_111.mat');
c_thresh=.5;
c_lower=.75;
c_upper=.25;
cap_btsp=zeros(1,length(data));
cap_fusi=zeros(size(cap_btsp));
cap_btsp_lower=zeros(size(cap_btsp));
cap_btsp_upper=zeros(size(cap_btsp));
cap_fusi_lower=zeros(size(cap_btsp));
cap_fusi_upper=zeros(size(cap_btsp));
for i=1:length(cap_btsp)
    c_btsp=diag(data(i).confm_plateau);
    c_fusi=diag(data_fusi(i).confm_plateau);

    cs_btsp=smooth(c_btsp,1);%ceil(length(c_btsp)*.01));
    cs_fusi=smooth(c_fusi,1);%ceil(length(c_fusi)*.01));

    cs_btsp=cs_btsp(end:-1:1);
    cs_fusi=cs_fusi(end:-1:1);

    cap_t=find(diff(cs_btsp<c_lower)>0);
    if numel(cap_t)<1
        cap_t=0;
    end
    cap_btsp_lower(i)=cap_t(end);

    cap_t=find(diff(cs_btsp<c_thresh)>0);
    if numel(cap_t)<1
        cap_t=0;
    end
    cap_btsp(i)=cap_t(end);

    cap_t=find(diff(cs_btsp<c_upper)>0);
    if numel(cap_t)<1
        cap_t=0;
    end
    cap_btsp_upper(i)=cap_t(end);

    cap_t=find(diff(cs_fusi<c_lower)>0);
    if numel(cap_t)<1
        cap_t=0;
    end
    cap_fusi_lower(i)=cap_t(end);

    cap_t=find(diff(cs_fusi<c_thresh)>0);
    if numel(cap_t)<1
        cap_t=0;
    end
    cap_fusi(i)=cap_t(end);

    cap_t=find(diff(cs_fusi<c_upper)>0);
    if numel(cap_t)<1
        cap_t=0;
    end
    cap_fusi_upper(i)=cap_t(end);
end

figure;
hold on;
ind_use=c<=.9;
errorbar(c(ind_use),cap_btsp(ind_use),cap_btsp(ind_use)-cap_btsp_lower(ind_use),cap_btsp_upper(ind_use)-cap_btsp(ind_use),'k.','linewidth',1,'markersize',30);
errorbar(c(ind_use),cap_fusi(ind_use),cap_fusi(ind_use)-cap_fusi_lower(ind_use),cap_fusi_upper(ind_use)-cap_fusi(ind_use),'m.','linewidth',1,'markersize',30);
set(gca,'tickdir','out');
box off;
xlabel('Activity autocorrelation (c)');
ylabel('Attractor capacity');

tau=-1./log(c);
figure;
hold on;
errorbar(tau(ind_use),cap_btsp(ind_use),cap_btsp(ind_use)-cap_btsp_lower(ind_use),cap_btsp_upper(ind_use)-cap_btsp(ind_use),'k.-','linewidth',1,'markersize',15);
errorbar(tau(ind_use),cap_fusi(ind_use),cap_fusi(ind_use)-cap_fusi_lower(ind_use),cap_fusi_upper(ind_use)-cap_fusi(ind_use),'m.-','linewidth',1,'markersize',15);
set(gca,'tickdir','out');
box off;
xlabel('Activity autocorrelation time (-1/log(c))');
ylabel('Attractor capacity');
%
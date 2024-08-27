function [cap_both,cap_pl]=calc_snrThresh(N,data,snrThresh,visible)

errfrac=.25; %Error bars will be where the snr crosses [snrThresh(1+errfrac), snrThresh(1-errfrac)];

cap_both=zeros(length(data),1);
cap_both_l=zeros(length(data),1);
cap_both_h=zeros(length(data),1);

cap_pl=zeros(length(data),1);
cap_pl_l=zeros(length(data),1);
cap_pl_h=zeros(length(data),1);

for i=1:length(data)
    smoothlength=ceil(length(data(i).SNR_both)*.02);
    snr_both=smooth(data(i).SNR_both,smoothlength);
    capt=find(diff(snr_both<snrThresh)>0);
    if numel(capt)==0
        cap_both(i)=1;
    else
        cap_both(i)=capt(1);
    end
    
    capt=find(diff(snr_both<(1+errfrac).*snrThresh)>0);
    if numel(capt)==0
        cap_both_l(i)=1;
    else
        cap_both_l(i)=capt(1);
    end
    capt=find(diff(snr_both<(1-errfrac).*snrThresh)>0);
    if numel(capt)==0
        cap_both_h(i)=1;
    else
        cap_both_h(i)=capt(1);
    end



    snr_pl=smooth(data(i).SNR_pl,smoothlength);
    capt=find(diff(snr_pl<snrThresh)>0);
    if numel(capt)==0
        cap_pl=1;
    else
        cap_pl(i)=capt(1);
    end
    capt=find(diff(snr_pl<(1+errfrac).*snrThresh)>0);
    if numel(capt)==0
        cap_pl_l(i)=1;
    else
        cap_pl_l(i)=capt(1);
    end
    capt=find(diff(snr_pl<(1-errfrac).*snrThresh)>0);
    if numel(capt)==0
        cap_pl_h(i)=1;
    else
        cap_pl_h(i)=capt(1);
    end
end

if visible
    % % figure; hold on;
    % % for i=1:length(data)
    % %     plot(smooth(data(i).SNR_both,20))
    % % end
    f=@(N) N.^2./log(N).^2;

    % d=cap_both;
    % dl=cap_both_l;
    % dh=cap_both_h;
    % figure;
    % hold on;
    % errorbar(N,d,d-dl,dh-d,'k.','markersize',15);
    % plot(N,f(N).*(d(end)/f(N(end))),'k--');
    % legend('BTSP','(N/log N)^2');
    % xlabel('N');
    % ylabel('capacity');
    % title('snr capacity: both');
    % set(gca,'xscale','log','yscale','log');
    % set(gca,'yscale','log');
    % box off;
    % set(gca,'tickdir','out');
    % 
    % d=cap_both;
    % dl=cap_both_l;
    % dh=cap_both_h;
    % figure;
    % hold on;
    % errorbar(N,d,d-dl,dh-d,'k.','markersize',15);
    % plot(N,f(N).*(d(end)./f(N(end))),'k--');
    % legend('BTSP','(N/log N)^2');
    % xlabel('N');
    % ylabel('capacity');
    % title('snr capacity: both');
    % box off;
    % set(gca,'tickdir','out');
    
    d=cap_pl;
    dl=cap_pl_l;
    dh=cap_pl_h;
    figure;
    hold on;
    errorbar(N,d,d-dl,dh-d,'k.','markersize',15,'linewidth',1);
    plot(N,f(N).*(d(end)./f(N(end))),'k--');
    legend('BTSP','(N/log N)^2');
    xlabel('N');
    ylabel('capacity');
    title('snr capacity: plateau');
    set(gca,'xscale','log','yscale','log');
    set(gca,'yscale','log');
    set(gca,'tickdir','out');
    box off;

    d=cap_pl;
    dl=cap_pl_l;
    dh=cap_pl_h;
    figure;
    hold on;
    errorbar(N,d,d-dl,dh-d,'k.','markersize',15,'linewidth',1);
    plot(N,f(N).*(d(end)/f(N(end))),'k--');
    legend('BTSP','(N/log N)^2');
    xlabel('N');
    ylabel('capacity');
    title('snr capacity: plateau');
    set(gca,'tickdir','out');
    box off;

end

end
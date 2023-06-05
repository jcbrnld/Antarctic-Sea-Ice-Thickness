% 24-May-2020

% Jacob Arnold
% Compare different sea ice thickness average intervals

load /Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/MAT_files/Final/Diff_av_int/s10SIT_ai2.mat;
SIT2 = SIT; clear SIT

load /Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/MAT_files/Final/Diff_av_int/s10SIT_ai4.mat;
SIT4 = SIT; clear SIT

load /Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/MAT_files/Final/Diff_av_int/s10SIT_ai6.mat;
SIT6 = SIT; clear SIT

load /Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/MAT_files/Final/Diff_av_int/s10SIT_ai10.mat;
SIT10 = SIT; clear SIT

load /Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/MAT_files/Final/Diff_av_int/s10SIT_ai20.mat;
SIT20 = SIT; clear SIT

load /Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/Sector10.mat;
SIT10_2 = SIT; clear SIT


figure;
set(gcf, 'Position', [500,600, 1100, 400]);
plot(SIT2.dn,nanmean(SIT2.H));hold on;
plot(SIT4.dn,nanmean(SIT4.H));
plot(SIT6.dn,nanmean(SIT6.H));
plot(SIT10.dn,nanmean(SIT10.H));
plot(SIT20.dn,nanmean(SIT20.H));
datetick('x', 'yyyy', 'keepticks')
xlim([min(SIT2.dn),max(SIT2.dn)])
legend('2 Finite','4 Finite','6 Finite','10 Finite','20 Finite');
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/allAVintervals.png','-dpng', '-r400')




figure;
set(gcf,'Position',[500,600,1100,400]);
plot(SIT10.dn,nanmean(SIT10.H));hold on;
plot(SIT102.dn,nanmean(SIT102.H));
%plot(SIT20.dn,nanmean(SIT20.H));
datetick('x', 'yyyy', 'keepticks')
xlim([min(SIT102.dn),max(SIT102.dn)])
legend('2 Finite', '10 Finite','20 Finite');
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/AVintervals_2_10_20.png','-dpng', '-r400')






figure;
set(gcf,'Position',[500,600,1000,900]);
subplot(2,1,1);
plot(SIT2.dn, nanmean(SIT2.H));hold on
plot(SIT10.dn, nanmean(SIT10.H), 'LineWidth', 1.2);
datetick('x', 'yyyy', 'keepticks')
xlim([min(SIT2.dn),max(SIT2.dn)])
legend('2 Finite', '10 Finite');
subplot(2,1,2);
plot(SIT2.dn, nanmean(SIT2.H));hold on
plot(SIT20.dn, nanmean(SIT20.H), 'LineWidth', 1.2);
datetick('x', 'yyyy', 'keepticks')
xlim([min(SIT2.dn),max(SIT2.dn)])
legend('2 Finite', '20 Finite');
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/AVintervals_2_10_20_subplot.png','-dpng', '-r400')








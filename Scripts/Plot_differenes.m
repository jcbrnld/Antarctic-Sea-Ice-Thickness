% 16-June-2021

% Jacob Arnold

% Compare 600/400/800 translations for old/second year/multi-year ice types
% with 300/250/350 translations for several sectors.


load ICE/ICETHICKNESS/Data/MAT_files/Final/Thicker_old-sy-my/sector14.mat
SIT_1 = SIT; clear SIT;
load ICE/ICETHICKNESS/Data/MAT_files/Final/Thinner_old-sy-my/sector14.mat
SIT_2 = SIT; clear SIT;





figure;
plot(SIT_1.dn, nanmean(SIT_1.H), 'linewidth', 1.1); hold on;
plot(SIT_2.dn, nanmean(SIT_2.H), 'linewidth', 1.1);
set(gcf, 'position', [500,600,1200,400]);
datetick('x', 'mm-yyyy');
xlim([min(SIT_1.dn), max(SIT_1.dn)])
set(gca,'XTickLabelRotation',35)
legend('Thicker definitions', 'Thinner definitions');
title('Sector14');
print('ICE/ICETHICKNESS/Figures/Compare_translations/sector14.png', '-dpng', '-r300');



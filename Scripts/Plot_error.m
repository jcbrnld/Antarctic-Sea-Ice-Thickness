% Jacob Arnold

% 26-aug-2021

% Plot interpretation error as upper and lower bounds of SIT



load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector10.mat
%%

figure;
set(gcf, 'position', [500,500,1600,400]);
plot(nanmean(SIT.H), 'color', [0.1,0.7,0.9], 'linewidth', 1.5);hold on
plot(nanmean(SIT.H)+nanmean(SIT.error.H), 'color','[0.95,0.95,0.95]',  'linewidth', .5)
plot(nanmean(SIT.H)-nanmean(SIT.error.H), 'color','[0.95,0.95,0.95]',  'linewidth', .5)
title('SIT with translation error bounds');
set(gca, 'color', [0.1,0.1,0.1]);





% Jacob Arnold

% 17-Aug-2021

% After loading and translating raw gridded SIGRID data (in
% SITworkingscript_Final), plot some area
% averaged comparisons. 


figure;
set(gcf, 'position', [300,600,1000,300]);
plot(double(SIT.dn), nanmean(SIT.ct));hold on
plot(double(SIT.dn), nanmean(avgSIC));
datetick('x', 'mm-yyyy');
grid on; grid minor
legend('NIC CT','Bremen SIC','location','southeast');
xlim([min(SIT.dn)-100, max(SIT.dn)+100]);
title('Sector14');
%text(731594, 10, {['Avg CT = ', num2str(nanmean(SIT.ct, 'all'))], ['Avg SIC = ', num2str(nanmean(avgSIC, 'all'))]});

%print('ICE/ICETHICKNESS/Figures/Compare_SIC_CT/Sector14_2.png', '-dpng', '-r800');



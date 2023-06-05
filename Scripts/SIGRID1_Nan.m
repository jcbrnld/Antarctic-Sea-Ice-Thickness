% 20-aug-2021

% Jacob Arnold


% View amount of actual data (aside from CT) in the older SIGIRID 1 charts. 







load ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/charts_gridded

%% Initial vals

%pernanca = (sum(isnan(charts_gridded.CA))./115380).*100;
pernansa = (sum(isnan(charts_gridded.SA))./115380).*100;
pernansb = (sum(isnan(charts_gridded.SB))./115380).*100;
pernansc = (sum(isnan(charts_gridded.SC))./115380).*100;
pernanct = (sum(isnan(charts_gridded.CT))./115380).*100;


figure;
set(gcf, 'position', [300,600,1000,300]);
plot(pernansa); hold on
plot(pernansb);
plot(pernansc);
plot(pernanct);
grid on; grid minor
legend('% nan SA','% nan SB','% nan SC', '% nan CT', 'Location', 'southeast');

%print('ICE/ICETHICKNESS/Figures/SIGRID1/percent_nans.png', '-dpng', '-r400');



%% Convert 99 to nan and view again


charts_gridded.SA(charts_gridded.SA==99) = nan;
charts_gridded.CA(charts_gridded.CA==99) = nan;
charts_gridded.SB(charts_gridded.SB==99) = nan;
charts_gridded.CB(charts_gridded.CB==99) = nan;






pernansa2 = (sum(isnan(charts_gridded.SA))./115380).*100;
pernansb2 = (sum(isnan(charts_gridded.SB))./115380).*100;
pernansc2 = (sum(isnan(charts_gridded.SC))./115380).*100;
pernanct2 = (sum(isnan(charts_gridded.CT))./115380).*100;
pernanca2 = (sum(isnan(charts_gridded.CA))./115380).*100;


figure;
set(gcf, 'position', [300,600,1000,300]);
plot(pernansa2); hold on
plot(pernansb2);
plot(pernansc2);
%plot(pernanct2);
grid on; grid minor
legend('% nan SA','% nan SB','% nan SC', '% nan CT', 'Location', 'southeast');
title('SA, SB, SC after 99=nan');



figure;
set(gcf, 'position', [300,600,1000,300]);
plot(pernansa); hold on
plot(pernansa2);
title('% nan SA before and after 99=nan');
text(20,77, {['Mean w99: ',num2str(mean(pernansa))],['Mean wnan: ',num2str(mean(pernansa2))]});
grid on; grid minor
legend('% nan SA with 99','% nan SA no 99', 'Location', 'southwest');
%print('ICE/ICETHICKNESS/Figures/SIGRID1/percent_nans_b4andafter99=nan.png', '-dpng', '-r400');



figure;
set(gcf, 'position', [300,600,1000,300]);
plot(pernansa2); hold on
plot(pernanca2);
title('% nan SA vs CA after 99=nan');
text(20,77, {['Mean SA: ',num2str(mean(pernansa2))],['Mean CA: ',num2str(mean(pernanca2))]});
grid on; grid minor
legend('% nan SA','% nan CA', 'Location', 'southwest');
%print('ICE/ICETHICKNESS/Figures/SIGRID1/percent_nans_CAvsSA.png', '-dpng', '-r400');











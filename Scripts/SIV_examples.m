% Jacob Arnold

% 20-Jan-2022

% Show unnatural SIV fluctuations from vanishing or incorrectly traced
% icebergs
% Use sector 12 as an example (B9b not traced before 12-Dec-2005)


sector = '10';

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
fSIT = SIT; clear SIT

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector',sector,'.mat']);
oSIT = SIT; clear SIT



%% Calculate SIV

% at each time
% --> sum of all grid point areas times their respective H
% --> adjust for units --> divide H by 1000


fSIV = sum((fSIT.H./1000).*3.125, 'omitnan'); % Yields Volume in km^3

oSIV = sum((oSIT.H./1000).*3.125, 'omitnan'); % Yields Volume in km^3



%%

cd = find(fSIT.dn==datenum(2005,12,12));

fdvdt = fSIV(cd)-fSIV(cd-1); fper = (fdvdt/fSIV(cd))*100;
odvdt = oSIV(cd)-oSIV(cd-1); oper = (odvdt/oSIV(cd))*100;

xticker = unique(fSIT.dv(:,1));
xticker(end+1) = 2022;
xticker(:,2:3) = 1;
xticker = datenum(xticker);

figure;
plot_dim(800,250);
plot(oSIT.dn, oSIV, 'color', [0.4,0.6,0.9], 'linewidth', 1.2);
hold on
plot(fSIT.dn, fSIV, 'color', [0.4,0.8,0.6], 'linewidth', 1.2);
xticks(xticker);
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(fSIT.dn)-50, max(fSIT.dn)+50]);
xline(fSIT.dn(cd), 'linewidth', 1, 'color', 'm');
%xline(fSIT.dn(cd-1), 'linewidth', 1, 'color', 'm');

text(732800, 50, {'\DeltaSIV at ungrounding',['before correction: ',num2str(odvdt),...
    'km^3 [',num2str(oper),' %]'], ['after correction: ',num2str(fdvdt), 'km^3 [',num2str(fper),' %]']},'interpreter','latex');
grid on
xtickangle(30);
ylabel('Sea Ice Volume [km^3]')
legend('Before Correction', 'After Correction');
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/Compare/s12siv.png', '-dpng', '-r500');

%% ZOOOOM

figure;
plot_dim(800,250);
plot(oSIT.dn, oSIV, 'color', [0.4,0.6,0.9], 'linewidth', 1.2);
hold on
plot(fSIT.dn, fSIV, 'color', [0.4,0.8,0.6], 'linewidth', 1.2);
%xticks(xticker);
xlim([fSIT.dn(cd-3), fSIT.dn(cd+2)]);
datetick('x', 'dd-mmm-yyyy', 'keepticks');

xline(fSIT.dn(cd), 'linewidth', 1, 'color', 'm');
xline(fSIT.dn(cd-1), 'linewidth', 1, 'color', 'm');

text(fSIT.dn(cd)+.5, 19, {'\DeltaSIV at ungrounding',['before correction: ',num2str(odvdt),...
    'km^3 [',num2str(oper),' %]'], ['after correction: ',num2str(fdvdt), 'km^3 [',num2str(fper),' %]']});
xtickangle(15);
ylabel('Sea Ice Volume [km^3]')
legend('Before Correction', 'After Correction');
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/Compare/s12sivzoom.png', '-dpng', '-r500');




%% Hard to see much - try just the period before b9b broke off

fav = mean(fSIV(1:cd));
oav = mean(oSIV(1:cd));

figure;
plot_dim(800,320);
plot(oSIT.dn(1:cd), oSIV(1:cd), 'color', [0.4,0.6,0.9], 'linewidth', 1.3);
hold on
plot(fSIT.dn(1:cd), fSIV(1:cd), 'color', [0.9,0.4,0.5], 'linewidth', 1.1);
xticks(xticker);
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(fSIT.dn)-25, fSIT.dn(cd)+25]);
%xline(fSIT.dn(cd), 'linewidth', 1.2, 'color', 'm');
grid on
xtickangle(30);
ylabel('Sea Ice Volume [km^3]')
title(['Sector ',sector,' before vs after finetuning'])
legend(['Before: Mean SIV = ',num2str(oav)], ['After: Mean SIV = ',num2str(fav)], 'fontsize', 12)
%text(731947, 50, {['Average volume before: ',num2str(oav)], ['Average volume after: ',num2str(fav)]});
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/Compare/s12b4B9b_2.png', '-dpng', '-r500');



%% Now look at difference between no CT nanfill and final 

sector = '10';

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
fSIT = SIT; clear SIT

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors_b4CTnanfill/sector',sector,'.mat']);
oSIT = SIT; clear SIT



%% Calculate SIV

% at each time
% --> sum of all grid point areas times their respective H
% --> adjust for units --> divide H by 1000


fSIV = sum((fSIT.H./1000).*3.125, 'omitnan'); % Yields Volume in km^3

oSIV = sum((oSIT.H./1000).*3.125, 'omitnan'); % Yields Volume in km^3



%%



%cd = find(fSIT.dn==datenum(2005,12,12)); % critical date
% Index 211 is the drop from 25km SIC
cd = 212;

fdvdt = fSIV(cd)-fSIV(cd-1); fper = (fdvdt/fSIV(cd))*100; % change and % change at that date
odvdt = oSIV(cd)-oSIV(cd-1); oper = (odvdt/oSIV(cd))*100;

xticker = unique(fSIT.dv(:,1));
xticker(end+1) = 2022;
xticker(:,2:3) = 1;
xticker = datenum(xticker);

figure;
plot_dim(800,250);
plot(oSIT.dn, oSIV, 'color', [0.4,0.6,0.9], 'linewidth', 1.2);
hold on
plot(fSIT.dn, fSIV, 'color', [0.4,0.8,0.6], 'linewidth', 1.2);
xticks(xticker);
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(fSIT.dn)-50, max(fSIT.dn)+50]);
xline(fSIT.dn(cd), 'linewidth', 1, 'color', 'm');
%xline(fSIT.dn(cd-1), 'linewidth', 1, 'color', 'm');

text(732800, 50, {'\DeltaSIV at ungrounding',['before correction: ',num2str(odvdt),...
    'km^3 [',num2str(oper),' %]'], ['after correction: ',num2str(fdvdt), 'km^3 [',num2str(fper),' %]']});
grid on
xtickangle(30);
title('Sector 10 SIV before vs after CT fill');
ylabel('Sea Ice Volume [km^3]')
legend('Before CT Fill', 'After CT Fill');
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/Compare/s10siv.png', '-dpng', '-r500');





%% ZOOOOM

figure;
plot_dim(800,250);
plot(oSIT.dn, oSIV, 'color', [0.4,0.6,0.9], 'linewidth', 1.2);
hold on
plot(fSIT.dn, fSIV, 'color', [0.4,0.8,0.6], 'linewidth', 1.2);
%xticks(xticker);
xlim([fSIT.dn(cd-3), fSIT.dn(cd+2)]);
datetick('x', 'dd-mmm-yyyy', 'keepticks');

xline(fSIT.dn(cd), 'linewidth', 1, 'color', 'm');
xline(fSIT.dn(cd-1), 'linewidth', 1, 'color', 'm');

text(fSIT.dn(cd)+.5, 19, {'\DeltaSIV at %NaN change',['before correction: ',num2str(odvdt),...
    'km^3 [',num2str(oper),' %]'], ['after correction: ',num2str(fdvdt), 'km^3 [',num2str(fper),' %]']});
xtickangle(15);
ylabel('Sea Ice Volume [km^3]')
legend('Before CT Fill', 'After CT Fill');
grid on
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/Compare/s10sivb4ct_zoom.png', '-dpng', '-r500');

















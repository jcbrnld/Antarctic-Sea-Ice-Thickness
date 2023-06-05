% Jacob Arnold

% 06-May-2022

% Fix offshore and so SIV 
% incorrect values were probably calculated by multiplying H times 3.125 
% where it should be by 25.

%% Offshore Zones
for ii = 1:6
    
    snames = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};
    sstrings = {'Subpolar Atlantic', 'Subpolar Indian', 'Subpolar Pacific', 'ACC Atlantic', 'ACC Indian', 'ACC Pacific'};
    sector = snames{ii};
    disp(['Fixing SIV for ',sstrings{ii}])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/',sector,'.mat']);


    SIV = sum((SIT.H./1000).*25, 1, 'omitnan'); % 25 km grid cells
    SIT.SIV = SIV';

    %save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/',sector,'.mat'], 'SIT', '-v7.3');

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/',sector,'.mat']);
    seaice.SIV = SIV';
    %save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/',sector,'.mat'], 'seaice', '-v7.3');

    % plot
    p = polyfit(seaice.dn, seaice.SIV, 1);
    y = polyval(p, seaice.dn);
    slope = (((y(2)-y(1))/y(1))*100)*521.77; % weeks in a decade

    figure; 
    plot_dim(900,270);
    plot(seaice.dn, seaice.SIV, 'color', [0.9,0.4,0.4], 'linewidth', 1.2);
    hold on;
    midtick = dnticker(1997,2022,7,1);
    for tt = 1:length(midtick)
        xline(midtick(tt), 'color', [0.8,0.8,0.8], 'linewidth', 0.5);
    end
    pline = plot(seaice.dn, y, '--','color', [.02,.02,.02], 'linewidth', 1.2);
    xticks(dnticker(1997,2022));
    datetick('x', 'mm/yyyy', 'keepticks');
    xtickangle(26);
    xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
    title([sstrings{ii},' Sea Ice Volume'])
    legend(pline, ['Slope = ',num2str(slope), ' %dec^-^1'], 'fontsize', 12);
    grid on
    ylabel('Sea Ice Volume [km^3]');
    print(['ICE/ICETHICKNESS/Figures/Zones/',snames{ii},'/',snames{ii},'SIV.png'], '-dpng', '-r500');

    clearvars
end




%% Southern ocean 


load('ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat');

soff = sum((SIT.H(SIT.offshore,:)./1000).*25, 1, 'omitnan'); % 25 km grid cells
ssh = sum((SIT.H(SIT.shelf,:)./1000).*3.125, 1, 'omitnan'); % 3.125 km grid cells
SIV = soff+ssh;

SIT.SIV = SIV';

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat', 'SIT', '-v7.3');

load('ICE/ICETHICKNESS/Data/MAT_files/Final/properties/so.mat');
seaice.SIV = SIV';
%save('ICE/ICETHICKNESS/Data/MAT_files/Final/properties/so.mat', 'seaice', '-v7.3');

% plot
p = polyfit(seaice.dn, seaice.SIV, 1);
y = polyval(p, seaice.dn);
slope = (((y(2)-y(1))/y(1))*100)*521.77; % %change/week * 521.77weeks in a decade

figure; 
plot_dim(900,270);
plot(seaice.dn, seaice.SIV, 'color', [0.9,0.4,0.4], 'linewidth', 1.2);
hold on;
midtick = dnticker(1997,2022,7,1);
for tt = 1:length(midtick)
    xline(midtick(tt), 'color', [0.8,0.8,0.8], 'linewidth', 0.7);
end
pline = plot(seaice.dn, y, '--','color', [.02,.02,.02], 'linewidth', 1.2);
xticks(dnticker(1997,2022));
datetick('x', 'mm/yyyy', 'keepticks');
xtickangle(26);
xlim([min(seaice.dn)-50, max(seaice.dn)+50]);
title('Southern Hemisphere Sea Ice Volume')
legend(pline, ['Slope = ',num2str(slope), ' %dec^-^1'], 'fontsize', 12);
grid on
ylabel('Sea Ice Volume [km^3]');
yticks(500:250:2500);
print('ICE/ICETHICKNESS/Figures/Zones/so/soSIV.png', '-dpng', '-r500');



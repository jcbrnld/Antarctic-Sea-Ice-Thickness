% Jacob Arnold

% 07-Oct-2021

% Load in SOD SIT data that have been average to KM ICESat campaign periods
% and interpolated to ICESat satellite tracks over a sector.

sector = '00';
load(['ICE/ICETHICKNESS/Data/MAT_files/Altimetry/KM_ICESat/For_Comparison/sector',sector,'_onTrack_RedunAve.mat']);
%


for tt = 1:12
    T = tt;
    if sector == '00'
        m_basemap('p', [0,360], [-90,-60])
        scatsize = 4;
        set(gcf, 'position', [500,600,1200,1000]);
    else
        m_basemap('a', londom, latdom)
        scatsize = 10;
    end

    m_scatter(TSOD.lon{T}, TSOD.lat{T}, scatsize, TSOD.H{T}, 'filled');
    caxis([0,3])
    cmocean('ice');
    cbh = colorbar;
    cbh.Ticks  = [0:0.25:3];
    print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/spatial/',TSOD.Cruises{T},'_SODonPaths.png'],...
        '-dpng','-r600');
    close

end

%-------------------------------------------------------------------
for aa = 1:12
    
    avgSOD(aa) = nanmean(TSOD.H{aa});
    avgICESat(aa) = nanmean(TSOD.kmSIT{aa});
end
diffav = avgSOD-avgICESat;
diffper = (diffav./avgSOD).*100;


figure
set(gcf, 'position', [500, 600, 1000, 600])
h1 = subplot(3,2,1:4);
p1 = plot(TSOD.mid_dn, avgSOD, 'color', [0.65, 1, 0.75], 'linewidth', 1.2);
hold on
p2 = plot(TSOD.mid_dn, avgICESat, 'color', [0.65,0.75, 1], 'linewidth', 1.2);
set(h1, 'Units', 'normalized');
set(h1, 'Position', [0.1, .32575, .8, .6]); % Controlling subplot size
datetick('x', 'mm-yyyy');
xticks(TSOD.mid_dn);
%xticklabels(kmSIT.Cruises)
xticklabels([])
%xlabel('ICESat Campaigns');
set(gca, 'color', [0.2,0.2,0.2]);
set(gcf, 'color', [1,1,1]);

coefficients1 = polyfit(TSOD.mid_dn.', avgSOD.', 1);
coefficients2 = polyfit(TSOD.mid_dn.', avgICESat.', 1);
YFit1 = coefficients1(1)*TSOD.mid_dn+coefficients1(2);
YFit2 = coefficients2(1)*TSOD.mid_dn+coefficients2(2);
plot(TSOD.mid_dn, YFit1, '--', 'color', [1,1,1],'LineWidth', 1); % Linear best fit
plot(TSOD.mid_dn, YFit2, '-.', 'color', [1,1,1],'LineWidth', 1); % Linear best fit
totalSlope1 = YFit1(end)-YFit1(1);
totalSlope2 = YFit2(end)-YFit2(1);

grid on
ax = gca;
ax.GridColor = [1,1,1];
legend('\color{white} SOD SIT', '\color{white} ICESat SIT',...
    ['\color{white} SOD Slope = ', num2str(totalSlope1)],...
    ['\color{white} ICESat Slope = ', num2str(totalSlope2)]);
ylabel('Sea Ice Thickness [m]');
ylim([0,2])
yticks([0:0.2:3]);

corrVals = corrcoef(avgSOD, avgICESat);
    disp(['Means Correlation: ', num2str(corrVals(2,1))])

title(['Sector ',sector,': Mean SIT from SOD and ICESat on ICESat Tracks']);
h2 = subplot(3,2,5:6);
plot(TSOD.mid_dn, abs(diffper), 'color', [.9, .7, .6], 'linewidth', 1.1)
set(h2, 'Units', 'normalized');
set(h2, 'Position', [0.1, .10, .8, .2]); % Controlling subplot size ---- Handy trick
datetick('x', 'mm-yyyy');
xticks(TSOD.mid_dn);
xticklabels(TSOD.Cruises)
xlabel('ICESat Campaigns');
set(gca, 'color', [0.2,0.2,0.2]);grid on
ax = gca;
ax.GridColor = [1,1,1];
ylabel('% Difference')
%ylim([0,100])
if max(abs(diffper))<100

    yticks([0:5:max(abs(diffper))+50]);
else
    if max(abs(diffper))>500
        yticks([0:100:max(abs(diffper))+200]);
    else

        yticks([0:10:max(abs(diffper))+100]);
    end
end
set(gcf, 'InvertHardcopy', 'off')
print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/Track/Average_compare2_WithPercDiff.png'], '-dpng','-r600');

%-----------------------


% Scatterplot of avgSOD and avgICESat
figure;
scatter(avgSOD, avgICESat, 60,'filled');
hold on
ylim([0,2.1]);xlim([0,2.1]);
grid on ;grid minor
title(['Sector ', sector, ' Mean SOD SIT vs ICESat for Each Campaign Period'])
text(0.08, 2, ['r = ', num2str(corrVals(2,1))], 'fontsize', 16);
xlabel('SOD SIT [m]');
ylabel('ICESat SIT [m]')
box on
tempx = [0:0.1:3];
coef = polyfit(avgSOD, avgICESat, 1);
YFit = coef(1)*tempx+coef(2);
fit = plot(tempx, YFit, '--m', 'linewidth', 1.1);
legend([fit], ['Slope = ',num2str(coef(1))], 'fontsize', 14);
print(['ICE/ICETHICKNESS/Figures/ICESat/Compare/sector',sector,'/Track/scatterRelationship.png'], '-dpng','-r400');














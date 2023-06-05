% Jacob Arnold

% View SIV trend lines only

for ss = 1:19
    if ss < 11
        sector = ['0',num2str(ss-1)];
    else
        sector = num2str(ss-1);
    end
    
    disp(['Starting sector ',sector,'...'])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    seaice = SIT; clear SIT
    SIV = nansum((seaice.H./1000).*3.125);
    p1 = polyfit(seaice.dn, SIV',1);
    y{ss} = polyval(p1, seaice.dn);
    slope(ss) = y{ss}(622)-y{ss}(101);
    slopeper(ss) = (slope(ss)/y{ss}(101))*100;
    y{ss} = y{ss}./nanmean(SIV, 'all');
    if ss==1
        dn = seaice.dn;
    end
    clear SIV p1 seaice
end

%colors = colormapinterp(mycolormap('idk'),18);
colors = colormapinterp(colormap('jet'),18);

figure;
plot_dim(1350,400);
ticker = dnticker(1997,2022);
plot(dn, y{1},':', 'linewidth', 5, 'color', 'm');
hold on
for ii = 2:19
    plot(dn, y{ii}, 'linewidth', 1.2, 'color', colors(ii-1,:));
end

set(gca, 'color', [0.9,0.9,0.9])
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27)
title('Trends of SIV in all shelf sectors')
grid on
legend('00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','orientation', 'horizontal', 'location', 'north');
xlim([min(dn)-50, max(dn)+50])
    
ax = gca;
ax.GridColor = [0,0,0];

ylabel('% of the mean')

set(gcf, 'InvertHardcopy', 'off')
print('ICE/ICETHICKNESS/Figures/Trends/allshelftrends.png', '-dpng', '-r600');


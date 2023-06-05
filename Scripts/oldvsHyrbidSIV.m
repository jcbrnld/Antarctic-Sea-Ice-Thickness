% Jacob Arnold




% Compare old vs hybrid SIT



% old
for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
        end

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Properties/b4_ratiocorrect/sector',sector,'.mat']);
    oSIT = seaice; clear seaice;

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    SIV = nansum((SIT.H./1000).*3.125);

    p1 = polyfit(oSIT.dn, oSIT.SIV',1);
    y1 = polyval(p1, oSIT.dn);
    slope1 = y1(622)-y1(101);
    slopeper1 = (slope1/y1(101))*100;

    p2 = polyfit(SIT.dn, SIV',1);
    y2 = polyval(p2, oSIT.dn);
    slope2 = y2(622)-y2(101);
    slopeper2 = (slope2/y2(101))*100;


    ticker = dnticker(1997,2022);
    figure
    plot_dim(800,200)
    plot(oSIT.dn, oSIT.SIV, 'linewidth', 1.05)
    hold on
    plot(oSIT.dn, y1,'--','color', [0.2,0.5,0.8])
    plot(SIT.dn, SIV, 'linewidth', 1.2);
    plot(SIT.dn, y2, '--', 'color', [0.8,0.6,0.4])
    xticks(ticker);
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(SIT.dn)-50, max(SIT.dn)+50])
    legend('Old', ['Slope = ',num2str(slopeper1),' % dec^-^1'],'New',...
        ['Slope = ',num2str(slopeper2),' % dec^-^1'], 'location', 'north' ,'orientation', 'horizontal')
    title(['Sector', sector,' SIV comparison: old vs hybrid'])
    ylabel('Sea Ice Volume [km^3]');

    print(['ICE/ICETHICKNESS/Figures/Diagnostic/hybridSIVcompare/sector',sector,'SIVcompare.png'], '-dpng', '-r400')
    clearvars
    
end
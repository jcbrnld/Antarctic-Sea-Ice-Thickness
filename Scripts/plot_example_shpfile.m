% Jacob Arnold

% 17-Aug-2022

% Plot an example ice chart's polygons



sfile = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/ANTARC120903');

m_basemap('p', [0,360], [-90,-51]);plot_dim(1000,800);

for ii = 1:length(sfile.ncst)
    xs = sfile.ncst{ii,1}(:,1);
    ys = sfile.ncst{ii,1}(:,2);
    [lats, lons] = ps2ll(xs, ys, 'truelat', -60);
    lons = lons+180;
    m_plot(lons, lats, 'm', 'linewidth', 1);
    
    clear xs ys lons lats
end
text(-0.08,0,datestr(datenum(sfile.dfbdate)), 'fontsize', 15);
print('ICE/ICETHICKNESS/Figures/Shapefiles/EXAMPLE_1.png', '-dpng', '-r500');



%% Ross


sfile = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/ANTARC120903');

[londom, latdom] = sectordomain(14);
m_basemap('m', londom, latdom);plot_dim(1000,800);

for ii = 1:length(sfile.ncst)
    xs = sfile.ncst{ii,1}(:,1);
    ys = sfile.ncst{ii,1}(:,2);
    [lats, lons] = ps2ll(xs, ys, 'truelat', -60);
    lons = lons+180;
    m_plot(lons, lats, 'm', 'linewidth', 1);
    
    clear xs ys lons lats
end
text(-0.08,0,datestr(datenum(sfile.dfbdate)), 'fontsize', 15);
%print('ICE/ICETHICKNESS/Figures/Shapefiles/EXAMPLE_ROSS_1.png', '-dpng', '-r500');

%% East aa

sfile = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/antarc061005');

londom = [55, 170];
latdom = [-70,-61,2];

m_basemap('m', londom, latdom);plot_dim(1000,300);

for ii = 1:length(sfile.ncst)
    xs = sfile.ncst{ii,1}(:,1);
    ys = sfile.ncst{ii,1}(:,2);
    [lats, lons] = ps2ll(xs, ys, 'truelat', -60);
    lons = lons+180;
    lolo = find(lons<londom(1));
    lons(lolo) = []; lats(lolo) = [];
    lohi = find(lons>londom(2));
    lons(lohi) = []; lats(lohi) = [];
    
    m_plot(lons, lats, 'm', 'linewidth', 1);
    
    clear xs ys lons lats
end
text(-0.08,0,datestr(datenum(sfile.dfbdate)), 'fontsize', 15);
%print('ICE/ICETHICKNESS/Figures/Shapefiles/EXAMPLE_EastAA_2.png', '-dpng', '-r500');


%% Weddell


sfile = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/ANTARC080707');

londom = [290, 360];
latdom = [-79,-60,2];

m_basemap('m', londom, latdom);plot_dim(1000,800);

for ii = 1:length(sfile.ncst)
    xs = sfile.ncst{ii,1}(:,1);
    ys = sfile.ncst{ii,1}(:,2);
    [lats, lons] = ps2ll(xs, ys, 'truelat', -60);
    lons = lons+180;
    lolo = find(lons<londom(1));
    lons(lolo) = []; lats(lolo) = [];
    lohi = find(lons>londom(2));
    lons(lohi) = []; lats(lohi) = [];
    
    m_plot(lons, lats, 'm', 'linewidth', 1);
    
    clear xs ys lons lats
end
text(-0.08,0,datestr(datenum(sfile.dfbdate)), 'fontsize', 15);
%print('ICE/ICETHICKNESS/Figures/Shapefiles/EXAMPLE_Weddell_2.png', '-dpng', '-r500');










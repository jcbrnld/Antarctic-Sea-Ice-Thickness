% Jacob Arnold

% 05-Aug-2021

% Search a shapefile for certain polygons to investigate


% Looking at a few in the e00 data




ind = 8;

ncst = e00_data.shpfiles{ind}.ncst;
m_basemap('p',[0,360],[-90,-45]);
set(gcf, 'position', [100,600,1000,800]);
%p = [1:length(e00_data.shpfiles{ind}.ncst)]; % all polygons at that ind
p = [3581];
for ii = 1:length(p)
    [lat, lon] = ps2ll(ncst{p(ii)}(:,1), ncst{p(ii)}(:,2), 'TrueLat', -60);
   
    m_plot(lon+180, lat);
    
end




%% create figures of all polygons at a given date

% first load shapefiles by running first portion of SITworkingscript_Final


% Load in sector grids to show in background
for ii = 1:18
    if ii<10
        sector = load(['ICE/Concentration/ant-sectors/sector0',num2str(ii),'.mat']);
    else
        sector = load(['ICE/Concentration/ant-sectors/sector',num2str(ii),'.mat']);
    end
    sector_C = struct2cell(sector);
    slon{ii} = sector_C{1,1}.lon;
    slat{ii} = sector_C{1,1}.lat;
    clear sector_C sector
end

clear ii


colors = ["[0.46,.55,0.55]";"[0.66,.85,0.05]";"[0.66,.55,0.05]";"[0.86,.35,0.25]";...
    "[0.96,.15,0.05]";"[0.96,.55,0.05]";"[0.9,.15,0.65]";"[0.96,.75,0.75]";"[0.96,.95,0.8]";...
    "[0.96,.05,1]";"[0.66,.25,0.55]";"[0.66,.45,0.95]";"[0.66,.65,0.95]";"[0.76,.85,0.75]";...
    "[0.46,.85,0.95]";"[0.26,.65,0.95]";"[0.26,.25,0.95]";"[0.26,.25,0.55]"];
%% ___________



ind=(412);

ncst = shpfiles{ind}.ncst;

m_basemap('p',[0,360],[-90,-55]);
%m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
set(gcf, 'position', [100,600,1000,800]);

for ii = 1:18
    m_scatter(slon{ii},slat{ii}, 1, [0.8,0.8,0.8],'filled', 'markerfacealpha', .8);
end


p = [1:length(ncst)]; % all polygons at that ind

for ii = 1:length(p)
    [lat,lon] = ps2ll(ncst{p(ii)}(:,1), ncst{p(ii)}(:,2), 'TrueLat', -60);
    
    m_plot(lon+180, lat, 'linewidth', 1.05);
    
end
text(-0.07, 0, datestr(datetime(dv(ind,:), 'Format', 'dd MMM yyyy')))
%print('ICE/ICETHICKNESS/Figures/Shapefiles/coastal_zoom_1.png', '-dpng', '-r600')
%print('ICE/ICETHICKNESS/Figures/Shapefiles/no_zoom_4.png', '-dpng', '-r600')







% Jacob Arnold

% 09-Feb-2021

% Check out the GIOMAS SIT data


heff = ncread('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/Data/ncfiles/heff.H2012.nc', 'heff');
lon = ncread('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/Data/ncfiles/heff.H2012.nc', 'lon_scaler');
lat = ncread('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/Data/ncfiles/heff.H2012.nc', 'lat_scaler');


%%

for ii = 1:12
    hdat = heff(:,:,ii);
    hdat = hdat(:);
    nines = find(hdat>100)
    hdat(nines) = nan;
    H(:,ii) = hdat;
    
    clear hdat nines
end


lon2d = lon;
lat2d = lat;

lon = lon2d(:);
lat = lat2d(:);

%%
m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,800)
m_scatter(lon, lat, 30, H(:,7), 'filled');
colormap(jet)
colorbar
text(-0.1,0,'GIOMAS SIT July 2012')
caxis([0,3])




%% Alright now lets read in all and save to .mat file

% Load in file names
fnames = textread('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/Data/ncfiles/names.txt', '%s');

lon = ncread('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/Data/ncfiles/heff.H2012.nc', 'lon_scaler'); % grab grid from random date
lat = ncread('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/Data/ncfiles/heff.H2012.nc', 'lat_scaler');
lon2d = lon;
lat2d = lat;

lon = lon2d(:);
lat = lat2d(:);
counter = 0; % initialize counter
months = []; % initialize months
years = []; % initialize years
for ll = 1:length(fnames)
    
    heff = ncread(['ICE/ICETHICKNESS/Data/Modeled/GIOMAS/Data/ncfiles/',fnames{ll}], 'heff');
    
    for mm = 1:length(heff(1,1,:))
        counter = counter+1;
        
        hdat = heff(:,:,mm);
        hdat = hdat(:);
        nines = find(hdat>100);
        hdat(nines) = nan;
        H(:,counter) = hdat;
    
        clear hdat nines

    end
    
    
    month = ncread(['ICE/ICETHICKNESS/Data/Modeled/GIOMAS/Data/ncfiles/',fnames{ll}], 'month');
    year = ncread(['ICE/ICETHICKNESS/Data/Modeled/GIOMAS/Data/ncfiles/',fnames{ll}], 'year');
    
    tem = nan(size(month));
    tem(:) = year;
    months = [months;month];
    years = [years;tem];
    
    clear tem month year heff
end

%% sweet

% now polish and save
months = double(months);

dv = years;
dv(:,2) = months;
dv(:,3) = 15; % each entry represents a whole month so assigning day to middleish of months
dn = datenum(dv);

GIOMAS.H = H;
GIOMAS.lon = lon;
GIOMAS.lat = lat;
GIOMAS.dn = dn;
GIOMAS.dv = dv;

save('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/GIOMAS_SIT.mat', 'GIOMAS', '-v7.3');

%% Some Figures
ticker = (1979:1:2022)';
ticker(:,2:3) = 1;
ticker = datenum(ticker);

figure;
plot_dim(1200,300)
plot(GIOMAS.dn, nanmean(GIOMAS.H), 'linewidth', 1.2, 'color', [0.99, 0.2,0.4]);
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xlim([min(GIOMAS.dn)-100, max(GIOMAS.dn)+100]);
xtickangle(30);
grid on
title('GIOMAS Mean SIT of all non-land grid points')
ylabel('Sea Ice Thickness [m]');
print('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/basic_figs/meanSIT_IncludingOpenWater.png', '-dpng', '-r400');


%% Now try timeseries only where there is ice

for ii = 1:length(GIOMAS.dn)
    isnz = find(GIOMAS.H(:,ii)~=0);% Find where it isnotzero
    meanH(ii) = nanmean(GIOMAS.H(isnz,ii));
end


figure;
plot_dim(1200,300)
plot(GIOMAS.dn, meanH, 'linewidth', 1.2, 'color', [0.99, 0.2,0.4]);
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks')
xlim([min(GIOMAS.dn)-100, max(GIOMAS.dn)+100]);
xtickangle(30);
grid on
title('GIOMAS Mean SIT where there is ice')
ylabel('Sea Ice Thickness [m]');
print('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/basic_figs/meanSIT_NoOpenWater.png', '-dpng', '-r400');




%% now spatial

% Overall mean
allmean = nanmean(GIOMAS.H,2);

m_basemap('p', [0,360], [-90,-50]);
plot_dim(800,700);
m_scatter(GIOMAS.lon, GIOMAS.lat, 17, allmean, 'filled')
colormap(jet)
cbh = colorbar;
text(-0.11,0,{'GIOMAS SIT', '1979-2021 Average'})
caxis([0,2.5])
cbh.Ticks = 0:0.3:2.4;

print('ICE/ICETHICKNESS/Data/Modeled/GIOMAS/basic_figs/average1979to2021.png', '-dpng', '-r400');
















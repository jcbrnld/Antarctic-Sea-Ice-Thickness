% Jacob Arnold

% 05-aug-2021

% plot and compare the various zone grids

% Edited 24-sep-2021 to plot 6 offshore noncircumpolar zones
% Commented out the loads that were replaced

% load(['ICE/Concentration/so-zones/azone_SIC.mat']);
% alon = azone.goodlon;
% alat = azone.goodlat;
% clear azone
% 
% load(['ICE/Concentration/so-zones/sazone_SIC.mat']);
% salon = sazone.goodlon;
% salat = sazone.goodlat;
% clear sazone
% 
% load(['ICE/Concentration/so-zones/pfzone_SIC.mat']);
% pflon = pfzone.goodlon;
% pflat = pfzone.goodlat;
% clear pfzone

load(['ICE/Concentration/so-zones/acc_ao_SIC_SIM.mat']);
accaolon = accao.lon;
accaolat = accao.lat;
clear accao

load(['ICE/Concentration/so-zones/acc_io_SIC_SIM.mat']);
acciolon = accio.lon;
acciolat = accio.lat;
clear accio

load(['ICE/Concentration/so-zones/acc_po_SIC_SIM.mat']);
accpolon = accpo.lon;
accpolat = accpo.lat;
clear accpo

load(['ICE/Concentration/so-zones/subpolar_ao_SIC_SIM.mat']);
sub_ao_lon = subpolarao.lon;
sub_ao_lat = subpolarao.lat;
clear subpolarao

load(['ICE/Concentration/so-zones/subpolar_po_SIC_SIM.mat']);
sub_po_lon = subpolarpo.lon;
sub_po_lat = subpolarpo.lat;
clear subpolarpo

load(['ICE/Concentration/so-zones/subpolar_io_SIC_SIM.mat']);
sub_io_lon = subpolario.lon;
sub_io_lat = subpolario.lat;
clear subpolario

m_basemap('p', [0,360],[-85,-30]);
set(gcf, 'position' , [500,600,1000,800]);
%m_elev([1000:1000:6000],'color',[0.6,0.6,0.6]);
a = m_scatter(accaolon, accaolat, .4, 'c', 'filled','markerfacealpha', .8);
pf = m_scatter(acciolon, acciolat, .4, 'g', 'filled','markerfacealpha', .85);
sa = m_scatter(accpolon, accpolat, .4, 'm', 'filled','markerfacealpha', .85);
ao = m_scatter(sub_ao_lon, sub_ao_lat, .5, [0.7, 0.3, 0.3], 'filled','markerfacealpha', .5);
io = m_scatter(sub_io_lon, sub_io_lat, .5, [0.3, 0.3, 0.7], 'filled','markerfacealpha', .5);
po = m_scatter(sub_po_lon, sub_po_lat, .5, [0.3, 0.6, 0.5], 'filled','markerfacealpha', .5);
hand = [a(1), pf(1), sa(1), ao(1), io(1), po(1)];
legend(hand, 'ACC\_Atlantic', 'ACC\_Indian', 'ACC\_Pacific', 'Subpolar\_Atlantic',...
    'Subpolar\_Indian', 'subpolar\_Pacific');
%print('ICE/Concentration/Figures/all_offshore_noncirc.png', '-dpng', '-r600');




%% add shelf sectors 

% load data

for ii = 1:18
    if ii<10
        sector = load(['ICE/Concentration/ant-sectors/sector0',num2str(ii),'.mat']);
    else
        sector = load(['ICE/Concentration/ant-sectors/sector',num2str(ii),'.mat']);
    end
    sector_C = struct2cell(sector);
    lon{ii} = sector_C{1,1}.lon;
    lat{ii} = sector_C{1,1}.lat;
    clear sector_C sector
end

clear ii


colors = ["[0.46,.55,0.55]";"[0.66,.85,0.05]";"[0.66,.55,0.05]";"[0.86,.35,0.25]";...
    "[0.96,.15,0.05]";"[0.96,.55,0.05]";"[0.9,.15,0.65]";"[0.96,.75,0.75]";"[0.96,.95,0.8]";...
    "[0.96,.05,1]";"[0.66,.25,0.55]";"[0.66,.45,0.95]";"[0.66,.65,0.95]";"[0.76,.85,0.75]";...
    "[0.46,.85,0.95]";"[0.26,.65,0.95]";"[0.26,.25,0.95]";"[0.26,.25,0.55]"];


m_basemap('p', [0 360 60], [-90 -35 10],'sdL_v10',[4000],[ 8]);
set(gcf,'Position',[500,600,1000,800]);
m_elev([1000:1000:6000],'color',[0.6,0.6,0.6]);
a = m_scatter(alon, alat, .4, 'c', 'filled','markerfacealpha', .8);
pf = m_scatter(pflon, pflat, .4, 'g', 'filled','markerfacealpha', .85);
sa = m_scatter(salon, salat, .4, 'm', 'filled','markerfacealpha', .85);
ao = m_scatter(sub_ao_lon, sub_ao_lat, .5, [0.7, 0.3, 0.3], 'filled','markerfacealpha', .5);
io = m_scatter(sub_io_lon, sub_io_lat, .5, [0.3, 0.3, 0.7], 'filled','markerfacealpha', .5);
po = m_scatter(sub_po_lon, sub_po_lat, .5, [0.3, 0.6, 0.5], 'filled','markerfacealpha', .5);
hand = [a(1), pf(1), sa(1), ao(1), io(1), po(1)];
for ii = 1:18
    m_scatter(lon{ii},lat{ii}, 1, eval(colors(ii)),'filled');
end
legend(hand, 'azone', 'pfzone', 'sazone', 'subpolar\_ao','subpolar\_io', 'subpolar\_po');

%print('ICE/Sectors/Subpolar/All_sectors_zones.png','-dpng', '-r800')
%print('ICE/Concentration/Figures/all_sectors_zones.png', '-dpng', '-r600');





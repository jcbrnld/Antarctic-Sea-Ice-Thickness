% Jacob Arnold
% 24-Nov-2021
% Inspect oceanic gaps after interpolation


% load in some data
load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_po.mat
data = load('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/acc_po.mat');
oSIT = data.SIT; clear data;
%%
% view an example
% 2004-9-20 -> index 361, 271

m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,800);
m_scatter(SIT.lon, SIT.lat, 10, SIT.H(:,361), 'filled')

% That date exists in original data. check it out:
m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,800);
m_scatter(oSIT.lon, oSIT.lat, 10, oSIT.H(:,271), 'filled')

% Lets try one more date
% 2005-1-10 -> index 377, 279
m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,800);
m_scatter(SIT.lon, SIT.lat, 10, SIT.H(:,377), 'filled')

% That date exists in original data. check it out:
m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,800);
m_scatter(oSIT.lon, oSIT.lat, 10, oSIT.H(:,279), 'filled')

% The feature shows up in both. So it is not a result of temporal
% interpolation. 

%% Lets look at the raw gridded file
load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sectoracc_po_SIC_25km_shpSIG.mat;
%%
m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,800);
m_scatter(SIT.lon, SIT.lat, 10, SIT.H(:,446), 'filled')

% These holes are not in original gridded data. Likely a result of
% averaging loop. 

m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,800);
m_scatter(oSIT.lon, oSIT.lat, 10, 'filled')
% Verified that the grid points are actually there - it is nans in the data

%% try to find them 

nanind = find(isnan(oSIT.H(:,271)));
m_basemap('p', [0,360], [-90,-50])
plot_dim(1000,800);
m_scatter(oSIT.lon, oSIT.lat, 10, oSIT.H(:,271), 'filled')
m_scatter(oSIT.lon(nanind), oSIT.lat(nanind), 10, 'm', 'filled')

%% Find nans in acc zones and fill with 0, make movie with filled dots highlighted 
dummyH = oSIT.H;
for ii = 1:length(oSIT.dn)
    nanind{ii} = find(isnan(dummyH(:,ii)));
    
    dummyH(nanind{ii},ii) = 0;
    
end
% Now find points that were nan at least half the time
nanloc = isnan(oSIT.H);
allnan = find(sum(nanloc,2) >= length(oSIT.dv)/2);
dummyH(allnan,:) = nan;


%% Make the movie


visquest = questdlg('See plots momentarily as they are created?');
if visquest(1)=='C'
    error('Cancel selected at visibility question')
end

% Make the movie: Notice where it saves

cntr = [1:50:20000];
mnths = {'jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'};

for ii = 1:length(oSIT.H(1,:));
    if ismember(ii,cntr)
        disp(['Finished through...     ', num2str(oSIT.dv(ii,3)), '-', mnths{oSIT.dv(ii,2)}, '-', num2str(oSIT.dv(ii,1))])
    end
    if visquest(1)=='Y'
        m_basemap('p', [0,360], [-90,-45])
    else
        m_basemap2('p', [0,360], [-90,-45]) 
    end

    size1 = 8;
    size2 = 12;

    m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
    set(gcf, 'Position', [1000, 500, 1000, 700])
    m_scatter(oSIT.lon, oSIT.lat, size1,dummyH(:,ii), 'filled');
    m_scatter(oSIT.lon(nanind{ii}), oSIT.lat(nanind{ii}), size2, 'm','filled');
    m_scatter(oSIT.lon(allnan), oSIT.lat(allnan), size2, 'c','filled');

    if isnan(oSIT.dv(ii))==0
        xlabel(datestr(datetime(oSIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
    else
        xlabel('-- --- ----')
    end
    colormap(jet(10))
    %cmocean('ice', 10);
    caxis([0,2])
    %caxis([0,1])
    cbh = colorbar;
    cbh.Ticks = [0:0.2:2];
    cbh.Label.String = ('Sea Ice Thickness [cm]');
    F(ii) = getframe(gcf);
    close gcf
end

writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Sectors/Full_length/acc_so_nanfill2.mp4'], 'MPEG-4');

writerobj.FrameRate = 5;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp(['Success! Video saved'])
clear F 

%% The correction looks good. 
% Now lets apply it to all acc zones before and after interp. 

% ACC AO
clear all

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/acc_b4nanfill/acc_ao.mat

dummyH = SIT.H;
for ii = 1:length(SIT.dn)
    nanind{ii} = find(isnan(dummyH(:,ii)));
    
    dummyH(nanind{ii},ii) = 0;
    
end
% Now find points that were nan at least half the time
nanloc = isnan(SIT.H);
allnan = find(sum(nanloc,2) >= length(SIT.dv)/2);
dummyH(allnan,:) = nan;

SIT.H = dummyH;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/acc_ao.mat', 'SIT')


clear all


load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_b4_nanfill/acc_ao.mat

dummyH = SIT.H;
for ii = 1:length(SIT.dn)
    nanind{ii} = find(isnan(dummyH(:,ii)));
    
    dummyH(nanind{ii},ii) = 0;
    
end
% Now find points that were nan at least half the time
nanloc = isnan(SIT.H);
allnan = find(sum(nanloc,2) >= length(SIT.dv)/2);
dummyH(allnan,:) = nan;

SIT.H = dummyH;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_ao.mat', 'SIT')



%%


% ACC IO
clear all

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/acc_b4nanfill/acc_io.mat

dummyH = SIT.H;
for ii = 1:length(SIT.dn)
    nanind{ii} = find(isnan(dummyH(:,ii)));
    
    dummyH(nanind{ii},ii) = 0;
    
end
% Now find points that were nan at least half the time
nanloc = isnan(SIT.H);
allnan = find(sum(nanloc,2) >= length(SIT.dv)/2);
dummyH(allnan,:) = nan;

SIT.H = dummyH;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/acc_io.mat', 'SIT')


clear all


load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_b4_nanfill/acc_io.mat

dummyH = SIT.H;
for ii = 1:length(SIT.dn)
    nanind{ii} = find(isnan(dummyH(:,ii)));
    
    dummyH(nanind{ii},ii) = 0;
    
end
% Now find points that were nan at least half the time
nanloc = isnan(SIT.H);
allnan = find(sum(nanloc,2) >= length(SIT.dv)/2);
dummyH(allnan,:) = nan;

SIT.H = dummyH;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_io.mat', 'SIT')

%%

% ACC PO
clear all

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/acc_b4nanfill/acc_po.mat

dummyH = SIT.H;
for ii = 1:length(SIT.dn)
    nanind{ii} = find(isnan(dummyH(:,ii)));
    
    dummyH(nanind{ii},ii) = 0;
    
end
% Now find points that were nan at least half the time
nanloc = isnan(SIT.H);
allnan = find(sum(nanloc,2) >= length(SIT.dv)/2);
dummyH(allnan,:) = nan;

SIT.H = dummyH;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/acc_po.mat', 'SIT')


clear all


load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_b4_nanfill/acc_po.mat

dummyH = SIT.H;
for ii = 1:length(SIT.dn)
    nanind{ii} = find(isnan(dummyH(:,ii)));
    
    dummyH(nanind{ii},ii) = 0;
    
end
% Now find points that were nan at least half the time
nanloc = isnan(SIT.H);
allnan = find(sum(nanloc,2) >= length(SIT.dv)/2);
dummyH(allnan,:) = nan;

SIT.H = dummyH;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_po.mat', 'SIT')


%% Do this to the so zones too

zones = {'subpolar_ao', 'subpolar_io', 'subpolar_po'};
for zz = 1:3
    
    clearvars -except zones zz 

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/acc_b4nanfill/',zones{zz},'.mat']);

    dummyH = SIT.H;
    for ii = 1:length(SIT.dn)
        nanind{ii} = find(isnan(dummyH(:,ii)));

        dummyH(nanind{ii},ii) = 0;

    end
    % Now find points that were nan at least half the time
    nanloc = isnan(SIT.H);
    allnan = find(sum(nanloc,2) >= length(SIT.dv)/2);
    dummyH(allnan,:) = nan;

    SIT.H = dummyH;

    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/',zones{zz},'.mat'], 'SIT')


    clearvars -except zones zz

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_b4_nanfill/',zones{zz},'.mat']);

    dummyH = SIT.H;
    for ii = 1:length(SIT.dn)
        nanind{ii} = find(isnan(dummyH(:,ii)));

        dummyH(nanind{ii},ii) = 0;

    end
    % Now find points that were nan at least half the time
    nanloc = isnan(SIT.H);
    allnan = find(sum(nanloc,2) >= length(SIT.dv)/2);
    dummyH(allnan,:) = nan;

    SIT.H = dummyH;

    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/zones/',zones{zz},'.mat'], 'SIT')

end



























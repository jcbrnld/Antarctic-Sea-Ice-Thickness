% Jacob Arnold

% 05-Oct-2021

% Read in KM ICESat SIT TRACK data BUT this time interpolate my SIT to the
% tracks and average to campaign periods

% 0. create .mat file of ICESat track SIT data
% 1. import ICESat data and SOD SIT data
% 2. Average SOD to ICESat campaigns
% 3. Interpolate SOD to ICESat satellite track grid points
% 4. do some comparisons! 

% Focus on using sector 00 for the whole shelf 
% May need to create polygon for sector 00 to determine which sat track
% grid points are within our region. 


% ON = Spring
% FM = Summer
% MJ = Fall

% dates:
% 2003 ||                                           ON03 = Oct1-Nov18
% 2004 || FM04 = Feb17-Mar21    MJ04 = May18-Jun21  ON04 = Oct3-Nov08
% 2005 || FM05 = Feb17-Mar24    MJ05 = May20-Jun23
% 2006 || FM06 = Feb22-Mar27    MJ06 = May24-Jun26  ON06 = Oct25-Nov27
% 2007 || MA07 = Mar12-Apr14                        ON07 = Oct02-Nov05
% 2008 || FM08 = Feb17-Mar21



ii = '00';

% Loop for all 18 sectors, did sector 00 separately
%for ii = 1:18

    clearvars -except ii; close all
    if ii < 10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    disp(['Working On Sector ', sector])


    if length(sector)==2
        %sect = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
        load(['ICE/ICETHICKNESS/Data/Mat_files/Final/Sectors/Sector',sector,'.mat']);
    else
        %sect = load(['ICE/Concentration/so-zones/',sector,'_SIC.mat']);
        %load(['ICE/ICETHICKNESS/Data/Mat_files/Final/Sectors/sector',sector,'.mat']);
    end


    % Create variable of ideal lon and lat limits for sector plots
    splot{1,1}=[289 312]; splot{1,2}=[-73 -60]; splot{2,1}=[296 337]; splot{2,2}=[-79 -70];
    splot{3,1}=[332 358]; splot{3,2}=[-77 -69]; splot{4,1}=[0 26]; splot{4,2}=[-71 -68];
    splot{5,1}=[24 55]; splot{5,2}=[-71 -65]; splot{6,1}=[53.5 68.5]; splot{6,2}=[-68 -65.2];
    splot{7,1}=[67 86]; splot{7,2}=[-70.5 -65]; splot{8,1}=[84.5 100.5]; splot{8,2}=[-67.5 -63.5];
    splot{9,1}=[99.5 113.5]; splot{9,2}=[-67.5 -63.5]; splot{10,1}=[112 123]; splot{10,2}=[-67.5 -64.5];
    splot{11,1}=[121 135]; splot{11,2}=[-67.5 -64.2]; splot{12,1}=[133.5 150.5]; splot{12,2}=[-69 -64.5];
    splot{13,1}=[149 173]; splot{13,2}=[-72 -65]; splot{14,1}=[160 207]; splot{14,2}=[-79 -69];
    splot{15,1}=[202 235.5]; splot{15,2}=[-78 -71.9]; splot{16,1}=[232 262]; splot{16,2}=[-76.2 -69];
    splot{17,1}=[258 295]; splot{17,2}=[-75 -67]; splot{18,1}=[282.5 308]; splot{18,2}=[-70 -59];

    if str2num(sector)~=0
        londom = splot{str2num(sector),1}; latdom = splot{str2num(sector),2};
    end

    load ICE/ICETHICKNESS/Data/MAT_files/Altimetry/KM_ICESat/kmSIT_track.mat



    % Average SOD SIT to match km cruise periods

    for jj = 1:length(kmSIT.Cruises)
        bounds = [kmSIT.dn_range{jj}(1), kmSIT.dn_range{jj}(end)];
        inds = find(SIT.dn>=bounds(1) & SIT.dn<=bounds(2));

        avgH(:,jj) = nanmean(SIT.H(:,inds),2);

    end


    % Interp from avgH to each campaign's track points. 
    % THIS Fills a lot of values outside the shelf domain. 
    % NEED to use boundary to create shelf polygon and only use track grid
    % points withing that polygon. 
    % for ii = 1:length(avgH(1,:))
    %     TavgH{ii} = griddata(double(SIT.lon), double(SIT.lat), double(avgH(:,ii)), kmSIT.Tlon{ii}, kmSIT.Tlat{ii});
    % end


    zonePoly = boundary(double(SIT.lon), double(SIT.lat), 1);

    % Only use track recordings within the sector
    for jj = 1:length(avgH(1,:))
        disp(['Workin on ', kmSIT.Cruises{jj}]);
        shelfDots{jj} = find(inpolygon(kmSIT.Tlon{jj}, kmSIT.Tlat{jj},...
            double(SIT.lon(zonePoly)), double(SIT.lat(zonePoly)))==1);

        TavgH{jj} = griddata(double(SIT.lon), double(SIT.lat), double(avgH(:,jj)),...
            kmSIT.Tlon{jj}(shelfDots{jj}),kmSIT.Tlat{jj}(shelfDots{jj}));

    end


    % Duplicate data points warning. Need to find these and compare separately.
    % 
    c = 2;
    m_basemap('p', [0,360],[-90,-60]);
    m_scatter(kmSIT.Tlon{c}(shelfDots{c}), kmSIT.Tlat{c}(shelfDots{c}), 3, TavgH{c}, 'filled')

    TSOD.H = TavgH;
    for ll = 1:12

        TSOD.lon{ll} = kmSIT.Tlon{ll}(shelfDots{ll});
        TSOD.lat{ll} = kmSIT.Tlat{ll}(shelfDots{ll});
        TSOD.kmSIT{ll} = kmSIT.H{ll}(shelfDots{ll});
    end
    TSOD.zonePoly = zonePoly;
    TSOD.sector = sector;
    TSOD.mid_dn = kmSIT.mid_dn;
    TSOD.dn_range = kmSIT.dn_range;
    TSOD.Cruises = kmSIT.Cruises;


    save(['ICE/ICETHICKNESS/Data/MAT_files/Altimetry/KM_ICESat/For_Comparison/sector',sector,'_onTrack_RedunAve.mat'], 'TSOD');

end




    
    
    
    
    
    
    
    
    
    
    







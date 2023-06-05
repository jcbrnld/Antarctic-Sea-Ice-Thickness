% Jacob Arnold

% 15-Feb-2022

% First look at SICCI SIT dataset WORBY SHOULD BE BETTER
% Derived from ICESat-1 altimetry data by Kern and Spreen 2015
% "Uncertainties in Antarctic Sea Ice Thickness Retreival from ICESat

% camp order from Kern et al. 2016
% camp = {'ON04', 'FM04', 'MJ04',... % 2004
%         'ON05', 'FM05', 'MJ05',... % 2005
%         'ON06', 'FM06', 'MJ06',... % 2006
%         'ON07', 'MA07',...         % 2007 
%                 'FM08'...          % 2008
%                 }; 
% organize by season instead
%camp = {'ON04', 'ON05', 'ON06', 'ON07', 'FM04', 'FM05', 'FM06', 'MA07', 'FM08', 'MJ04', 'MJ05', 'MJ06'};
    
% Nah, lets organize in temporal order
mission = {'FM04', 'MJ04', 'ON04', 'FM05', 'MJ05', 'ON05', 'FM06', 'MJ06', 'ON06', 'MA07', 'ON07', 'FM08'};

%file names 
fname{1} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20040217-20040320__UHAM-ICDC__fv01.07.nc'; %FM04
fname{2} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20040518-20040620__UHAM-ICDC__fv01.07.nc'; %MJ04
fname{3} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20041003-20041108__UHAM-ICDC__fv01.07.nc'; %ON04
fname{4} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20050216-20050322__UHAM-ICDC__fv01.07.nc'; %FM05
fname{5} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20050520-20050622__UHAM-ICDC__fv01.07.nc'; %MJ05
fname{6} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20051021-20051123__UHAM-ICDC__fv01.07.nc'; %ON05
fname{7} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20060222-20060326__UHAM-ICDC__fv01.07.nc'; %FM06
fname{8} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20060524-20060625__UHAM-ICDC__fv01.07.nc'; %MJ06
fname{9} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20061025-20061126__UHAM-ICDC__fv01.07.nc'; %ON06
fname{10} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20070312-20070414__UHAM-ICDC__fv01.07.nc'; %MA07
fname{11} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20071002-20071104__UHAM-ICDC__fv01.07.nc'; %ON07
fname{12} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__SICCIalgorithm__20080217-20080320__UHAM-ICDC__fv01.07.nc'; %FM08



for ii = 1:length(fname)
    % on06
    % ICESat mission?
    daterange{ii}(1,1:3) = [str2num(fname{ii}(86:89)), str2num(fname{ii}(90:91)), str2num(fname{ii}(92:93))];
    daterange{ii}(2,:) = [str2num(fname{ii}(95:98)), str2num(fname{ii}(99:100)), str2num(fname{ii}(101:102))];
    
    dnrange{ii} = datenum(daterange{ii});
    
    dn(ii) = median(dnrange{ii}); % Find middle of date range

    lon2d{ii} = ncread(['ICE/ICETHICKNESS/Data/Altimetry_SIT/SICCI_SIT_DATA/',fname{ii}], 'lon');
    lat2d{ii} = ncread(['ICE/ICETHICKNESS/Data/Altimetry_SIT/SICCI_SIT_DATA/',fname{ii}], 'lat');

    sit2d{ii} = ncread(['ICE/ICETHICKNESS/Data/Altimetry_SIT/SICCI_SIT_DATA/',fname{ii}], 'sit');
    sic2d{ii} = ncread(['ICE/ICETHICKNESS/Data/Altimetry_SIT/SICCI_SIT_DATA/',fname{ii}], 'sic');

    lon{ii} = lon2d{ii}(:);
    lat{ii} = lat2d{ii}(:);
    sit{ii} = sit2d{ii}(:);
    sic{ii} = sic2d{ii}(:);

    iceout{ii} = find(sic{ii} >= 60 & sit{ii} <= 0);

end

% This loads them all in nicely
SICCO.lon = lon;
SICCO.lat = lat;
SICCO.sit = sit;
SICCO.sic = sic;
SICCO.mission = mission;
SICCO.daterange = daterange;
SICCO.dnrange = dnrange;
SICCO.lon2d = lon2d;
SICCO.lat2d = lat2d;
SICCO.sit2d = sit2d;
SICCO.sic2d = sic2d;
SICCO.iceout = iceout;
SICCO.resolution = '100km';
SICCO.comment = {'iceout are the grid point indices where sic >= 0.6 but there are no SIT data',...
                 'dn contains median values from the date ranges of each campaign period'};
             
save('ICE/ICETHICKNESS/Data/MAT_files/Altimetry/SICCO/ICESat_SICCO.mat', 'SICCO', '-v7.3');

%% Compare with SOD SIT

load('ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat');

%%%
cl = find(sitv>0); % comparison indices
lonc = lonv(cl);   % comparison lon
latc = latv(cl);   % comparison lat
dat = datenum(daterange);
dind = find(SIT.dn>dat(1) & SIT.dn<dat(2));
csit = sitv(cl);

myH = nanmean(SIT.H(:,dind),2);

%%% interp

[x100,y100] = ll2ps(latc, lonc);
[x3125,y3125] = ll2ps(double(SIT.lat), double(SIT.lon));

cH = griddata(x3125, y3125, double(myH), x100, y100); % comparison H

%%

m_basemap('p', [0,360], [-90,-53]);
plot_dim(800,700)
p1 = m_scatter(lonv(iceout), latv(iceout), 90, [0.8,0.8,0.8], 's', 'filled'); % background gray where sic>.6
m_scatter(lonv(sitv>0), latv(sitv>0), 90, sitv(sitv>0), 's', 'filled');       % sit where there are data
% m_scatter(lonv(sitv==0), latv(sitv==0), 60, [0.8,0.8,0.8], 's', 'filled');    % where sit==0


cbh = colorbar;
caxis([-0.3,3]);
colormap(colormapinterp(mycolormap('tan'),12, [0.8, 0.8, 0.8]));
cbh.Ticks = [-0.2,-0.1,0.02, 0.3:0.3:2.7];
cbh.TickLabels{1} = 'no SIT data';
cbh.TickLabels{2} = 'SIC > 0.6 but';
cbh.TickLabels{3} = '0';
cbh.TickLength = 0;
cbh.FontSize = 12;
cbh.Label.String = 'SICCO Sea Ice Thickness [m]';
cbh.Label.FontSize = 16;
cbh.Label.FontWeight = 'bold';
cbh.Label.Position(1) = 3;
text(-0.05,0,'ON06', 'fontweight', 'bold', 'fontsize', 13);



%%% for comparison 

m_basemap('p', [0,360], [-90,-53]);
plot_dim(800,700)
p1 = m_scatter(lonv(iceout), latv(iceout), 90, [0.8,0.8,0.8], 's', 'filled'); % background gray where sic>.6
m_scatter(lonc, latc, 90, cH, 's', 'filled');       % sit where there are data
% m_scatter(lonv(sitv==0), latv(sitv==0), 60, [0.8,0.8,0.8], 's', 'filled');    % where sit==0


cbh = colorbar;
caxis([-0.3,3]);
colormap(colormapinterp(mycolormap('tan'),12, [0.8, 0.8, 0.8]));
cbh.Ticks = [-0.2,-0.1,0.02, 0.3:0.3:2.7];
cbh.TickLabels{1} = 'no SIT data';
cbh.TickLabels{2} = 'SIC>0.6 but';
cbh.TickLabels{3} = '0';
cbh.TickLength = 0;
cbh.FontSize = 12;
cbh.Label.String = 'SOD Sea Ice Thickness [m]';
cbh.Label.FontSize = 16;
cbh.Label.FontWeight = 'bold';
cbh.Label.Position(1) = 3;
text(-0.05,0,'ON06', 'fontweight', 'bold', 'fontsize', 13);



%%% Diff



ccom = csit-cH;


m_basemap('p', [0,360], [-90,-53]);
plot_dim(800,700)
p1 = m_scatter(lonv(iceout), latv(iceout), 90, [0.82,0.82,0.82], 's', 'filled'); % background gray where sic>.6
m_scatter(lonc, latc, 90, ccom, 's', 'filled');       % sit where there are data
% m_scatter(lonv(sitv==0), latv(sitv==0), 60, [0.8,0.8,0.8], 's', 'filled');    % where sit==0


cbh = colorbar;
caxis([-3,2.5]);
colormap(colormapinterp(mycolormap('grp'),10, [0.82, 0.82, 0.82; 0.05,0.1,0.25], [0.3,0.05,0.1]));
cbh.Ticks = [-2.8,-2.7,-2, -1.5:0.5:2];
cbh.TickLabels{1} = 'no SIT data';
cbh.TickLabels{2} = 'SIC > 0.6 but';
cbh.TickLabels{3} = '-2';
cbh.TickLength = 0;
cbh.FontSize = 12;
cbh.Label.String = 'SICCO - SOD [m]';
cbh.Label.FontSize = 16;
cbh.Label.FontWeight = 'bold';
cbh.Label.Position(1) = 3;
text(-0.05,0,'ON06', 'fontweight', 'bold', 'fontsize', 13);





%% my data interpolated to on06 and 100km grid WITH range appropriate to MY data



m_basemap('p', [0,360], [-90,-53]);
plot_dim(800,700)
p1 = m_scatter(lonv(iceout), latv(iceout), 90, [0.8,0.8,0.8], 's', 'filled'); % background gray where sic>.6
m_scatter(lonc, latc, 90, cH, 's', 'filled');       % sit where there are data
% m_scatter(lonv(sitv==0), latv(sitv==0), 60, [0.8,0.8,0.8], 's', 'filled');    % where sit==0


cbh = colorbar;
caxis([-0.2,2.2]);
colormap(colormapinterp(mycolormap('id3'),13, [0.8, 0.8, 0.8]));
cbh.Ticks = [-0.15,-0.05,0.01, 0.2:0.2:2];
cbh.TickLabels{1} = 'No SIT Data';
cbh.TickLabels{2} = 'SIC>0.6 but';
cbh.TickLabels{3} = '0';
cbh.TickLength = 0;
cbh.FontSize = 12;
cbh.Label.String = 'SOD Sea Ice Thickness [m]';
cbh.Label.FontSize = 16;
cbh.Label.FontWeight = 'bold';
cbh.Label.Position(1) = 3;
text(-0.05,0,'ON06', 'fontweight', 'bold', 'fontsize', 13);










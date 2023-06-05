% Jacob Arnold
% 24-Feb-2022



% First look at WOL SIT dataset 
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
fname{1} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20040217-20040320__UHAM-ICDC__fv01.07.nc'; %FM04
fname{2} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20040518-20040620__UHAM-ICDC__fv01.07.nc'; %MJ04
fname{3} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20041003-20041108__UHAM-ICDC__fv01.07.nc'; %ON04
fname{4} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20050216-20050322__UHAM-ICDC__fv01.07.nc'; %FM05
fname{5} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20050520-20050622__UHAM-ICDC__fv01.07.nc'; %MJ05
fname{6} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20051021-20051123__UHAM-ICDC__fv01.07.nc'; %ON05
fname{7} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20060222-20060326__UHAM-ICDC__fv01.07.nc'; %FM06
fname{8} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20060524-20060625__UHAM-ICDC__fv01.07.nc'; %MJ06
fname{9} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20061025-20061126__UHAM-ICDC__fv01.07.nc'; %ON06
fname{10} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20070312-20070414__UHAM-ICDC__fv01.07.nc'; %MA07
fname{11} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20071002-20071104__UHAM-ICDC__fv01.07.nc'; %ON07
fname{12} = 'ESACCI-SEAICE-L4-SEAICETHICKNESS__ICESat-1__SH100km__NSIDCpolstereo__WORBY_1-layer_algorithm__20080217-20080320__UHAM-ICDC__fv01.07.nc'; %FM08



for ii = 1:length(fname)
    % on06
    % ICESat mission?
    daterange{ii}(1,1:3) = [str2num(fname{ii}(95:98)), str2num(fname{ii}(99:100)), str2num(fname{ii}(101:102))];
    daterange{ii}(2,:) = [str2num(fname{ii}(104:107)), str2num(fname{ii}(108:109)), str2num(fname{ii}(110:111))];
    
    dnrange{ii} = datenum(daterange{ii});
    
    dn(ii) = median(dnrange{ii}); % Find middle of date range

    lon2d{ii} = ncread(['ICE/ICETHICKNESS/Data/Altimetry_SIT/WORBY_1layer_SIT_DATA/',fname{ii}], 'lon');
    lat2d{ii} = ncread(['ICE/ICETHICKNESS/Data/Altimetry_SIT/WORBY_1layer_SIT_DATA/',fname{ii}], 'lat');

    sit2d{ii} = ncread(['ICE/ICETHICKNESS/Data/Altimetry_SIT/WORBY_1layer_SIT_DATA/',fname{ii}], 'sit');
    sic2d{ii} = ncread(['ICE/ICETHICKNESS/Data/Altimetry_SIT/WORBY_1layer_SIT_DATA/',fname{ii}], 'sic');

    lon{ii} = lon2d{ii}(:);
    lat{ii} = lat2d{ii}(:);
    sit{ii} = sit2d{ii}(:);
    sic{ii} = sic2d{ii}(:);

    iceout{ii} = find(sic{ii} >= 60 & sit{ii} <= 0);

end

% This loads them all in nicely
WOL.lon = lon;
WOL.lat = lat;
WOL.sit = sit;
WOL.sic = sic;
WOL.mission = mission;
WOL.daterange = daterange;
WOL.dnrange = dnrange;
WOL.lon2d = lon2d;
WOL.lat2d = lat2d;
WOL.sit2d = sit2d;
WOL.sic2d = sic2d;
WOL.iceout = iceout;
WOL.resolution = '100km';
WOL.comment = {'iceout are the grid point indices where sic >= 0.6 but there are no SIT data',...
                 'dn contains median values from the date ranges of each campaign period',...
                 'These data are generated from ICESat-1 laser altimetry following the Worby one layer approach detailed in Kern et al 2016'};
             
save('ICE/ICETHICKNESS/Data/MAT_files/Altimetry/WOL/ICESat_WOL.mat', 'WOL', '-v7.3');








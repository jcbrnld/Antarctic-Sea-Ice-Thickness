% Jacob Arnold

% 24_Feb_2022

% Comparison with ICESat Worby 1 layer (WOL) approach from Kern et al 2016
% This is theoretically more accurate than snow data approaches or zero ice
% freeboard approaches. 

% 0. average SOD SIT within icesat mission bounds
% 1. interpolate SOD SIT to 100 km grid from WOL only where there are WOL data
% 2. Compare area-averaged timeseries and trends 
% 3. Compare spatial differences at each ICESat campaign
% 4. Compare SIT distributions 

load ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/so.mat;

load ICE/ICETHICKNESS/Data/MAT_files/Altimetry/WOL/ICESat_WOL.mat;

%% 0.

for ii = 1:12
    sdn = WOL.dnrange{ii}(1);
    edn = WOL.dnrange{ii}(2);
    
    campind = find(SIT.dn >= sdn & SIT.dn <= edn);
    % define H for campaign period from SOD SIT
    
    CampH(:,ii) = nanmean(SIT.H(:,campind),2);

    
    clear sdn edn campind
end
    

%% 1. 
[sx,sy] = ll2ps(SIT.lat, SIT.lon);
[cx,cy] = ll2ps(WOL.lat, WOL.lon);

for ii = 1:12
    
    % create interpolated H for each campaign
    IH(:,ii) = griddata(sx, sy, CampH(:,ii), cx, cy); % SOME OF THESE WILL NEED TO BE MADE DOUBLE

    
end

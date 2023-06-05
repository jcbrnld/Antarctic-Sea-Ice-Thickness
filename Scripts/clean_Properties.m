% Jacob Arnold

% 07-Mar-2022

% Clean up properties files including removing huge daily wind divergence
% and curl variables 


for ii = 1:16
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    disp(['Cleaning sector ',sector,'...'])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    oldsi = seaice;
    
    if isfield(seaice, 'windcurl');
        
        % start building new seaice
        seaice.lon = oldsi.lon;
        seaice.lat = oldsi.lat;
        seaice.dn = oldsi.dn;
        seaice.dv = oldsi.dv;
        seaice.sector = oldsi.sector;
        seaice.SIV = oldsi.SIV;
        seaice.SIE = oldsi.SIE;
        seaice.SIA = oldsi.SIA;
        seaice.MAM = oldsi.MAM;
        seaice.JJA = oldsi.JJA;
        seaice.SON = oldsi.SON;
        seaice.DJF = oldsi.DJF;
        seaice.MONTH_AV = oldsi.MONTH_AV;
        seaice.meanH = oldsi.meanH;

        seaice.readme = oldsi.readme(1:7,1);
        % early mean and late mean aren't useful
        % windcurl and winddev will be reinterpolated and saved elsewhere --
        % they are huge;
        % ice motion is going to be reinterpolated s0 mU_ice and mV_ice will change
        % Ice divergence will be recalculated

        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice', '-v7.3');
        
    else
        disp(['Sector ',sector,' does not need to be cleaned'])
        
    end

    
    clearvars
    
end






%% sectors 17 and 18 - a little different 

sector = '18';


load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    oldsi = seaice;

% start building new seaice
seaice.lon = oldsi.lon;
seaice.lat = oldsi.lat;
seaice.dn = oldsi.dn;
seaice.dv = oldsi.dv;
seaice.sector = oldsi.sector;
seaice.SIV = oldsi.SIV;
seaice.SIE = oldsi.SIE;
seaice.SIA = oldsi.SIA;
seaice.MAM = oldsi.MAM;
seaice.JJA = oldsi.JJA;
seaice.SON = oldsi.SON;
seaice.DJF = oldsi.DJF;
seaice.MONTH_AV = oldsi.MONTH_AV;
seaice.meanH = oldsi.meanH;

seaice.readme = oldsi.readme(1:7,1);
% early mean and late mean aren't useful
% windcurl and winddev will be reinterpolated and saved elsewhere --
% they are huge;
% ice motion is going to be reinterpolated s0 mU_ice and mV_ice will change
% Ice divergence will be recalculated

save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice', '-v7.3');























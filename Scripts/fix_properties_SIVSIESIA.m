% Jacob Arnold

% 24-May-2022

% Fix properties' SIV, SIE, and SIA 


% Start with sectors
zones = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};

% Try it out first
cumSIC = [];
for ii = 19:24
    if ii < 10
        sector = ['0',num2str(ii)];
    elseif ii >= 10 & ii <= 18
        sector = num2str(ii);
    else
        sector = zones{ii-18};
    end
    disp(['Correcting ',sector,' properties'])
    if length(sector)==2
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/',sector,'.mat']);
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/',sector,'.mat']);
    
    end

    
    seaice.SIV = SIT.SIV;

    if ii <=18 
        sic = SIT.SIC;
    else
        sic = SIT.ct_hires;
    end
    % SIE
    % Sum of all grid points with > 15% SIC times grid cell area
    sieind = sic > 15;
    if length(sector)==2
        SIE = sum(sieind).*(3.125^2); % units are km^2
    else
        SIE = sum(sieind).*(25^2); % units are km^2
    end
    seaice.SIE = SIE;

    % SIA
    % Sum of all grid cell areas times their concentrations
    if length(sector)==2
        SIA = nansum((sic./100).*(3.125^2)); % units are km^2
    else
        SIA = nansum((sic./100).*(25^2)); % units are km^2
    end
    seaice.SIA = SIA;
    
     if length(sector)==2
       
        %save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice');
    
    else
       
        %save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/',sector,'.mat'], 'seaice');
    
     end
     
     cumSIC = [cumSIC; sic];
    clearvars -except zones cumSIC
end





%% Correct offshore and SO properties

load ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/offshore.mat;
load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/offshore.mat;


seaice.SIV = SIT.SIV;
sic = cumSIC;

 sieind = sic > 15;

SIE = sum(sieind).*(25^2);
 
SIA = nansum((sic./100).*(25^2)); % units are km^2


seaice.SIE = SIE;
seaice.SIA = SIA;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/properties/offshore.mat', 'seaice');

offSIV = seaice.SIV;
offSIA = SIA;
offSIE = SIE;

clearvars -except offSIV offSIA offSIE;


% SO
load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector00.mat;
shel = seaice; clear seaice


SIV = shel.SIV+offSIV;
SIE = shel.SIE+offSIE;
SIA = shel.SIA+offSIA;

load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/so.mat;
seaice.SIV = SIV;
seaice.SIE = SIE;
seaice.SIA = SIA;


figure;
plot(seaice.dn, seaice.SIV);


save('ICE/ICETHICKNESS/Data/MAT_files/Final/properties/so.mat', 'seaice');
















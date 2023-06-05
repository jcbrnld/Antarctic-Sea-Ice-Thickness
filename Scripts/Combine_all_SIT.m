% Jacob Arnold
% 10-Nov-2021


% Add together all sectors and zones to create entire southern hemisphere
% sea ice thickness dataset. 

clear all
close all

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat;
shelf_ind = 1:length(SIT.H(:,1));

alon = SIT.lon;
alat = SIT.lat;
aH = SIT.H;
adn = SIT.dn;
adv = SIT.dv;

clear SIT

load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/subpolar_ao.mat

alon = [alon; SIT.lon];
alat = [alat; SIT.lat];
aH = [aH; SIT.H];

clear SIT


load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/subpolar_io.mat


alon = [alon; SIT.lon];
alat = [alat; SIT.lat];
aH = [aH; SIT.H];

clear SIT

%

load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/subpolar_po.mat


alon = [alon; SIT.lon];
alat = [alat; SIT.lat];
aH = [aH; SIT.H];

clear SIT


load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_ao.mat


alon = [alon; SIT.lon];
alat = [alat; SIT.lat];
aH = [aH; SIT.H];

clear SIT


load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_io.mat


alon = [alon; SIT.lon];
alat = [alat; SIT.lat];
aH = [aH; SIT.H];

clear SIT


load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_po.mat


alon = [alon; SIT.lon];
alat = [alat; SIT.lat];
aH = [aH; SIT.H];


offshore_ind = shelf_ind(end)+1:length(aH(:,1));

%


SO_SIT.H = aH;
SO_SIT.lon = alon;
SO_SIT.lat = alat;
SO_SIT.dn = adn;
SO_SIT.dv = adv;
SO_SIT.shelf_ind = shelf_ind;
SO_SIT.offshore_ind = offshore_ind;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat', 'SO_SIT', '-v7.3');

disp('Southern Hemisphere SIT Saved')












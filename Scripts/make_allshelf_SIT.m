% Jacob Arnold

% 28-Sep-2021

% Join all sector SIT data

newlon = [];
newlat = [];
allH = [];

for ii = 1:18
    if ii<10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    
    newlon = [newlon; SIT.lon];
    
    newlat = [newlat; SIT.lat];
    
    allH = [allH; SIT.H];
    
    clear SIT
    
end


load 'ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector10.mat'
SIT10 = SIT; clear SIT

SIT.lon = newlon;
SIT.lat = newlat;
SIT.H = allH;

SIT.dn = SIT10.dn;
SIT.dv = SIT10.dv;


save('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/shelf.mat', 'SIT', '-v7.3');

clear all




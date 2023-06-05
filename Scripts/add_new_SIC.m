% Jacob Arnold

% 02-Jan-22

% Open new SIC files, grab sector's SIC, create dn,dv, add to old SIC
% structure.


% Check what dates we need
% load ICE/Concentration/ant-sectors/sector04.mat;
% 2021           2          15              % last date of SIC record


% test reading in hdf file
hinfo = hdfinfo('ICE/Concentration/New_Data/2021/asi-AMSR2-s3125-20210407-v5.4.hdf');

[nlons,nlats] = hinfo.SDS.Dims.Size;
file = hdfread(hinfo.SDS.Filename, '/ASI Ice Concentration', 'Index', {[1 1], [1 1], [nlons nlats]});

[londom, latdom] = sectordomain(10);
m_basemap('a', londom, latdom);
m_scatter(SIC.lon, SIC.lat, 10, file(SIC.index), 'filled')

%% STARTS HERE

D=textread('ICE/Concentration/New_Data/2021/names.txt','%s');

ndays=length(D);

n=0;
for k=1:ndays;

    hinfo=hdfinfo(['ICE/Concentration/New_Data/2021/', D{k}]);

    lfilename = length(hinfo.SDS.Filename);
    dummy = hinfo.SDS.Filename(lfilename-16:lfilename-9); % for amsr2 and amsre
    %dummy = hinfo.SDS.Filename(lfilename-14:lfilename-7); % for ssmis17
    
    n=n+1;
    [nlons,nlats] = hinfo.SDS.Dims.Size;
    DATA.SIC(1:nlons,1:nlats,n) = hdfread(hinfo.SDS.Filename,'/ASI Ice Concentration','Index', {[1  1],[1  1],[nlons  nlats]});
    DATA.year(n) = str2num(dummy(1:4));
    DATA.month(n) = str2num(dummy(5:6));
    DATA.day(n) = str2num(dummy(7:8));


    clear hinfo dummy;
end; 

%% 

dv(:,1) = DATA.year;
dv(:,2) = DATA.month;
dv(:,3) = DATA.day;

dn = datenum(dv);

DATA.dv = dv; 
DATA.dn = dn;

%% 

load /Volumes/Data/data2/DATASETS/Sea-Ice/concentrations/amsr2_s3125/amsr2_s3125_2021.mat;

ndv(:,1) = amsr2_s3125_2021.year;
ndv(:,2) = amsr2_s3125_2021.month;
ndv(:,3) = amsr2_s3125_2021.day;
ndn = datenum(ndv);

amsr2_s3125_2021.dv = ndv;
amsr2_s3125_2021.dn = ndn;



ccdata.SIC = cat(3,amsr2_s3125_2021.SIC,DATA.SIC);
ccdata.dn = [amsr2_s3125_2021.dn; DATA.dn];
ccdata.dv = [amsr2_s3125_2021.dv; DATA.dv];
ccdata.year = [amsr2_s3125_2021.year, DATA.year];
ccdata.month = [amsr2_s3125_2021.month, DATA.month];
ccdata.day = [amsr2_s3125_2021.day, DATA.day];

amsr2_s3125_2021 = ccdata;

save('/Volumes/Data/data2/DATASETS/Sea-Ice/concentrations/amsr2_s3125/amsr2_s3125_2021.mat', 'amsr2_s3125_2021','-v7.3');





%% Now the main 2021 file is updated lets use DATA to update all sectors 



for ii = 1:18
    
    if ii < 10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    disp(['Workin on sector ',sector, '...'])
    
    load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    
    for ff = 1:length(DATA.dn);
        dat = DATA.SIC(:,:,ff);
        
        newdat(:,ff) = dat(SIC.index);
        
    end
    
    newsic = [SIC.sic, newdat];
    newdn = [SIC.dn; DATA.dn];
    newdv = [SIC.dv; DATA.dv];
    
    SIC.sic = newsic;
    SIC.dn = newdn;
    SIC.dv = newdv;
    
    save(['ICE/Concentration/ant-sectors/sector',sector,'.mat'], 'SIC', '-v7.3');
    
    clear SIC newsic newdn newdv newdat dat
    
end
    





%% Finally interpolate for the 6 offshore zones

load ICE/Concentration/ant-sectors/sector04.mat;
origlon = SIC.grid3p125km.lon(:);
origlat = SIC.grid3p125km.lat(:);

[x3, y3] = ll2ps(origlat, origlon);


for ii = 19:24
    indx = ii;
    
    if indx==19;sector = 'subpolar_ao_SIC_25km';elseif indx==20; sector='subpolar_io_SIC_25km';
    elseif indx==21;sector='subpolar_po_SIC_25km';elseif indx==22; sector='acc_ao_SIC_25km';
    elseif indx==23; sector='acc_io_SIC_25km';elseif indx==24; sector='acc_po_SIC_25km';
    end
    
    disp(['Working on ',sector,'...'])


    file = load(['ICE/Concentration/so-zones/25km_sic/',sector,'.mat']);
    data = struct2cell(file);
    SIC = data{1,1}; clear file data
    
    [x25, y25] = ll2ps(SIC.lat, SIC.lon);
    
    
    for jj = 1:length(DATA.dn)
        
        disp([sector, ' --> Interpolating ',num2str(jj),' of ',num2str(length(DATA.dn))])
        dat = DATA.SIC(:,:,jj);
        dat = dat(:);
        
        newsic(:,jj) = griddata(double(x3), double(y3), double(dat), double(x25), double(y25));
        clear dat
        
    end
    
    catsic = [SIC.sic, newsic];
    catdn = [SIC.dn; DATA.dn];
    catdv = [SIC.dv; DATA.dv];
    
    
    SIC.sic = catsic;
    SIC.dn = catdn;
    SIC.dv = catdv;
    SIC.zone = sector;
    
    save(['ICE/Concentration/so-zones/25km_sic/',sector,'.mat'], 'SIC', '-v7.3');
    
    clear SIC x25 y25 newsic catsic catdn catdv
    
end











% Jacob Arnold

% 07-Apr-2022

% Combine necessary data to create big properties and SIT files for
% sector 00, Offshore, and SO


%% Sector 00

% initiate 
lon = []; lat = []; SIV = zeros(1262,1); SIE = zeros(1262,1); SIA = zeros(1262,1); 
MAM = []; JJA = []; SON = []; DJF = [];
monthly_means = []; meanH = []; SID = []; iu = []; iv = []; ispd = []; sp = []; sst = [];
t2m = []; wu = []; wv = []; wdiv = []; wcurl = []; wspd = []; 
sa = []; sb = []; sc = []; sd = []; ca = []; cb = []; cc = []; cd = []; ct = [];
ct_hires = []; index = []; H = [];
for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    disp(['Getting data from sector ',sector,'...'])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    %load(['ICE/Motion/Data/NSIDC/sector',sector,'.mat']);
    
    lon = [lon; seaice.lon];
    lat = [lat; seaice.lat];
    dn = seaice.dn;
    dv = seaice.dv;
    
    % SIT
    sa = [sa; SIT.sa];
    sb = [sb; SIT.sb];
    sc = [sc; SIT.sc];
    sd = [sd; SIT.sd];
    ca = [ca; SIT.ca];
    cb = [cb; SIT.cb];
    cc = [cc; SIT.cc];
    cd = [cd; SIT.cd];
    ct = [ct; SIT.ct];
    ct_hires = [ct_hires; SIT.ct_hires];
    index = [index; SIT.index];
    comment = SIT.comment;
    H = [H; SIT.H];
    
    % Properties
    readme = seaice.readme; 
    SIV = SIV + seaice.SIV;
    SIE = SIE + seaice.SIE;
    SIA = SIA + seaice.SIA;
     MAM = [MAM; seaice.seasonal.MAM];
     JJA = [JJA; seaice.seasonal.JJA];
     SON = [SON; seaice.seasonal.SON];
     DJF = [DJF; seaice.seasonal.DJF];
     monthly_means = [monthly_means; seaice.monthly_means];
    meanH = [meanH; seaice.meanH];
    

    clear seaice;


end

disp('Loading in 00 SIM data');
load ICE/Motion/Data/NSIDC/sector00.mat;

seaice.lon = lon; seaice.lat = lat; seaice.dn = dn; seaice.dv = dv; seaice.readme = readme;
seaice.SIV = SIV; seaice.SIE = SIE; seaice.SIA = SIA; seaice.seasonal.MAM = MAM; seaice.seasonal.JJA = JJA;
seaice.seasonal.SON = SON; seaice.seasonal.DJF = DJF; seaice.monthly_means = monthly_means;
seaice.meanH = meanH; seaice.SID = nanmean(SIM.SID); seaice.iu = nanmean(SIM.uh); seaice.iv = nanmean(SIM.vh);
seaice.ispd = nanmean(sqrt(SIM.uh.^2 + SIM.vh.^2));

disp('Loading in 00 ECMWF data')
load /Volumes/Data/Research_long/ECMWF/matfiles/h_timescale/sector00_ecmwf_Ht.mat;
seaice.sp = nanmean(ecmwf.sp); seaice.sst = nanmean(ecmwf.sst); seaice.t2m = nanmean(ecmwf.t2m);
seaice.wu = nanmean(ecmwf.u); seaice.wv = nanmean(ecmwf.v); seaice.wspd = nanmean(sqrt(ecmwf.u.^2 + ecmwf.v.^2));
seaice.wdiv = nanmean(ecmwf.wdiv); seaice.wcurl = nanmean(ecmwf.wcurl);
clear ecmwf;
disp('Saving sector 00 properties')
save('ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector00.mat', 'seaice', '-v7.3')

SIT.lon = lon; SIT.lat = lat; SIT.dn = dn; SIT.dv = dv; SIT.H = H;
SIT.sa = sa; SIT.sb = sb; SIT.sc = sc; SIT.sd = sd;
SIT.ca = ca; SIT.cb = cb; SIT.cc = cc; SIT.cd = cd; SIT.ct = ct;
SIT.ct_hires = ct_hires; SIT.index = index; 
disp('Saving sector 00 SIT')
save('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat', 'SIT', '-v7.3');


%% make sector 00 ice motion

% initialize
uh = []; vh = []; lon = []; lat = []; SID = []
for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    disp(['Getting data from sector ',sector,'...'])
    
    load(['ICE/Motion/Data/NSIDC/sector',sector,'.mat']);

    uh = [uh; SIM.uh];
    vh = [vh; SIM.vh];
    dnh = SIM.dnh;
    lon = [lon; SIM.lon];
    lat = [lat; SIM.lat];
    readme = SIM.readme;
    SID = [SID; SIM.SID];

    clear SIM;
end

SIM.uh = uh;
SIM.vh = vh;
SIM.dnh = dnh;
SIM.lon = lon;
SIM.lat = lat;
SIM.readme = readme;
SIM.SID = SID;


m_basemap('p', [0,360], [-90,-60])
m_scatter(SIM.lon, SIM.lat, 8, nanmean(SIM.SID, 2), 'filled')

disp('Finished and saving')
save('ICE/Motion/Data/NSIDC/sector00.mat', 'SIM', '-v7.3');


%% Sector 00 ECMWF

% Initialize
lon = []; lat = []; u = []; v = []; 
wdiv = []; wcurl = []; ue = []; ve = []; t2m = []; 
sst = []; sp = []; 
for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    disp(['Getting data from sector ',sector,'...'])
    
    load(['/Volumes/Data/Research_long/ECMWF/matfiles/h_timescale/sector',sector,'_ecmwf_Ht.mat']);
    
    lon = [lon; ecmwf.lon];
    lat = [lat; ecmwf.lat];
    u = [u; ecmwf.u];
    v = [v; ecmwf.v];
    wdiv = [wdiv; ecmwf.wdiv];
    wcurl = [wcurl; ecmwf.wcurl];
    ue = [ue; ecmwf.ue];
    ve = [ve; ecmwf.ve];
    t2m = [t2m; ecmwf.t2m];
    sst = [sst; ecmwf.sst];
    sp = [sp; ecmwf.sp];
    
    dn = ecmwf.dn;
    dv = ecmwf.dv;
    comment = ecmwf.comment;
    
    clear ecmwf
end

ecmwf.lon = lon; ecmwf.lat = lat; ecmwf.u = u; ecmwf.v = v;
ecmwf.wdiv = wdiv; ecmwf.wcurl = wcurl; ecmwf.ue = ue; ecmwf.ve = ve;
ecmwf.t2m = t2m; ecmwf.sst = sst; ecmwf.sp = sp; ecmwf.dn = dn;
ecmwf.dv = dv; ecmwf.comment = comment;

save('/Volumes/Data/Research_long/ECMWF/matfiles/h_timescale/sector00_ecmwf_Ht.mat', 'ecmwf', '-v7.3');


%% Add SIC to SIT structure

SIC = [];
for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    disp(['Getting data from sector ',sector,'...'])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);

    SIC = [SIC; SIT.SIC];
    
    clear SIT
end

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat;
SIT.SIC = SIC;

save('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat', 'SIT', '-v7.3');


%% Offshore















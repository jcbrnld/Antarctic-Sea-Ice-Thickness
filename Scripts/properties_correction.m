

% Correct properties' sea ice divergence

for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    disp(['Correcting sector ',sector,' properties structure'])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    load(['ICE/Motion/Data/NSIDC/sector',sector,'.mat']);
    
    
    os = seaice; clear seaice
    
    % rebuild the structure to improve naming
    seaice.lon = os.lon;
    seaice.lat = os.lat;
    seaice.dn = os.dn;
    seaice.dv = os.dv;
    seaice.readme = os.readme;
    seaice.SIV = os.SIV';
    seaice.SIE = os.SIE';
    seaice.SIA = os.SIA';
    seaice.seasonal.MAM = os.MAM;
    seaice.seasonal.JJA = os.JJA;
    seaice.seasonal.SON = os.SON;
    seaice.seasonal.DJF = os.DJF;
    seaice.monthly_means = os.MONTH_AV;
    seaice.meanH = os.meanH;
    seaice.SID = nanmean(SIM.SID)';
    seaice.iu = nanmean(SIM.uh)';
    seaice.iv = nanmean(SIM.vh)';
    seaice.ispd = nanmean(sqrt(SIM.uh.^2 + SIM.vh.^2))';
    seaice.sp = os.msp';
    seaice.sst = os.msst';
    seaice.t2m = os.mt2m';
    seaice.wu = os.mwu';
    seaice.wv = os.mwv';
    seaice.wdiv = os.mwdiv';
    seaice.wcurl = os.mwcurl';
    seaice.wspd = os.mwspd';
    
    
    % and save
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice', '-v7.3');
    
    
end







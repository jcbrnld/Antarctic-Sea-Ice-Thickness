% Jacob Arnold

% 30-Mar-2022

% Add to properties structures 
% mean divergence
% mean SIM u
% mean SIM v 
% mean SIM spd
% mean wind u
% mean wind v
% mean wind divergence
% mean wind curl
% mean SST
% mean surface pressure
% mean 2 m atmospheric temp

for ss = 1:18
    if ss < 10
        sector = ['0', num2str(ss)];
    else
        sector = num2str(ss);
    end
    disp(['Beginning sector ',sector,'...'])
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);

    % Ice motion parameters
    load(['ICE/Motion/Data/NSIDC/sector',sector,'.mat']);

    mSID = nanmean(SIM.SID);
    miu = nanmean(SIM.uh);
    miv = nanmean(SIM.vh);
    mispd = nanmean(sqrt(SIM.uh.^2 + SIM.vh.^2));

    seaice.mSID = mSID;
    seaice.miu = miu;
    seaice.miv = miv;
    seaice.mispd = mispd;

    seaice.readme{length(seaice.readme)+1} = 'mSID is mean sea ice divergence. miu miv and mispd are mean u v velocity components and mean spd of ice motion in the sector';

    clear SIM

    % Atmospheric parameters
    load(['/Volumes/Data/Research_long/ECMWF/matfiles/h_timescale/sector',sector,'_ecmwf_Ht.mat']);

    % FIX ATMOSPHERIC INTERPOLATION FIRST -JA 30mar2022
    msp = nanmean(ecmwf.sp);
    msst = nanmean(ecmwf.sst);
    mt2m = nanmean(ecmwf.t2m);
    mwu = nanmean(ecmwf.u);
    mwv = nanmean(ecmwf.v);
    mwdiv = nanmean(ecmwf.wdiv);
    mwcurl = nanmean(ecmwf.wcurl);
    mwspd = nanmean(sqrt(ecmwf.u.^2 + ecmwf.v.^2));

    seaice.msp = msp;
    seaice.msst = msst;
    seaice.mt2m = mt2m;
    seaice.mwu = mwu;
    seaice.mwv = mwv;
    seaice.mwdiv = mwdiv;
    seaice.mwcurl = mwcurl;
    seaice.mwspd = mwspd;

    seaice.readme{length(seaice.readme)+1} = 'msp is mean surface pressure, msst is mean sea surface temp., mt2m is mean temp. 2m above surface, mw properties are all mean wind properties';

    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice', '-v7.3');
    clearvars
end





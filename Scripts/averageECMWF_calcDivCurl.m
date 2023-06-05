% Jacob Arnold

% 03-Mar-2022

% average interpolated ECMWF data to match SIT temporal scale 
% while we're at it, calculate wind divergence and curl

% load in seaice
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);

% load interpolated ecmwf
load(['/Volumes/Data/Research/ECMWF/matfiles/sector',sector,'_ecmwf.mat']);

for ii = 1:length(seaice.dn)
    loc = find(ecmwf.dn==seaice.dn(ii));
    if ~isempty(loc);
        if ecmwf.dn(loc)+3 > ecmwf.dn(end)
            mysst(ii) = nanmean(ecmwf.sst(:,loc-3:end),2);
            mysp(ii) = nanmean(ecmwf.sp(:,loc-3:end),2);
            myu10(ii) = nanmean(ecmwf.u10(:,loc-3:end),2);
            myv10(ii) = nanmean(ecmwf.v10(:,loc-3:end),2);
            myt2m(ii) = nanmean(ecmwf.t2m(:,loc-3:end),2);
        else
            mysst(ii) = nanmean(ecmwf.sst(:,loc-3:loc+3),2);
            mysp(ii) = nanmean(ecmwf.sp(:,loc-3:loc+3),2);
            myu10(ii) = nanmean(ecmwf.u10(:,loc-3:loc+3),2);
            myv10(ii) = nanmean(ecmwf.v10(:,loc-3:loc+3),2);
            myt2m(ii) = nanmean(ecmwf.t2m(:,loc-3:loc+3),2);

        end
    else
        mydpdy(ii) = nan;
        mydpdx(ii) = nan;
        mylowlat(ii) = nan;
        myhighlat(ii) = nan;
    end

    clear loc
end

figure;
plot_dim(1000,400);
subplot(2,1,1)
plot(nanmean(mysp));
subplot(2,1,2)
plot(sum(isnan(mysp))./length(mysp(:,1)))

clear ecmwf;
ecmwf.dn = seaice.dn;
ecmwf.lon = seaice.lon;
ecmwf.lat = seaice.lat;
ecmwf.sst = mysst;
ecmwf.sp = mysp;
ecmwf.u10 = myu10;
ecmwf.v10 = myv10;
ecmwf.t2m = myt2m;

% calculate divergence and curl
% need 2d grid
load ICE/ICETHICKNESS/Data/MAT_files/grid_3125.mat;

wdiv = nan(length(seaice.lon), length(seaice.dn));
wcurl = wdiv;
for ii = 1:length(seaice.dn)
    tu = nan(size(grid_3125.lon));
    tv = tdiv;
    
    tu(seaice.index) = ecmwf.u10(:,ii); % temporary 2d velcity components at week ii
    tv(seaice.index) = ecmwf.v10(:,ii);
    
    tdiv = cdtdivergence(grid_3125.lat, grid_3125.lon, tu, tv);
    tcurl = ctdcurl(grid_3125.lat, grid_3125.lon, tu, tv);
    
    wdiv(:,ii) = tdiv(seaice.index);
    wcurl(:,ii) = tcurl(seaice.index);
    
    clear tu tv tdiv
    
end






save(['/Volumes/Data/Research/ECMWF/matfiles/sector',sector,'.mat'], 'ecmwf', '-v7.3');











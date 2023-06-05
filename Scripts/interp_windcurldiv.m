% Jacob Arnold

% 03-Mar-2022

% interpolate wind divergence and curl to sector grids from segments
% STILL NEED TO RUN FOR 17 and 18
% Error using save
% Can not write file
% /Volumes/Data_baby/Research/ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector17.mat.

% RERUN AND SAVE WIND CURL DIVERGENCE AND EKMAN TO SEPARATE FILE IN DATA
% ALSO average to SIT timescale and save in properties -JA 04Mar2022

% NEED to clear out some space on data and run for sectors 17 and 18
for ss = 17:18

    if ss < 10
        sector = ['0', num2str(ss)];
    else
        sector = num2str(ss);
    end
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);

    data = load(['/Volumes/Data/Research_long/ECMWF/matfiles/segment',sector,'.mat']);
    data2 = struct2cell(data);
    ecmwf1 = data2{1,1}; clear data data2

    %%% convert lats and lons to xy

    [sx,sy] = ll2ps(seaice.lat, seaice.lon);
    [ex,ey] = ll2ps(ecmwf1.lat(:), ecmwf1.lon(:));

    % need to interpolate 
    % u10, v10, t2m, sst, sp, 
    ndiv = nan(length(seaice.lon), length(ecmwf1.dn));
    ncurl = ndiv; nue = ndiv; nve = ndiv; nu = ndiv;
    nv = ndiv; nt2m = ndiv; nsst = ndiv; nsp = ndiv;

    counter = 0:500:20000;
    for ii = 1:length(ecmwf1.dn)
        if ismember(ii,counter)
            disp(['Sector ',sector,' interpolating ',num2str(ii), ' of ', num2str(length(ecmwf1.dn))])
        end
        uii = ecmwf1.u10(:,:,ii);
        vii = ecmwf1.u10(:,:,ii);
        divii = ecmwf1.div10(:,:,ii);
        curlii = ecmwf1.curlz10(:,:,ii);
        ueii = ecmwf1.ue(:,:,ii);
        veii = ecmwf1.ve(:,:,ii);
        t2mii = ecmwf1.t2m(:,:,ii);
        sstii = ecmwf1.sst(:,:,ii);
        spii = ecmwf1.sp(:,:,ii);

        nu(:,ii) = griddata(double(ex), double(ey), double(uii(:)), double(sx), double(sy));
        nv(:,ii) = griddata(double(ex), double(ey), double(vii(:)), double(sx), double(sy));
        ndiv(:,ii) = griddata(double(ex), double(ey), double(divii(:)), double(sx), double(sy));
        ncurl(:,ii) = griddata(double(ex), double(ey), double(curlii(:)), double(sx), double(sy));
        nue(:,ii) = griddata(double(ex), double(ey), double(ueii(:)), double(sx), double(sy));
        nve(:,ii) = griddata(double(ex), double(ey), double(veii(:)), double(sx), double(sy));
        nt2m(:,ii) = griddata(double(ex), double(ey), double(t2mii(:)), double(sx), double(sy));
        nsst(:,ii) = griddata(double(ex), double(ey), double(sstii(:)), double(sx), double(sy));
        nsp(:,ii) = griddata(double(ex), double(ey), double(spii(:)), double(sx), double(sy));
        


        clear divii curlii

    end
    
    % average to my timescale and save as smaller files
    % THIS AVERAGING DID NOT WORK
    % - just produced nans. This is corrected in a separate script (open
    % large files and reaverage all properties to h timescale and resave
    % -JA 30-mar-2022
    
    for qq = 1:length(seaice.dn)
        if seaice.dn(qq) > max(ecmwf1.dn)
            sU(:,qq) = nan;
            sV(:,qq) = nan;
            sdiv(:,qq) = nan;
            scurl(:,qq) = nan;
            sue(:,qq) = nan;
            sve(:,qq) = nan;
            st2m(:,qq) = nan;
            ssst(:,qq) = nan;
            ssp(:,qq) = nan;
            continue
        end

        dnloc = find(ecmwf1.dn==seaice.dn(qq));

        if ecmwf1.dn(dnloc)+3>max(seaice.dn)
            sU(:,qq) = nanmean(nu(:,dnloc-3:end),2);
            sV(:,qq) = nanmean(nv(:,dnloc-3:end),2);
            sdiv(:,qq) = nanmean(ndiv(:,dnloc-3:end),2);
            scurl(:,qq) = nanmean(ncurl(:,dnloc-3:end),2);
            sue(:,qq) = nanmean(nue(:,dnloc-3:end),2);
            sve(:,qq) = nanmean(nve(:,dnloc-3:end),2);
            st2m(:,qq) = nanmean(nt2m(:,dnloc-3:end),2);
            ssst(:,qq) = nanmean(nsst(:,dnloc-3:end),2);
            ssp(:,qq) = nanmean(nsp(:,dnloc-3:end),2);
        else
            sU(:,qq) = nanmean(nu(:,dnloc-3:dnloc+3),2);
            sV(:,qq) = nanmean(nv(:,dnloc-3:dnloc+3),2);
            sdiv(:,qq) = nanmean(ndiv(:,dnloc-3:dnloc+3),2);
            scurl(:,qq) = nanmean(ncurl(:,dnloc-3:dnloc+3),2);
            sue(:,qq) = nanmean(nue(:,dnloc-3:dnloc+3),2);
            sve(:,qq) = nanmean(nve(:,dnloc-3:dnloc+3),2);
            st2m(:,qq) = nanmean(nt2m(:,dnloc-3:dnloc+3),2);
            ssst(:,qq) = nanmean(nsst(:,dnloc-3:dnloc+3),2);
            ssp(:,qq) = nanmean(nsp(:,dnloc-3:dnloc+3),2);

        end

        clear dnloc

    end
    ecmwf.dn = seaice.dn;
    ecmwf.dv = seaice.dv;
    ecmwf.lon = seaice.lon;
    ecmwf.lat = seaice.lat;
    ecmwf.u = sU;
    ecmwf.v = sV;
    ecmwf.wdiv = sdiv;
    ecmwf.wcurl = scurl;
    ecmwf.ue = sue;
    ecmwf.ve = sve;
    ecmwf.t2m = st2m;
    ecmwf.sst = ssst;
    ecmwf.sp = ssp;
    ecmwf.comment = {'These are on the same timescale as SIT'};
    disp('Saving the short one')
    save(['/Volumes/Data/Research_long/ECMWF/matfiles/h_timescale/sector',sector,'_ecmwf_Ht.mat'], 'ecmwf', '-v7.3');
    
    clear sU sV sdiv scurl sue sve st2m ssst ssp ecmwf
    
    % THese files will be huge --> must save on Data not data_baby
    ecmwf.dn = ecmwf1.dn;
    ecmwf.dv = ecmwf1.dv;
    ecmwf.lon = seaice.lon;
    ecmwf.lat = seaice.lat;
    ecmwf.u = nu;
    ecmwf.v = nv;
    ecmwf.wdiv = ndiv;
    ecmwf.wcurl = ncurl;
    ecmwf.ue = nue;
    ecmwf.ve = nve;
    ecmwf.t2m = nt2m;
    ecmwf.sst = nsst;
    ecmwf.sp = nsp;
    disp('Saving the long one')

    save(['/Volumes/Data/Research_long/ecmwf/matfiles/sector',sector,'.mat'], 'ecmwf', '-v7.3');

    disp(['Finished with sector ',sector])
    clearvars 

end








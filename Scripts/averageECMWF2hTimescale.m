% Jacob Arnold

% 30-Mar-2022

% Wind properties were not averaged to h timescale correctly. 
% Here we fix this by opening the large (daily) wind files for each sector
% and average their properties to h timescale then re-save.
for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end

    disp(['Beginning sector ',sector, '...'])

    % use properties as it is a small file that has the dn we need
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);

    % now the big atmo file
    load(['/Volumes/Data/Research_long/ECMWF/matfiles/sector',sector,'.mat']);
    ecmwf1 = ecmwf; clear ecmwf
    edv = datevec(ecmwf1.dn);
    edv(:,4) = 0;
    ecmwf1.dn = datenum(edv); % fix hour inclusion that makes dn not whole numbers

    % and average
    counter = 1;
    c2 = 0:100:2000;
    for qq = 1:length(seaice.dn)
        if ismember(qq,c2)
            disp(['sector ',sector,': Averaging ',num2str(qq),' of ',num2str(length(seaice.dn))])
        end
        if seaice.dn(qq) > max(ecmwf1.dn)
            toobig(counter) = seaice.dn(qq); counter = counter+1; % keep track of nans
            sU(:,qq) = nan;
            sV(:,qq) = nan;
            sdiv(:,qq) = nan;
            scurl(:,qq) = nan;
            sue(:,qq) = nan;
            sve(:,qq) = nan;
            st2m(:,qq) = nan;
            ssst(:,qq) = nan;
            ssp(:,qq) = nan;
        else

            dnloc = find(ecmwf1.dn==seaice.dn(qq));

            if ecmwf1.dn(dnloc)+3>max(ecmwf1.dn)
                sU(:,qq) = nanmean(ecmwf1.u(:,dnloc-3:end),2);
                sV(:,qq) = nanmean(ecmwf1.v(:,dnloc-3:end),2);
                sdiv(:,qq) = nanmean(ecmwf1.wdiv(:,dnloc-3:end),2);
                scurl(:,qq) = nanmean(ecmwf1.wcurl(:,dnloc-3:end),2);
                sue(:,qq) = nanmean(ecmwf1.ue(:,dnloc-3:end),2);
                sve(:,qq) = nanmean(ecmwf1.ve(:,dnloc-3:end),2);
                st2m(:,qq) = nanmean(ecmwf1.t2m(:,dnloc-3:end),2);
                ssst(:,qq) = nanmean(ecmwf1.sst(:,dnloc-3:end),2);
                ssp(:,qq) = nanmean(ecmwf1.sp(:,dnloc-3:end),2);
            else
                sU(:,qq) = nanmean(ecmwf1.u(:,dnloc-3:dnloc+3),2);
                sV(:,qq) = nanmean(ecmwf1.v(:,dnloc-3:dnloc+3),2);
                sdiv(:,qq) = nanmean(ecmwf1.wdiv(:,dnloc-3:dnloc+3),2);
                scurl(:,qq) = nanmean(ecmwf1.wcurl(:,dnloc-3:dnloc+3),2);
                sue(:,qq) = nanmean(ecmwf1.ue(:,dnloc-3:dnloc+3),2);
                sve(:,qq) = nanmean(ecmwf1.ve(:,dnloc-3:dnloc+3),2);
                st2m(:,qq) = nanmean(ecmwf1.t2m(:,dnloc-3:dnloc+3),2);
                ssst(:,qq) = nanmean(ecmwf1.sst(:,dnloc-3:dnloc+3),2);
                ssp(:,qq) = nanmean(ecmwf1.sp(:,dnloc-3:dnloc+3),2);

            end

            clear dnloc
        end
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

    figure
    plot(nanmean(ecmwf.wdiv))
    title(['Sector ',sector, ' mean wind divergence'])
    
    clearvars
end












% Jacob Arnold

% 08-Feb-2022

% Interpolate older gridded data at the formerly missing grid points
secnames = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};

for ss = 1:6
    sector = secnames{ss};
    disp(['Beginning sector ',sector]);

    load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/backup08feb22/sector',sector,'_SIC_25km_shpSIG.mat']);
    SIG = SIT; clear SIT;

    load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/backup08feb22/sector',sector,'_SIC_25km_shpE00.mat']);
    E00 = SIT; clear SIT;


    % Load in data with larger grid
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones_short/',sector,'.mat']);
    oSIT = SIT; clear SIT;

    % Find those new grid points
    olen = length(oSIT.lon);
    nlen = length(SIG.lon);
    diflen = olen-nlen;
    if diflen==0
        error(['There is no difference in grid size for sector ',sector])
    end
    disp(['There are ',num2str(diflen),' more grid points that need to be found.']);
    for ii = 0:diflen-1 % test that those missing grid points are tacked on the end
        tloc = find(SIG.lon==oSIT.lon(end-ii) & SIG.lat==oSIT.lat(end-ii));
        if ~isempty(tloc)
            error(['grid point at position: end-',num2str(ii),' already exists in shortSIT'])
        else
            if ii == diflen-1
                disp(['The missing grid points are the last ',num2str(ii)+1,' in oSIT'])
            end
        end

    end

    newlon = oSIT.lon(end-(diflen-1):end);
    newlat = oSIT.lat(end-(diflen-1):end);




    if length(E00.lon)==length(SIG.lon)
        disp('Both E00 and SIG have same number of grid points')
    else
        error('E00 and SIG have different size grids... something is wrong');
    end
    % Grab our older grid
    smlat = SIG.lat;
    smlon = SIG.lon;
    % Convert from lat/lon to xy coordinates
    [smx,smy] = ll2ps(smlat, smlon);
    [gx,gy] = ll2ps(oSIT.lat, oSIT.lon);

    % ------> Lets start with E00
    counter = 0:100:10000;
    disp('Starting E00')
    for ii = 1:length(E00.dn);
        if ismember(ii,counter)
            disp(['On E00 number ',num2str(ii)])
        end
        newsa(:,ii) = griddata(double(smx), double(smy), double(E00.sa(:,ii)), double(gx), double(gy));
        newsb(:,ii) = griddata(double(smx), double(smy), double(E00.sb(:,ii)), double(gx), double(gy));
        newsc(:,ii) = griddata(double(smx), double(smy), double(E00.sc(:,ii)), double(gx), double(gy));
        newsd(:,ii) = griddata(double(smx), double(smy), double(E00.sd(:,ii)), double(gx), double(gy));
        newca(:,ii) = griddata(double(smx), double(smy), double(E00.ca(:,ii)), double(gx), double(gy));
        newcb(:,ii) = griddata(double(smx), double(smy), double(E00.cb(:,ii)), double(gx), double(gy));
        newcc(:,ii) = griddata(double(smx), double(smy), double(E00.cc(:,ii)), double(gx), double(gy));
        newcd(:,ii) = griddata(double(smx), double(smy), double(E00.cd(:,ii)), double(gx), double(gy));
        newct(:,ii) = griddata(double(smx), double(smy), double(E00.ct(:,ii)), double(gx), double(gy));

    end

    oldE = E00;
    clear E00;

    % Build new
    E00.H = nan(size(newsa));
    E00.sa = newsa; 
    E00.sb = newsb;
    E00.sc = newsc;
    E00.sd = newsd;
    E00.ca = newca;
    E00.cb = newcb;
    E00.cc = newcc;
    E00.cd = newcd;
    E00.ct = newct;
    E00.lon = oSIT.lon;
    E00.lat = oSIT.lat;
    E00.dn = oldE.dn;
    E00.dv = oldE.dv;
    clear newsa newsb newsc newsd newca newcb newcc newcd newct

    save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_SIC_25km_shpE00.mat'], 'E00', '-v7.3');



    % ------> Now SIG
    disp('Starting SIG')
    for ii = 1:length(SIG.dn);
        if ismember(ii,counter)
            disp(['On SIG number ',num2str(ii)])
        end
        newsa(:,ii) = griddata(double(smx), double(smy), double(SIG.sa(:,ii)), double(gx), double(gy));
        newsb(:,ii) = griddata(double(smx), double(smy), double(SIG.sb(:,ii)), double(gx), double(gy));
        newsc(:,ii) = griddata(double(smx), double(smy), double(SIG.sc(:,ii)), double(gx), double(gy));
        newsd(:,ii) = griddata(double(smx), double(smy), double(SIG.sd(:,ii)), double(gx), double(gy));
        newca(:,ii) = griddata(double(smx), double(smy), double(SIG.ca(:,ii)), double(gx), double(gy));
        newcb(:,ii) = griddata(double(smx), double(smy), double(SIG.cb(:,ii)), double(gx), double(gy));
        newcc(:,ii) = griddata(double(smx), double(smy), double(SIG.cc(:,ii)), double(gx), double(gy));
        newcd(:,ii) = griddata(double(smx), double(smy), double(SIG.cd(:,ii)), double(gx), double(gy));
        newct(:,ii) = griddata(double(smx), double(smy), double(SIG.ct(:,ii)), double(gx), double(gy));

    end

    oldSIG = SIG;
    clear SIG;

    % Build new
    SIG.H = nan(size(newsa));
    SIG.sa = newsa;
    SIG.sb = newsb;
    SIG.sc = newsc;
    SIG.sd = newsd;
    SIG.ca = newca;
    SIG.cb = newcb;
    SIG.cc = newcc;
    SIG.cd = newcd;
    SIG.ct = newct;
    SIG.lon = oSIT.lon;
    SIG.lat = oSIT.lat;
    SIG.dn = oldSIG.dn;
    SIG.dv = oldSIG.dv;


    save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_SIC_25km_shpSIG.mat'], 'SIG', '-v7.3');
    clearvars -except secnames

end




%% Now for SIC

secnames = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};

for ss = 1:6
    sector = secnames{ss};
    disp(['Beginning sector ',sector]);

    %sector = 'subpolar_io';

    load(['ICE/Concentration/so-zones/25km_sic/backup08feb22/',sector,'_SIC_25km.mat']);

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones_short/',sector,'.mat']);

    smlon = SIC.lon;
    smlat = SIC.lat;

    lalon = SIT.lon;
    lalat = SIT.lat;

    ldif = length(lalon) - length(smlon);
    disp(['Number of grid points to fill is ',num2str(ldif)])



    % Convert from lat/lon to xy coordinates
    [smx,smy] = ll2ps(smlat, smlon);
    [gx,gy] = ll2ps(lalat, lalon);

    counter = 0:500:10000;
    for ii = 1:length(SIC.dn)
        if ismember(ii,counter)
            disp(['On SIC number ',num2str(ii)])
        end
        newsic(:,ii) = griddata(double(smx), double(smy), SIC.sic(:,ii), double(gx), double(gy));

    end


    oSIC = SIC; clear SIC

    % Build new
    SIC.sic = newsic;
    SIC.lon = lalon;
    SIC.lat = lalat;
    SIC.dn = oSIC.dn;
    SIC.dv = oSIC.dv;
    SIC.zone = oSIC.zone;


    save(['ICE/Concentration/so-zones/25km_sic/',sector,'_SIC_25km.mat'], 'SIC', '-v7.3');
    
    clearvars -except secnames

end












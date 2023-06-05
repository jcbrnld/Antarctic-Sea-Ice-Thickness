% Jacob Arnold

% 08-Feb-2022

% ONE more thing for the zones... need to interp the partials over those
% new grid points.

% Run this one when you get home

secnames = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};

for ss = 1:6
    sector = secnames{ss};
    disp(['Beginning sector ',sector]);
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones_short/Partials/backup08feb22/',sector,'_partials.mat']);
    load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_SIC_25km_shpE00.mat']);
    
    smlon = partials.lon;
    smlat = partials.lat;
    
    lalon = SIT.lon;
    lalat = SIT.lat;
    
    % Find those new grid points
    olen = length(SIT.lon);
    nlen = length(partials.lon);
    diflen = olen-nlen;
    if diflen==0
        error(['There is no difference in grid size for sector ',sector])
    end
    disp(['There are ',num2str(diflen),' more grid points that need to be found.']);
    
    [smx,smy] = ll2ps(smlat, smlon);
    [lax, lay] = ll2ps(lalat, lalon);
    
    counter = 0:100:10000;
    for ii = 1:length(partials.dn)
        if ismember(ii,counter)
            disp(['On ',sector,' week ',num2str(ii)])
        end
        % Interpolate all variables
        newsa(:,ii) = griddata(double(smx), double(smy), double(partials.sa(:,ii)), double(lax), double(lay));
        newsb(:,ii) = griddata(double(smx), double(smy), double(partials.sb(:,ii)), double(lax), double(lay));
        newsc(:,ii) = griddata(double(smx), double(smy), double(partials.sc(:,ii)), double(lax), double(lay));
        newsd(:,ii) = griddata(double(smx), double(smy), double(partials.sd(:,ii)), double(lax), double(lay));
        newct(:,ii) = griddata(double(smx), double(smy), double(partials.ct(:,ii)), double(lax), double(lay));
        newca(:,ii) = griddata(double(smx), double(smy), double(partials.ca(:,ii)), double(lax), double(lay));
        newcb(:,ii) = griddata(double(smx), double(smy), double(partials.cb(:,ii)), double(lax), double(lay));
        newcc(:,ii) = griddata(double(smx), double(smy), double(partials.cc(:,ii)), double(lax), double(lay));
        newcd(:,ii) = griddata(double(smx), double(smy), double(partials.cd(:,ii)), double(lax), double(lay));
        newca_hires(:,ii) = griddata(double(smx), double(smy), double(partials.ca_hires(:,ii)), double(lax), double(lay));
        newcb_hires(:,ii) = griddata(double(smx), double(smy), double(partials.cb_hires(:,ii)), double(lax), double(lay));
        newcc_hires(:,ii) = griddata(double(smx), double(smy), double(partials.cc_hires(:,ii)), double(lax), double(lay));
        newcd_hires(:,ii) = griddata(double(smx), double(smy), double(partials.cd_hires(:,ii)), double(lax), double(lay));
        newct_hires(:,ii) = griddata(double(smx), double(smy), double(partials.ct_hires(:,ii)), double(lax), double(lay));
        
        % Now the deeper ones
        newmaca(:,ii) = griddata(double(smx), double(smy), double(partials.mavg.CA(:,ii)), double(lax), double(lay));
        newmacb(:,ii) = griddata(double(smx), double(smy), double(partials.mavg.CB(:,ii)), double(lax), double(lay));
        newmacc(:,ii) = griddata(double(smx), double(smy), double(partials.mavg.CC(:,ii)), double(lax), double(lay));
        newmacd(:,ii) = griddata(double(smx), double(smy), double(partials.mavg.CD(:,ii)), double(lax), double(lay));
        newmact(:,ii) = griddata(double(smx), double(smy), double(partials.mavg.CT(:,ii)), double(lax), double(lay));
        newmasa(:,ii) = griddata(double(smx), double(smy), double(partials.mavg.SA(:,ii)), double(lax), double(lay));
        newmasb(:,ii) = griddata(double(smx), double(smy), double(partials.mavg.SB(:,ii)), double(lax), double(lay));
        newmasc(:,ii) = griddata(double(smx), double(smy), double(partials.mavg.SC(:,ii)), double(lax), double(lay));
        newmasd(:,ii) = griddata(double(smx), double(smy), double(partials.mavg.SD(:,ii)), double(lax), double(lay));
        
        newersa(:,ii) = griddata(double(smx), double(smy), double(partials.error.sa(:,ii)), double(lax), double(lay));
        newersb(:,ii) = griddata(double(smx), double(smy), double(partials.error.sb(:,ii)), double(lax), double(lay));
        newersc(:,ii) = griddata(double(smx), double(smy), double(partials.error.sc(:,ii)), double(lax), double(lay));
        newersd(:,ii) = griddata(double(smx), double(smy), double(partials.error.sd(:,ii)), double(lax), double(lay));
        newerH(:,ii) = griddata(double(smx), double(smy), double(partials.error.H(:,ii)), double(lax), double(lay));
        
    end
    
    oldpartials = partials; clear partials
    
    % Build new
    partials.sa = newsa; partials.sb = newsb; partials.sc = newsc; partials.sd = newsd;
    partials.ca = newca; partials.cb = newcb; partials.cc = newcc; partials.cd = newcd; partials.ct = newct;
    partials.ca_hires = newca_hires; partials.cb_hires = newcb_hires; partials.cc_hires = newcc_hires; 
    partials.cd_hires = newcd_hires; partials.ct_hires = newct_hires;
    
    partials.mavg.CA = newmaca; partials.mavg.CB = newmacb;
    partials.mavg.CC = newmacc; partials.mavg.CD = newmacd;
    partials.mavg.CT = newmact; partials.mavg.SA = newmasa;
    partials.mavg.SB = newmasb; partials.mavg.SC = newmasc; partials.mavg.SD = newmasd;
    
    
    partials.error.sa = newersa;
    partials.error.sb = newersb;
    partials.error.sc = newersc;
    partials.error.sd = newersd;
    partials.error.H = newerH;
    
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones_short/Partials/',sector,'_partials.mat'], 'partials', '-v7.3');
    
    
    clearvars -except secnames
    
end
    
    
    
    
    
    
    


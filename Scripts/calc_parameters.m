% Jacob Arnold

% 10-Feb-2022

% Calculate for each sector, each zone, all shelf, all offshore, all SO
% --> Sea Ice Volume
% --> Sea Ice Extent
% --> Sea Ice Area
% --> Seasonal averages (size = #grid points x 4) seasons: mam, jja, son, djf
% --> Monthly averages (size = #grid points x 12)
% --> Record length average (size = #grid points x 1)

% ---- let's hold off on growth season - do that separately
% --> Growth season start (based on volume)
% --> Growth season end (based on volume)
% --> Growth season length (based on volume)
% --> Decay season start (based on volume)
% --> Decay season end (based on volume)
% --> Decay season length (based on volume)

zones = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};
% Initialize cumulative variables
cSIV = [];cSIE = [];cSIA = [];cMAM = [];cJJA = [];cSON = [];
cDJF = [];cMONTH = [];cMean = [];cem = [];clm = [];

% Try it out first

for ss = 1:24
    if ss < 10
        sector = ['0',num2str(ss)];
    elseif ss >= 10 & ss <= 18
        sector = num2str(ss);
    else
        sector = zones{ss-18};
    end
    if length(sector)==2
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/',sector,'.mat']);
    end

    disp(['Beginning sector ',sector])
    seaice.lon = SIT.lon;
    seaice.lat = SIT.lat;
    seaice.dn = SIT.dn;
    seaice.dv = SIT.dv;
    seaice.readme = {'SIV: Sea Ice Volume'; 'SIE: Sea Ice Extent'; 'SIA: Sea Ice Area';...
        'MAM: averaged March,April,May'; 'JJA: averaged June,July,August'; 'SON: averaged September,October,November';...
        'DJF: averaged December,January,February'; 'earlymean: 1997-2014 average'; 'latemean: 2015-2021 average'};
    seaice.sector = sector;

    % SIV
    AH = (SIT.H./1000).*3.125; % mXn of area times SIT in km^3
    SIV = sum(AH, 1,'omitnan'); % Sum all grid cell AHs to get total sector volume at that time. 
    seaice.SIV = SIV;
    
    if ss <=18 
        sic = SIT.SIC;
    else
        sic = SIT.ct_hires;
    end
    % SIE
    % Sum of all grid points with > 15% SIC times grid cell area
    sieind = sic > 15;
    if length(sector)==2
        SIE = sum(sieind).*3.125; % units are km^2
    else
        SIE = sum(sieind).*25; % units are km^2
    end
    seaice.SIE = SIE;

    % SIA
    % Sum of all grid cell areas times their concentrations
    if length(sector)==2
        SIA = nansum((sic./100).*3.125); % units are km^2
    else
        SIA = nansum((sic./100).*25); % units are km^2
    end
    seaice.SIA = SIA;

    % Seasonal averages
    % mam
    mamind = find(SIT.dv(:,2)==3 | SIT.dv(:,2)==4 | SIT.dv(:,2)==5);
    MAM = nanmean(SIT.H(:,mamind),2);

    %jja
    jjaind = find(SIT.dv(:,2)==6 | SIT.dv(:,2)==7 | SIT.dv(:,2)==8);
    JJA = nanmean(SIT.H(:,jjaind),2);

    %son
    sonind = find(SIT.dv(:,2)==9 | SIT.dv(:,2)==10 | SIT.dv(:,2)==11);
    SON = nanmean(SIT.H(:,sonind),2);

    %djf
    djfind = find(SIT.dv(:,2)==12 | SIT.dv(:,2)==1 | SIT.dv(:,2)==2);
    DJF = nanmean(SIT.H(:,djfind),2);

    seaice.MAM = MAM;
    seaice.JJA = JJA;
    seaice.SON = SON;
    seaice.DJF = DJF;


    % monthly averages
    for ii = 1:12
        mind = find(SIT.dv(:,2)==ii);
        MONTH_AV(:,ii) = nanmean(SIT.H(:,mind),2);
        clear mind;
    end
    seaice.MONTH_AV = MONTH_AV;



    % All average
    meanH = nanmean(SIT.H,2);
    seaice.meanH = meanH;

    % early and late aren't so useful
%     % 1997-2014 average
%     dind = find(SIT.dv(:,1)<=2014);
%     earlymean = nanmean(SIT.H(:,dind),2);
%     seaice.earlymean = earlymean;
%     % 2015-2021 average
%     dind2 = find(SIT.dv(:,1)>2014);
%     latemean = nanmean(SIT.H(:,dind2),2);
%     seaice.latemean = latemean;


    % Build sector 00 properties rather than recalculating
    cSIV = sum([cSIV;SIV],1);
    cSIE = sum([cSIE;SIE],1);
    cSIA = sum([cSIA;SIA],1);
    cMAM = [cMAM;MAM];
    cJJA = [cJJA;JJA];
    cSON = [cSON;SON];
    cDJF = [cDJF;DJF];
    cMONTH = [cMONTH;MONTH_AV];
    cMean = [cMean;meanH];
   % cem = [cem;earlymean];
   % clm = [clm;latemean];
    creadme = seaice.readme; % putting this here so I don't forget


    if ss<=18
        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice', '-v7.3');
    else
        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/',sector,'.mat'],'seaice','-v7.3');
    end

    if ss==18
        % Sector 00 (entire shelf)
        clear seaice SIT
        seaice.SIV = cSIV;
        seaice.SIE = cSIE;
        seaice.SIA = cSIA;
        seaice.MAM = cMAM;
        seaice.JJA = cJJA;
        seaice.SON = cSON;
        seaice.DJF = cDJF;
        seaice.MONTH_AV = cMONTH;
        seaice.meanH = cMean;
       % seaice.earlymean = cem;
       % seaice.latemean = clm;
        seaice.readme = creadme;

        load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat;

        % check size
        if length(SIT.lon)==length(seaice.meanH) & length(SIT.dn)==length(seaice.SIV)
            disp(['Sizes match for sector 00'])
        else 
            error('Sizes do NOT match for sector 00')
        end
        seaice.lon = SIT.lon;
        seaice.lat = SIT.lat;
        seaice.dn = SIT.dn;
        seaice.dv = SIT.dv;
        seaice.sector = '00';

        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector00.mat'], 'seaice', '-v7.3');

    elseif ss==24
        % Entire southern ocean
        

        load ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/offshore.mat;
        offSIT = SIT; clear SIT
        load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector00.mat;
        sheSIT = seaice; clear seaice
        SIT.lon = [sheSIT.lon; offSIT.lon];
        SIT.lat = [sheSIT.lat; offSIT.lat];
        SIT.dn = sheSIT.dn;
        SIT.dv = sheSIT.dv;

        seaice.SIV = cSIV;
        seaice.SIE = cSIE;
        seaice.SIA = cSIA;
        seaice.MAM = cMAM;
        seaice.JJA = cJJA;
        seaice.SON = cSON;
        seaice.DJF = cDJF;
        seaice.MONTH_AV = cMONTH;
        seaice.meanH = cMean;
        %seaice.earlymean = cem;
        %seaice.latemean = clm;
        seaice.readme = creadme;
        % check size
        if length(SIT.lon)==length(seaice.meanH) & length(SIT.dn)==length(seaice.SIV)
            disp(['Sizes match for all Southern Ocean'])
        else 
            error('Sizes do NOT match for all Southern Ocean')
        end
        seaice.lon = SIT.lon;
        seaice.lat = SIT.lat;
        seaice.dn = SIT.dn;
        seaice.dv = SIT.dv;
        seaice.sector = 'southern_ocean';

        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/so.mat'],'seaice','-v7.3');

        % now just offshore
        clear seaice SIT
        load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector00.mat;
        sec00 = seaice; clear seaice;
        gl = length(sec00.lon)+1;

        seaice.SIV = cSIV-sec00.SIV;
        seaice.SIE = cSIE-sec00.SIE;
        seaice.SIA = cSIA-sec00.SIA;
        seaice.MAM = cMAM(gl:end);
        seaice.JJA = cJJA(gl:end);
        seaice.SON = cSON(gl:end);
        seaice.DJF = cDJF(gl:end);
        seaice.MONTH_AV = cMONTH(gl:end,:);
        seaice.meanH = cMean(gl:end);
        seaice.earlymean = cem(gl:end);
        seaice.latemean = clm(gl:end);
        seaice.readme = creadme;

        load ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/offshore.mat;
        if length(SIT.lon)==length(seaice.meanH) & length(SIT.dn)==length(seaice.SIV)
            disp(['Sizes match for all offshore'])
        else 
            error('Sizes do NOT match for all offshore')
        end
        seaice.lon = SIT.lon;
        seaice.lat = SIT.lat;
        seaice.dn = SIT.dn;
        seaice.dv = SIT.dv;
        seaice.sector = 'offshore';
        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/offshore.mat'],'seaice','-v7.3');

    end

    clear seaice SIT SIV SIE SIA MAM AH dind dind2 DJF djfind earlymean JJA jjaind lateman mamind meanH MONTH_AV sector SON sonind





end






%% Divergence
load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);


































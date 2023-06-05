% Jacob Arnold

% 19-Nov-2021

% Calculate sea ice volume in all sectors and zones 


% Start with the sectors 

sampdv(:,1) = [1997:2022];
sampdv(:,2:3) = 1;
sampdn = datenum(sampdv);

for ii = 1:18
    if ii<10
        sector = ['0',num2str(ii)]
    else
        sector = num2str(ii)
    end
    
    disp(['Calculating SIV for sector ',sector])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    
    AH = (SIT.H./1000).*3.125; % mXn of area times SIT in km^3

    SIV = sum(AH, 1,'omitnan'); % Sum all grid cell AHs to get total sector volume at that time. 
    
    figure;
    set(gcf, 'position', [200,250,1000,300])
    plot(SIT.dn, SIV, 'linewidth', 1.1, 'color', [0.3,0.7,0.6])
    title(['Sector ',sector,' Sea Ice Volume']);
    ylabel('Sea Ice Volume [km^3]');
    xticks(sampdn);
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(25)
    xlim([729650, 738238]);
    grid on
    
    print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/SeaIceVolume.png'], '-dpng', '-r500');
    
    SIT.SIV = SIV;
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
    
    clear AH SIV SIT
    
end
    
%% zones


sampdv(:,1) = [1997:2022];
sampdv(:,2:3) = 1;
sampdn = datenum(sampdv);

zones = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};
zones2 = {'Subpolar Atlantic', 'Subpolar Indian', 'Subpolar Pacific', 'ACC Atlantic', 'ACC Indian', 'ACC Pacific'};

for ii = 1:6
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/',zones{ii},'.mat']);
    
    AH = (SIT.H./1000).*25; % mXn of area times SIT in km^3

    SIV = sum(AH, 1,'omitnan'); % Sum all grid cell AHs to get total sector volume at that time. 
    
    figure;
    set(gcf, 'position', [200,250,1000,300])
    plot(SIT.dn, SIV, 'linewidth', 1.1, 'color', [0.3,0.7,0.6])
    title([zones2{ii},' Sea Ice Volume']);
    ylabel('Sea Ice Volume [km^3]');
    xticks(sampdn);
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(25)
    xlim([729650, 738238]);
    grid on
    
    print(['ICE/ICETHICKNESS/Figures/zones/',zones{ii},'/SeaIceVolume.png'], '-dpng', '-r500');
    
    SIT.SIV = SIV;
    asiv(ii,:) = SIV; % save all zones to sum offshore SIV later.
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/',zones{ii},'.mat'], 'SIT', '-v7.3');
    
    clear AH SIV SIT
    
end



%%
% Jacob Arnold
% 27-Jan-2022
% Calculate SIV on original timescale (before interpolation)


sampdv(:,1) = [1997:2022];
sampdv(:,2:3) = 1;
sampdn = datenum(sampdv);

for ii = 1:18
    if ii<10
        sector = ['0',num2str(ii)]
    else
        sector = num2str(ii)
    end
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
    
    AH = (SIT.H./1000).*3.125; % mXn of area times SIT in km^3

    SIV = sum(AH, 1,'omitnan'); % Sum all grid cell AHs to get total sector volume at that time. 
    
    figure;
    set(gcf, 'position', [200,250,1000,300])
    plot(SIT.dn, SIV, 'linewidth', 1.1, 'color', [0.3,0.7,0.6])
    title(['Sector ',sector,' Sea Ice Volume']);
    ylabel('Sea Ice Volume [km^3]');
    xticks(sampdn);
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(25)
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    grid on
    
    print(['ICE/ICETHICKNESS/Figures/orig_timescale/sector',sector,'_SIVb4interp.png'], '-dpng', '-r500');
    
    SIT.SIV = SIV;
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
    
    clear AH SIV SIT
    
end

















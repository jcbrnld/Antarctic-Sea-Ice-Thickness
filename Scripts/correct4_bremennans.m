% Jacob Arnold

% 17-Jan-2022

% Apply an ice shelf edge correction to SIT data using grid points that are
% NaN > 90% of the time in the Bremen AMSRe and AMSR2 data. 

% 1. load in SIC and SIT data
% 2. Grab only AMSRe and AMSR2 data
% 3. Find indices of grid points that are nan > .9
% 4. Make those indices nan for all variables in SIT


for ii = 1:18
    if ii <10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    disp(['Beginning Sector ',sector,'...'])
    
    % 1. 
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup17jan22/sector',sector,'.mat']);

    load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);

    dn = SIC.dn;
    dv = SIC.dv;
    SICcorr2 = SIC.sic;


    %%% 2.
    % Find only AMSRe and AMSR2 years

    % AMSRe --> start 2002-06-01
    %       --> end   2011-09-30

    % AMSR2 --> start 2012-07-02
    %       --> end   end of data file

    start1 = datenum(2002, 06, 01);
    end1 = datenum(2011, 09, 30);
    start2 = datenum(2012, 07, 02);

    amsrinds = find((dn >= start1 & dn <= end1) | dn >= start2); 

    amsrSIC = SICcorr2(:,amsrinds);


    %%% 3. 

    rmlocs = find(sum(isnan(amsrSIC),2)./length(amsrSIC(1,:)) == 1);

    [londom, latdom] = sectordomain(str2double(sector));
    dots = sectordotsize(str2double(sector));

    m_basemap('a', londom, latdom);
    sectorexpand(str2double(sector));
    scat1 = m_scatter(SIT.lon, SIT.lat, dots, [0.7,0.7,0.7], 'filled');
    scat2 = m_scatter(SIT.lon(rmlocs), SIT.lat(rmlocs), dots, 'm', 'filled');
    legend([scat1,scat2], ['Sector ',sector,' Grid'], 'Always NaN in Bremen SIC', 'fontsize', 13);
    xlabel(['Sector ',sector]);

    print(['ICE/ICETHICKNESS/Figures/Diagnostic/BremenAMSRnan_correction/sector',sector,'_alwaysnan.png'], '-dpng', '-r400');


    %%% 4. 

    % save old H
    SIT.H_noIceShelfCorr = SIT.H;
    SIT.iceShelfCorr = rmlocs;
    SIT.H(rmlocs,:) = nan; % just apply to H for now. 

    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');



    %%% 5. Timeseries comparison
    newSIT = SIT; clear SIT

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors_b4CTnanfill/sector',sector,'.mat']);
    oldSIT = SIT; clear SIT


    ticker = unique(newSIT.dv(:,1));
    ticker(end+1) = 2022;
    ticker(:,2:3) = 1;
    ticker = datenum(ticker);

    figure
    plot_dim(1000,300)
    plot(oldSIT.dn, (sum(isnan(oldSIT.H))./length(oldSIT.lon)).*100, 'linewidth', 1.3, 'color', [0.4,0.7,0.9]);
    hold on
    plot(newSIT.dn, (sum(isnan(newSIT.H_noIceShelfCorr))./length(newSIT.lon)).*100, 'linewidth', 1.3, 'color', [0.4,0.8,0.6]);
    plot(newSIT.dn, (sum(isnan(newSIT.H))./length(newSIT.lon)).*100, 'linewidth', 1.3,'color', [0.9,0.5,0.6]);
    xticks(ticker);
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(25);
    grid on
    xlim([min(newSIT.dn)-50, max(newSIT.dn)+50]);
    ylim([0,70]);
    ylabel('% of grid cells with NaN')
    legend('Original SIT', 'SIT With SIC correction', 'SIT AMSR NaN Correction');
    title(['Sector ',sector,' percent NaN']);

    print(['ICE/ICETHICKNESS/Figures/Diagnostic/BremenAMSRnan_correction/sector',sector,'_pernancompare.png'], '-dpng', '-r400');

    clearvars
end





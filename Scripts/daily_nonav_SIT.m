% Jacob Arnold

% 03-Feb-2022

% Daily non-averaged SIT to find icebergs on new weekly timescale.

%sector = '10';

for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    
    disp(['Beginning sector ',sector,'...'])
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);

    %%%


    dn = SIT.dn;
    ddn = dn(1):dn(end);


    for ii = 1:length(ddn)
        [minval, dloc(ii)] = min(abs(dn-ddn(ii)));

    end
    % that worked
    % dloc are now the indices of dn that each value in ddn is closest to 

    % make new SIT.H which is length(SIT.lon) by length(ddn)

    nH = nan(length(SIT.lon), length(ddn));

    for ii = 1:length(ddn)
        nH(:,ii) = SIT.H(:,dloc(ii));
    end

    % nH is now daily non-averaged SIT (each day is closest obs from original timescale)

    figure;
    plot_dim(1000,300);
    plot(ddn, nanmean(nH));
    hold on
    plot(SIT.dn, nanmean(SIT.H));

    % Matches


    %%% now find H on mondays weekly dn
    lastdate = datenum(2021,12,30); % is a thursday
    newdn = [729690:7:lastdate]'; % This is a weekly dn made entirely from Mondays

    for ii = 1:length(newdn)
        newind(ii) = find(ddn==newdn(ii));

    end

    newH = nH(:,newind); % This is non-interpolated H on same weekly timescale as interpolation

    %%% now we need cell array of nan indices for newH

    for ii = 1:length(newH(1,:))
        nanind{ii} = find(isnan(newH(:,ii)));

    end


    % nanind SHOWS WHERE ICEBERGS (and other nans) SHOULD BE IN INTERPOLATED DATASET

    tSIT.dailyH = nH;
    tSIT.weekH = newH;
    tSIT.dailydn = ddn;
    tSIT.weekdn = newdn;
    tSIT.nanind = nanind;
    tSIT.comment = {'These are non-interpolated H on daily and uniform weekly (mondays) timescales',...
        'dailyH is daily timeseries of H from nearest H from original timescale',...
        'weekH is weekly (mondays) from nearest H from original timescale'...
        'nanind is nan values for each week from weekH. These are to be used to back fill icebergs after temporal interpolation to weekly timescale'};

    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/dayweek_nointerp/sector',sector,'_nointerp.mat'], 'tSIT','-v7.3');
    
    ticker = (1997:2022)';
    ticker(:,2:3) = 1; 
    ticker = datenum(ticker);
    figure;
    plot_dim(1000,300);
    plot(SIT.dn, nanmean(SIT.H));
    hold on
    plot(tSIT.dailydn, nanmean(tSIT.dailyH));
    plot(tSIT.weekdn, nanmean(tSIT.weekH));
    xticks(ticker);
    datetick('x','mm-yyyy', 'keepticks');
    xtickangle(25)
    grid on
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    legend('Original', 'Daily', 'Weekly');
    title(['Sector ',sector,': SIT daily/weekly nointerp check']);
    ylabel('Sea Ice Thickness [m]');
    print(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/dayweek_nointerp/test_plots/sector',sector,'_compare.png'], '-dpng', '-r300');
    
    clearvars
end

%% Now for the zones
zones = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};
for ss = 1:6
    
    sector = zones{ss};
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Zones/',sector,'.mat']);

    %%%

    dn = SIT.dn;
    ddn = dn(1):dn(end); % Create daily dn


    for ii = 1:length(ddn)
        [minval, dloc(ii)] = min(abs(dn-ddn(ii)));

    end
    % dloc are now the indices of dn that each value in ddn is closest to
    % (should be same size as ddn)

    % make new SIT.H which is length(SIT.lon) by length(ddn)

    nH = nan(length(SIT.lon), length(ddn));

    for ii = 1:length(ddn)
        nH(:,ii) = SIT.H(:,dloc(ii));
    end

    % nH is now daily non-averaged SIT (each day is closest obs from original timescale)

    %%% now find H on mondays weekly dn
    lastdate = datenum(2021,12,30); % is a thursday
    newdn = [729690:7:lastdate]'; % This is a weekly dn made entirely from Mondays

    for ii = 1:length(newdn)
        newind(ii) = find(ddn==newdn(ii));

    end

    newH = nH(:,newind); % This is non-interpolated H on same weekly timescale as interpolation

    %%% now we need cell array of nan indices for newH

    for ii = 1:length(newH(1,:))
        nanind{ii} = find(isnan(newH(:,ii)));

    end


    % nanind SHOWS WHERE ICEBERGS (and other nans) SHOULD BE IN INTERPOLATED DATASET

    tSIT.dailyH = nH;
    tSIT.weekH = newH;
    tSIT.dailydn = ddn;
    tSIT.weekdn = newdn;
    tSIT.nanind = nanind;
    tSIT.comment = {'These are non-interpolated H on daily and uniform weekly (mondays) timescales',...
        'dailyH is daily timeseries of H from nearest H from original timescale',...
        'weekH is weekly (mondays) from nearest H from original timescale'...
        'nanind is nan values for each week from weekH. These are to be used to back fill icebergs after temporal interpolation to weekly timescale'};

    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/dayweek_nointerp/',sector,'_nointerp.mat'], 'tSIT','-v7.3');
    
    ticker = (1997:2022)';
    ticker(:,2:3) = 1; 
    ticker = datenum(ticker);
    figure;
    plot_dim(1000,300);
    plot(SIT.dn, nanmean(SIT.H));
    hold on
    plot(tSIT.dailydn, nanmean(tSIT.dailyH));
    plot(tSIT.weekdn, nanmean(tSIT.weekH));
    xticks(ticker);
    datetick('x','mm-yyyy', 'keepticks');
    xtickangle(25)
    grid on
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    legend('Original', 'Daily', 'Weekly');
    title(['Sector ',sector,': SIT daily/weekly nointerp check']);
    ylabel('Sea Ice Thickness [m]');
    print(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/dayweek_nointerp/test_plots/sector',sector,'_compare.png'], '-dpng', '-r300');
    
    clearvars -except zones
end



%% 
% Three options 
% --> interpolate the nanvals and refill, then back-fill with nanind:
        % >> nanH = isnan(H(ii,:)); % by time
        % >> t = 1:length(H(1,:));
        % >> fH = H;
        % >> fH(ii,nanH) = interp1(t(~nanH), H(ii,~nanH), t(nanH));

% --> fill nans useing inpaint_nans then back-fill with nanind 
        % >> fH(ii,:) = inpaint_nans(H(ii,:),4); % MUST specify 4 for closest to traditional linear method. 
                                                % otherwise uses plate metaphor solving series of linear equations to fill nans

% --> reinterpolate while ignoring nans then refill
        % >> % similar to 1 but rerun entire enterpolation 
        % >> % should produce same result but take much longer
        
        
        







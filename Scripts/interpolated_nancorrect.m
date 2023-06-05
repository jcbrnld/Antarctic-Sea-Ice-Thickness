% Jacob Arnold

% 03-Feb-2022

% Interpolate over nans in interpolated SIT data 
% Then backfill nans from tSIT files



% Test method
t1 = rand(10,1);
t1 = t1.*100;
t1([3 7 8 ]) = nan;

t1nan = isnan(t1);
x = find(t1nan==0);
vq = find(t1nan==1);

t2 = interp1(x, t1(~t1nan), vq)'; % find interp values for those nans

t1(vq) = t2; % Fill those nans

outp = [t1,t2];
disp(outp)

%% Now for the real data

for ss = 2:4
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    %sector = '10';
    disp(['beginning sector ',sector])
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);

    for ii = 1:length(SIT.lon)

        dummyH = SIT.H(ii,:);

        Hnan = isnan(dummyH);

        oldsize = find(Hnan==0);
        nsize = find(Hnan==1);
        if length(oldsize)<100;
            newH(ii,:) = dummyH;
            continue
        elseif length(oldsize) == length(Hnan);
            newH(ii,:) = dummyH;
            continue
        end

        finsize = SIT.dn(oldsize);
        nansize = SIT.dn(nsize);

        nanH = interp1(finsize, dummyH(oldsize), nansize); % Find interpolated values for nans

        dummyH(nsize) = nanH; % fill nans

        newH(ii,:) = dummyH; 

        clear dummyH nanH oldsize finsize nansize Hnan

    end


    nano = (sum(isnan(SIT.H),1)./length(SIT.lon)).*100;
    nann = (sum(isnan(newH),1)./length(SIT.lon)).*100;
    ticker = (1997:2022)';
    ticker(:,2:3) = 1; 
    ticker = datenum(ticker);
    figure;
    plot_dim(1000,300);
    plot(SIT.dn, nano);
    hold on
    plot(SIT.dn, nann);
    xticks(ticker);
    datetick('x','mm-yyyy', 'keepticks');
    xtickangle(25)
    grid on
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    legend('before', 'after');
    title(['Sector ',sector,': naninterp b4 iceberg refill']);
    ylabel('% NaN');
    print(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/dayweek_nointerp/test_plots/sector',sector,'_nansb4refill.png'], '-dpng', '-r300');


    %%% Sweet now replace at each week with the correct nans. 

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/dayweek_nointerp/b4_ratiocorrect/sector',sector,'_nointerp.mat']);

    nanind = tSIT.nanind;

    if length(nanind) ~= length(newH(1,:));
        error('nanind and newH lengths do not match')
    end
    for ii = 1:length(nanind)

        newH(nanind{ii},ii) = nan;

    end



    nano = (sum(isnan(SIT.H),1)./length(SIT.lon)).*100;
    nann = (sum(isnan(newH),1)./length(SIT.lon)).*100;
    ticker = (1997:2022)';
    ticker(:,2:3) = 1; 
    ticker = datenum(ticker);
    figure;
    plot_dim(1000,300);
    plot(SIT.dn, nano);
    hold on
    plot(SIT.dn, nann);
    xticks(ticker);
    datetick('x','mm-yyyy', 'keepticks');
    xtickangle(25)
    grid on
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    legend('before', 'after');
    title(['Sector ',sector,': naninterp after iceberg refill']);
    ylabel('% NaN');
    print(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/dayweek_nointerp/test_plots/sector',sector,'_nansafterrefill.png'], '-dpng', '-r300');

    SIT.H = newH;
    
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');

    clearvars
    
end



%% And the Zones
% 

zones = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};

for ss = 1:6
    sector = zones{ss};
    
    disp(['beginning zone ',sector])
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/backup25_feb_22/',sector,'.mat']);

    for ii = 1:length(SIT.lon)

        dummyH = SIT.H(ii,:);

        Hnan = isnan(dummyH);

        oldsize = find(Hnan==0);
        nsize = find(Hnan==1);
        if length(oldsize)<100;
            newH(ii,:) = dummyH;
            continue
        elseif length(oldsize) == length(Hnan);
            newH(ii,:) = dummyH;
            continue
        end

        finsize = SIT.dn(oldsize);
        nansize = SIT.dn(nsize);

        nanH = interp1(finsize, dummyH(oldsize), nansize); % Find interpolated values for nans

        dummyH(nsize) = nanH; % fill nans

        newH(ii,:) = dummyH; 

        clear dummyH nanH oldsize finsize nansize Hnan

    end


    nano = (sum(isnan(SIT.H),1)./length(SIT.lon)).*100;
    nann = (sum(isnan(newH),1)./length(SIT.lon)).*100;
    ticker = (1997:2022)';
    ticker(:,2:3) = 1; 
    ticker = datenum(ticker);
    figure;
    plot_dim(1000,300);
    plot(SIT.dn, nano);
    hold on
    plot(SIT.dn, nann);
    xticks(ticker);
    datetick('x','mm-yyyy', 'keepticks');
    xtickangle(25)
    grid on
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    ylim([0,10]);
    legend('before', 'after');
    title(['Zone ',sector,': naninterp b4 iceberg refill']);
    ylabel('% NaN');
    print(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/dayweek_nointerp/test_plots/',sector,'_nansb4refill.png'], '-dpng', '-r300');


    %%% Sweet now replace at each week with the correct nans. 

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/dayweek_nointerp/b4_ratiocorrect/',sector,'_nointerp.mat']);

    nanind = tSIT.nanind;

    if length(nanind) ~= length(newH(1,:));
        error('nanind and newH lengths do not match')
    end
    for ii = 1:length(nanind)

        newH(nanind{ii},ii) = nan;

    end



    nano = (sum(isnan(SIT.H),1)./length(SIT.lon)).*100;
    nann = (sum(isnan(newH),1)./length(SIT.lon)).*100;
    ticker = (1997:2022)';
    ticker(:,2:3) = 1; 
    ticker = datenum(ticker);
    figure;
    plot_dim(1000,300);
    plot(SIT.dn, nano);
    hold on
    plot(SIT.dn, nann);
    xticks(ticker);
    datetick('x','mm-yyyy', 'keepticks');
    xtickangle(25)
    grid on
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    ylim([0,10]);
    legend('before', 'after');
    title(['Zone ',sector,': naninterp after iceberg refill']);
    ylabel('% NaN');
    print(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/dayweek_nointerp/test_plots/',sector,'_nansafterrefill.png'], '-dpng', '-r300');

    SIT.H = newH;
    
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/',sector,'.mat'], 'SIT', '-v7.3');

    disp(['Sector ',zones{ss},' updated with correct nans'])
    
    clearvars -except zones
    
    
end
























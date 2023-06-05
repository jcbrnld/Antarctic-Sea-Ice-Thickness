% Jacob Arnold

% 24-Feb-2022

% Working with new SIT sector datasets using hybrid averaging approach
% Step 1: temporally interp to fill all nans
% Step 2: re-define nans from cleaned files
% step 3: Save as orig timescale
% step 4: Check new files for unnatural spikes and temporally interpolate
%         over those if/when necessary and resave 
% step 6: create daily noav files (use script already made) [daily_noav_SIT.m]
% step 7: interpolate to uniform weekly grid (use script already made) [temporal_interp.m]
% step 8: interpolate over nans then refill with nans from previous SIT [interpolated_nancorrect.m]
%         files (actually from previous daily nointerp files)

% ONLY steps 1:3 will be done in this script. 


% Step 1:
%sector = '10';
for ss = 17:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    disp(['beginning sector ',sector])

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/raw_hybrid/sector',sector,'_hybrid.mat']);

    %%% Step 1-3


    
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

    % step 2
    nSIT = SIT; clear SIT

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/b4_ratioCorrection/sector',sector,'.mat']);
    oSIT = SIT; clear SIT
    if length(oSIT.dn)~=length(nSIT.dn)
        if oSIT.dn(3) == 729704
            oSIT.dn(3) = [];
            oSIT.H(:,3) = [];
        end
    end

    cnans = isnan(oSIT.H);

    newH(cnans) = nan;
    ticker = dnticker(1997,2022);
    figure; plot_dim(1200,200)
    plot(nSIT.dn, (sum(isnan(nSIT.H))./length(nSIT.lon)).*100);
    hold on
    plot(nSIT.dn, (sum(isnan(newH))./length(nSIT.lon)).*100);
    legend('Before', 'After');
    xticks(ticker);
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27)
    xlim([min(nSIT.dn)-50, max(nSIT.dn)+50]);
    title(['Sector ',sector,' before and after nan correction']);
    ylabel('% NaN')
    
    drawnow
    
    
    SIT = nSIT;
    SIT.H = newH; 

    clear nSIT oSIT

    % step 3
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3')
   
    clearvars
end


%% Step 4 make movies to do this (so skip)

% MAKE movies of raw gridded data BUT ADD index next to date 
% THEN ADD BAD dates to switch board in temporal_interp and fix things

ticker = dnticker(1997,2022);
figure;
plot_dim(1200,300)
plot(SIT.dn, nanmean(SIT.H))
grid on
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27)
title(['Sector ',sector,' Mean SIT']);
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);



































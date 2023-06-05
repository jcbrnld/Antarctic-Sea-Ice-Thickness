% Jacob Arnold

% 10-Feb-2022

% Fix nans in ct_hires
allSIC = [];
for ss = 1:18
    if ss<10
        sector = ['0',num2str(ss)]
    else
        sector = num2str(ss)
    end

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/backup25feb22/sector',sector,'.mat']);


    % First interpolate to fill nans
    disp(['Beginning sector',sector,' interpolation'])
    tester = 0:500:50000;
    for ii = 1:length(SIT.lon)
        if ismember(ii, tester)
            disp(['Interpolating CT in sector ',sector,': ', num2str(ii), ' of ', num2str(length(SIT.lon))]);
        end
        dummyct = SIT.ct_hires(ii,:);
        ctnan = isnan(dummyct);

        oldsize = find(ctnan==0);
        nsize = find(ctnan==1);

        if length(oldsize)<100;
                newct(ii,:) = dummyct;
                continue
        elseif length(oldsize) == length(ctnan);
                newct(ii,:) = dummyct;
                continue
        end
        finsize = SIT.dn(oldsize);
        nansize = SIT.dn(nsize);

        nanct = interp1(finsize, dummyct(oldsize), nansize); % Find interpolated values for nans

        dummyct(nsize) = nanct; % fill nans
        newct(ii,:) = dummyct;

        clear dummyct nanct nansize finsize oldsize ctnan
    end

    % Then refill with appropriate nans from H (almost re-nans what we just
    % filled except for a few descrete cases)
    Hnans = find(isnan(SIT.H));
    newct(Hnans) = nan;

    figure;plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.lon));plot_dim(900,200);
    hold on
    plot(SIT.dn, sum(isnan(newct))./length(SIT.lon));
    legend('If you see this line something is wrong','NaN fraction');
    SIT.SIC = newct;
    allSIC = [allSIC;newct];
    
    disp(['Finished and saving sector',sector])
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
    

    clearvars -except zones allSIC

end

% now load sector 00 and give it the allSIC variable
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat']);
SIT.SIC = allSIC;

save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat'], 'SIT', '-v7.3');


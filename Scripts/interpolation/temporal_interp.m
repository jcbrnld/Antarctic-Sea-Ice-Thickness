% Jacob Arnold
% 16-Nov-2021: First written
% 01-Feb-2022: updated through end of 2021 
% Temporally inerpolate SIT to weekly timescale

% First find/create the new dn

% Sectors
for ss = 4
    if ss < 10
        sector = ['0', num2str(ss)]
    else
        sector = num2str(ss)
    end

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
    
    dummyH = SIT.H;
    dummydn = SIT.dn;

    % First dn is 729690 and is a Monday
    

    lastdate = datenum(2021,12,30); % is a thursday
    newdn = [729690:7:lastdate]'; % This is a weekly dn made entirely from Mondays


    % remove bad H dates before interp
    switch sector
        case {'01'}
            rmvals = [8, 21, 28, 143, 179, 283, 284, 310]; 
        case {'02'}
            rmvals = [121, 143, 179, 245, 263];
        case {'03'}
            rmvals =  [174, 534];
        case {'05'}
            rmvals = [2, 4];
        case {'06'}
            rmvals = [103, 110, 186];
        case {'08'}
            rmvals = [2,4];
        case {'09'}
            rmvals = [2,4];
        case {'10'}
            rmvals = [2, 4, 279];
        case {'11'}
            rmvals = [2,4];
        case {'13'}
            rmvals = [2, 4, 5, 7, 20, 23, 36, 128];
        case {'15'} 
            rmvals =  [2, 4, 5, 161];
        case {'16'}
            rmvals = [2, 4, 5, 46, 310];
        case {'17'}
            rmvals = [283, 284];
        case {'18'}
            rmvals = [270, 476];
        otherwise
            rmvals = [];
    end
    dummyH(:,rmvals) = [];
    dummydn(rmvals) = [];
    
    tester = 0:100:1000000;
    for ii = 1:length(SIT.H(:,1))
        if ismember(ii, tester)
            disp(['Interpolating Sector ',sector,' Grid Point # ', num2str(ii), ' of ', num2str(length(SIT.lon))]);
        end
        newH(ii,:) = interp1(dummydn, dummyH(ii,:), newdn);
        newsa(ii,:) = interp1(SIT.dn, SIT.sa(ii,:), newdn);
        newsb(ii,:) = interp1(SIT.dn, SIT.sb(ii,:), newdn);
        newsc(ii,:) = interp1(SIT.dn, SIT.sc(ii,:), newdn);
        newsd(ii,:) = interp1(SIT.dn, SIT.sd(ii,:), newdn);
        newca(ii,:) = interp1(SIT.dn, SIT.ca(ii,:), newdn);
        newcb(ii,:) = interp1(SIT.dn, SIT.cb(ii,:), newdn);
        newcc(ii,:) = interp1(SIT.dn, SIT.cc(ii,:), newdn);
        newcd(ii,:) = interp1(SIT.dn, SIT.cd(ii,:), newdn);
        newct(ii,:) = interp1(SIT.dn, SIT.ct(ii,:), newdn);
        newct_hires(ii,:) = interp1(SIT.dn, SIT.ct_hires(ii,:), newdn);
        newicebergs(ii,:) = interp1(SIT.dn, SIT.icebergs(ii,:), newdn); % Icebergs correction must have already been run.

    end

     figure;
     set(gcf, 'position', [200,200,1200,350]);
     plot(SIT.dn, nanmean(SIT.H))
     hold on
     plot(newdn, nanmean(newH));
    legend('Old SIT', 'New SIT');
    datetick('x', 'mm-yyyy');
    title(['Sector ',sector,' SIT at original dates and uniform weekly']);
    ylabel('Sea Ice Thickness [m]');
    %print(['ICE/ICETHICKNESS/Figures/Temporal_interp/sector',sector,'.png'], '-dpng', '-r400');

    close

    OS = SIT; clear SIT;

    SIT.H = newH;
    SIT.dn = newdn;
    SIT.dv = datevec(newdn);
    SIT.lon = OS.lon;
    SIT.lat = OS.lat;
    SIT.sa = newsa;
    SIT.sb = newsb;
    SIT.sc = newsc;
    SIT.sd = newsd;
    SIT.ca = newca;
    SIT.cb = newcb;
    SIT.cc = newcc;
    SIT.cd = newcd;
    SIT.ct = newct;
    SIT.ct_hires = newct_hires;
    SIT.icebergs = newicebergs;

      
    
    SIT.comment = {'Only H (thickness), icebergs, and partials (Ca-d, Ct, ct_hires, Sa-d) have been temporally interpolated. See data files under research/ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors for all other variables such as error mavg, etc.'};
    
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
    
    clearvars 


    
end




%% Zones
zones = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};

for ss = 1:6
    sector = zones{ss}

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones/',sector,'.mat']);


    % First dn is 729690 and is a Monday
    lastdate = datenum(2021,12,30); % is a thursday
    newdn = [729690:7:lastdate]'; % This is a weekly dn made entirely from Mondays

    rep = find(diff(SIT.dn)==0); % Remove that duplicate date if it exists
    if ~isempty(rep)
        
        if rep ~= 305
            warning('Different Duplicate Date');
            pause
        end
        % indices 305 and 306 have same dn

        dupav = nanmean(SIT.H(:,305:306), 2);
        SIT.H(:,305) = dupav;
        SIT.H(:,306) = [];
        SIT.dn(306) = [];
        SIT.dv(306,:) = [];
    else
        disp('No duplicate dates to worry about');
    end

    %create icebergs index out of cell
    if iscell(SIT.icebergs)
        oldbergstyle = SIT.icebergs;
        icebergs = zeros(size(SIT.H));
        for ii = 1:length(oldbergstyle)
            bergpoints = oldbergstyle{ii}-((ii-1)*length(SIT.lon));% Convert indices to represent each column
            if isempty(bergpoints)
                continue
            else
                icebergs(:,bergpoints) = 1;
            end
            clear bergpoints
        end
        SIT.icebergs = icebergs;
    end
    
    

    tester = 0:100:1000000;
    for ii = 1:length(SIT.H(:,1))
        if ismember(ii, tester)
            disp(['Interpolating Sector ',sector,' Grid Point # ', num2str(ii), ' of ', num2str(length(SIT.lon))]);
        end
        newH(ii,:) = interp1(SIT.dn, SIT.H(ii,:), newdn);
        newsa(ii,:) = interp1(SIT.dn, SIT.sa(ii,:), newdn);
        newsb(ii,:) = interp1(SIT.dn, SIT.sb(ii,:), newdn);
        newsc(ii,:) = interp1(SIT.dn, SIT.sc(ii,:), newdn);
        newsd(ii,:) = interp1(SIT.dn, SIT.sd(ii,:), newdn);
        newca(ii,:) = interp1(SIT.dn, SIT.ca(ii,:), newdn);
        newcb(ii,:) = interp1(SIT.dn, SIT.cb(ii,:), newdn);
        newcc(ii,:) = interp1(SIT.dn, SIT.cc(ii,:), newdn);
        newcd(ii,:) = interp1(SIT.dn, SIT.cd(ii,:), newdn);
        newct(ii,:) = interp1(SIT.dn, SIT.ct(ii,:), newdn);
        newct_hires(ii,:) = interp1(SIT.dn, SIT.ct_hires(ii,:), newdn);
        newicebergs(ii,:) = interp1(SIT.dn, SIT.icebergs(ii,:), newdn); % Icebergs correction must have already been run.


    end

     figure;
     set(gcf, 'position', [200,200,1200,350]);
     plot(SIT.dn, nanmean(SIT.H))
     hold on
     plot(newdn, nanmean(newH));
    legend('Old SIT', 'New SIT');
    datetick('x', 'mm-yyyy');
    title(['Sector ',sector,' SIT at original dates and uniform weekly']);
    ylabel('Sea Ice Thickness [m]');
    print(['ICE/ICETHICKNESS/Figures/Temporal_interp/',sector,'.png'], '-dpng', '-r400');

    close

    OS = SIT; clear SIT;

    SIT.H = newH;
    SIT.dn = newdn;
    SIT.dv = datevec(newdn);
    SIT.lon = OS.lon;
    SIT.lat = OS.lat;
    SIT.sa = newsa;
    SIT.sb = newsb;
    SIT.sc = newsc;
    SIT.sd = newsd;
    SIT.ca = newca;
    SIT.cb = newcb;
    SIT.cc = newcc;
    SIT.cd = newcd;
    SIT.ct = newct;
    SIT.ct_hires = newct_hires;
    SIT.icebergs = newicebergs;

    SIT.comment = {'Only H (thickness), icebergs, and partials (Ca-d, Ct, ct_hires, Sa-d) have been temporally interpolated. See data files under research/ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors for all other variables such as error mavg, etc.'};
    
    
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/zones/',sector,'.mat'], 'SIT');

    clear SIT OS newH dupav 

    
end












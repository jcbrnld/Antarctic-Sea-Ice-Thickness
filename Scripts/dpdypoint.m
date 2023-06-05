% Jacob Arnold

% 03_mar_2022

% try dpdy at specific point at north and south edge of sector

sector = '10';

 disp(['Beginning sector ',sector,'...']);
    data = load(['/Volumes/Data/Research/ECMWF/matfiles/segment',sector,'.mat']);
    data2 = struct2cell(data);
    ecmwf = data2{1,1};
    clear data data2

    if length(ecmwf.dv(1,:))>6
        ecmwf.dv = ecmwf.dv';
    end
    
    % fix date formatting issues with ecmfw data
    if length(ecmwf.dv(1,:))>3
        if sum(ecmwf.dv(:,4))~=0
            ecmwf.dv(:,4)=0;
            ecmwf.dn = datenum(ecmwf.dv);
        end
    end
    %%%
    
    % s10
    s = find(ecmwf.lat(:) == -67 & ecmwf.lon(:) == 118);
    n = find(ecmwf.lat(:) == -65 & ecmwf.lon(:) == 118);

    % check location
    m_basemap('m', double([ecmwf.lon(1,1)-0.5, ecmwf.lon(end,1)+0.5]), double([ecmwf.lat(1,end)-0.25, ecmwf.lat(1,1)+0.25]));
    m_scatter(seaice.lon, seaice.lat, sectordotsize(str2num(sector)), 'filled', 'markerfacecolor', [0.7,0.7,0.7])
    m_scatter(ecmwf.lon(s), ecmwf.lat(s), 500, 's', 'filled')
    m_scatter(ecmwf.lon(n), ecmwf.lat(n), 500, 's', 'filled')
    
    
    for ii = 1:length(ecmwf.dn)
        sp = ecmwf.sp(:,:,ii);
        sp = sp(:);
        nor(ii) = sp(n);
        sou(ii) = sp(s);
    
        pdy(ii) = nor(ii)-sou(ii);
        
    end
    % remove extreme outliers
    stdpdy = std(pdy);
    pdy(pdy>=nanmean(pdy)+stdpdy*3) = nan;
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);
    
    meanu = nanmean(ecmwf.u10);
emptydn = [];
    emptytracker = 0; case1tracker = 0; case2tracker = 0;
    for ii = 1:length(seaice.dn)
        loc = find(ecmwf.dn==seaice.dn(ii));
        if ~isempty(loc);
            if ecmwf.dn(loc)+3 > ecmwf.dn(end)
                case1tracker = case1tracker+1;
                mypdy(ii) = nanmean(pdy(loc-3:end));
            else
                case2tracker = case2tracker+1;
                mypdy(ii) = nanmean(pdy(loc-3:loc+3));

            end
        else
            mypdy(ii) = nan;
        end
        
        clear loc
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
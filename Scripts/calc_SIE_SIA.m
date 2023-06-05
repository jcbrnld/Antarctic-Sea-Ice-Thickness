% Jacob Arnold

% 07-Dec-2021

% Calculate SIE and SIA for all sectors (00-18) and zones 

% Sea Ice Extent (SIE) is the number of grid points with at least 15% SIC
% times grid point area.

% Sea Ice Area (SIA) is the sum of grid point areas multiplied by their SIC


% SIE and SIA comes from SIC data
% Plot SIT, SIT, and SIV timeseries

data = load('ICE/Concentration/ant-sectors/sector10.mat');
data2 = struct2cell(data);
SIC = data2{1,1}; clear data data2

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector10.mat


% SIE first 
% Daily
for ii = 1:length(SIC.sic(1,:));
    
    num15 = sum(SIC.sic(:,ii)>15);
    SIE(ii) = num15*3.125;
    
end


% Weekly
% for ii = 1:length(SIC.week.sic(1,:));
%     
%     num15 = sum(SIC.week.sic(:,ii)>15);
%     SIE(ii) = num15*3.125;
%     
% end

% Looks like a fair amount of bad data in both. Need to create index of bad
% days/weeks and interpolate over them. 




% SIA next
SIA = sum(SIC.sic.*3.125, 'omitnan');

figure
plot_dim(1000,400)
subplot(2,1,1)
plot(double(SIC.dn), SIA)
datetick('x', 'mm-yyyy');
xtickangle(25)

% Some difference between older data and Bremen data (at 2002)
% Maybe from a difference in number of nans? 

subplot(2,1,2)
plot(double(SIC.dn), sum(isnan(SIC.sic)))
datetick('x', 'mm-yyyy');
xtickangle(25)

% Need to find these typical nans for older data and use the inverse of
% that index to calc SIA over similar area.

%% Maybe find grid points that are nan more than 50% of the time. 

mostnan = find(sum(isnan(SIC.sic),2)/length(SIC.sic(1,:)) > 0.30);
mostnan2 = sum(isnan(SIC.sic),2)/length(SIC.sic(1,:)) > 0.30;
tempind = 1-mostnan2;
goodind = find(tempind==1); % perfect this works. 

%
[londom latdom] = sectordomain(10);
m_basemap('a', londom, latdom)
plot_dim(1200,800)
m_scatter(SIC.lon, SIC.lat,30, 'filled');
m_scatter(SIC.lon(mostnan), SIT.lat(mostnan), 40, 'filled');

% Looks like it misses much polynya area along the coast and DIT

m_basemap('a', londom, latdom)
plot_dim(1200,800)
m_scatter(SIC.lon, SIC.lat, 30, SIC.sic(:,1700), 'filled')

%%


SIA2 = sum(SIC.sic(goodind,:).*3.125, 'omitnan');

figure;
plot_dim(1200,400)
plot(SIC.dn, SIA2)



%% Now for all  sectors 



for ii = 1:18
    if ii<10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    disp(['Working on Sector ', sector,' now...'])
    
    data = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    data2 = struct2cell(data);
    SIC = data2{1,1}; clear data data2

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);    
    
    mostnan = sum(isnan(SIC.sic),2)/length(SIC.sic(1,:)) > 0.30; % find grid points that are nan more than 30% of the time
    tempind = 1-mostnan;
    goodind = find(tempind==1); % perfect this works. 

    % SIC at grid points from goodind
    sicg = SIC.sic(goodind,:);

    num15 = sum(sicg > 15);
    tSIE = num15.*3.125;
    
    SIA{ii+1} = sum((sicg./100).*3.125, 'omitnan');
    SIE{ii+1} = tSIE;
    
    %siaind = find(SIA{ii+1}<100000; % remove bad data
    %tempSIA = SIA{ii+1};
    %tempSIA(siaind) = nan;

    figure;
    plot_dim(1200,800)
    subplot(2,1,1)
    plot(double(SIC.dn), SIA{ii+1}, 'linewidth', 1.2);
    datetick('x', 'mm-yyyy');
    xtickangle(25);
    grid on
    title(['Sector ',sector,' Sea Ice Area']); 
    ylabel('Sea Ice Area [km^2]');
    xlim([SIC.dn(1)-50, SIC.dn(end)+50]);
    %ylim([0,800000])
    
    
    subplot(2,1,2)
    plot(double(SIC.dn), SIE{ii+1}, 'linewidth', 1.2);
    datetick('x', 'mm-yyyy');
    xtickangle(25);
    grid on
    title(['Sector ',sector,' Sea Ice Extent']); 
    ylabel('Sea Ice Extent [km^2]');
    xlim([SIC.dn(1)-50, SIC.dn(end)+50]);
    %ylim([0,900000])
    print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/SIA_SIE_noqc.png'], '-dpng', '-r500');

    lon{ii+1} = SIT.lon(goodind);
    lat{ii+1} = SIT.lat(goodind);
    
    
    [londom, latdom] = sectordomain(str2num(sector));
    m_basemap('a', londom, latdom)
    plot_dim(1000,900);
    m_scatter(SIT.lon, SIT.lat, 20, 'filled') % entirely behind the others
    l1 = m_scatter(SIC.lon(mostnan), SIT.lat(mostnan), 20, 'filled');
    l2 = m_scatter(SIC.lon(goodind), SIC.lat(goodind), 20, 'filled');
    xlabel(['Sector ',sector], 'fontweight', 'bold');
    legend([l1,l2], 'NAN > 30% of the time', 'NAN < 30% of the time');
    print(['ICE/ICETHICKNESS/Figures/Sectors/Sector',sector,'/oldvsnewSICgridpoints.png'], '-dpng', '-r500');


    clear mostnan tempind goodind sicg SIC SIT londom latdom
    
    drawnow
    
end


























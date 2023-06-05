% Jacob Arnold

% 03-Dec-2021

% Find where repeat grid points are located in the SIT data


for ii = 1:17
    if ii<9
        sector1 = ['0',num2str(ii)];
        sector2 = ['0',num2str(ii+1)];
    elseif ii==9
        sector1 = ['0',num2str(ii)];
        sector2 = num2str(ii+1);
    else
        sector1 = num2str(ii);
        sector2 = num2str(ii+1);
    end
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector1,'.mat']);
    SIT1 = SIT; clear SIT
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector2,'.mat']);
    SIT2 = SIT; clear SIT
    
    
    g1 = [SIT1.lon, SIT1.lat];
    g2 = [SIT2.lon, SIT2.lat];
    
    [C{ii}, I1{ii},I2{ii}] = intersect(g1,g2,'rows');
    
    if ~isempty(C{ii})
        disp(['Grids ',sector1,' and ',sector2,' share ',num2str(length(I1{ii})),' grid points'])
    end
    
    lon{ii} = SIT1.lon;
    lon{ii+1} = SIT2.lon;
    lat{ii} = SIT1.lat;
    lat{ii+1} = SIT2.lat;
    
    
    clear SIT1 SIT2 g1 g2
    
end
    


% NO TWO GRIDS share any grid points 


%%



% Now look at each sector individually and find where the repeats occur



for ii = 1:18
    if ii<10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    lonlat = [SIT.lon,SIT.lat];
    numrep = length(SIT.lon)-length(unique(lonlat, 'rows'));
    
   
    disp(['Sector ',sector,' has ', num2str(numrep),' reapeated grid points'])
    
    
    lon{ii} = SIT.lon;
    lat{ii} = SIT.lat;
    
    clear SIT numrep lonlat
    
end

% output:
% Sector 01 has 0 reapeated grid points
% Sector 02 has 0 reapeated grid points
% Sector 03 has 0 reapeated grid points
% Sector 04 has 0 reapeated grid points
% Sector 05 has 0 reapeated grid points
% Sector 06 has 0 reapeated grid points
% Sector 07 has 0 reapeated grid points
% Sector 08 has 2 reapeated grid points
% Sector 09 has 0 reapeated grid points
% Sector 10 has 0 reapeated grid points
% Sector 11 has 0 reapeated grid points
% Sector 12 has 0 reapeated grid points
% Sector 13 has 6 reapeated grid points
% Sector 14 has 0 reapeated grid points
% Sector 15 has 1 reapeated grid points
% Sector 16 has 0 reapeated grid points
% Sector 17 has 0 reapeated grid points
% Sector 18 has 0 reapeated grid points


%% 

% Find where in sectors 08, 13, and 15 those repeats are found
% Also need to check if polys have an repeats

snums = [8,13,15];
for ss = 1:3
    counter = 0;
    
    for ii = 1:length(lon{snums(ss)})

        gloc = find((lon{snums(ss)} == lon{snums(ss)}(ii)) & (lat{snums(ss)} == lat{snums(ss)}(ii)));

        if length(gloc)>1
            counter = counter+1;
            reploc{counter,ss} = gloc; % columns represent sector 08,13,15 grids
        end
        clear gloc
    end

end


% Remove the repeats (second half of reported vals)
reploc(3:4,1) = {[]};
reploc(7:12,2) = {[]};
reploc(2,3) = {[]};

% These numbers are lonindex, latindex
s08rep = [reploc{1,1};reploc{2,1}]
s13rep = [reploc{1,2};reploc{2,2}; reploc{3,2}; reploc{4,2}; reploc{5,2}; reploc{6,2}];
s15rep = reploc{1,3};
% EACH PAIR are indices for the same grid point so s13rep(1) and s13rep(2)
% are indices for the same point. 


%% sector 08 plot

m_basemap('a', [84.5 100.5], [-67.5 -63.5])
plot_dim(1000,700)
m_scatter(lon{8}, lat{8},10, 'filled')
m_scatter(lon{8}(s08rep), lat{8}(s08rep), 30,'filled')
xlabel({'Sector 08','2 repeated grid points'}, 'fontsize', 16, 'fontweight', 'bold');
m_plot(sector08.week.poly.lon, sector08.week.poly.lat, 'm')
%print('ICE/ICETHICKNESS/Figures/Diagnostic/Repeat_gridpoints/sector08-2.png', '-dpng', '-r400');


%% Sector 13 plot

[londom, latdom] = sectordomain(13);
m_basemap('a', londom, latdom)
plot_dim(1000,700)
m_scatter(lon{13}, lat{13},10, 'filled')
m_scatter(lon{13}(s13rep), lat{13}(s13rep), 30,'filled')
m_plot(sector13.week.poly.lon, sector13.week.poly.lat, 'm')
xlabel({'Sector 13','6 repeated grid points'}, 'fontsize', 16, 'fontweight', 'bold');

 %print('ICE/ICETHICKNESS/Figures/Diagnostic/Repeat_gridpoints/sector13.png', '-dpng', '-r400');

%% Sector 15 plot

[londom, latdom] = sectordomain(15);
m_basemap('a', londom, latdom)
plot_dim(1000,700)
m_scatter(lon{15}, lat{15},10, 'filled')
m_scatter(lon{15}(s15rep), lat{15}(s15rep), 30,'filled')
m_plot(sector15.week.poly.lon, sector15.week.poly.lat, 'm')
xlabel({'Sector 15','1 repeated grid point'}, 'fontsize', 16, 'fontweight', 'bold');

%print('ICE/ICETHICKNESS/Figures/Diagnostic/Repeat_gridpoints/sector15-2.png', '-dpng', '-r400');




%%


% look at those grid points' data

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector13;

% the first repeat
figure
plot(SIT.H(s13rep(1),:)); 
hold on
plot(SIT.H(s13rep(2), :));

sum(abs(SIT.H(s13rep(1))-SIT.H(s13rep(2)))) % zero difference

% the second repeat
sum(abs(SIT.H(s13rep(3))-SIT.H(s13rep(4)))) % zero Difference
% third
sum(abs(SIT.H(s13rep(5))-SIT.H(s13rep(6)))) % zero difference
% fourth
sum(abs(SIT.H(s13rep(7))-SIT.H(s13rep(8)))) % zero difference

% fifth
sum(abs(SIT.H(s13rep(9))-SIT.H(s13rep(10)))) % zero difference

% sixth
sum(abs(SIT.H(s13rep(11))-SIT.H(s13rep(12)))) % zero difference



% now for sector 15
clear SIT
load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector15;

sum(abs(SIT.H(s15rep(1))-SIT.H(s15rep(2)))) % zero difference


% now sector 08
clear SIT
load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector08;

sum(~isnan(abs(SIT.H(s08rep(1))-SIT.H(s08rep(2))))) % zero difference

sum(~isnan(abs(SIT.H(s08rep(3))-SIT.H(s08rep(4))))) % zero difference

% NONE OF THE REPEATS show any difference in data values. 
% remove the repeats? 



% the indices:
% 
% s08rep =
% 
%         8671
%         8818
%         8731
%         8825
% 
% s13rep
% 
% s13rep =
% 
%            4
%        12133
%           10
%        12142
%           18
%        12151
%           29
%        12159
%           56
%        12172
%           74
%        12179
% 
% s15rep
% 
% s15rep =
% 
%         8616
%         8729
% 

%load ICE/Concentration/ant-sectors/sector15.mat
%load ICE/Concentration/ant-sectors/sector08.mat

%% Were these duplicates in original sector vectors? 

load ICE/Concentration/ant-sectors/sector13.mat
s13lonlat = [sector13.lon, sector13.lat];
length(sector13.lon)-length(unique(s13lonlat,'rows'))
% ans = 6
% In this original grid vector there were those 6 grid point repeats




%% Check original grid index

[londom, latdom] = sectordomain(13);

m_basemap('a', londom, latdom)
m_scatter(sector13.grid3p125km.lon(:), sector13.grid3p125km.lat(:));
m_scatter(sector13.grid3p125km.lon(sector13.index), sector13.grid3p125km.lat(sector13.index));


% That is the index of the original grid! 
% Try using contourf
data = nan(size(sector13.grid3p125km.lon));
data(sector13.index) = SIT.H(:,420);
m_basemap('a', londom, latdom)
plot_dim(1000,900)
m_contourf(sector13.grid3p125km.lon, sector13.grid3p125km.lat, data, 5)

% This works for contouring a sector! 
% Need to add this index to all sectors AND MUST REMOVE INDEX VALUES FOR
% REPEAT GRID POINTS WHEN THOSE GRID POINTS ARE REMOVED


alllonlat = [sector13.grid3p125km.lon(:), sector13.grid3p125km.lat(:)];
length(alllonlat(:,1))-length(unique(alllonlat, 'rows'))

% ans = 0

% So original grid had no repeats -> repeats are product of isinpoly? 



































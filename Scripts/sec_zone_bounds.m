% Jacob Arnold

% View SIT sector and zone grid boundaries


load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat

locvar(:,1) = SO_SIT.lon;
locvar(:,2) = SO_SIT.lat;

length(SO_SIT.lon)-length(unique(locvar,'rows')) % Number of repeated grid points 
% Only 12

% Create index of grid points that have been used multiple times. 
for ii = 1:length(SO_SIT.lon);
    if ii==1
        counter=0
        counter2=0
    end
    tvar = find((SO_SIT.lon == SO_SIT.lon(ii)) & (SO_SIT.lat == SO_SIT.lat(ii)));
    
    if length(tvar)==2
        counter=counter+1;
        repeatind(counter,1) = tvar(1);
        repeatind(counter,2) = tvar(2);
        
    end
    
    if length(tvar)>2
        counter2 = counter2+1;
        morethan1_ind(counter2) = ii;
    end
    clear tvar
    
end


%% plot


m_basemap('p', [0,360], [-90,-49])
plot_dim(1000,800)
m_scatter(SO_SIT.lon, SO_SIT.lat, 10);
m_scatter(SO_SIT.lon(repeatind(:,2)), SO_SIT.lat(repeatind(:,2)), 'c', 'filled')

% Interesting

% Look at the shelf specifically next? 
% Plot zone and sector boundaries on this same type plot to see if these always fall
% on edges. what about zones? 

% PLOT sector boundaries and save plots showing these closely. 
% Maybe save a structure of sector and zone boundary polygons to SO_SIT ******



%% Sector boundary polygons 

clear all

% convenient/apropriate lat and lon domains for each sector.
splot{1,1}=[289 312]; splot{1,2}=[-73 -60]; splot{2,1}=[296 337]; splot{2,2}=[-79 -70];
splot{3,1}=[332 358]; splot{3,2}=[-77 -69]; splot{4,1}=[0 26]; splot{4,2}=[-71 -68];
splot{5,1}=[24 55]; splot{5,2}=[-71 -65]; splot{6,1}=[53 69]; splot{6,2}=[-68 -65.1];
splot{7,1}=[66.5 86.5]; splot{7,2}=[-71 -64.5]; splot{8,1}=[84.5 100.5]; splot{8,2}=[-67.5 -63.5];
splot{9,1}=[99 114]; splot{9,2}=[-67.5 -63.5]; splot{10,1}=[112 123]; splot{10,2}=[-67.5 -64.5];
splot{11,1}=[120.5 135]; splot{11,2}=[-67.5 -64.2]; splot{12,1}=[132.5 151.5]; splot{12,2}=[-69.3 -64.2];
splot{13,1}=[148 174]; splot{13,2}=[-72.5 -65]; splot{14,1}=[159.5 207]; splot{14,2}=[-79.5 -69];
splot{15,1}=[200 236]; splot{15,2}=[-78 -71.9]; splot{16,1}=[232 262]; splot{16,2}=[-76.2 -69];
splot{17,1}=[258 295]; splot{17,2}=[-75 -67]; splot{18,1}=[282.5 308]; splot{18,2}=[-69 -59];

sdotsize = [8 12 10 12 10 28 13 25 26 45 28 20 12 9 16 15 9 9];
prevar = [1,0.3,1,1,1,1,0.9,0.27,0.9,0.27,0.26,1,1,0.95,1,1,1,1]; % Define the precision with which boundary needs to resolve each sector
% Load in each sector, convert to xy, use boundary to find border poly
for ii = 1:18 
    if ii < 10
        sector = ['0',num2str(ii)];
    else 
        sector = num2str(ii);
    end
    disp(['Working on: Sector ',sector])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    
    [x,y] = ll2ps(SIT.lat,SIT.lon);
    
    boundInd = boundary(double(x),double(y),prevar(ii));
    
    data = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    data2 = struct2cell(data);
    sic = data2{1,1}; clear data data2
    
    m_basemap('a', splot{ii,1}, splot{ii,2})
    plot_dim(1200,800);
    m_scatter(SIT.lon, SIT.lat, sdotsize(ii), 'filled')
    b1 = m_plot(SIT.lon(boundInd), SIT.lat(boundInd), 'm', 'linewidth', 1.3);
    b2 = m_plot(sic.week.poly.lon,sic.week.poly.lat, 'linewidth', 1.3);
    legend([b1,b2],'Poly from Boundary', 'Original Poly');
    xlabel(['Sector ',sector], 'fontsize',16,'fontweight','bold');
    
    %print(['ICE/Sectors/Shelf/Sec_boundaries/sector',sector,'.png'],'-dpng', '-r600');
    close
    % Save these features in variables to play with and plot
    Sbound{ii} = boundInd;
    Obound{ii}(:,1) = sic.week.poly.lon;
    Obound{ii}(:,2) = sic.week.poly.lat;
    sgrids{ii}(:,1) = SIT.lon;
    sgrids{ii}(:,2) = SIT.lat;
    
    clear x y boundInd SIT sic b1 b2 

end




% For sectors 3? 4? 5? 13 15 18
% even a precision of 1 is not good enough - original poly is better
% original poly doesn't always follow sector edge (see sec 14 and 17) is there a
% reason?
gridsNpolys.Sbound = Sbound;
gridsNpolys.Obound = Obound;
gridsNpolys.sgrids = sgrids;
gridsNpolys.readme = {'sgrids are the lat_lon for the shelf grids;',...
    'Sbounds are the indices of sgrids for the polys defined by boundary;',...
    'Obound are the lat_lon for the polys previously defined by hand'};

save('ICE/Sectors/Shelf/gridsNpolys.mat', 'gridsNpolys');

%%

load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat

m_basemap('p', [0,360],[-90,-60])
plot_dim(1300,1000)
m_scatter(SO_SIT.lon(SO_SIT.shelf_ind), SO_SIT.lat(SO_SIT.shelf_ind),10, 'filled','markerfacecolor',[0.6,0.6,0.6])
for ii = 1:18
    m_plot(Obound{ii}(:,1), Obound{ii}(:,2), 'linewidth', 1.3);
end


for ii = 1:17
    londom = (splot{ii,1}+splot{ii+1,1})./2;
    latdom = [min(splot{ii,2}(1), splot{ii+1,2}(1)), max(splot{ii,2}(2), splot{ii+1,2}(2))];
    
    m_basemap('a', londom, latdom);
    plot_dim(1200,900);
    m_scatter(sgrids{ii}(:,1), sgrids{ii}(:,2), 25, 'filled','markerfacecolor',[0.4,0.6,0.7])
    m_scatter(sgrids{ii+1}(:,1), sgrids{ii+1}(:,2), 25, 'filled','markerfacecolor',[0.4,0.9,0.7])
    m_plot(Obound{ii}(:,1), Obound{ii}(:,2), 'linewidth', 1.3, 'color', 'm');
    m_plot(Obound{ii+1}(:,1), Obound{ii+1}(:,2), 'linewidth', 1.3, 'color', 'm');
    print(['ICE/Sectors/Shelf/Borders/large_view/sectors_',num2str(ii),'_', num2str(ii+1),'.png'], '-dpng', '-r500');
    clear londom latdom
end


%%

 print -dpng -r500 ICE/Sectors/Shelf/Borders/s2_s3_2.png;



%%

load ICE/Sectors/Shelf/gridsNpolys.mat

londom = (splot{ii,1}+splot{ii+1,1})./2;
latdom = [min(splot{ii,2}(1), splot{ii+1,2}(1)), max(splot{ii,2}(2), splot{ii+1,2}(2))];
    
m_basemap('a',londom, latdom)
plot_dim(800,1000)
m_scatter(gridsNpolys.sgrids{3}(:,1), gridsNpolys.sgrids{3}(:,2), 25, 'filled','markerfacecolor',[0.4,0.6,0.7])
m_scatter(gridsNpolys.sgrids{2}(:,1), gridsNpolys.sgrids{2}(:,2), 25, 'filled','markerfacecolor',[0.4,0.8,0.7])
%m_plot(gridsNpolys.sgrids{3}(gridsNpolys.Sbound{3},1), gridsNpolys.sgrids{3}(gridsNpolys.Sbound{3},2),...
%     'm','linewidth', 1.3);
m_plot(gridsNpolys.Obound{3}(:,1), gridsNpolys.Obound{3}(:,2), 'm', 'linewidth', 1.3);
m_plot(gridsNpolys.sgrids{2}(gridsNpolys.Sbound{2},1), gridsNpolys.sgrids{2}(gridsNpolys.Sbound{2},2),...
     'm', 'linewidth', 1.3);











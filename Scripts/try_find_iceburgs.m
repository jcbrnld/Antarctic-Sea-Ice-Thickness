% 08-June-2021

% Jacob Arnold

% Try to find iceburgs by identifying them from within each week's SIC grid
% data. Also view SA for iceburg tracing 

load('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector01.mat');

gridedge = boundary(SIT.lon, SIT.lat);
for dd = 1:length(SIT.dn)
   zerloc = find(SIT.cthires(:,dd)==0)
   
   Tpolylon(:,1) = SIT.lon(zerloc)+1; % create polygons around each zero grid point
   Tpolylon(:,2) = SIT.lon(zerloc)-1; 
   Tpolylon(:,3) = SIT.lon(zerloc);
   Tpolylon(:,4) = Tpolylon(:,3);
   
   Tpolylat(:,1) = SIT.lat(zerloc);
   Tpolylat(:,2) = Tpolylat(:,1);
   Tpolylat(:,3) = SIT.lat(zerloc)+1;
   Tpolylat(:,4) = SIT.lat(zerloc)-1;
   
    
    
    
    
    
   %for ii = 1:length(SIT.lon)
        %if SIT.cthires(ii,dd)==0
            


    %end


end





% test out the guts
% Iceburgs show up as NaN in sa
% This finds those areas - need to narrow down inside the grid field rather
% than along the edges
day = 335;
zerloc = find(isnan(SIT.sa(:,day))==1);
Tpolylon(:,1) = SIT.lon(zerloc)+0.1; % create polygons around each zero grid point
Tpolylon(:,2) = SIT.lon(zerloc)-0.1; 
Tpolylon(:,3) = SIT.lon(zerloc);
Tpolylon(:,4) = Tpolylon(:,3);

Tpolylat(:,1) = SIT.lat(zerloc);
Tpolylat(:,2) = Tpolylat(:,1);
Tpolylat(:,3) = SIT.lat(zerloc)+0.1;
Tpolylat(:,4) = SIT.lat(zerloc)-0.1;


m_basemap('m', [289 312], [-73 -60]);
m_scatter(SIT.lon, SIT.lat, 12, SIT.sa(:,day), 'filled'); hold on;
for ii = 1:length(Tpolylon(:,1));
    m_plot(Tpolylon(ii,:),Tpolylat(ii,:), 'm');
end



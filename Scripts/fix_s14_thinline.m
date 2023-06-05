% Jacob Arnold

% 27_jan_2022

% Find that thing string of formerly nans near the central ross ice shelf
% region and spatially interpolate to fill during the months that we filled
% previously. Consult s14_inconsis_fix.m 

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector14.mat;
oSIT = SIT; clear SIT

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector14.mat;

dummyH = SIT.H;


[londom, latdom] = sectordomain(14);
dots = sectordotsize(14);


%%
% thin line appears in july and sep each year. Find those grid points then
% spatially interp to fill in all july and dec. 


jsind = find(SIT.dv(:,2)==7 | SIT.dv(:,2)==9);


for ii = 1:length(jsind)
    nani = find(isnan(oSIT.H(:,jsind(ii))));
    trimi = find(oSIT.lat(nant)>-78.22 & oSIT.lon(nant)<184 & oSIT.lon(nant)>180);
    nani = nani(trimi);
    
    intarea = find(SIT.lat<-77.5 & SIT.lon>179.5 & SIT.lon<184.5);

    newvals = intarea;

    for jj = 1:length(nant)
        loc = find(newvals==nant(jj));
        newvals(loc) = [];
        clear loc
    end
    
    % spatial interp of dummyH
    newdat = griddata(double(SIT.lon(newvals)), double(SIT.lat(newvals)), double(oSIT.H(newvals,jsind(ii))),...
    double(SIT.lon(intarea)), double(SIT.lat(intarea)));

    dummyH(intarea, jsind(ii)) = newdat;
    
    clear newdat newvals intarea nani trimi

end

%% Test the product


m_basemap('a', londom, latdom) 
sectorexpand(14)
m_scatter(SIT.lon, SIT.lat, dots, SIT.H(:,jsind(120)), 'filled');


m_basemap('a', londom, latdom) 
sectorexpand(14)
m_scatter(SIT.lon, SIT.lat, dots, dummyH(:,jsind(120)), 'filled');


%% OK and save

SIT.H = dummyH;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector14.mat', 'SIT', '-v7.3');








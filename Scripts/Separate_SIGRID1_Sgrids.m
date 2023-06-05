% Jacob Arnold

% 25-Aug-2021

% snip off sector grids from older (1973-1994)

list={'Sector01', 'Sector02', 'Sector03', 'Sector04', 'Sector05', 'Sector06',...
    'Sector07', 'Sector08', 'Sector09', 'Sector10', 'Sector11', 'Sector12', 'Sector13',...
    'Sector14', 'Sector15', 'Sector16', 'Sector17', 'Sector18', 'All Subpolar', 'Subpolar Atlantic',...
    'Subpolar Indian', 'Subpolar Pacific'};
[indx,tf] = listdlg('PromptString',{'Which sector do you wish to use?'},...
    'SelectionMode','single','ListString', list);
if indx<10
    sector = ['0', num2str(indx)];
elseif indx<19 & indx>9
    sector = num2str(indx);
elseif indx==19;sector = 'subpolar';elseif indx==20; sector='subpolar_ao_SIC';
elseif indx==21;sector='subpolario';elseif indx==22; sector='subpolar_po_SIC';
end

% Bring in the gridded charts
load ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/charts_gridded.mat



if length(sector)==2
    sect = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
else
    sect = load(['ICE/Concentration/so-zones/',sector,'_SIC.mat']);

end

sectC = struct2cell(sect);

long = sectC{1,1}.lon;
latg = sectC{1,1}.lat;
clear sect sectC



% find xy coordinates of grid corresponding to shapefile coordinate system

% vvv ** THIS IS THE OLD METHOD use the new (correct) method below 
% ilon1 = (long+90).*-pi/180;
% ilat1 = (90+latg).*105000;
% [gx, gy] = pol2cart(ilon1, ilat1);
% ^^^ **


% THIS IS THE CORRECT version for converting lat/lon to polar stereographic xy of the shapefiles. 
[gx,gy] = ll2ps(latg,long-180,'TrueLat',-60); % ** TrueLat of -60 is vital to a correct conversion


 
SIT.H=single(nan(length(long),length(shpfiles)));
SIT.sa=SIT.H;
SIT.sb=SIT.H; 
SIT.sc=SIT.H;
SIT.sd=SIT.H;
SIT.ca=SIT.H;
SIT.cb=SIT.H;
SIT.cc=SIT.H;
SIT.ct=SIT.H;
SIT.cd=SIT.H;

disp('Acquired Grid')













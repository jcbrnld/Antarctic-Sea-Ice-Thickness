
% Purpose: 
% Calculate sea ice thickness through the following stages:
%    1) Read in shapefiles of stage of development and concentration data
%    2) Project onto a grid
%    3) quality control the SIC and SOD data and find ratios of each partial concentration to total concentration at each grid point
%    4) use ratios to replace partial concentration data with Bremen gridded concentration data
%    5) Calculate sea ice thickness 

%% PLAY with shaperead

sfile = m_shaperead('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/ANTARC150730')

% convert grid to xy
% (must load grid before running this)
ilon1 = (long+90).*-pi/180;
ilat1 = (90+latg).*105000;
[gx, gy] = pol2cart(ilon1, ilat1);

% test inpolygon in xy
isin = find(inpolygon(gx, gy, sfile.ncst{27,1}(:,1), sfile.ncst{27,1}(:,2))==1);

% Plot and check 
figure;scatter(gx, gy, 16);hold on;scatter(gx(isin), gy(isin), 14,'filled' );
plot(sfile.ncst{27,1}(:,1),sfile.ncst{27,1}(:,2), 'LineWidth', 1.2)
set(gcf, 'Position', [600, 500, 800, 700]);
legend('grid', 'isin', 'polygon')
xlim([-2550000, -1900000]);ylim([850000, 1500000]);
%print('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Figures/Shapefile_polygons/20150730_gridXY_CB.png','-dpng', '-r400')


%% NEW Chapter 1 | open shapefiles but DO NOT convert to polar coordinates
%fnames=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt','%s');
fnames=textread('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt','%s');

% Create date variables
%____

%_____
dummyfn=char(fnames);
xx=nan(size(fnames));
ind=xx;
dn=xx;
B=isstrprop(dummyfn,'digit');
for ii=1:length(fnames);
    ind(ii)=find(B(ii,:)==1,1);
    yyyy(ii)=str2double(dummyfn(ii,ind(ii):ind(ii)+3));
    mm(ii)=str2double(dummyfn(ii,ind(ii)+4:ind(ii)+5));
    dd(ii)=str2double(dummyfn(ii,ind(ii)+6:ind(ii)+7));
    dn(ii)=datenum(yyyy(ii),mm(ii),dd(ii));

end
%clear ii yyyy mm dd xx B ind dummyfn fnames;
dv=datevec(dn);
% list of actual data file names
fnames=textread('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesIT.txt','%s');
% sort list of actual data files in chronological order
%load /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/datesortindices.mat
% sort list of actual data files in chronological order
fnames_T1=textread('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITcor.txt','%s');
fnames_T2=textread('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt','%s');
for ii = (1:length(fnames_T1));
    ind(ii) = find(ismember(fnames_T1, fnames_T2(ii)));
end 
ind = ind.';
fnames=fnames(ind); % ind are the indices of the sorted files
shpfiles=cell(size(fnames));
% Read in Longitude and Latitude

for ii=1:length(fnames)
    disp([num2str(ii) ' of ' num2str(length(dn)) ' : Reading Shapefiles'])
    ff1=cell2mat(fnames(ii));
    ff2=['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/' ff1];
    shpfiles{ii}=m_shaperead(ff2(1:end-4));
end
clear ii x y dd B;


%% view polygons (Optional)
m_basemap('p', [0 360 60], [-80 -40 10]);% view 1 polygon
set(gcf, 'Position', [600, 500, 800, 700]);
m_plot(lon{363,27}, lat{363,27},'LineWidth', 1.5);
%print('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Figures/Shapefile_polygons/20150730_trial_toxy.png','-dpng', '-r400')

% view isin for a select polygon % FIND CIRCUMPOLAR POLYS
da = 385;po=122 ;m_basemap('a', [112, 123, 5], [-67.6, -64.5, 1],'sdL_v10',[2000,4000],[8, 1]);
set(gcf, 'Position', [600, 500, 800, 700]);
inp = find(inpolygon(long, latg, lon{da, po}, lat{da, po})==1);
m_scatter(long(inp), latg(inp), 15, 'filled');hold on;
m_plot(lon{da, po}, lat{da, po}, 'LineWidth', 2);

% view all polygons
da=363;m_basemap('p', [0 360 60], [-80 -40 10]); % view all polygons for a day
%m_basemap('a', [284.5 308], [-69.2 -60.2],'sdL_v10',[2000,4000],[8, 1]);
set(gcf, 'Position', [600, 500, 800, 700]);
for ii = 1:length(longood(da,:));
    tlon=longood{da,ii};
    tlat=latgood{da,ii};
    m_plot(tlon, tlat);
    hold on;clear tlon tlat;
end

% View isin and polyborders
da = 363; m_basemap('a', [112, 123, 5], [-67.6, -64.5, 1],'sdL_v10',[2000,4000],[8, 1]);
set(gcf, 'Position', [600, 500, 800, 700]);
for ii = 1:length(lon(da,:));
    inp = find(inpolygon(long, latg, lon{da, ii}, lat{da, ii})==1);
    m_scatter(long(inp), latg(inp), 15, 'filled');hold on;
    m_plot(lon{da,ii}, lat{da,ii}, 'LineWidth', 2);
end

%m_basemap('a', [112, 123, 5], [-67.6, -64.5, 1],'sdL_v10',[2000,4000],[8, 1]);
m_basemap('a', [284.5 308], [-69.2 -60.2],'sdL_v10',[2000,4000],[8, 1]);
set(gcf, 'Position', [600, 500, 800, 700]);
m_plot(lon{367,1}, lat{367,1}, 'lineWidth', 10);
%print('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Figures/Shapefile_polygons/20150827_ISIN.png','-dpng', '-r400')

%% shorten things ONLY TO TEST

dn=dn(362:365);dummyfn=dummyfn(362:365,:);dv=dv(362:365,:);
fnames=fnames(362:365);ind=ind(362:365);
%lat=lat(362:365,:);lon=lon(362:365,:);
shpfiles=shpfiles(362:365);

%% Step 2 | load sector grid


% load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/Concentration/ANT/sector18.mat')
% long=sector18.goodlon;
% latg = sector18.goodlat;
% clear sector18
 
% load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/Concentration/ant-sectors/sector10.mat')
% long=sector10.lon;
% latg = sector10.lat;
% clear sector10

load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/Concentration/ant-sectors/sector10.mat')
long=sector10.lon;
latg = sector10.lat;
clear sector10

% load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/Concentration/so-zones/subpolarep_SIC.mat')
% long = subpolarep.goodlon;
% latg = subpolarep.goodlat;
% clear subpolarep

% find xy coordinates of grid corresponding to shapefile coordinate system
ilon1 = (long+90).*-pi/180;
ilat1 = (90+latg).*105000;
[gx, gy] = pol2cart(ilon1, ilat1);

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


%% Step 3 | Project polys onto xy grid VERIFY SD and CD
for ii=1:length(shpfiles);
    junk=cell2mat(shpfiles(ii));
    if isfield(junk.dbf, 'SD')==1;
        SD{ii}=single(str2double(junk.dbf.SD));
    else
        SD{ii}=nan;
    end
    if isfield(junk.dbf, 'CD')==1;
        CD{ii}=single(str2double(junk.dbf.CD));
    else
        CD{ii}=nan;
    end
    CA{ii}=single(str2double(junk.dbf.CA));
    SA{ii}=single(str2double(junk.dbf.SA));
    CB{ii}=single(str2double(junk.dbf.CB));
    SB{ii}=single(str2double(junk.dbf.SB));
    CC{ii}=single(str2double(junk.dbf.CC));
    SC{ii}=single(str2double(junk.dbf.SC));
    CT{ii}=single(str2double(junk.dbf.CT));
end
clear ii


for ii = 1:length(shpfiles)
    tic
    disp([num2str(ii) ' of ' num2str(length(fnames))])
    tempsa=SA{ii};
    tempsb=SB{ii};
    tempsc=SC{ii};
    tempsd=SD{ii};
    tempca=CA{ii};
    tempcb=CB{ii};
    tempcc=CC{ii};
    tempct=CT{ii};
    tempcd=CD{ii};
    for jj = 1:length(shpfiles{ii,1}.ncst);
    %for jj = 1:length(goodloc{ii});
%         px = shpfiles{ii,1}.ncst{goodloc{ii}(jj)}(:,1);
%         py = shpfiles{ii,1}.ncst{goodloc{ii}(jj)}(:,2);
        px = shpfiles{ii,1}.ncst{jj,1}(:,1);
        py = shpfiles{ii,1}.ncst{jj,1}(:,2);
        ISIN = find(inpolygon(gx,gy,px,py)==1);
        SIT.sa(ISIN,ii)=tempsa(jj);
        SIT.sb(ISIN,ii)=tempsb(jj);
        SIT.sc(ISIN,ii)=tempsc(jj);
        %SIT.sd(ISIN,ii)=tempsd(jj);
        SIT.ca(ISIN,ii)=tempca(jj);
        SIT.cb(ISIN,ii)=tempcb(jj);
        SIT.cc(ISIN,ii)=tempcc(jj);
        SIT.ct(ISIN,ii)=tempct(jj);
        %SIT.cd(ISIN,ii)=tempcd(jj);
    end
    toc
end
clear ii jj tempsa tempsb tempsc tempca tempcb tempcc tempct



%% Save gridded data
%save /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/Sabrina_shp_gridded.mat -v7.3
% Trim down by clearing additional unnecessary variables
%load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/Sabrina_shp_gridded.mat
%% Step 4 | Decode Data

disp('Converting concentrations from SIGRID to %')
SIT.ca(SIT.ca==98 | SIT.ca==0)=0;
SIT.ca(SIT.ca==1)=5; % open water
SIT.ca(SIT.ca==2)=5; % bergy water
SIT.ca(SIT.ca==11)=55;
SIT.ca(SIT.ca==21)=60;
SIT.ca(SIT.ca==31)=65;
SIT.ca(SIT.ca==41)=70;
SIT.ca(SIT.ca==51)=75;
SIT.ca(SIT.ca==61)=80;
SIT.ca(SIT.ca==71)=85;
SIT.ca(SIT.ca==81)=90;
SIT.ca(SIT.ca==91)=95; % more than 9/10, but less than 10/10
SIT.ca(SIT.ca==92)=100; % 10/10
SIT.ca(SIT.ca==-9)=nan;
for jj=1:length(SIT.ca);
    if (SIT.ca(jj)~= 0 & SIT.ca(jj)~=5 & SIT.ca(jj)~=55 & SIT.ca(jj)~=65 & SIT.ca(jj)~=75 & SIT.ca(jj)~=85 & SIT.ca(jj)~=95 & SIT.ca(jj)~=100 & SIT.ca(jj)~=10 & SIT.ca(jj)~=20 &...
            SIT.ca(jj)~=30 & SIT.ca(jj)~=40 & SIT.ca(jj)~=50 & SIT.ca(jj)~=60 &...
            SIT.ca(jj)~=70 & SIT.ca(jj)~=80 & SIT.ca(jj)~=90);
        if isnan(SIT.ca(jj))==0; % did not like being a part of the preceding if statement
            [Q,R]=quorem(sym(SIT.ca(jj)),sym(10));
            SIT.ca(jj)=(Q*10+R*10)/2; % Take the Average of the Sea ice concentration interval
        end
        clear Q R;
    end
end
clear jj;
disp('CA done...')

SIT.cb(SIT.cb==98 | SIT.cb==0)=0;
SIT.cb(SIT.cb==1)=5; % open water
SIT.cb(SIT.cb==2)=5; % bergy water
SIT.cb(SIT.cb==11)=55;
SIT.cb(SIT.cb==21)=60;
SIT.cb(SIT.cb==31)=65;
SIT.cb(SIT.cb==41)=70;
SIT.cb(SIT.cb==51)=75;
SIT.cb(SIT.cb==61)=80;
SIT.cb(SIT.cb==71)=85;
SIT.cb(SIT.cb==81)=90;
SIT.cb(SIT.cb==91)=95; % more than 9/10, but less than 10/10
SIT.cb(SIT.cb==92)=100; % 10/10
SIT.cb(SIT.cb==-9)=nan;
for jj=1:length(SIT.cb);
    if    (SIT.cb(jj)~=0 & SIT.cb(jj)~=5 & SIT.cb(jj)~=55 & SIT.cb(jj)~=65 & SIT.cb(jj)~=75 & SIT.cb(jj)~=85 & SIT.cb(jj)~=95 & SIT.cb(jj)~=100 & SIT.cb(jj)~=10 & SIT.cb(jj)~=20 &...
            SIT.cb(jj)~=30 & SIT.cb(jj)~=40 & SIT.cb(jj)~=50 & SIT.cb(jj)~=60 &...
            SIT.cb(jj)~=70 & SIT.cb(jj)~=80 & SIT.cb(jj)~=90);
        if isnan(SIT.cb(jj))==0; % did not like being a part of the preceding if statement
            [Q,R]=quorem(sym(SIT.cb(jj)),sym(10));
            SIT.cb(jj)=(Q*10+R*10)/2; % Take the Average of the Sea ice concentration interval
        end
        clear Q R;
    end
end
clear jj;
disp('CB done...')

SIT.cc(SIT.cc==98 | SIT.cc==0)=0;
SIT.cc(SIT.cc==1)=5; % open water
SIT.cc(SIT.cc==2)=5; % bergy water
SIT.cc(SIT.cc==11)=55;
SIT.cc(SIT.cc==21)=60;
SIT.cc(SIT.cc==31)=65;
SIT.cc(SIT.cc==41)=70;
SIT.cc(SIT.cc==51)=75;
SIT.cc(SIT.cc==61)=80;
SIT.cc(SIT.cc==71)=85;
SIT.cc(SIT.cc==81)=90;
SIT.cc(SIT.cc==91)=95; % more than 9/10, but less than 10/10
SIT.cc(SIT.cc==92)=100; % 10/10
SIT.cc(SIT.cc==-9)=nan;
for jj=1:length(SIT.cc);
    if    (SIT.cc(jj)~=0 & SIT.cc(jj)~=5 & SIT.cc(jj)~=55 & SIT.cc(jj)~=65 & SIT.cc(jj)~=75 & SIT.cc(jj)~=85 & SIT.cc(jj)~=95 & SIT.cc(jj)~=100 & SIT.cc(jj)~=10 & SIT.cc(jj)~=20 &...
            SIT.cc(jj)~=30 & SIT.cc(jj)~=40 & SIT.cc(jj)~=50 & SIT.cc(jj)~=60 &...
            SIT.cc(jj)~=70 & SIT.cc(jj)~=80 & SIT.cc(jj)~=90);
        if isnan(SIT.cc(jj))==0; % did not like being a part of the preceding if statement
            [Q,R]=quorem(sym(SIT.cc(jj)),sym(10));
            SIT.cc(jj)=(Q*10+R*10)/2; % Take the Average of the Sea ice concentration interval
        end
        clear Q R;
    end
end
clear jj;
disp('CC done...')

SIT.ct(SIT.ct==98 | SIT.ct==0)=0;
SIT.ct(SIT.ct==1)=5; % open water
SIT.ct(SIT.ct==2)=5; % bergy water
SIT.ct(SIT.ct==11)=55;
SIT.ct(SIT.ct==21)=60;
SIT.ct(SIT.ct==31)=65;
SIT.ct(SIT.ct==41)=70;
SIT.ct(SIT.ct==51)=75;
SIT.ct(SIT.ct==61)=80;
SIT.ct(SIT.ct==71)=85;
SIT.ct(SIT.ct==81)=90;
SIT.ct(SIT.ct==91)=95; % more lengththan 9/10, but less than 10/10
SIT.ct(SIT.ct==92)=100; % 10/10
SIT.ct(SIT.ct==-9)=nan;
for jj=1:length(SIT.ct);
    if    (SIT.ct(jj)~=0 & SIT.ct(jj)~=5 & SIT.ct(jj)~=55 & SIT.ct(jj)~=65 & SIT.ct(jj)~=75 & SIT.ct(jj)~=85 & SIT.ct(jj)~=95 & SIT.ct(jj)~=100 & SIT.ct(jj)~=10 & SIT.ct(jj)~=20 &...
            SIT.ct(jj)~=30 & SIT.ct(jj)~=40 & SIT.ct(jj)~=50 & SIT.ct(jj)~=60 &...
            SIT.ct(jj)~=70 & SIT.ct(jj)~=80 & SIT.ct(jj)~=90);
        if isnan(SIT.ct(jj))==0; % did not like being a part of the preceding if statement
            [Q,R]=quorem(sym(SIT.ct(jj)),sym(10));
            SIT.ct(jj)=(Q*10+R*10)/2; % Take the Average of the Sea ice concentration interval
        end
        clear Q R;
    end
end
clear jj;
disp('Done... ')
% Convert SIGRID code to thickness values
% Some are denoted for later use 
% Comments indicate description from SIGRID-3 documents table
    % See also table 1 (pg 16) in Morgan 2011 (thesis)
% But what about everything below 81? Those values don't occur in the data

% See where these changes ACTUALLY occur:
% for iii = 1:3;
%     for jjj = -9:99;
%         if iii==1;
%             if isfinite(find(SIT.sa==jjj));
%                 disp(['values for SA', num2str(jjj)])
%             end
%         elseif iii==2;
%             if isfinite(find(SIT.sb==jjj));
%                 disp(['values for SB', num2str(jjj)])
%             end
%         elseif iii==3;
%             if isfinite(find(SIT.sc==jjj));
%                 disp(['values for SC', num2str(jjj)])
%             end
%         end
%     end
% end

% OUTPUT:
% values for SA-9 values for SB-9  values for SC-9
% values for SA0  values for SB0   values for SC0
% values for SA81 values for SB81  values for SC81
% values for SA83 values for SB83  values for SC83
% values for SA86 values for SB86  values for SC86
% values for SA87 values for SB87  values for SC87
% values for SA95 values for SB95
%                 values for SB97
% values for SA98
% values for SA99 values for SB99  values for SC99

disp('Converting stages of development from SIGRID to cm')
SIT.sa(SIT.sa==-9)=nan;
SIT.sa(SIT.sa==1)=0;
SIT.sa(SIT.sa==2)=1.5;
SIT.sa(SIT.sa==51)=55;
SIT.sa(SIT.sa==52)=60;
SIT.sa(SIT.sa==53)=65;
SIT.sa(SIT.sa==54)=70;
SIT.sa(SIT.sa==55)=75; % Should be ice free?
SIT.sa(SIT.sa==56)=80;
SIT.sa(SIT.sa==57)=85;
SIT.sa(SIT.sa==58)=90;
SIT.sa(SIT.sa==59)=95;
SIT.sa(SIT.sa==60)=100;
SIT.sa(SIT.sa==61)=110;
SIT.sa(SIT.sa==62)=120;
SIT.sa(SIT.sa==63)=130;
SIT.sa(SIT.sa==64)=140;
SIT.sa(SIT.sa==65)=150;
SIT.sa(SIT.sa==66)=160;
SIT.sa(SIT.sa==67)=170;
SIT.sa(SIT.sa==68)=180;
SIT.sa(SIT.sa==69)=190;
SIT.sa(SIT.sa==70)=200; % Brash ice
SIT.sa(SIT.sa==71)=250;
SIT.sa(SIT.sa==72)=300;
SIT.sa(SIT.sa==73)=350;
SIT.sa(SIT.sa==74)=400;
SIT.sa(SIT.sa==75)=500;
SIT.sa(SIT.sa==76)=600;
SIT.sa(SIT.sa==77)=700;
SIT.sa(SIT.sa==78)=800;
SIT.sa(SIT.sa==79)=-79;
SIT.sa(SIT.sa==80)=-80; % No stage of development
SIT.sa(SIT.sa==81)=2.5; % New ice: <10 cm
SIT.sa(SIT.sa==82)=5; % Nilas, ice rind: <10 cm 
SIT.sa(SIT.sa==83)=15; % Young ice: 10 - <30 cm
SIT.sa(SIT.sa==84)=12.5; % Grey ice: 10 - <15 cm
SIT.sa(SIT.sa==85)=22.5; % Grey-White ice: 15 - <30 cm
SIT.sa(SIT.sa==86)=115; % First year ice: >=30 - 200 cm
SIT.sa(SIT.sa==87)=50; % Thin first year ice: 30 - <70 cm
SIT.sa(SIT.sa==88)=40; % Thin first year stage 1: 30 - <50 cm
SIT.sa(SIT.sa==89)=60; % Thin first year stage 2: 50 - <70 cm 
SIT.sa(SIT.sa==90)=-90; % For later use
SIT.sa(SIT.sa==91)=95; % Medium first year ice: 70 - <120 cm
SIT.sa(SIT.sa==92)=-92; % For later use
SIT.sa(SIT.sa==93)=160; % Thick first year ice: >=120 cm
SIT.sa(SIT.sa==94)=-94; % For later use
SIT.sa(SIT.sa==95)=600; % Old ice
SIT.sa(SIT.sa==96)=400; % Second year ice
SIT.sa(SIT.sa==97)=800; % Multi-year ice
SIT.sa(SIT.sa==98)=nan; % Glacier ice
SIT.sa(SIT.sa==99)=-99; % Undetermined/Unknown
SIT.sb(SIT.sb==-9)=nan;
SIT.sb(SIT.sb==1)=0;
SIT.sb(SIT.sb==2)=1.5;
SIT.sb(SIT.sb==51)=55;
SIT.sb(SIT.sb==52)=60;
SIT.sb(SIT.sb==53)=65;
SIT.sb(SIT.sb==54)=70;
SIT.sb(SIT.sb==55)=75;
SIT.sb(SIT.sb==56)=80;
SIT.sb(SIT.sb==57)=85;
SIT.sb(SIT.sb==58)=90;
SIT.sb(SIT.sb==59)=95;
SIT.sb(SIT.sb==60)=100;
SIT.sb(SIT.sb==61)=110;
SIT.sb(SIT.sb==62)=120;
SIT.sb(SIT.sb==63)=130;
SIT.sb(SIT.sb==64)=140;
SIT.sb(SIT.sb==65)=150;
SIT.sb(SIT.sb==66)=160;
SIT.sb(SIT.sb==67)=170;
SIT.sb(SIT.sb==68)=180;
SIT.sb(SIT.sb==69)=190;
SIT.sb(SIT.sb==70)=200;
SIT.sb(SIT.sb==71)=250;
SIT.sb(SIT.sb==72)=300;
SIT.sb(SIT.sb==73)=350;
SIT.sb(SIT.sb==74)=400;
SIT.sb(SIT.sb==75)=500;
SIT.sb(SIT.sb==76)=600;
SIT.sb(SIT.sb==77)=700;
SIT.sb(SIT.sb==78)=800;
SIT.sb(SIT.sb==79)=-79;
SIT.sb(SIT.sb==80)=-80;
SIT.sb(SIT.sb==81)=2.5;
SIT.sb(SIT.sb==82)=5;
SIT.sb(SIT.sb==83)=15;
SIT.sb(SIT.sb==84)=12.5;
SIT.sb(SIT.sb==85)=22.5;
SIT.sb(SIT.sb==86)=115;
SIT.sb(SIT.sb==87)=50;
SIT.sb(SIT.sb==88)=40;
SIT.sb(SIT.sb==89)=60;
SIT.sb(SIT.sb==90)=-90;
SIT.sb(SIT.sb==91)=95;
SIT.sb(SIT.sb==92)=-92;
SIT.sb(SIT.sb==93)=160;
SIT.sb(SIT.sb==94)=-94;
SIT.sb(SIT.sb==95)=600;
SIT.sb(SIT.sb==96)=400;
SIT.sb(SIT.sb==97)=800;
SIT.sb(SIT.sb==98)=nan;
SIT.sb(SIT.sb==99)=-99;
SIT.sc(SIT.sc==-9)=nan;
SIT.sc(SIT.sc==1)=0;
SIT.sc(SIT.sc==2)=1.5;
SIT.sc(SIT.sc==51)=55;
SIT.sc(SIT.sc==52)=60;
SIT.sc(SIT.sc==53)=65;
SIT.sc(SIT.sc==54)=70;
SIT.sc(SIT.sc==55)=75;
SIT.sc(SIT.sc==56)=80;
SIT.sc(SIT.sc==57)=85;
SIT.sc(SIT.sc==58)=90;
SIT.sc(SIT.sc==59)=95;
SIT.sc(SIT.sc==60)=100;
SIT.sc(SIT.sc==61)=110;
SIT.sc(SIT.sc==62)=120;
SIT.sc(SIT.sc==63)=130;
SIT.sc(SIT.sc==64)=140;
SIT.sc(SIT.sc==65)=150;
SIT.sc(SIT.sc==66)=160;
SIT.sc(SIT.sc==67)=170;
SIT.sc(SIT.sc==68)=180;
SIT.sc(SIT.sc==69)=190;
SIT.sc(SIT.sc==70)=200;
SIT.sc(SIT.sc==71)=250;
SIT.sc(SIT.sc==72)=300;
SIT.sc(SIT.sc==73)=350;
SIT.sc(SIT.sc==74)=400;
SIT.sc(SIT.sc==75)=500;
SIT.sc(SIT.sc==76)=600;
SIT.sc(SIT.sc==77)=700;
SIT.sc(SIT.sc==78)=800;
SIT.sc(SIT.sc==79)=-79;
SIT.sc(SIT.sc==80)=-80;
SIT.sc(SIT.sc==81)=2.5;
SIT.sc(SIT.sc==82)=5;
SIT.sc(SIT.sc==83)=15;
SIT.sc(SIT.sc==84)=12.5;
SIT.sc(SIT.sc==85)=22.5;
SIT.sc(SIT.sc==86)=115;
SIT.sc(SIT.sc==87)=50;
SIT.sc(SIT.sc==88)=40;
SIT.sc(SIT.sc==89)=60;
SIT.sc(SIT.sc==90)=-90;
SIT.sc(SIT.sc==91)=95;
SIT.sc(SIT.sc==92)=-92;
SIT.sc(SIT.sc==93)=160;
SIT.sc(SIT.sc==94)=-94;
SIT.sc(SIT.sc==95)=600;
SIT.sc(SIT.sc==96)=400;
SIT.sc(SIT.sc==97)=800;
SIT.sc(SIT.sc==98)=nan;
SIT.sc(SIT.sc==99)=-99;

disp('Done.')

figure
subplot(3,3,1)
histogram(SIT.ca, 10)
subplot(3,3,2)
histogram(SIT.cb, 10)
subplot(3,3,3)
histogram(SIT.cc, 10)
subplot(3,3,4)
histogram(SIT.sa)
subplot(3,3,5)
histogram(SIT.sb)
subplot(3,3,6)
histogram(SIT.sc)
subplot(3,3,7:9)
histogram(SIT.ct)





percca = (sum(isnan(SIT.ca),'all')/(length(SIT.ca(:,1)) * length(SIT.ca(1,:))))*100;
perccb = (sum(isnan(SIT.cb),'all')/(length(SIT.cb(:,1)) * length(SIT.cb(1,:))))*100;
perccc = (sum(isnan(SIT.cc),'all')/(length(SIT.cc(:,1)) * length(SIT.cc(1,:))))*100;
percct = (sum(isnan(SIT.ct),'all')/(length(SIT.ct(:,1)) * length(SIT.ct(1,:))))*100;
percsa = (sum(isnan(SIT.sa),'all')/(length(SIT.sa(:,1)) * length(SIT.sa(1,:))))*100;
percsb = (sum(isnan(SIT.sb),'all')/(length(SIT.sb(:,1)) * length(SIT.sb(1,:))))*100;
percsc = (sum(isnan(SIT.sc),'all')/(length(SIT.sc(:,1)) * length(SIT.sc(1,:))))*100;
disp(['% NaN: ca = ', num2str(percca),'% | ','cb = ', num2str(perccb),'% | ','cc = ', num2str(perccc),'% | ',...
    'ct = ', num2str(percct),'% | ','sa = ', num2str(percsa),'% | ','sb = ', num2str(percsb),'% | ','sc = ', num2str(percsc),'% | '])
clear percca perccb perccc percct percsa percsb percsc

dnDup = dn; % problems with overwriting SIT.dn after original dn has been replaced. This duplication allows correction of this when necessary. 
SIT.dn=dn;
SIT.dv=dv;
SIT.lon=long;
SIT.lat=latg;

%% Import and average SIC data to match temporal scale of SOD


% step 1: load SIC data and average to same times 
load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/Concentration/ant-sectors/sector10.mat');
dn = sector10.dn;
SICcorr2 = sector10.sic;
clear sector10
% load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/Concentration/so-zones/subpolarep_SIC.mat')
% dn = subpolarep.dn;
% SICcorr2 = subpolarep.goodsic;
% clear subpolarep


mdn = SIT.dn;
dmdn = diff(mdn); % should be 1xN-1 -> difference between each two values
for ii = 1:length(dmdn)
    lmdn(ii,1) = mdn(ii)+round((dmdn(ii))/2); %provides midpoint values between each dn - should be N-2x1
    %disp(ii)
end
clear ii
%------
%[junky,nantestind] = find(dn==mdn);
[Ca, IAa, IBa] = intersect(dn, mdn);
nantest = sum(isnan(SICcorr2(:,IAa)),'all');clear nantestind; disp(["Number of NaNs at matching dates: "+num2str(nantest)])

clear junky nantest
%------

for ii = 1:length(lmdn);
    mids(ii) = find(dn==lmdn(ii));
end
%[junk,mids] = find(dn==lmdn); %CHECK THIS
lmdn = lmdn(1:length(mids)); %CHECK THIS should always be true
fd = find(dn==mdn(1));
if length(dn)>=length(SIT.dn);
    ld = find(dn==mdn(length(lmdn)+1));
else
    ld = length(dn);
end
%ld = find(dn==mdn(length(lmdn)+1)); % IF length(dn)>=length(SIT.dn)
%ld = length(dn); % IF length(dn)<length(SIT.dn)
for gg = 1:length(long)
    for ii = 1:length(lmdn)-1
        avgSIC(gg,ii+1) = nanmean(SICcorr2(gg,mids(ii):mids(ii+1)));
    end 
    avgSIC(gg,1) = nanmean(SICcorr2(gg,fd:mids(1)));
    avgSIC(gg,length(lmdn)) = nanmean(SICcorr2(gg, mids(end):ld));
end
clear ii gg
%------
nantest = sum(isnan(avgSIC),'all'); disp(["Number of NaNs after avg: "+num2str(nantest)])
clear nantest
%------Convert Ca Cb Cc and Ct to 0 where Bremen SIC == 0

% no_ice = find(avgSIC==0);
% SIT.ca(no_ice)=0;
% SIT.cb(no_ice)=0;
% SIT.cc(no_ice)=0;
% SIT.ct(no_ice)=0;

disp('Done averaging SIC across each weekly/biweekly interval')

%% Quality Control Data


% SIT.dn=dn;
% SIT.dv=dv;
% SIT.lon=long;
% SIT.lat=latg;
%clear dn dv long latg polyind1 shpfiles longood latgood lon lat fnames ind SA SB SC CA CB CC CT dummylon goodpolys;
% first compute the record length average of times when all components are
% present
% Stage of Development
origSA = SIT.sa;
origSB = SIT.sb;
origSC = SIT.sc;
tempnanSA=find(SIT.sa<0);
tempnanSB=find(SIT.sb<0);
tempnanSC=find(SIT.sc<0);
dummySA=SIT.sa;
dummySB=SIT.sb;
dummySC=SIT.sc;
dummySA(tempnanSA)=nan;
dummySB(tempnanSB)=nan;
dummySC(tempnanSC)=nan;

indA = zeros(size(SIT.ca));
indB = zeros(size(SIT.ca));
indC = zeros(size(SIT.ca));

% --- Stage of Development moving average below ---
% MINI DOC STRING HERE DESCRIBING WHAT THIS DOES


yrs = unique(SIT.dv(:,1));
mnths = unique(SIT.dv(:,2));
refsF(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(1))";
for cc = 1:length(yrs)-1
    refsF(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(cc)+"))";
end
refsL(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))";
for cc = 1:length(yrs)-1
    refsL(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(cc)+"))";
end
for yy = 1:length(yrs)
    tic;
    disp(['SOD ',num2str(yrs(yy))])
    for mm = 1:length(mnths)
        for gg = 1:length(SIT.lon)
            if yy == 1
                for rr = 3:length(refsF)
                    ind = find(eval(join(refsF(1:rr))));
                    if sum(~isnan(dummySA(gg,ind)),'all') >= 2
                        goodsa = ind;
                        mavgSA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySA(gg, goodsa)); clear goodsa;
                        break
                    end
                end; clear rr
                for rr = 3:length(refsF)
                    ind = find(eval(join(refsF(1:rr))));
                    if sum(~isnan(dummySB(gg,ind)),'all') >= 2
                        goodsb = ind;
                        mavgSB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySB(gg, goodsb)); clear goodsb;
                        break
                    end
                end; clear rr
                for rr = 3:length(refsF)
                    ind = find(eval(join(refsF(1:rr))));
                    if sum(~isnan(dummySC(gg,ind)),'all') >= 2
                        goodsc = ind;
                        mavgSC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySC(gg, goodsc)); clear goodsc;
                        break
                    end
                end; clear rr
            elseif yy == length(yrs)
                lstm = SIT.dv(end,2);
                if mm > lstm;
                    continue
                else
                    for rr = 3:length(refsL) % takes yy-rr
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummySA(gg,ind)),'all') >= 2
                            goodsa = ind;
                            mavgSA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySA(gg, goodsa)); clear goodsa;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsL) 
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummySB(gg,ind)),'all') >= 2
                            goodsb = ind;
                            mavgSB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySB(gg, goodsb)); clear goodsb;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsL) 
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummySC(gg,ind)),'all') >= 2
                            goodsc = ind;
                            mavgSC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySC(gg, goodsc)); clear goodsc;
                            break
                        end
                    end; clear rr
                end
            else
                if length(yrs)-yy >= yy % first half or middle years
                    refsM(yy) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))";
                    for aa = 1:length(yrs)-yy
                        if yy-aa >= 1 % within shorter bound
                            refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                            refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                            ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:)
                            if sum(~isnan(dummySA(gg,ind)),'all') >= 2
                                goodsa = ind;
                                mavgSA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySA(gg, goodsa)); clear goodsa;
                                break
                            end; clear ind
                        elseif yy-aa < 1
                            refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                            ind = find(eval(join(refsM(1:yy+aa))));
                            if sum(~isnan(dummySA(gg,ind)),'all') >= 2
                                goodsa = ind;
                                mavgSA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySA(gg, goodsa)); clear goodsa;
                                break
                            end; clear ind 
                        end
                    end
                    for aa = 1:length(yrs)-yy
                        if yy-aa >= 1 % within shorter bound
                            refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                            refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                            ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                            if sum(~isnan(dummySB(gg,ind)),'all') >= 2
                                goodsb = ind;
                                mavgSB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySB(gg, goodsb)); clear goodsb;
                                break
                            end; clear ind
                        elseif yy-aa < 1
                            refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                            ind = find(eval(join(refsM(1:yy+aa))));
                            if sum(~isnan(dummySB(gg,ind)),'all') >= 2
                                goodsb = ind;
                                mavgSB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySB(gg, goodsb)); clear goodsb;
                                break
                            end; clear ind
                        end
                    end
                    for aa = 1:length(yrs)-yy
                        if yy-aa >= 1 % within shorter bound
                            refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                            refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                            ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                            if sum(~isnan(dummySC(gg,ind)),'all') >= 2
                                goodsc = ind;
                                mavgSC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySC(gg, goodsc)); clear goodsc;
                                break
                            end; clear ind
                        elseif yy-aa < 1
                            refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                            ind = find(eval(join(refsM(1:yy+aa))));
                            if sum(~isnan(dummySC(gg,ind)),'all') >= 2
                                goodsc = ind;
                                mavgSC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySC(gg, goodsc)); clear goodsc;
                                break
                            end; clear ind
                        end
                    end
                elseif length(yrs)-yy < yy % second half of years
                    refsM(yy) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))";
                    for aa = 1:yy-1
                        if yy+aa <= length(yrs) % within shorter bound
                            refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                            refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                            ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                            if sum(~isnan(dummySA(gg,ind)),'all') >= 2
                                goodsa = ind;
                                mavgSA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySA(gg, goodsa)); clear goodsa;
                                break
                            end; clear ind
                        elseif yy+aa > length(yrs)
                            refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                            ind = find(eval(join(refsM(yy-aa:end))));
                            if sum(~isnan(dummySA(gg,ind)),'all') >= 2
                                goodsa = ind;
                                mavgSA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySA(gg, goodsa)); clear goodsa;
                                break
                            end; clear ind
                        end
                    end
                    for aa = 1:yy-1
                        if yy+aa <= length(yrs) % within shorter bound
                            refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                            refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                            ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                            if sum(~isnan(dummySB(gg,ind)),'all') >= 2
                                goodsb = ind;
                                mavgSB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySB(gg, goodsb)); clear goodsb;
                                break
                            end; clear ind
                        elseif yy+aa > length(yrs)
                            refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                            ind = find(eval(join(refsM(yy-aa:end))));
                            if sum(~isnan(dummySB(gg,ind)),'all') >= 2
                                goodsb = ind;
                                mavgSB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySB(gg, goodsb)); clear goodsb;
                                break
                            end; clear ind
                        end
                    end
                    for aa = 1:yy-1
                        if yy+aa <= length(yrs) % within shorter bound
                            refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                            refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                            ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                            if sum(~isnan(dummySC(gg,ind)),'all') >= 2
                                goodsc = ind;
                                mavgSC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySC(gg, goodsc)); clear goodsc;
                                break
                            end; clear ind
                        elseif yy+aa > length(yrs)
                            refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                            ind = find(eval(join(refsM(yy-aa:end))));
                            if sum(~isnan(dummySC(gg,ind)),'all') >= 2
                                goodsc = ind;
                                mavgSC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySC(gg, goodsc)); clear goodsc;
                                break
                            end; clear ind
                        end
                    end
                end
            end
        end
    end
    toc
end
clear cc yy mm gg aa rr;
ratioSA=mavgSA./(mavgSA+mavgSB+mavgSC);
ratioSB=mavgSB./(mavgSA+mavgSB+mavgSC);
ratioSC=mavgSC./(mavgSA+mavgSB+mavgSC);

% --- Stage of Development moving average above ---


stgdevratio=[ratioSA,ratioSB,ratioSC];
clear dummySA dummySB dummySC;
[Cab,IA,IB]=intersect(tempnanSA,tempnanSB);
[Cabc,Iab,IC]=intersect(Cab,tempnanSC);
%clear Cab Cabc IA IB Iab IC stgdevratio; % use tempnanSA...When SIT.sa is -99, so are SIT.sb and SIT.sc
avgABC=mavgSA+mavgSB+mavgSC;
for i=1:length(SIT.dn); % loop through all files - everywhere a -99 appears fill with average at that location across all times
    all99=find(SIT.sa(:,i)==-99);
    SIT.sa(all99,i)=avgABC(all99,i).*ratioSA(all99,i); %This is the same as avgSA? 
    SIT.sb(all99,i)=avgABC(all99,i).*ratioSB(all99,i);
    SIT.sc(all99,i)=avgABC(all99,i).*ratioSC(all99,i);
    clear all99;
end
clear i;
[Cbc,IB,IC]=intersect(tempnanSB,tempnanSC);
for i=1:length(SIT.dn); % loop through all files
    all99=find(SIT.sb(:,i)==-99);
    SIT.sb(all99,i)=avgABC(all99,i).*ratioSB(all99,i);
    SIT.sc(all99,i)=avgABC(all99,i).*ratioSC(all99,i);
    clear all99;
end
clear i;
for i=1:length(SIT.dn); % loop through all files
    all99=find(SIT.sc(:,i)==-99);
    SIT.sc(all99,i)=avgABC(all99,i).*ratioSC(all99,i);
    clear all99;
end
clear i;
% Sea Ice Concentration
% once for initial QC --no longer necessary as it loops itself--
cases = zeros(size(SIT.ca));

for qq = 1:2;
    for i=1:length(SIT.dn); % all files
        for j=1:length(SIT.lon); % all grid points
            % Case 1: all finite, but do not add up to CT
            if (isfinite(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1 & SIT.ca(j,i)+SIT.cb(j,i)+SIT.cc(j,i)~=SIT.ct(j,i))
                difference=SIT.ct(j,i)-(SIT.ca(j,i)+SIT.cb(j,i)+SIT.cc(j,i));
                cases(j,i)=1; %track how often each case occurrs
                if difference<0;
                    cases(j,i)=1.1;
                    SIT.ca(j,i)=nan;SIT.cb(j,i)=nan;SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference>0;
                    cases(j,i)=1.2;
                    % fill in the difference across the partials with their
                    % weighted value
                    if qq==2;
                        SIT.ca(j,i)=SIT.ca(j,i)+difference*ratioCA(j,i); % new MA
                        SIT.cb(j,i)=SIT.cb(j,i)+difference*ratioCB(j,i); % new MA
                        SIT.cc(j,i)=SIT.cc(j,i)+difference*ratioCC(j,i); % new MA
                    end
                elseif difference==0;
                    disp('FLAG - case 1 - This should not have happened')
                    
                end
        
              clear difference;
            % Case 2: CA=nan, but CB, CC, CT are finite    
            elseif (isnan(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1)
                cases(j,i)=2; %track how often each case occurrs
                difference=SIT.ct(j,i)-(SIT.cb(j,i)+SIT.cc(j,i));
                if difference<0;
                    cases(j,i)=2.1;
                    SIT.cb(j,i)=nan;SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    cases(j,i)=2.2;
                    SIT.ca(j,i)=0;
                elseif difference>0;
                    cases(j,i)=2.3;
                    SIT.ca(j,i)=difference;
                end
                clear difference
            % Case 3: CB=nan, but CA, CC, CT are finite    
            elseif (isfinite(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                cases(j,i)=3; %track how often each case occurrs
                difference=SIT.ct(j,i)-(SIT.ca(j,i)+SIT.cc(j,i));
                if difference<0;
                    cases(j,i)=3.1;
                    SIT.ca(j,i)=nan;SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    cases(j,i)=3.2;
                    SIT.cb(j,i)=0;
                elseif difference>0;
                    cases(j,i)=3.3;
                    SIT.cb(j,i)=difference;
                end
                clear difference;
            % Case 4: CC=nan, but CA, CB, CT are finite    
            elseif (isfinite(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                cases(j,i)=4; %track how often each case occurrs
                difference=SIT.ct(j,i)-(SIT.ca(j,i)+SIT.cb(j,i));
                if difference<0;
                    cases(j,i)=4.1;
                    SIT.ca(j,i)=nan;SIT.cb(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    cases(j,i)=4.2;
                    SIT.cc(j,i)=0;
                elseif difference>0;
                    cases(j,i)=4.3;
                    SIT.cc(j,i)=difference;
                end
                clear difference;
            % Case 5: CA, CT are finite, CB, CC are nan   
            elseif (isfinite(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                cases(j,i)=5; %track how often each case occurrs
                difference=SIT.ct(j,i)-SIT.ca(j,i);
                if difference<0;
                    cases(j,i)=5.1;
                    SIT.ca(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    cases(j,i)=5.2;
                    SIT.cb(j,i)=0;SIT.cc(j,i)=0;
                elseif difference>0;    
                    cases(j,i)=5.3;
                    % replace remaining partials with their weighted value
                    if qq==2;
                        ratio=ratioCB(j,i)/ratioCC(j,i); % new MA
                        SIT.cc(j,i)=difference/(ratio+1); % cmmt 1st (not anymore)
                        SIT.cb(j,i)=difference-SIT.cc(j,i); % cmmt 1st (not anymore)
                        clear ratio; % cmmt 1st
                    end
                end
                clear difference;
            % Case 6: CB, CT are finite, CA, CC are nan    
            elseif (isnan(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                cases(j,i)=6; %track how often each case occurrs
                difference=SIT.ct(j,i)-SIT.cb(j,i);
                if difference<0;
                    cases(j,i)=6.1;
                    SIT.cb(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    cases(j,i)=6.2;
                    SIT.ca(j,i)=0;SIT.cc(j,i)=0;
                elseif difference>0;
                    cases(j,i)=6.3;
                    % replace remaining partials with their weighted value
                    if qq==2;
                        ratio=ratioCA(j,i)/ratioCC(j,i); % new MA
                        SIT.cc(j,i)=difference/(ratio+1); % cmmt 1st (not anymore)
                        SIT.ca(j,i)=difference-SIT.cc(j,i); % cmmt 1st (not anymore)
                        clear ratio; % cmmt 1st
                    end
                end
                clear difference;
            % Case 7: CC, CT are finite, CA, CB are nan    
            elseif (isnan(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                cases(j,i)=7; %track how often each case occurrs
                difference=SIT.ct(j,i)-SIT.cc(j,i);
                if difference<0;
                    cases(j,i)=7.1;
                    SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    cases(j,i)=7.2;
                    SIT.ca(j,i)=0;SIT.cb(j,i)=0;
                elseif difference>0;
                    cases(j,i)=7.3;
                    % replace remaining partials with their weighted value
                    if qq==2;
                        ratio=ratioCA(j,i)/ratioCB(j,i); % new MA
                        SIT.cb(j,i)=difference/(ratio+1); % cmmt 1st (not anymore)
                        SIT.ca(j,i)=difference-SIT.cb(j,i); % cmmt 1st (not anymore)
                        clear ratio; % cmmt 1st
                    end
                end
                clear difference;
             % Case 8: finite value for CT, but nan for CA, CB, CC ******** see documentation
            
            elseif (isnan(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                cases(j,i)=8; %track how often each case occurrs
                % replace partials with their weighted value OLD
                if qq==2;
                     SIT.ca(j,i)=ratioCA(j,i)*SIT.ct(j,i); % new MA
                     SIT.cb(j,i)=ratioCB(j,i)*SIT.ct(j,i); % new MA
                     SIT.cc(j,i)=ratioCC(j,i)*SIT.ct(j,i); % new MA
                end
                 % NEW_ ONLY 1 ice type so find that ice type and attribute ct value to the appropriate partial concentration
%                  if isnan(origSA(j,i))==0 & isnan(origSB(j,i))==1 & isnan(origSC(j,i))==1;
%                      SIT.ca(j,i)=SIT.ct(j,i);
%                      indA(j,i) = 1;
%                  elseif isnan(origSA(j,i))==1 & isnan(origSB(j,i))==0 & isnan(origSC(j,i))==1;
%                      SIT.cb(j,i) = SIT.ct(j,i);
%                      indB(j,i) = 1;
%                  elseif isnan(origSA(j,i))==1 & isnan(origSB(j,i))==1 & isnan(origSC(j,i))==0;
%                      SIT.cc(j,i) = SIT.ct(j,i);
%                      indC(j,i) = 1;
%                  end
            % Case 9: finite CA, CB, CC, but CT=nan    
            elseif (isfinite(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                    isnan(SIT.ct(j,i))==1)
                cases(j,i)=9; %track how often each case occurrs
                test=SIT.ca(j,i)+SIT.cb(j,i)+SIT.cc(j,i);
                if test<=100 & test>=0;
                    SIT.ct(j,i)=test;
                else
                    SIT.ca(j,i)=nan;SIT.cb(j,i)=nan;SIT.cc(j,i)=nan;
                end
                clear test;
            % Case 10: one (or more) of the partials is nan and CT is nan    
            elseif ((isnan(SIT.ca(j,i))==1 | isnan(SIT.cb(j,i))==1 | isnan(SIT.cc(j,i))==1) & ...
                    isnan(SIT.ct(j,i))==1)
                cases(j,i)=10; %track how often each case occurrs
                % no way of knowing the truth so fill nan
                SIT.ca(j,i)=nan;SIT.cb(j,i)=nan;SIT.cc(j,i)=nan;
            end
        end
        clear j;
    end
    clear i;
    nannuma = sum(isnan(SIT.ca), 'all')
    nannumb = sum(isnan(SIT.cb), 'all')
    nannumt = sum(isnan(SIT.ct), 'all')
    % This shows same number of NANs in ct after both passes
    %    ALSO ca, cb, and cc have same number of nans as ct after second pass 

    % compare partial concentration ratios with stage of development ratios
    dummyCA=SIT.ca;
    dummyCB=SIT.cb;
    dummyCC=SIT.cc;
    dummyCT=SIT.ct;

% --- new Moving Average below ---
% 
    mavgCA=nan(size(dummyCA));
    mavgCB=mavgCA;
    mavgCC=mavgCA;
    mavgCT=mavgCA;
   
    
    yrs = unique(SIT.dv(:,1));
    mnths = unique(SIT.dv(:,2));
    refsF(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(1))";
    for cc = 1:length(yrs)-1
        refsF(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(cc)+"))";
    end
    refsL(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))";
    for cc = 1:length(yrs)-1
        refsL(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(cc)+"))";
    end
    for yy = 1:length(yrs)
        tic
        if qq ==1
            disp(['First Pass SIC ', num2str(yrs(yy))])
        else
            disp(['Second Pass SIC ', num2str(yrs(yy))])
        end
        for mm = 1:length(mnths)
            for gg = 1:length(SIT.lon)
                if yy == 1
                    for rr = 3:length(refsF)
                        ind = find(eval(join(refsF(1:rr))));
                        if sum(~isnan(dummyCA(gg,ind)),'all') >= 2
                            goodca = ind;
                            mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCA(gg, goodca)); clear goodca;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsF)
                        ind = find(eval(join(refsF(1:rr))));
                        if sum(~isnan(dummyCB(gg,ind)),'all') >= 2
                            goodcb = ind;
                            mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCB(gg, goodcb)); clear goodcb;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsF)
                        ind = find(eval(join(refsF(1:rr))));
                        if sum(~isnan(dummyCC(gg,ind)),'all') >= 2
                            goodcc = ind;
                            mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCC(gg, goodcc)); clear goodcc;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsF)
                        ind = find(eval(join(refsF(1:rr))));
                        if sum(~isnan(dummyCT(gg,ind)),'all') >= 2
                            goodct = ind;
                            mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCT(gg, goodct)); clear goodct; 
                            break
                        end
                    end; clear rr
                elseif yy == length(yrs)
                    lstm = SIT.dv(end,2);
                    if mm > lstm;
                        continue
                    else
                        for rr = 3:length(refsL) % takes yy-rr
                            ind = find(eval(join(refsL(1:rr))));
                            if sum(~isnan(dummyCA(gg,ind)),'all') >= 2
                                goodca = ind;
                                mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCA(gg, goodca)); clear goodca;
                                break
                            end
                        end; clear rr
                        for rr = 3:length(refsL) 
                            ind = find(eval(join(refsL(1:rr))));
                            if sum(~isnan(dummyCB(gg,ind)),'all') >= 2
                                goodcb = ind;
                                mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCB(gg, goodcb)); clear goodcb;
                                break
                            end
                        end; clear rr
                        for rr = 3:length(refsL) 
                            ind = find(eval(join(refsL(1:rr))));
                            if sum(~isnan(dummyCC(gg,ind)),'all') >= 2
                                goodcc = ind;
                                mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCC(gg, goodcc)); clear goodcc;
                                break
                            end
                        end; clear rr
                        for rr = 3:length(refsL) 
                            ind = find(eval(join(refsL(1:rr))));
                            if sum(~isnan(dummyCT(gg,ind)),'all') >= 2
                                goodct = ind;
                                mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCT(gg, goodct)); clear goodct;
                                break
                            end
                        end; clear rr
                    end
                else
                    if length(yrs)-yy >= yy % first half or middle years
                        refsM(yy) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))";
                        for aa = 1:length(yrs)-yy
                            if yy-aa >= 1 % within shorter bound
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:)
                                if sum(~isnan(dummyCA(gg,ind)),'all') >= 2
                                    goodca = ind;
                                    mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCA(gg, goodca)); clear goodca;
                                    break
                                end; clear ind
                            elseif yy-aa < 1
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                ind = find(eval(join(refsM(1:yy+aa))));
                                if sum(~isnan(dummyCA(gg,ind)),'all') >= 2
                                    goodca = ind;
                                    mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCA(gg, goodca)); clear goodca;
                                    break
                                end; clear ind 
                            end
                        end
                        for aa = 1:length(yrs)-yy
                            if yy-aa >= 1 % within shorter bound
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                                if sum(~isnan(dummyCB(gg,ind)),'all') >= 2
                                    goodcb = ind;
                                    mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCB(gg, goodcb)); clear goodcb;
                                    break
                                end; clear ind
                            elseif yy-aa < 1
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                ind = find(eval(join(refsM(1:yy+aa))));
                                if sum(~isnan(dummyCB(gg,ind)),'all') >= 2
                                    goodcb = ind;
                                    mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCB(gg, goodcb)); clear goodcb;
                                    break
                                end; clear ind
                            end
                        end
                        for aa = 1:length(yrs)-yy
                            if yy-aa >= 1 % within shorter bound
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                                if sum(~isnan(dummyCC(gg,ind)),'all') >= 2
                                    goodcc = ind;
                                    mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCC(gg, goodcc)); clear goodcc;
                                    break
                                end; clear ind
                            elseif yy-aa < 1
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                ind = find(eval(join(refsM(1:yy+aa))));
                                if sum(~isnan(dummyCC(gg,ind)),'all') >= 2
                                    goodcc = ind;
                                    mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCC(gg, goodcc)); clear goodcc;
                                    break
                                end; clear ind
                            end
                        end
                        for aa = 1:length(yrs)-yy
                            if yy-aa >= 1 % within shorter bound
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                                if sum(~isnan(dummyCT(gg,ind)),'all') >= 2
                                    goodct = ind;
                                    mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCT(gg, goodct)); clear goodct;
                                    break
                                end; clear ind
                            elseif yy-aa < 1
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                ind = find(eval(join(refsM(1:yy+aa))));
                                if sum(~isnan(dummyCT(gg,ind)),'all') >= 2
                                    goodct = ind;
                                    mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCT(gg, goodct)); clear goodct;
                                    break
                                end; clear ind
                            end
                        end
                    elseif length(yrs)-yy < yy % second half of years
                        refsM(yy) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))";
                        for aa = 1:yy-1
                            if yy+aa <= length(yrs) % within shorter bound
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                                if sum(~isnan(dummyCA(gg,ind)),'all') >= 2
                                    goodca = ind;
                                    mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCA(gg, goodca)); clear goodca;
                                    break
                                end; clear ind
                            elseif yy+aa > length(yrs)
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:end))));
                                if sum(~isnan(dummyCA(gg,ind)),'all') >= 2
                                    goodca = ind;
                                    mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCA(gg, goodca)); clear goodca;
                                    break
                                end; clear ind
                            end
                        end
                        for aa = 1:yy-1
                            if yy+aa <= length(yrs) % within shorter bound
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                                if sum(~isnan(dummyCB(gg,ind)),'all') >= 2
                                    goodcb = ind;
                                    mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCB(gg, goodcb)); clear goodcb;
                                    break
                                end; clear ind
                            elseif yy+aa > length(yrs)
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:end))));
                                if sum(~isnan(dummyCB(gg,ind)),'all') >= 2
                                    goodcb = ind;
                                    mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCB(gg, goodcb)); clear goodcb;
                                    break
                                end; clear ind
                            end
                        end
                        for aa = 1:yy-1
                            if yy+aa <= length(yrs) % within shorter bound
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                                if sum(~isnan(dummyCC(gg,ind)),'all') >= 2
                                    goodcc = ind;
                                    mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCC(gg, goodcc)); clear goodcc;
                                    break
                                end; clear ind
                            elseif yy+aa > length(yrs)
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:end))));
                                if sum(~isnan(dummyCC(gg,ind)),'all') >= 2
                                    goodcc = ind;
                                    mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCC(gg, goodcc)); clear goodcc;
                                    break
                                end; clear ind
                            end
                        end
                        for aa = 1:yy-1
                            if yy+aa <= length(yrs) % within shorter bound
                                refsM(yy+aa) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(aa)+"))";
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:yy+aa)))); % should be the same as refsM(:,:)
                                if sum(~isnan(dummyCT(gg,ind)),'all') >= 2
                                    goodct = ind;
                                    mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCT(gg, goodct)); clear goodct;
                                    break
                                end; clear ind
                            elseif yy+aa > length(yrs)
                                refsM(yy-aa) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(aa)+"))|";
                                ind = find(eval(join(refsM(yy-aa:end))));
                                if sum(~isnan(dummyCT(gg,ind)),'all') >= 2
                                    goodct = ind;
                                    mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCT(gg, goodct)); clear goodct;
                                    break
                                end; clear ind
                            end
                        end
                    end
                end
            end
        end
        toc
    end


    ratioCA=mavgCA./mavgCT;
    ratioCB=mavgCB./mavgCT;
    ratioCC=mavgCC./mavgCT;
    
    if qq==1
        cases1P=cases;
    elseif qq==2
        cases2P=cases;
    end
    cases=zeros(size(cases));
end

% find out how many of each case was found
% case1 = sum(cases1P(find(cases1P==1)),'all');
% case2 = sum(cases1P(find(cases1P==2)),'all')/2;
% case3 = sum(cases1P(find(cases1P==3)),'all')/3;
% case4 = sum(cases1P(find(cases1P==4)),'all')/4;
% case5 = sum(cases1P(find(cases1P==5)),'all')/5;
% case6 = sum(cases1P(find(cases1P==6)),'all')/6;
% case7 = sum(cases1P(find(cases1P==7)),'all')/7;
% case8 = sum(cases1P(find(cases1P==8)),'all')/8;
% case9 = sum(cases1P(find(cases1P==9)),'all')/9;
% case10 = sum(cases1P(find(cases1P==10)),'all')/10;




% avgb4CT = avgSIC; % confirm that some nans were filled in the following loop
% for ii = 1:length(avgSIC(1,:)); % fill Bremen nans with CT values when possible
%     sicnans = find(isnan(avgSIC(:,ii))==1);
%     avgSIC(sicnans,ii) = SIT.ct(sicnans,ii);
%     clear sicnans 
% end
% nansb4 = sum(isnan(avgb4CT));
% perb4 = (nansb4./length(avgSIC(:,1)))*100;
% nansavg = sum(isnan(avgSIC));
% peravg = (nansavg./length(avgSIC(:,1)))*100;
% figure
% plot(perb4);hold on;plot(peravg);legend(['Before CT fill', 'After CT fill']);clear nansb4 perb4 nansavg peravg

for i = 1:length(avgSIC(1,:)) % create high resolution partial concentrations from the Bremen SIC data
   CAhires(:,i)=avgSIC(:,i).*ratioCA(:,i); 
   CBhires(:,i)=avgSIC(:,i).*ratioCB(:,i);
   CChires(:,i)=avgSIC(:,i).*ratioCC(:,i);
end
    
percca = (sum(isnan(SIT.ca),'all')/(length(SIT.ca(:,1)) * length(SIT.ca(1,:))))*100;
perccb = (sum(isnan(SIT.cb),'all')/(length(SIT.cb(:,1)) * length(SIT.cb(1,:))))*100;
perccc = (sum(isnan(SIT.cc),'all')/(length(SIT.cc(:,1)) * length(SIT.cc(1,:))))*100;
percct = (sum(isnan(SIT.ct),'all')/(length(SIT.ct(:,1)) * length(SIT.ct(1,:))))*100;
percsa = (sum(isnan(SIT.sa),'all')/(length(SIT.sa(:,1)) * length(SIT.sa(1,:))))*100;
percsb = (sum(isnan(SIT.sb),'all')/(length(SIT.sb(:,1)) * length(SIT.sb(1,:))))*100;
percsc = (sum(isnan(SIT.sc),'all')/(length(SIT.sc(:,1)) * length(SIT.sc(1,:))))*100;
disp(['% NaN: ca = ', num2str(percca),'% | ','cb = ', num2str(perccb),'% | ','cc = ', num2str(perccc),'% | ',...
    'ct = ', num2str(percct),'% | ','sa = ', num2str(percsa),'% | ','sb = ', num2str(percsb),'% | ','sc = ', num2str(percsc),'% | '])




% --- new Moving Average above ---
    clear test Cbc IB IC tempnanSA tempnanSB tempnanSC dummyCA dummyCB dummyCC dummyCT;





%% Calculate Sea Ice Thickness in cm THIS ONE

% SIT.H=(CAhires/100).*SIT.sa+(CBhires/100).*SIT.sb+(CChires/100).*SIT.sc;
% this does not allow for a single term with a NaN to compute a NaN for
% thickness unless all terms are NaN
for i=1:length(avgSIC(1,:));
    for j=1:length(SIT.lon);
        termA=(CAhires(j,i)/100)*SIT.sa(j,i);
        termB=(CBhires(j,i)/100)*SIT.sb(j,i);
        termC=(CChires(j,i)/100)*SIT.sc(j,i);
        if isfinite(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1
            SIT.H(j,i)=termA+termB+termC;
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isnan(termC)==1
            SIT.H(j,i)=termA+termB;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isfinite(termC)==1
            SIT.H(j,i)=termA+termC;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isnan(termC)==1
            SIT.H(j,i)=termA;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1
            SIT.H(j,i)=termB+termC;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isnan(termC)==1
            SIT.H(j,i)=termB;
        elseif isnan(termA)==1 & isnan(termB)==1 & isfinite(termC)==1
            SIT.H(j,i)=termC;
        else
            Hhires(j,i)=termA+termB+termC;
        end
        clear termA termB termC
    end
    clear j;
end

%  no_ice = find(avgSIC==0);
%  SIT.H(no_ice)=0;

disp('Sea Ice Thickness calculation complete')
clear i;



 figure
 histogram(SIT.H)

%% add the new computed partials to the SIT structure
SIT.ca_hires=CAhires;
SIT.cb_hires=CBhires;
SIT.cc_hires=CChires;
SIT.ct_hires=sic_compare;

%% MAKE A MOVIE
% only after finishing the SIT calculation

for ii = 1:length(SIT.H(1,:));
    m_basemap('a', [112, 123, 5], [-67.6, -64.5, 1],'sdL_v10',[2000,4000],[8, 1]) %sector10
    %m_basemap('a', [284.5 308], [-69.2 -60.2],'sdL_v10',[2000,4000],[8, 1]); %sector18
    %m_basemap('a', [227 295], [-75 -65],'sdL_v10',[2000,4000],[8, 1]); %subpolarEP
    set(gcf, 'Position', [600, 500, 1000, 700]) %subpolarEP
    %set(gcf, 'Position', [600, 500, 800, 700])
    m_scatter(SIT.lon, SIT.lat, 25,SIT.H(:,ii), 'filled')
    if isnan(SIT.dv(ii))==0
        xlabel(datestr(datetime(SIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
    else
        xlabel('-- --- ----')
    end
    colormap(jet(12))
    caxis([0,600])
    %caxis([0,1])
    cbh = colorbar
    cbh.Ticks = [0:50:600];
    F(ii) = getframe(gcf);
    close gcf
end

writerobj = VideoWriter('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Figures/Videos/S10_Nc8.avi');
writerobj.FrameRate = 5;

open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp('Success! Video saved')
clear F


%% save
% save /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/SabrinaSITqc.mat SIT -v7.3
% save /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/MertzSITqc.mat SIT -v7.3
%save /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/sector12SIT.mat SIT -v7.3
%save /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/sabrinaSIT_oldSIC.mat SIT -v7.3
%save /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/first_xy/sector10SIT_newcase8.mat  SIT -v7.3



load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/first_xy/sector10SIT.mat 

%% Sector 10
d = 150;m_basemap('a', [112, 123, 5], [-67.6, -64.5, 1],'sdL_v10',[2000,4000],[8, 1])
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(SIT.lon, SIT.lat, 15, SIT.H(:,d), 'filled')
xlabel(datestr(datetime(SIT.dv(d,:), 'Format', 'dd MMM yyyy')))
%cmocean('-ice', 12);
colormap(jet(12)) % thickness
caxis([0,600]);% thickness
cbh = colorbar;
cbh.Ticks = [0:50:600]; % thickness
% colormap(jet(10))% concentration
% caxis([0,100]);% concentration
%cbh = colorbar;
% cbh.Ticks = [0: 10: 100] % concentration
 

%print('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Figures/first_look_3125/10Mar2003/SIT.png','-dpng', '-r400')


%m_propmap(1, 'a', [112, 123, 5], [-67.6, -64.5, 1], 'd', SIT.lon, SIT.lat, SIT.H, 12, 'ver', '[cm]', 'linear', [0:50:600]);



%% sector 18
m_basemap('a', [284.5 308], [-69.2 -60.2],'sdL_v10',[2000,4000],[8, 1]);
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(SIT.lon, SIT.lat, 5,SIT.H(:,100), 'filled')
colormap('jet')
%cmocean('ice')
caxis([0,600]);
colorbar

%% Subpolar East Pacific
m_basemap('a', [227 295], [-75 -65],'sdL_v10',[2000,4000],[8, 1]);
set(gcf, 'Position', [600, 500, 1000, 700])
m_scatter(SIT.lon, SIT.lat, 2,SIT.H(:,220), 'filled')
colormap(jet(12))
%cmocean('ice', (12))
caxis([0,600]);
cbh = colorbar;
cbh.Ticks = [0:50:600];


%% avg for sector at each time

SavgH = nanmean(SIT.H);

figure
set(gcf, 'Position', [600, 500, 1000, 600])
plot( SIT.dn, SavgH)
title('Subpolar East Pacific Average')
ylabel('Sea Ice Thickness (cm)')
datetick('x', 'yyyy', 'keepticks')
xlim([min(SIT.dn),max(SIT.dn)])
%print('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Figures/Averages/SubpolarEP.png','-dpng', '-r400')

%% Average %nan timeseries


numnans = sum(isnan(SIT.H));
pernans = (numnans./length(SIT.H(:,1)))*100;
numnansCA = sum(isnan(SIT.ca));pernansCA = (numnansCA./length(SIT.ca(:,1)))*100;
numnansCB = sum(isnan(SIT.cb));pernansCB = (numnansCB./length(SIT.cb(:,1)))*100;
numnansCC = sum(isnan(SIT.cc));pernansCC = (numnansCC./length(SIT.cc(:,1)))*100;
numnansCT = sum(isnan(SIT.ct));pernansCT = (numnansCT./length(SIT.ct(:,1)))*100;
%numnansSIC = sum(isnan(avgSIC));pernansSIC = (numnansSIC./length(avgSIC(:,1)))*100;
%numnansCAH = sum(isnan(CAhires));pernansCAH = (numnansCAH./length(CAhires(:,1)))*100;


figure
set(gcf, 'Position', [600, 500, 800,1100])
subplot(3,1,1);
plot( SIT.dn, pernans, 'LineWidth', 1.3);hold on
yline(mean(pernans), 'r--', 'LineWidth', 1.4);
plot(SIT.dn, pernansCA,'LineWidth', 1.3);
plot(SIT.dn, pernansCB,'LineWidth', 1.3);
plot(SIT.dn, pernansCC,'LineWidth', 1.3);
plot(SIT.dn, pernansCT,'LineWidth', 1.3);
title('Sector 10')
ylabel('% Not a Number')
datetick('x', 'mmm yyyy', 'keeplimits')
xlim([min(SIT.dn-70),max(SIT.dn+70)])
ylim([5,60]);
grid on
legend('SIT', 'SIT Mean','CA','CB','CC','CT');

subplot(3,1,2);
plot( SIT.dn, pernans, 'LineWidth', 1.3);hold on
yline(mean(pernans), 'r--', 'LineWidth', 1.4);
plot(SIT.dn, pernansSIC, 'lineWidth', 1.3);
title('Sector 10')
ylabel('% Not a Number')
datetick('x', 'mmm yyyy', 'keeplimits')
xlim([min(SIT.dn-70),max(SIT.dn+70)])
ylim([5,60]);
grid on
legend('SIT', 'SIT Mean','SIC');

subplot(3,1,3);
plot( SIT.dn, pernans, 'LineWidth', 1.3);hold on
yline(mean(pernans), 'r--', 'LineWidth', 1.4);
plot(SIT.dn, pernansCAH, 'lineWidth', 1.3);
title('Sector 10')
ylabel('% Not a Number')
datetick('x', 'mmm yyyy', 'keeplimits')
xlim([min(SIT.dn-70),max(SIT.dn+70)])
ylim([5,60]);
grid on
legend('SIT', 'SIT Mean','CAhires');
%print('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Figures/Averages/Sector_10/ALLmeanNANxysubplot.png','-dpng', '-r400')



%% m_propmap example

m_propmap(1,'m',[0 360 60 30],[-80 -40  10  5],'d',SIT.lon,SIT.lat,SIT.H(:,100),4,'ver','SIT [cm]','linear',[0:10:100]);  




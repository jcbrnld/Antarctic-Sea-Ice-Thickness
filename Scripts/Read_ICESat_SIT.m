% 19-May_21 
% Jacob Arnold

% View SIT derived from ICESat (Kurtz and Marcus)
% ON = Spring
% FM = Summer
% MJ = Fall

% dates:
% 2003 ||                                           ON03 = Oct1-Nov18
% 2004 || FM04 = Feb17-Mar21    MJ04 = May18-Jun21  ON04 = Oct3-Nov08
% 2005 || FM05 = Feb17-Mar24    MJ05 = May20-Jun23
% 2006 || FM06 = Feb22-Mar27    MJ06 = May24-Jun26  ON06 = Oct25-Nov27
% 2007 || MA07 = Mar12-Apr14                        ON07 = Oct02-Nov05
% 2008 || FM08 = Feb17-Mar21
names={'ON03', 'FM04', 'MJ04', 'ON04', 'FM05', 'MJ05', 'FM06', 'MJ06',...
    'ON06', 'MA07', 'ON07', 'FM08'};
list={'Sector01', 'Sector02', 'Sector03', 'Sector04', 'Sector05', 'Sector06',...
    'Sector07', 'Sector08', 'Sector09', 'Sector10', 'Sector11', 'Sector12', 'Sector13',...
    'Sector14', 'Sector15', 'Sector16', 'Sector17', 'Sector18', 'All Subpolar', 'Subpolar Atlantic',...
    'Subpolar Indian Ocean', 'Subpolar West Pacific', 'Subpolar East Pacific',};
[indx,tf] = listdlg('PromptString',{'Which sector do you wish to use?'},...
    'SelectionMode','single','ListString', list);
if indx<10
    sector = ['0', num2str(indx)];
elseif indx<19 & indx>9
    sector = num2str(indx);
elseif indx==19;sector = 'subpolar';elseif indx==20; sector='subpolarao';
elseif indx==21;sector='subpolario';elseif indx==22; sector='subpolarwp';
elseif indx==23;sector='subpolarep';
end

if length(sector)==2
    sect = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    load(['ICE/ICETHICKNESS/Data/Mat_files/Final/Sectors/Sector',sector,'.mat']);
else
    sect = load(['ICE/Concentration/so-zones/',sector,'_SIC.mat']);
    load(['ICE/ICETHICKNESS/Data/Mat_files/Final/Sectors/',sector,'.mat']);
end
SIT1 = SIT; clear SIT
sectSIC = struct2cell(sect); clear sect

% Create variable of ideal lon and lat limits for sector plots
splot{1,1}=[289 312]; splot{1,2}=[-73 -60]; splot{2,1}=[296 337]; splot{2,2}=[-79 -70];
splot{3,1}=[332 358]; splot{3,2}=[-77 -69]; splot{4,1}=[0 26]; splot{4,2}=[-71 -68];
splot{5,1}=[24 55]; splot{5,2}=[-71 -65]; splot{6,1}=[53.5 68.5]; splot{6,2}=[-68 -65.2];
splot{7,1}=[67 86]; splot{7,2}=[-70.5 -65]; splot{8,1}=[84.5 100.5]; splot{8,2}=[-67.5 -63.5];
splot{9,1}=[99.5 113.5]; splot{9,2}=[-67.5 -63.5]; splot{10,1}=[112 123]; splot{10,2}=[-67.5 -64.5];
splot{11,1}=[121 135]; splot{11,2}=[-67.5 -64.2]; splot{12,1}=[133.5 150.5]; splot{12,2}=[-69 -64.5];
splot{13,1}=[149 173]; splot{13,2}=[-72 -65]; splot{14,1}=[160 207]; splot{14,2}=[-79 -69];
splot{15,1}=[202 235.5]; splot{15,2}=[-78 -71.9]; splot{16,1}=[232 262]; splot{16,2}=[-76.2 -69];
splot{17,1}=[258 295]; splot{17,2}=[-75 -67]; splot{18,1}=[282.5 308]; splot{18,2}=[-70 -59];


londom = splot{str2num(sector),1}; latdom = splot{str2num(sector),2};




% Columns are lat, lon, Freeboard, Thickness

ON03 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/ON03_interp_25km_grid.txt');
ON03(ON03==-999)=nan;
%ON03(ON03==0)=nan;
ON03dn=datenum(2003,10,01):datenum(2003,11,18);ISatM(1,1)=median(ON03dn);

FM04 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/FM04_interp_25km_grid.txt');
FM04(FM04==-999)=nan;
%FM04(FM04==0)=nan;
FM04dn=datenum(2004,02,17):datenum(2004,03,21);ISatM(1,2)=median(FM04dn);
MJ04 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/MJ04_interp_25km_grid.txt');
MJ04(MJ04==-999)=nan;
%MJ04(MJ04==0)=nan;
MJ04dn=datenum(2004,05,18):datenum(2004,06,21);ISatM(1,3)=median(MJ04dn);
ON04 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/ON04_interp_25km_grid.txt');
ON04(ON04==-999)=nan;
%ON04(ON04==0)=nan;
ON04dn=datenum(2004,10,03):datenum(2004,11,08);ISatM(1,4)=median(ON04dn);

FM05 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/FM05_interp_25km_grid.txt');
FM05(FM05==-999)=nan;
%FM05(FM05==0)=nan;
FM05dn=datenum(2005,02,17):datenum(2005,03,24);ISatM(1,5)=median(FM05dn);
MJ05 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/MJ05_interp_25km_grid.txt');
MJ05(MJ05==-999)=nan;
%MJ05(MJ05==0)=nan;
MJ05dn=datenum(2005,05,20):datenum(2005,06,23);ISatM(1,6)=median(MJ05dn);

FM06 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/FM06_interp_25km_grid.txt');
FM06(FM06==-999)=nan;
%FM06(FM06==0)=nan;
FM06dn=datenum(2006,02,22):datenum(2006,03,27);ISatM(1,7)=median(FM06dn);
MJ06 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/MJ06_interp_25km_grid.txt');
MJ06(MJ06==-999)=nan;
%MJ06(MJ06==0)=nan;
MJ06dn=datenum(2006,05,24):datenum(2006,06,26);ISatM(1,8)=median(MJ06dn);
ON06 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/ON06_interp_25km_grid.txt');
ON06(ON06==-999)=nan;
%ON06(ON06==0)=nan;
ON06dn=datenum(2006,10,25):datenum(2006,11,27);ISatM(1,9)=median(ON06dn);

MA07 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/MA07_interp_25km_grid.txt');
MA07(MA07==-999)=nan;
%MA07(MA07==0)=nan;
MA07dn=datenum(2007,03,12):datenum(2007,04,14);ISatM(1,10)=median(MA07dn);
ON07 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/ON07_interp_25km_grid.txt');
ON07(ON07==-999)=nan;
%ON07(ON07==0)=nan;
ON07dn=datenum(2007,10,02):datenum(2007,11,05);ISatM(1,11)=median(ON07dn);

FM08 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Gridded/FM08_interp_25km_grid.txt');
FM08(FM08==-999)=nan;
%FM08(FM08==0)=nan;
FM08dn=datenum(2008,02,17):datenum(2008,03,21);ISatM(1,12)=median(FM08dn);


% Actual cruise track
track.ON03 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/ON03.txt');
track.FM04 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/FM04.txt');
track.MJ04 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/MJ04.txt');
track.ON04 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/ON04.txt');
track.FM05 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/FM05.txt');
track.MJ05 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/MJ05.txt');
track.FM06 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/FM06.txt');
track.MJ06 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/MJ06.txt');
track.ON06 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/ON06.txt');
track.MA07 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/MA07.txt');
track.ON07 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/ON07.txt');
track.FM08 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/FM08.txt');
trackC = struct2cell(track);


%% Snip off sector 

plon = sectSIC{1,1}.plon;
plat = sectSIC{1,1}.plat;

%SITsat=nan(92,12);
trN = find(isnan(ON03(:,4))==0); ON03NL = ON03(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(ON03NL(:,2),ON03NL(:,1), plon, plat)==1);
ON03S = ON03NL(sect,:);clear sect; SITsat(:,1)=ON03S(:,4);clear trN;

trN = find(isnan(FM04(:,4))==0); FM04NL = FM04(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(FM04NL(:,2),FM04NL(:,1), plon, plat)==1);
FM04S = FM04NL(sect,:);clear sect; SITsat(:,2)=FM04S(:,4);

trN = find(isnan(MJ04(:,4))==0); MJ04NL = MJ04(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(MJ04NL(:,2),MJ04NL(:,1), plon, plat)==1);
MJ04S = MJ04NL(sect,:);clear sect; SITsat(:,3)=MJ04S(:,4);

trN = find(isnan(ON04(:,4))==0); ON04NL = ON04(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(ON04NL(:,2),ON04NL(:,1), plon, plat)==1);
ON04S = ON04NL(sect,:);clear sect; SITsat(:,4)=ON04S(:,4);clear trN

trN = find(isnan(FM05(:,4))==0); FM05NL = FM05(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(FM05NL(:,2),FM05NL(:,1), plon, plat)==1);
FM05S = FM05NL(sect,:);clear sect; SITsat(:,5)=FM05S(:,4);

trN = find(isnan(MJ05(:,4))==0); MJ05NL = MJ05(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(MJ05NL(:,2),MJ05NL(:,1), plon, plat)==1);
MJ05S = MJ05NL(sect,:);clear sect; SITsat(:,6)=MJ05S(:,4);

trN = find(isnan(FM06(:,4))==0); FM06NL = FM06(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(FM06NL(:,2),FM06NL(:,1), plon, plat)==1);
FM06S = FM06NL(sect,:);clear sect; SITsat(:,7)=FM06S(:,4);

trN = find(isnan(MJ06(:,4))==0); MJ06NL = MJ06(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(MJ06NL(:,2),MJ06NL(:,1), plon, plat)==1);
MJ06S = MJ06NL(sect,:);clear sect; SITsat(:,8)=MJ06S(:,4);

trN = find(isnan(ON06(:,4))==0); ON06NL = ON06(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(ON06NL(:,2),ON06NL(:,1), plon, plat)==1);
ON06S = ON06NL(sect,:);clear sect; SITsat(:,9)=ON06S(:,4);

trN = find(isnan(MA07(:,4))==0); MA07NL = MA07(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(MA07NL(:,2),MA07NL(:,1), plon, plat)==1);
MA07S = MA07NL(sect,:);clear sect; SITsat(:,10)=MA07S(:,4);

trN = find(isnan(ON07(:,4))==0); ON07NL = ON07(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(ON07NL(:,2),ON07NL(:,1), plon, plat)==1);
ON07S = ON07NL(sect,:);clear sect; SITsat(:,11)=ON07S(:,4);

trN = find(isnan(FM08(:,4))==0); FM08NL = FM08(trN,:);% REMOVE THE LAND GRID POINTS
sect=find(inpolygon(FM08NL(:,2),FM08NL(:,1), plon, plat)==1);
FM08S = FM08NL(sect,:);clear sect; SITsat(:,12)=FM08S(:,4);


%%

% Interpolate
SITsatI=nan(length(SIT1.H),12);

Q = scatteredInterpolant(ON03NL(:,2), ON03NL(:,1), ON03NL(:,4), 'linear');
SITsatI(:,1) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(FM04NL(:,2), FM04NL(:,1), FM04NL(:,4), 'linear');
SITsatI(:,2) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(MJ04NL(:,2), MJ04NL(:,1), MJ04NL(:,4), 'linear');
SITsatI(:,3) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(ON04NL(:,2), ON04NL(:,1), ON04NL(:,4), 'linear');
SITsatI(:,4) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(FM05NL(:,2), FM05NL(:,1), FM05NL(:,4), 'linear');
SITsatI(:,5) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(MJ05NL(:,2), MJ05NL(:,1), MJ05NL(:,4), 'linear');
SITsatI(:,6) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(FM06NL(:,2), FM06NL(:,1), FM06NL(:,4), 'linear');
SITsatI(:,7) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(MJ06NL(:,2), MJ06NL(:,1), MJ06NL(:,4), 'linear');
SITsatI(:,8) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(ON06NL(:,2), ON06NL(:,1), ON06NL(:,4), 'linear');
SITsatI(:,9) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(MA07NL(:,2), MA07NL(:,1), MA07NL(:,4), 'linear');
SITsatI(:,10) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

Q = scatteredInterpolant(ON07NL(:,2), ON07NL(:,1), ON07NL(:,4), 'linear');
SITsatI(:,11) = Q(double(SIT1.lon), double(SIT1.lat));clear Q;

Q = scatteredInterpolant(FM08NL(:,2), FM08NL(:,1), FM08NL(:,4), 'linear');
SITsatI(:,12) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 


%% View individually 
m_basemap('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1]);% sector01
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(SIT1.lon, SIT1.lat, 10, SITsatI(:,4),  'filled')
colormap(jet(10)); caxis([0,2]);
cbh = colorbar; cbh.Ticks = [0:.2:2];


%%

% View
m_basemap('a', londom, latdom, 'sdL_v10',[2000,4000],[8, 1]) %sector10
set(gcf,'Position',[500,600,700,800])
m_scatter(ON07S(:,2), ON07S(:,1), 90, SITsat(:,11), 'filled')
colormap(jet(10))
caxis([0,2]);
cbh = colorbar;
cbh.Ticks = [0:.2:2];




figure
set(gcf,'Position',[500,600,1200,500])
plot(SIT1.dn,nanmean(SIT1.H));hold on;
plot(ISatM, nanmean(SITsat).*100, 'm','LineWidth', 1.2)
datetick('x', 'yyyy', 'keepticks')
xlim([min(SIT1.dn),max(SIT1.dn)])
grid on; grid minor
legend('SOD SIT', 'ICESat SIT')
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/SODvsICESat_A10.png','-dpng', '-r400')



shortT = find(SIT1.dn>=min(ISatM) & SIT1.dn<=max(ISatM));
figure
set(gcf,'Position',[500,600,1000,500])
plot(SIT1.dn(shortT),nanmean(SIT1.H(:,shortT)));hold on;
plot(ISatM, nanmean(SITsat).*100, 'm','LineWidth', 1.2)
datetick('x', 'yyyy', 'keepticks')
xlim([min(SIT1.dn(shortT)),max(SIT1.dn(shortT))])
grid on; grid minor
legend('SOD SIT', 'ICESat SIT')
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/SODvsICESatZoom_A10.png','-dpng', '-r400')


%% Average SOD SIT to same timescale

I1 = find(SIT1.dn>=min(ON03dn) & SIT1.dn<=max(ON03dn));
I2 = find(SIT1.dn>=min(FM04dn) & SIT1.dn<=max(FM04dn));
I3 = find(SIT1.dn>=min(MJ04dn) & SIT1.dn<=max(MJ04dn));
I4 = find(SIT1.dn>=min(ON04dn) & SIT1.dn<=max(ON04dn));
I5 = find(SIT1.dn>=min(FM05dn) & SIT1.dn<=max(FM05dn));
I6 = find(SIT1.dn>=min(MJ05dn) & SIT1.dn<=max(MJ05dn));
I7 = find(SIT1.dn>=min(FM06dn) & SIT1.dn<=max(FM06dn));
I8 = find(SIT1.dn>=min(MJ06dn) & SIT1.dn<=max(MJ06dn));
I9 = find(SIT1.dn>=min(ON06dn) & SIT1.dn<=max(ON06dn));
I10 = find(SIT1.dn>=min(MA07dn) & SIT1.dn<=max(MA07dn));
I11 = find(SIT1.dn>=min(ON07dn) & SIT1.dn<=max(ON07dn));
I12 = find(SIT1.dn>=min(FM08dn) & SIT1.dn<=max(FM08dn));


ASITdn(1)=median(SIT1.dn(I1));ASITdn(2)=median(SIT1.dn(I2));
ASITdn(3)=median(SIT1.dn(I3));ASITdn(4)=median(SIT1.dn(I4));
ASITdn(5)=median(SIT1.dn(I5));ASITdn(6)=median(SIT1.dn(I6));
ASITdn(7)=median(SIT1.dn(I7));ASITdn(8)=median(SIT1.dn(I8));
ASITdn(9)=median(SIT1.dn(I9));ASITdn(10)=median(SIT1.dn(I10));
ASITdn(11)=median(SIT1.dn(I11));ASITdn(12)=median(SIT1.dn(I12));


ASITh(1) = nanmean(SIT1.H(:,I1),'all');ASITh(2) = nanmean(SIT1.H(:,I2),'all');
ASITh(3) = nanmean(SIT1.H(:,I3),'all');ASITh(4) = nanmean(SIT1.H(:,I4),'all');
ASITh(5) = nanmean(SIT1.H(:,I5),'all');ASITh(6) = nanmean(SIT1.H(:,I6),'all');
ASITh(7) = nanmean(SIT1.H(:,I7),'all');ASITh(8) = nanmean(SIT1.H(:,I8),'all');
ASITh(9) = nanmean(SIT1.H(:,I9),'all');ASITh(10) = nanmean(SIT1.H(:,I10),'all');
ASITh(11) = nanmean(SIT1.H(:,I11),'all');ASITh(12) = nanmean(SIT1.H(:,I12),'all');

ASIThG(:,1) = nanmean(SIT1.H(:,I1),2);ASIThG(:,2) = nanmean(SIT1.H(:,I2),2);
ASIThG(:,3) = nanmean(SIT1.H(:,I3),2);ASIThG(:,4) = nanmean(SIT1.H(:,I4),2);
ASIThG(:,5) = nanmean(SIT1.H(:,I5),2);ASIThG(:,6) = nanmean(SIT1.H(:,I6),2);
ASIThG(:,7) = nanmean(SIT1.H(:,I7),2);ASIThG(:,8) = nanmean(SIT1.H(:,I8),2);
ASIThG(:,9) = nanmean(SIT1.H(:,I9),2);ASIThG(:,10) = nanmean(SIT1.H(:,I10),2);
ASIThG(:,11) = nanmean(SIT1.H(:,I11),2);ASIThG(:,12) = nanmean(SIT1.H(:,I12),2);

%% plot on same temporal scale


figure
set(gcf,'Position',[500,600,1000,500])
plot(ASITdn, nanmean(ASIThG));hold on;
plot(ISatM, nanmean(SITsatI).*100, 'm', 'LineWidth', 1.2);
datetick('x', 'mm-yyyy');
grid on; grid minor
xlim([min(ASITdn)-50, max(ASITdn)+50]);
set(gca,'XTickLabelRotation',35);
legend('SOD SIT', 'ICESat SIT', 'Location', 'northwest');
title({'SOD averaged to ICESat interval', 'ICESat interpolated to SOD grid'});
%print('ICE/ICETHICKNESS/Figures/Averages/Sector_01/SODvsICESatSameA_Interp.png','-dpng', '-r400')




%% Compare interpolated and averaged

for ii=1:12
    m_basemap('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1]) %sector10
    m_scatter(SIT1.lon, SIT1.lat, 12, ASIThG(:,ii), 'filled');
    colormap(jet(10))
    caxis([0,200]);
    cbh = colorbar;
    cbh.Ticks = [0:20:200];xlabel([names(ii), 'SOD']);
    %print(['ICE/ICETHICKNESS/Figures/ICESat/compare/S10/',cell2mat(names(ii)),'SOD.png'], '-dpng', '-r200');
    
    m_basemap('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1]) %sector10
    m_scatter(SIT1.lon, SIT1.lat, 12, SITsatI(:,ii).*100, 'filled');hold on
    m_scatter(trackC{ii,1}(:,3), trackC{ii,1}(:,2), 10, 'm','filled')
    colormap(jet(10))
    caxis([0,200]);
    cbh = colorbar;
    cbh.Ticks = [0:20:200];xlabel([names(ii), 'ICESat']);
    %print(['ICE/ICETHICKNESS/Figures/ICESat/compare/S10/track/',cell2mat(names(ii)),'ICESatwT.png'], '-dpng', '-r200');
end
%%
for ii=1:12
    m_basemap('a', [112, 123, 5], [-67.6, -64.5, 1],'sdL_v10',[2000,4000],[8, 1]) %sector10
    tdif = ASIThG(:,ii)-(SITsatI(:,ii).*100);
    m_scatter(SIT1.lon, SIT1.lat, 13, tdif,'filled');
    hold on; m_scatter(trackC{ii,1}(:,3), trackC{ii,1}(:,2), 10, 'm', 'filled')
    cmocean('balance',10)
    caxis([-200,200]);
    cbh = colorbar;
    cbh.Ticks = [-200:40:200];xlabel([names(ii), 'SOD-ICESat']);
    clear tdif
    %print(['ICE/ICETHICKNESS/Figures/ICESat/compare/S10/difference/',cell2mat(names(ii)),'SOD-ICESatwT.png'], '-dpng', '-r200');

end
    
%% plot track data

for ii = 1:12
    m_basemap('p', [0,360,60],[-85,-45,10])
    set(gcf, 'position',[500,600,800,700])
    m_scatter(trackC{ii,1}(:,3), trackC{ii,1}(:,2), 10, trackC{ii,1}(:,5).*100,'filled');
    colormap(jet(10))
    caxis([0,200]);
    cbh = colorbar;
    cbh.Ticks = [0:20:200];xlabel([names(ii), 'ICESat']);
    %print(['ICE/ICETHICKNESS/Figures/ICESat/Track/',cell2mat(names(ii)),'ICESatTrack.png'], '-dpng', '-r300');

end








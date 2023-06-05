% 24-May-2021

% Jacob Arnold

% Check out ESA EnviSat SIT data

%ncdisp('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/2003/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-200309-fv2.0.nc')
% Variables to import : lat, lon, sea_ice_thickness
path2research=[];
% Sep 2009
lat = ncread([path2research,'ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/2003/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-200309-fv2.0.nc'], 'lat');
lon = ncread([path2research,'ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/2003/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-200309-fv2.0.nc'], 'lon');
esSIT = ncread([path2research,'ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/2003/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-200309-fv2.0.nc'], 'sea_ice_thickness');

latv=lat(:);lonv=lon(:);esSITv=esSIT(:);

m_basemap('p',[0,360,60],[-85,-50,10]);
set(gcf,'Position', [500,600,800,700])
m_scatter(lonv,latv,27,esSITv.*100,'filled');
colormap(jet(10))
caxis([0,200]);
cbh = colorbar;
cbh.Ticks = [0:20:200];xlabel('Sep_2009')

% lat1 = ncread('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/2010/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-201002-fv2.0.nc', 'lat');
% lat1v = lat1(:);
% Based on this it appears the grid may remain constant

path = [path2research,'ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/'];
years = {'2003','2004','2005','2006','2007','2008','2009','2010','2011','2012'};

lat2 = ncread([path, cell2mat(years(1)),'/' 'ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-200309-fv2.0.nc'], 'lat');


%% create .mat file of all data --- Skip if already completed

path = 'ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/';
years = {'2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012'};

esSIT.SIT=[];esSIT.dv=[];
for ii = 1:length(years)
    if cell2mat(years(ii))=='2002'
        jc = {'06', '07', '08', '09', '10', '11', '12'};
        for jj=1:7
            data = ncread([path,cell2mat(years(ii)),'/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-',cell2mat(years(ii)),cell2mat(jc(jj)),'-fv2.0.nc'],'sea_ice_thickness');
            data=data(:);
            SIT1(:,jj)=data; clear data
            dv1(jj,1)=eval(cell2mat(years(ii)));
            dv1(jj,2)=eval(cell2mat(jc(jj)));
        end
        
    elseif cell2mat(years(ii))=='2012'
        rc={'01','02','03'};
        for rr=1:3
            data = ncread([path,cell2mat(years(ii)),'/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-',cell2mat(years(ii)),cell2mat(rc(rr)),'-fv2.0.nc'],'sea_ice_thickness');
            data=data(:);
            SIT1(:,rr)=data; clear data
            dv1(rr,1)=eval(cell2mat(years(ii)));
            dv1(rr,2)=eval(cell2mat(rc(rr)));
        end
        
    else
        mc = {'01','02','03','04','05','06','07','08','09','10','11','12'};
        for mm = 1:12
            data = ncread([path,cell2mat(years(ii)),'/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-',cell2mat(years(ii)),cell2mat(mc(mm)),'-fv2.0.nc'],'sea_ice_thickness');
            data=data(:);
            SIT1(:,mm)=data; clear data
            dv1(mm,1)=eval(cell2mat(years(ii)));
            dv1(mm,2)=eval(cell2mat(mc(mm)));
        end
        
        
    end
    
   esSIT.SIT = [esSIT.SIT,SIT1];clear SIT1
   esSIT.dv = [esSIT.dv;dv1];clear dv1
end
clear ii jj rr mm rc mc jc

esSIT.lat = ncread('ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/2003/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-200309-fv2.0.nc', 'lat');
esSIT.lon = ncread('ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/2003/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-200309-fv2.0.nc', 'lon');
esSIT.lat = esSIT.lat(:);
esSIT.lon = esSIT.lon(:);
esSIT.dv(:,3)=15;
esSIT.dn = datenum(esSIT.dv(:,1),esSIT.dv(:,2), esSIT.dv(:,3));

save ICE/ICETHICKNESS/Data/MAT_files/Altimetry/ESA_EnviSat/EnviSat_SIT.mat  esSIT -v7.3;



%% START HERE FOR ANALYSES   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
path2research=[];


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
    %sect = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    load(['ICE/ICETHICKNESS/Data/Mat_files/Final/Sectors/Sector',sector,'.mat']);
else
    %sect = load(['ICE/Concentration/so-zones/',sector,'_SIC.mat']);
    load(['ICE/ICETHICKNESS/Data/Mat_files/Final/Sectors/',sector,'.mat']);
end

% Old version: uncomment sect in if statement above to use this
% sectSIC = struct2cell(sect); clear sect
% plon = sectSIC{1,1}.plon;
% plat = sectSIC{1,1}.plat;

% ----------------------------
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

SIT1 = SIT; clear SIT


% Find BOUNDARY of sector grid and create lon/lat of sect polygon
sectBound = boundary(double(SIT1.lon), double(SIT1.lat));
plon = SIT1.lon(sectBound); plat = SIT1.lat(sectBound);

% test boundary:
% m_basemap('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1]);
% set(gcf, 'position', [500, 600, 1200, 700])
% m_scatter(SIT1.lon(sectBound), SIT1.lat(sectBound), 200, 'LineWidth', 1.1)
% hold on
% m_scatter(sect.sector01.plon, sect.sector01.plat, 25, [0.1, 0.7, 0.9], 'filled')
% m_plot(SIT1.lon(sectBound), SIT1.lat(sectBound), 'm', 'linewidth', 1.2)
% %print('ICE/ICETHICKNESS/Figures/EnviSat/Sector_01/boundary_poly_Compare.png','-dpng', '-r400')



%-----------------------------------------
%% Load in InviSat SIT data
load(['ICE/ICETHICKNESS/Data/MAT_files/Altimetry/ESA_EnviSat/yrs02-12.mat']);


negs = find(esSIT.lon<0);
esSIT.lon(negs) = esSIT.lon(negs)+360;

% clip sector
sectP=find(inpolygon(esSIT.lon,esSIT.lat, plon, plat)==1);
IS_SIT.SIT = esSIT.SIT(sectP,:); IS_SIT.lon = esSIT.lon(sectP); IS_SIT.lat = esSIT.lat(sectP);
nf = find(isnan(IS_SIT.SIT)==1);
IS_SIT.SIT(nf)=0;


m_basemap('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1]);
set(gcf,'Position', [500,600,800,700])
m_scatter(IS_SIT.lon,IS_SIT.lat,500,IS_SIT.SIT(:,9).*100,'filled');hold on
m_scatter(SIT1.lon, SIT1.lat, 12,'m','filled', 'markerfacealpha', 0.03);
colormap(jet(10))
caxis([0,200]);
cbh = colorbar;
cbh.Ticks = [0:20:200];xlabel('EnviSat SIT, Feb 2003')
%print('ICE/ICETHICKNESS/Figures/EnviSat/Sector_10/Feb_2006_smallgrid.png','-dpng', '-r400')

endes = find(SIT1.dn<= max(esSIT.dn));

figure
set(gcf,'Position',[500,600,1200,500])
plot(SIT1.dn(endes),nanmean(SIT1.H(:,endes)));hold on;
plot(esSIT.dn, nanmean(IS_SIT.SIT).*100, 'm','LineWidth', 1.2)
datetick('x', 'mm-yyyy')
xlim([min(SIT1.dn),max(SIT1.dn(endes))])
set(gca,'XTickLabelRotation',35);
grid on; grid minor
legend('SOD SIT', 'EnviSat SIT')
title(['Sector ',sector]);
%print('ICE/ICETHICKNESS/Figures/Averages/Sector_01/SODvsEnviSatZoom_A10_0convert.png','-dpng', '-r400')



%%  Average to same interval




years = unique(SIT1.dv(:,1));
counter = 1;
for ii = 1:length(years)
    ind = find(SIT1.dv(:,1)==years(ii));
    months = unique(SIT1.dv(ind,2));
    for jj=1:length(months)
        ind2 = find(SIT1.dv(:,1)==years(ii) & SIT1.dv(:,2)==months(jj));
        SITma(:,counter) = nanmean(SIT1.H(:,ind2),2);
        SITmaDV(counter,1)=years(ii); SITmaDV(counter,2)=months(jj);
        counter = counter+1;
    end
end
clear ii jj counter months years ind ind2
SITmaDV(:,3)=15;
SITmaDN = datenum(SITmaDV(:,1), SITmaDV(:,2), SITmaDV(:,3));

NesS10 = IS_SIT(:,8:end);
NSITma = SITma(:,1:111);


% Now can compare sector means

figure
set(gcf,'Position', [500, 600, 1000, 400]);
plot(SITmaDN(1:111),nanmean(NSITma));hold on
plot(esSIT.dn(8:end), nanmean(NesS10).*100, 'm');
grid on; grid minor;
title(['Sector ',sector]);
legend('SOD SIT Monthly Averaged', 'EnviSat SIT');
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/SODvsEnviSatZoom_Monavg.png','-dpng', '-r400')



corrc = corrcoef(nanmean(NSITma),nanmean(NesS10).*100)

figure
scatter(nanmean(NSITma),nanmean(NesS10).*100, 45,'filled')
xlim([0,700])
ylim([0,700])
text(500, 630, ['r = ',num2str(corrc(1,2))], 'fontsize', 16);
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/SODvsEnviSat_scatter.png','-dpng', '-r400')








%% Interpolate to match SOD grid

% first remove nans
esSIT_rm = esSIT;
esSIT_rm.SIT = nan(size(esSIT.SIT)); esSIT_rm.lon = nan(size(esSIT.lon)); esSIT_rm.lat = nan(size(esSIT.lat));

for ii = 1:length(esSIT.dn)
    
    tn(:,ii) = find(isnan(esSIT.SIT(:,ii))==0);
    esSIT_rm.SIT{:,ii} = esSIT.SIT(tn,ii);
    esSIT_rm.lon{:,ii} = esSIT.lon(tn,ii);
    esSIT_rm.lat{:,ii} = esSIT.lat(tn,ii);
end
    


esSIT_I=nan(length(SIT1.lon),length(esSIT.dn));

for ii = 1:length(esSIT.dn)
    
    Q = scatteredInterpolant(esSIT.lon, esSIT.lat, double(esSIT.SIT(:,ii)), 'linear');
    esSIT_I(:,ii) = Q(double(SIT1.lon), double(SIT1.lat));clear Q; 

end



%% compare interpolated

figure;
set(gcf, 'position', [500,600,900, 400]);
plot(SITmaDN(1:111),nanmean(NSITma), 'linewidth', 1.01);hold on
plot(esSIT.dn, nanmean(esSIT_I).*100, 'linewidth', 1.01);
datetick('x', 'mm-yyyy')
xlim([min(SIT1.dn),max(SIT1.dn(endes))])
set(gca,'XTickLabelRotation',35);
title(['Sector ',sector])
grid on; grid minor
legend('SOD SIT', 'EnviSat SIT')







%%
corrcoef(t6, t4);






rownames = {'PDSI vs PCP'; 'PDSI vs PHDI'; 'PDSI vs ZNDX'}
TexasCorr = [.7; .2; .9];
CentralCorr = [.2; .9; .3];

table(rownames, TexasCorr, CentralCorr)

%         rownames        TexasCorr    CentralCorr
%     ________________    _________    ___________
% 
%     {'PDSI vs PCP' }       0.7           0.2    
%     {'PDSI vs PHDI'}       0.2           0.9    
%     {'PDSI vs ZNDX'}       0.9           0.3    
% 
% 







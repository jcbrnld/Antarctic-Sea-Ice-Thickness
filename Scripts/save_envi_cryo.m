% Jacob Arnold

% 29-Sep-2021

% Open Envisat and Cryosat data and save as .mat file

% Load in the Envisat data
% Load in the Cryosat data
% Compare overlap
% Combine datasets without overlap
% Save overlap separately in structure 

% Envisat data has already been saved as .mat file by read_ESAEnviSat_SIT.m

%% create .mat file of EnviSat data 

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

%save ICE/ICETHICKNESS/Data/MAT_files/Altimetry/ESA_EnviSat/EnviSat_SIT.mat  esSIT -v7.3;



%% create .mat file of CryoSat-2 SIT data 

path = 'ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_CryoSat_2/';
years = {'2010','2011','2012','2013','2014','2015','2016', '2017'};

csSIT.SIT=[];csSIT.dv=[];
for ii = 1:length(years)
    if cell2mat(years(ii))=='2010'
        jc = {'11','12'};
        for jj=1:2
            data = ncread([path,cell2mat(years(ii)),'/ESACCI-SEAICE-L3C-SITHICK-SIRAL_CRYOSAT2-SH50KMEASE2-',cell2mat(years(ii)),cell2mat(jc(jj)),'-fv2.0.nc'],'sea_ice_thickness');
            data=data(:);
            SIT1(:,jj)=data; clear data
            dv1(jj,1)=eval(cell2mat(years(ii)));
            dv1(jj,2)=eval(cell2mat(jc(jj)));
        end
        
    elseif cell2mat(years(ii))=='2017'
        rc={'01','02','03','04'};
        for rr=1:4
            data = ncread([path,cell2mat(years(ii)),'/ESACCI-SEAICE-L3C-SITHICK-SIRAL_CRYOSAT2-SH50KMEASE2-',cell2mat(years(ii)),cell2mat(rc(rr)),'-fv2.0.nc'],'sea_ice_thickness');
            data=data(:);
            SIT1(:,rr)=data; clear data
            dv1(rr,1)=eval(cell2mat(years(ii)));
            dv1(rr,2)=eval(cell2mat(rc(rr)));
        end
        
    else
        mc = {'01','02','03','04','05','06','07','08','09','10','11','12'};
        for mm = 1:12
            data = ncread([path,cell2mat(years(ii)),'/ESACCI-SEAICE-L3C-SITHICK-SIRAL_CRYOSAT2-SH50KMEASE2-',cell2mat(years(ii)),cell2mat(mc(mm)),'-fv2.0.nc'],'sea_ice_thickness');
            data=data(:);
            SIT1(:,mm)=data; clear data
            dv1(mm,1)=eval(cell2mat(years(ii)));
            dv1(mm,2)=eval(cell2mat(mc(mm)));
        end
        
        
    end
    
   csSIT.SIT = [csSIT.SIT,SIT1];clear SIT1
   csSIT.dv = [csSIT.dv;dv1];clear dv1
end
clear ii jj rr mm rc mc jc

csSIT.lat = ncread('ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/2003/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-200309-fv2.0.nc', 'lat');
csSIT.lon = ncread('ICE/ICETHICKNESS/Data/Altimetry_SIT/ESA_EnviSat/2003/ESACCI-SEAICE-L3C-SITHICK-RA2_ENVISAT-SH50KMEASE2-200309-fv2.0.nc', 'lon');
csSIT.lat = csSIT.lat(:);
csSIT.lon = csSIT.lon(:);
csSIT.dv(:,3)=15;
csSIT.dn = datenum(csSIT.dv(:,1),csSIT.dv(:,2), csSIT.dv(:,3));

%save ICE/ICETHICKNESS/Data/MAT_files/Altimetry/ESA_EnviSat/CryoSat2_SIT.mat  csSIT -v7.3;


































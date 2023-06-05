% Jacob Arnold

% 13-Jan-2021

% Add to an existing Sea Ice Thickness dataset 
% This is used to add new dates do the Stage of development-based sea ice
% thickness dataset as new ice charts are available.

% The focus of this script will be the shapefiles SO Sea Ice Concentration
% from Bremen must be updated on each sector's grid or interpolated for offshore zones.

% First download the new files and put them in a folder 
% Specify the name of that folder here:
foldername = 'new_sfiles';

% create a list of the .shp files in that folder in the shell:
% ls *.shp > names.txt


%% Chapter 1: correct/alter the file names ***************************************
% THIS NEED ONLY BE RUN once for new shapefiles INDEPENDANT OF SECTOR/ZONE.
% SKIP IF this has already been done for the new files / new names.txt file


% START in /Volumes/Data/Research OR define path:
%path2research=['/Users/jacobarnold/Documents/Classes/Research/'];% uncomment this to start at the root
%path2research=['/Volumes/Data/Research/'];

path2research=[];

% Load text file containing the filenames of interest
fnames=textread([path2research,'ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/names.txt'],'%s');
dummyfn=char(fnames);
% Find the first number that is part of the date in the filename
xx=nan(size(fnames));
ind=xx;
B=isstrprop(dummyfn,'digit');
for ii=1:length(fnames);
    ind(ii)=find(B(ii,:)==1,1);
    xx(ii)=str2double(dummyfn(ii,ind(ii)));
    if xx(ii)~=2;
        dummyfncor=[dummyfn(ii,1:ind(ii)-1) num2str(20) dummyfn(ii,ind(ii):end)];
        fnames(ii)=cellstr(dummyfncor);
        clear dummyfncor;
    elseif xx(ii)==2 & (isequal(str2num(dummyfn(ii, ind(ii)+6)),[])==1);
        dummyfncor2 = [dummyfn(ii,1:ind(ii)-1) num2str(20) dummyfn(ii,ind(ii):end)];
        fnames(ii)=cellstr(dummyfncor2);
    end
end
clear ii;

fid=fopen([path2research,'ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/namesITcor.txt'],'w');
for ii=1:length(fnames)
    fprintf(fid,'%s\n',fnames{ii,:});
end
fclose(fid);

clear ii fnames dummyfn B fid ind xx;

% read list of files back in with corrected dates
fnames=textread([path2research,'ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/namesITcor.txt'],'%s');
dummyfn=char(fnames);

% Find the first number that is part of the date in the filename
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
clear ii;
[dn,ind]=sort(dn,'ascend');
dv=datevec(dn);
fnames=fnames(ind);

fid=fopen([path2research,'ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/namesITsortedcor.txt'],'w');
for ii=1:length(fnames)
    fprintf(fid,'%s\n',fnames{ii,:});
end
fclose(fid);



% test to see if the text file is correct
fnames=textread([path2research,'ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/namesITsortedcor.txt'],'%s'); 
    
    



%% CHAPTER 2. Next load in new shpfiles and project onto grid





list={'Sector01', 'Sector02', 'Sector03', 'Sector04', 'Sector05', 'Sector06',...
    'Sector07', 'Sector08', 'Sector09', 'Sector10', 'Sector11', 'Sector12', 'Sector13',...
    'Sector14', 'Sector15', 'Sector16', 'Sector17', 'Sector18', 'Subpolar Atlantic',...
    'Subpolar Indian', 'Subpolar Pacific', 'ACC Atlantic', 'ACC Indian', 'ACC Pacific'};
[indx,tf] = listdlg('PromptString',{'Which sector do you wish to use?'},...
    'SelectionMode','single','ListString', list);
if indx<10
    sector = ['0', num2str(indx)];
elseif indx<19 & indx>9
    sector = num2str(indx);
elseif indx==19;sector = 'subpolar_ao_SIC_25km';elseif indx==20; sector='subpolar_io_SIC_25km';
elseif indx==21;sector='subpolar_po_SIC_25km';elseif indx==22; sector='acc_ao_SIC_25km';
elseif indx==23; sector='acc_io_SIC_25km';elseif indx==24; sector='acc_po_SIC_25km';
end


clear tf
    
% path2research=[];
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Step 1 | read in the shapefiles
% 1.1 read in newer shapefiles (2003-2021+)

    
fnames=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/namesITsortedcor.txt'],'%s');
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
fnames=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/names.txt'],'%s');

% sort list of actual data files in chronological order
fnames_T1=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/namesITcor.txt'],'%s');
fnames_T2=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/namesITsortedcor.txt'],'%s');
for ii = (1:length(fnames_T1));
    ind(ii) = find(ismember(fnames_T1, fnames_T2(ii)));
end 
ind = ind.';
fnames=fnames(ind); % ind are the indices of the sorted files
shpfiles=cell(size(fnames));

% Read in Longitude and Latitude
tic
pool = parpool(feature('numcores')); % should open pool with max number of workers possible
parfor ii=1:length(fnames)
    disp([num2str(ii) ' of ' num2str(length(dn)) ' : Reading Shapefiles'])
    ff1=cell2mat(fnames(ii));
    ff2=['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/' ff1];
    shpfiles{ii}=m_shaperead(ff2(1:end-4));
end
delete(pool);
toc
% for loop test (s01) elapsed time: 345.3 seconds
% parfor loop test (s01) elapsed time: 152.2 seconds
clear ii x y dd B;
disp('Shapefiles Opened')

savename = ['sector',sector,'_shpSIG.mat'];
    

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Step 2 | load sector grid


if length(sector)==2
    sect = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
else
    sect = load(['ICE/Concentration/so-zones/25km_sic/',sector,'.mat']);

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
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Step 3 | Project polys onto grid in xy space
disp('Preparing to project polygons onto grid') 


for ii=1:length(shpfiles);
    junk=cell2mat(shpfiles(ii));
    CA{ii}=single(str2double(junk.dbf.CA));
    SA{ii}=single(str2double(junk.dbf.SA));
    CB{ii}=single(str2double(junk.dbf.CB));
    SB{ii}=single(str2double(junk.dbf.SB));
    CC{ii}=single(str2double(junk.dbf.CC));
    SC{ii}=single(str2double(junk.dbf.SC));
    CT{ii}=single(str2double(junk.dbf.CT));
    if isfield(junk.dbf, 'SD')==1;
        SD{ii}=single(str2double(junk.dbf.SD));
    else
        SD{ii}=single(nan(size(CA{ii})));
    end
    if isfield(junk.dbf, 'CD')==1;
        CD{ii}=single(str2double(junk.dbf.CD));
    else
        CD{ii}=single(nan(size(CA{ii})));
    end
end

clear ii

disp('start')
for ii = 1:length(shpfiles)
    tic
    disp([num2str(ii) ' of ' num2str(length(shpfiles))]) % *
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
        px = shpfiles{ii,1}.ncst{jj,1}(:,1);
        py = shpfiles{ii,1}.ncst{jj,1}(:,2);
        ISIN = find(inpolygon(gx,gy,px,py)==1);
        SIT.sa(ISIN,ii)=tempsa(jj);
        SIT.sb(ISIN,ii)=tempsb(jj);
        SIT.sc(ISIN,ii)=tempsc(jj);
        SIT.sd(ISIN,ii)=tempsd(jj);
        SIT.ca(ISIN,ii)=tempca(jj);
        SIT.cb(ISIN,ii)=tempcb(jj);              
        SIT.cc(ISIN,ii)=tempcc(jj);
        SIT.ct(ISIN,ii)=tempct(jj);
        SIT.cd(ISIN,ii)=tempcd(jj);
    end
    toc
end
clear ii jj tempsa tempsb tempsc tempca tempcb tempcc tempct
dnDup = dn; % problems with overwriting SIT.dn after original dn has been replaced. This duplication allows correction of this when/if necessary. 
SIT.dn=dn; % Apply current (shapefile) dn to SIT structure because dn will be overwritten with SIC dn in next section
SIT.dv=dv; % """"
SIT.lon=long;
SIT.lat=latg;

clear CA CB CC CD CT dn dummyfn dv ff1 ff2 fnames fnames_T1 fnames_T2 gx gy ilat1 ilon1 ind ISIN junk latg long mm px py SA SB SC SD shpfiles tempcd tempsd

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nSIT = SIT; clear SIT
disp(['New dates to add are: ',datestr(nSIT.dn(1)),' to ',datestr(nSIT.dn(end))])
% Step 4 | add to previously gridded data and save
load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/',savename]);

% Now concatenate new gridded data with old
% check that number of grid points is the same
if length(SIT.lon) ~= length(nSIT.lon)
    warning(['Different number of grid points SIT has ',num2str(length(SIT.lon)),' nSIT has ',num2str(length(nSIT.lon))])
end

if SIT.dn(end) >= nSIT.dn(1)
    disp('Some overlap. Need to trim older file')
    firstind = find(SIT.dn==nSIT.dn(1));
    SIT.dn(firstind(1):end) = [];
    SIT.dv(firstind(1):end,:) = [];
    SIT.H(:,firstind(1):end) = [];
    SIT.sa(:,firstind(1):end) = [];
    SIT.sb(:,firstind(1):end) = [];
    SIT.sc(:,firstind(1):end) = [];
    SIT.sd(:,firstind(1):end) = [];
    SIT.ca(:,firstind(1):end) = [];
    SIT.cb(:,firstind(1):end) = [];
    SIT.cc(:,firstind(1):end) = [];
    SIT.cd(:,firstind(1):end) = [];
    SIT.ct(:,firstind(1):end) = [];
    
end

cSIT.lon = SIT.lon;
cSIT.lat = SIT.lat;
cSIT.dn = [SIT.dn; nSIT.dn];
cSIT.dv = [SIT.dv; nSIT.dv];
cSIT.H = [SIT.H, nSIT.H];
cSIT.sa = [SIT.sa, nSIT.sa];
cSIT.sb = [SIT.sb, nSIT.sb];
cSIT.sc = [SIT.sc, nSIT.sc];
cSIT.sd = [SIT.sd, nSIT.sd];
cSIT.ca = [SIT.ca, nSIT.ca];
cSIT.cb = [SIT.cb, nSIT.cb];
cSIT.cc = [SIT.cc, nSIT.cc];
cSIT.cd = [SIT.cd, nSIT.cd];
cSIT.ct = [SIT.ct, nSIT.ct];


clear SIT;

SIT = cSIT;

disp(['Sector ',sector,': New last date is ', datestr(SIT.dn(end))])

%

save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/',savename], 'SIT', '-v7.3');

disp(['Updated raw gridded data for sector', sector]) 



%% Chapter 3 - calculate (update) Sea Ice Thickness
% BE SURE TO HAVE UPDATED CONCENTRATION BEFORE RUNNING THIS STEP


% NAVIGATE TO RESEARCH DIRECTORY BEFORE RUNNING
clear all
startdate = inputdlg('Define start date of new data in yyyymmdd format. Do not add dashes or slashes between y m or d');
startyear = str2num(startdate{1,1}(1:4));
startmonth = str2num(startdate{1,1}(5:6));
startday = str2num(startdate{1,1}(7:8));


path2research=[];
% Step 1 | load gridded raw data
%path2research=['/Users/jacobarnold/Documents/Classes/Research/'];% uncomment this to start at the root
%path2research=['/Volumes/Data/Research/'];

list={'Sector01', 'Sector02', 'Sector03', 'Sector04', 'Sector05', 'Sector06',...
    'Sector07', 'Sector08', 'Sector09', 'Sector10', 'Sector11', 'Sector12', 'Sector13',...
    'Sector14', 'Sector15', 'Sector16', 'Sector17', 'Sector18', 'Subpolar Atlantic',...
    'Subpolar Indian', 'Subpolar Pacific', 'ACC Atlantic', 'ACC Indian', 'ACC Pacific'};
[indx,tf] = listdlg('PromptString',{'Which sector do you wish to use?'},...
    'SelectionMode','single','ListString', list);
if indx<10
    sector = ['0', num2str(indx)];
elseif indx<19 & indx>9
    sector = num2str(indx);
elseif indx==19;sector = 'subpolar_ao_SIC_25km';elseif indx==20; sector='subpolar_io_SIC_25km';
elseif indx==21;sector='subpolar_po_SIC_25km';elseif indx==22; sector='acc_ao_SIC_25km';
elseif indx==23; sector='acc_io_SIC_25km';elseif indx==24; sector='acc_po_SIC_25km';
end

% 
load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpE00.mat']);
e00SIT = SIT;clear SIT

load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpSIG.mat']); 
shp = SIT; clear SIT



SIT.dn = [e00SIT.dn;shp.dn]; SIT.dv = [e00SIT.dv;shp.dv]; 
SIT.sa = [e00SIT.sa,shp.sa]; SIT.sb = [e00SIT.sb,shp.sb]; SIT.sc = [e00SIT.sc,shp.sc]; SIT.sd = [e00SIT.sd,shp.sd];
SIT.ct = [e00SIT.ct,shp.ct]; SIT.ca = [e00SIT.ca,shp.ca]; SIT.cb = [e00SIT.cb,shp.cb];
SIT.cc = [e00SIT.cc,shp.cc]; SIT.cd = [e00SIT.cd,shp.cd]; 
SIT.H = [e00SIT.H,shp.H];
SIT.lon = shp.lon; SIT.lat = shp.lat;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Step 2 | Interpret SIGRID specifics before translating 
% NaN values should only be where grid points did not have a polygon

% Much more efficient than looping
dind = find(SIT.sd~=-9 & isnan(SIT.sd)==0 & SIT.sd~=99 & SIT.sd~=0);
dvar = SIT.ct(dind)-(SIT.ca(dind)+SIT.cb(dind)+SIT.cc(dind));
dpos = find(dvar>0);dzer=find(dvar==0);
%fourIt=zeros(size(SIT.ca));fourIt(dind(dpos))=1; % diagnostic
SIT.cd(dind(dpos))=-10;SIT.cd(dind(dzer))=0;
saFill = find(SIT.sa==-9 & SIT.ct~=0);

oneind = find((SIT.ca==-9 | SIT.ca==99 | isnan(SIT.ca)==1 | SIT.ca==0) & (SIT.cb==-9 | SIT.cb==99 | isnan(SIT.cb)==1 | SIT.cb==0)...
    & (SIT.cc==-9 | SIT.cc==99 | isnan(SIT.cc)==1 | SIT.cc==0) & (SIT.ct~=-9 & SIT.ct~=99 & isnan(SIT.ct)==0 & SIT.ct~=0) ...
    & (SIT.sa~=-9 & SIT.sa~=99 & isnan(SIT.sa)==0 & SIT.sa~=0) & (SIT.sb==-9 | SIT.sb==99 | isnan(SIT.sb)==1 | SIT.sb==0)...
    & (SIT.sc==-9 | SIT.sc==99 | isnan(SIT.sc)==1 | SIT.sc==0) & (SIT.sd==-9 | SIT.sd==99 | isnan(SIT.sd)==1 | SIT.sd==0));
SIT.ca(oneind) = SIT.ct(oneind);
%oneIt=zeros(size(SIT.ca));oneIt(oneind)=1; % diagnostic
SIT.cb(oneind)=0; SIT.cc(oneind)=0; SIT.cd(oneind)=0;
clear dind dvar dpos dzer 


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Step 3 | Translate Data


%__________________________
% NOW DEFINE ERRORS from conversion of sigrid to cm and %
sa_Error = nan(size(SIT.sa)); sb_Error = sa_Error; sc_Error = sa_Error; sd_Error = sa_Error; H_Error = sa_Error;

%         SA                           SB                         SC                          SD 
sa_Error(SIT.sa==0)=0;    sb_Error(SIT.sb==0)=0;    sc_Error(SIT.sc==0)=0;    sd_Error(SIT.sd==0)=0;
sa_Error(SIT.sa==55)=0;    sb_Error(SIT.sb==55)=0;    sc_Error(SIT.sc==55)=0;    sd_Error(SIT.sd==55)=0;
sa_Error(SIT.sa==81)=2.5;  sb_Error(SIT.sb==81)=2.5;  sc_Error(SIT.sc==81)=2.5;  sd_Error(SIT.sd==81)=2.5; 
sa_Error(SIT.sa==82)=5;    sb_Error(SIT.sb==82)=5;    sc_Error(SIT.sc==82)=5;    sd_Error(SIT.sd==82)=5;
sa_Error(SIT.sa==83)=10;   sb_Error(SIT.sb==83)=10;   sc_Error(SIT.sc==83)=10;   sd_Error(SIT.sd==83)=10;
sa_Error(SIT.sa==84)=2.5;  sb_Error(SIT.sb==84)=2.5;  sc_Error(SIT.sc==84)=2.5;  sd_Error(SIT.sd==84)=2.5; 
sa_Error(SIT.sa==85)=7.5;  sb_Error(SIT.sb==85)=7.5;  sc_Error(SIT.sc==85)=7.5;  sd_Error(SIT.sd==85)=7.5;
sa_Error(SIT.sa==86)=85;   sb_Error(SIT.sb==86)=85;   sc_Error(SIT.sc==86)=85;   sd_Error(SIT.sd==86)=85;
sa_Error(SIT.sa==87)=20;   sb_Error(SIT.sb==87)=20;   sc_Error(SIT.sc==87)=20;   sd_Error(SIT.sd==87)=20;
sa_Error(SIT.sa==88)=10;   sb_Error(SIT.sb==88)=10;   sc_Error(SIT.sc==88)=10;   sd_Error(SIT.sd==88)=10;
sa_Error(SIT.sa==89)=10;   sb_Error(SIT.sb==89)=10;   sc_Error(SIT.sc==89)=10;   sd_Error(SIT.sd==89)=10;
sa_Error(SIT.sa==91)=25;   sb_Error(SIT.sb==91)=25;   sc_Error(SIT.sc==91)=25;   sd_Error(SIT.sd==91)=25;
sa_Error(SIT.sa==93)=40;   sb_Error(SIT.sb==93)=40;   sc_Error(SIT.sc==93)=40;   sd_Error(SIT.sd==93)=40;
sa_Error(SIT.sa==95)=50;   sb_Error(SIT.sb==95)=50;   sc_Error(SIT.sc==95)=50;   sd_Error(SIT.sd==95)=50;
sa_Error(SIT.sa==96)=25;   sb_Error(SIT.sb==96)=25;   sc_Error(SIT.sc==96)=25;   sd_Error(SIT.sd==96)=25;
sa_Error(SIT.sa==97)=25;   sb_Error(SIT.sb==97)=25;   sc_Error(SIT.sc==97)=25;   sd_Error(SIT.sd==97)=25;




SIT.error.sa = sa_Error; SIT.error.sb = sb_Error; SIT.error.sc = sc_Error; SIT.error.sd = sd_Error;
SIT.error.H = H_Error;
clear sa_Error sb_Error sc_Error sd_Error H_Error
%--------------------





% Find icebergs

% 98 is glacier ice but if concentration is very low it should be ignored (converted to 0)
icebergs = find(SIT.sa == 98 & (SIT.sb==-9 | SIT.sb==0 | SIT.sb==99 | isnan(SIT.sb)==1)...
    & (SIT.sc==-9 | SIT.sc==0 | SIT.sc==99 | isnan(SIT.sc)==1)...
    & (SIT.sd==-9 | SIT.sd==0 | SIT.sd==99 | isnan(SIT.sd)==1)...
    & SIT.ca>=46); 


% Translate concentration
% Based on SIGRID documentation: "SIGRID-3: A Vector Archive Format for Sea
% Ice Charts" Page 18
disp('Converting concentrations from SIGRID to %')
%        CA                       CB                      CC                     CT
SIT.ca(SIT.ca==55)=0;   SIT.cb(SIT.cb==55)=0;   SIT.cc(SIT.cc==55)=0;   SIT.ct(SIT.ct==55)=0;
SIT.ca(SIT.ca==1)=5;    SIT.cb(SIT.cb==1)=5;    SIT.cc(SIT.cc==1)=5;    SIT.ct(SIT.ct==1)=5;
SIT.ca(SIT.ca==2)=5;    SIT.cb(SIT.cb==2)=5;    SIT.cc(SIT.cc==2)=5;    SIT.ct(SIT.ct==2)=5;
SIT.ca(SIT.ca==92)=100; SIT.cb(SIT.cb==92)=100; SIT.cc(SIT.cc==92)=100; SIT.ct(SIT.ct==92)=100;
SIT.ca(SIT.ca==91)=95;  SIT.cb(SIT.cb==91)=95;  SIT.cc(SIT.cc==91)=95;  SIT.ct(SIT.ct==91)=95;
SIT.ca(SIT.ca==89)=85;  SIT.cb(SIT.cb==89)=85;  SIT.cc(SIT.cc==89)=85;  SIT.ct(SIT.ct==89)=85;
SIT.ca(SIT.ca==81)=90;  SIT.cb(SIT.cb==81)=90;  SIT.cc(SIT.cc==81)=90;  SIT.ct(SIT.ct==81)=90;
SIT.ca(SIT.ca==79)=80;  SIT.cb(SIT.cb==79)=80;  SIT.cc(SIT.cc==79)=80;  SIT.ct(SIT.ct==79)=80;
SIT.ca(SIT.ca==78)=75;  SIT.cb(SIT.cb==78)=75;  SIT.cc(SIT.cc==78)=75;  SIT.ct(SIT.ct==78)=75;
SIT.ca(SIT.ca==68)=70;  SIT.cb(SIT.cb==68)=70;  SIT.cc(SIT.cc==68)=70;  SIT.ct(SIT.ct==68)=70;
SIT.ca(SIT.ca==67)=65;  SIT.cb(SIT.cb==67)=65;  SIT.cc(SIT.cc==67)=65;  SIT.ct(SIT.ct==67)=65;
SIT.ca(SIT.ca==57)=60;  SIT.cb(SIT.cb==57)=60;  SIT.cc(SIT.cc==57)=60;  SIT.ct(SIT.ct==57)=60;
SIT.ca(SIT.ca==56)=55;  SIT.cb(SIT.cb==56)=55;  SIT.cc(SIT.cc==56)=55;  SIT.ct(SIT.ct==56)=55;
SIT.ca(SIT.ca==46)=50;  SIT.cb(SIT.cb==46)=50;  SIT.cc(SIT.cc==46)=50;  SIT.ct(SIT.ct==46)=50;
SIT.ca(SIT.ca==35)=40;  SIT.cb(SIT.cb==35)=40;  SIT.cc(SIT.cc==35)=40;  SIT.ct(SIT.ct==35)=40;
SIT.ca(SIT.ca==34)=35;  SIT.cb(SIT.cb==34)=35;  SIT.cc(SIT.cc==34)=35;  SIT.ct(SIT.ct==34)=35;
SIT.ca(SIT.ca==24)=30;  SIT.cb(SIT.cb==24)=30;  SIT.cc(SIT.cc==24)=30;  SIT.ct(SIT.ct==24)=30;
SIT.ca(SIT.ca==23)=25;  SIT.cb(SIT.cb==23)=25;  SIT.cc(SIT.cc==23)=25;  SIT.ct(SIT.ct==23)=25;
SIT.ca(SIT.ca==13)=20;  SIT.cb(SIT.cb==13)=20;  SIT.cc(SIT.cc==13)=20;  SIT.ct(SIT.ct==13)=20;
SIT.ca(SIT.ca==12)=15;  SIT.cb(SIT.cb==12)=15;  SIT.cc(SIT.cc==12)=15;  SIT.ct(SIT.ct==12)=15;
SIT.ca(SIT.ca==-9)=0;   SIT.cb(SIT.cb==-9)=0;   SIT.cc(SIT.cc==-9)=0;   SIT.ct(SIT.ct==-9)=0;
SIT.ca(SIT.ca==99)=-99; SIT.cb(SIT.cb==99)=-99; SIT.cc(SIT.cc==99)=-99; SIT.ct(SIT.ct==99)=-99;

% Translate Stage of Development 
% Based on SIGRID documentation: "SIGRID-3: A Vector Archive Format for Sea
% Ice Charts" Page 19
disp('Converting SOD from SIGRID to cm')
%       SA                        SB                       SC                       SD
SIT.sa(SIT.sa==55)=0;    SIT.sb(SIT.sb==55)=0;    SIT.sc(SIT.sc==55)=0;    SIT.sd(SIT.sd==55)=0;
SIT.sa(SIT.sa==70)=200;  SIT.sb(SIT.sb==70)=200;  SIT.sc(SIT.sc==70)=200;  SIT.sd(SIT.sd==70)=200;
SIT.sa(SIT.sa==80)=0;    SIT.sb(SIT.sb==80)=0;    SIT.sc(SIT.sc==80)=0;    SIT.sd(SIT.sd==80)=0;
SIT.sa(SIT.sa==81)=2.5;  SIT.sb(SIT.sb==81)=2.5;  SIT.sc(SIT.sc==81)=2.5;  SIT.sd(SIT.sd==81)=2.5;
SIT.sa(SIT.sa==82)=5;    SIT.sb(SIT.sb==82)=5;    SIT.sc(SIT.sc==82)=5;    SIT.sd(SIT.sd==82)=5;
SIT.sa(SIT.sa==83)=20;   SIT.sb(SIT.sb==83)=20;   SIT.sc(SIT.sc==83)=20;   SIT.sd(SIT.sd==83)=20; % The median for this category (Young Ice) is actuall 20, but a thin-bias assumption is reasonable so a translated value of 15 is used. 
SIT.sa(SIT.sa==84)=12.5; SIT.sb(SIT.sb==84)=12.5; SIT.sc(SIT.sc==84)=12.5; SIT.sd(SIT.sd==84)=12.5;
SIT.sa(SIT.sa==85)=22.5; SIT.sb(SIT.sb==85)=22.5; SIT.sc(SIT.sc==85)=22.5; SIT.sd(SIT.sd==85)=22.5;
SIT.sa(SIT.sa==86)=115;  SIT.sb(SIT.sb==86)=115;  SIT.sc(SIT.sc==86)=115;  SIT.sd(SIT.sd==86)=115;
SIT.sa(SIT.sa==87)=50;   SIT.sb(SIT.sb==87)=50;   SIT.sc(SIT.sc==87)=50;   SIT.sd(SIT.sd==87)=50;
SIT.sa(SIT.sa==88)=40;   SIT.sb(SIT.sb==88)=40;   SIT.sc(SIT.sc==88)=40;   SIT.sd(SIT.sd==88)=40;
SIT.sa(SIT.sa==89)=60;   SIT.sb(SIT.sb==89)=60;   SIT.sc(SIT.sc==89)=60;   SIT.sd(SIT.sd==89)=60;
SIT.sa(SIT.sa==90)=nan;  SIT.sb(SIT.sb==90)=nan;  SIT.sc(SIT.sc==90)=nan;  SIT.sd(SIT.sd==90)=nan;
SIT.sa(SIT.sa==91)=95;   SIT.sb(SIT.sb==91)=95;   SIT.sc(SIT.sc==91)=95;   SIT.sd(SIT.sd==91)=95;
SIT.sa(SIT.sa==92)=nan;  SIT.sb(SIT.sb==92)=nan;  SIT.sc(SIT.sc==92)=nan;  SIT.sd(SIT.sd==92)=nan;
SIT.sa(SIT.sa==93)=150;  SIT.sb(SIT.sb==93)=150;  SIT.sc(SIT.sc==93)=150;  SIT.sd(SIT.sd==93)=150;
SIT.sa(SIT.sa==94)=nan;  SIT.sb(SIT.sb==94)=nan;  SIT.sc(SIT.sc==94)=nan;  SIT.sd(SIT.sd==94)=nan;
SIT.sa(SIT.sa==95)=265;  SIT.sb(SIT.sb==95)=265;  SIT.sc(SIT.sc==95)=265;  SIT.sd(SIT.sd==95)=265; % New
SIT.sa(SIT.sa==96)=215;  SIT.sb(SIT.sb==96)=215;  SIT.sc(SIT.sc==96)=215;  SIT.sd(SIT.sd==96)=215; % New
SIT.sa(SIT.sa==97)=300;  SIT.sb(SIT.sb==97)=300;  SIT.sc(SIT.sc==97)=300;  SIT.sd(SIT.sd==97)=300; % New

SIT.sa(SIT.sa==98)=0;  SIT.sb(SIT.sb==98)=0;  SIT.sc(SIT.sc==98)=0;  SIT.sd(SIT.sd==98)=0; % actual icebergs will be made nan at the start of step 5
SIT.sa(SIT.sa==99)=-99;  SIT.sb(SIT.sb==99)=-99;  SIT.sc(SIT.sc==99)=-99;  SIT.sd(SIT.sd==99)=-99;
SIT.sa(SIT.sa==-9)=0;    SIT.sb(SIT.sb==-9)=0;    SIT.sc(SIT.sc==-9)=0;    SIT.sd(SIT.sd==-9)=0;



% Translate stage of development 
% Based on SIGRID documentation: "SIGRID-3: A Vector Archive Format for Sea
% Ice Charts" Page 19

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Step 4 | Import and average SIC data to match temporal scale of SOD

disp('Load in SIC and average to same interval as SOD')
% step 1: load SIC data and average to same times 
if length(sector)==2
    sect = load([path2research,'ICE/Concentration/ant-sectors/sector',sector,'.mat']);
else
    sect = load([path2research,'ICE/Concentration/so-zones/25km_sic/',sector,'.mat']);
    
end
sectC = struct2cell(sect);

dn = sectC{1,1}.dn;
dv = sectC{1,1}.dv;
SICcorr2 = sectC{1,1}.sic;
clear sect sectC
if sum(dv(:,4))~=0;
    dv(:,4) = 0;
    dn = datenum(double(dv));
end


if dn(end)<=SIT.dn(end)
    ltin = find(SIT.dn>=dn(end));aldu = ltin(1)-1;
    SIT.dn = SIT.dn(1:aldu); 
    SIT.dv = SIT.dv(1:aldu,:);
    SIT.sa = SIT.sa(:,1:aldu);
    SIT.sb = SIT.sb(:,1:aldu);
    SIT.sc = SIT.sc(:,1:aldu);
    SIT.sd = SIT.sd(:,1:aldu);
    SIT.ca = SIT.ca(:,1:aldu);
    SIT.cb = SIT.cb(:,1:aldu);
    SIT.cc = SIT.cc(:,1:aldu);
    SIT.ct = SIT.ct(:,1:aldu);
    SIT.cd = SIT.cd(:,1:aldu);
    SIT.H = SIT.H(:,1:aldu);
    shrt = find(icebergs>length(SIT.sa(:)));
    if length(shrt)>=1;
        icebergs = icebergs(1:shrt(1)-1);
    end
    
end

% DO NOT TRY TO USE interp1 INSTEAD OF AVERAGING:

%
% __________________________________________ 
% 
mdn = SIT.dn;
dmdn = diff(mdn); % should be 1xN-1 -> difference between each two values
for ii = 1:length(dmdn)
    lmdn(ii,1) = mdn(ii)+round((dmdn(ii))/2); %provides midpoint values between each dn - should be N-1x1
end
clear ii

for ii = 1:length(lmdn);
    loc1 = find(dn==lmdn(ii));
    if isempty(loc1)
        loc2 = find(dn==(lmdn(ii)+1));
        if isempty(loc2)==0
            mids(ii) = loc2;
        end
    else
        mids(ii) = loc1;
    end
    clear loc1 loc2
    %mids(ii) = find(dn==lmdn(ii)); % should be 1xN-1
end


fd = find(dn==mdn(1));
if dn(end)>=SIT.dn(end)
    ld = find(dn==mdn(length(lmdn)+1));
else
    ld = length(dn);
end

avgSIC = nan(length(SIT.lon), length(SIT.dn));
for gg = 1:length(SIT.lon)
    for ii = 1:length(lmdn)-1
        avgSIC(gg,ii+1) = nanmean(SICcorr2(gg,mids(ii):mids(ii+1)));
    end 
    avgSIC(gg,1) = nanmean(SICcorr2(gg,fd:mids(1)));
    avgSIC(gg,length(lmdn)+1) = nanmean(SICcorr2(gg, mids(end):ld));
end
clear ii gg
%------
%nantest = sum(isnan(avgSIC),'all'); disp(["Number of NaNs after avg: "+num2str(nantest)])
clear nantest dmdn fourIt oneIt fd ld lmdn mdn mids  



% __________________________________________________________________________________________

disp('Done averaging SIC across each weekly/biweekly interval')





% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Step 5 | Fill 99s and create ratios


% nan out icebergs
SIT.sa(icebergs) = nan; SIT.sb(icebergs) = nan; SIT.sc(icebergs) = nan; SIT.sd(icebergs) = nan;
SIT.ca(icebergs) = nan; SIT.cb(icebergs) = nan; SIT.cc(icebergs) = nan; SIT.cd(icebergs) = nan; SIT.ct(icebergs) = nan;



SIT.cd(SIT.cd==-10)=SIT.ct(SIT.cd==-10) - (SIT.ca(SIT.cd==-10)+SIT.cb(SIT.cd==-10)+SIT.cc(SIT.cd==-10)); % fill in CD values 

% Stage of Development


all99Sa = find(SIT.sa<0);all99Sb = find(SIT.sb<0);all99Sc = find(SIT.sc<0);
all99Sd = find(SIT.sd<0);all99Ca = find(SIT.ca<0);all99Cb = find(SIT.cb<0);
all99Cc = find(SIT.cc<0);all99Cd = find(SIT.cd<0);all99Ct = find(SIT.ct<0);



% Convert -99s to nans
SIT.sa(SIT.sa<0)=nan; SIT.sb(SIT.sb<0)=nan; 
SIT.sc(SIT.sc<0)=nan; SIT.sd(SIT.sd<0)=nan;
SIT.ca(SIT.ca<0)=nan; SIT.cb(SIT.cb<0)=nan; 
SIT.cc(SIT.cc<0)=nan; SIT.cd(SIT.cd<0)=nan;
SIT.ct(SIT.ct<0)=nan; 
%

% fill in SIC nans with CT HERE
sicnans = find(isnan(avgSIC));
avgSIC(sicnans) = SIT.ct(sicnans);

dummySA=SIT.sa;
dummySB=SIT.sb;
dummySC=SIT.sc;
dummySD=SIT.sd;

dv=SIT.dv;
% --- Stage of Development moving average below ---
% MINI DOC STRING HERE DESCRIBING WHAT THIS DOES

avInt = 10; % number of ~nan values accepted when averaging

% DEFINE STARTING DATE *****************
sdate = datenum(startyear, startmonth, startday);
sdv = datevec(sdate);
sdateloc = find(SIT.dn==sdate);
newdn = SIT.dn(sdateloc:end);
newdv = datevec(newdn);

newnum = length(SIT.dn)-(sdateloc-1);
% **************************************
% Shorten SIC to match new dates
avgSIC2 = avgSIC(:, end-(newnum-1):end);
avgSIC = avgSIC2; clear avgSIC2;
% _________________

mavgSA = nan(length(SIT.lon), length(SIT.dn)-(sdateloc-1));
mavgSB = mavgSA; mavgSC = mavgSA; mavgSD = mavgSA;

yrs = unique(newdv(:,1));
mnths = unique(newdv(:,2));
allyrs = unique(SIT.dv(:,1));
allmnths = unique(SIT.dv(:,2));
refsL(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))"; % only one year (the last year)
for cc = 1:length(allyrs)-1
    refsL(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==allyrs(end-"+num2str(cc)+"))";
end
disp('Begin SOD Monthly Average Loop')
for yy = 1:length(yrs) % unique years 
    tic;
    for mm = 1:length(mnths) % unique months
        disp(['SOD ',num2str(yrs(yy)),'  ',num2str(mnths(mm))])
        for gg = 1:length(SIT.lon) % grid points in the sector

            if yy == length(yrs) % Special process for the last year * THIS SHOULD ALWAYS BE THE CASE
                lstm = SIT.dv(end,2);                               %  IF YOU NEED TO ADD MORE THAN ONE YEAR DO EACH INDIVIDUALLY
                if mm > lstm;
                    continue 
                else
                    for rr = 3:length(refsL) % takes yy-rr
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummySA(gg,ind)),'all') >= avInt
                            goodsa = ind;
                            mavgSA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySA(gg, goodsa)); clear goodsa;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsL) 
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummySB(gg,ind)),'all') >= avInt
                            goodsb = ind;
                            mavgSB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySB(gg, goodsb)); clear goodsb;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsL) 
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummySC(gg,ind)),'all') >= avInt
                            goodsc = ind;
                            mavgSC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySC(gg, goodsc)); clear goodsc;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsL) 
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummySD(gg,ind)),'all') >= avInt
                            goodsd = ind;
                            mavgSD(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummySD(gg, goodsd)); clear goodsd;
                            break
                        end
                    end; clear rr
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
ratioSD=mavgSD./(mavgSD+mavgSD+mavgSD);

%
% --- Stage of Development moving average above ---


stgdevratio=[ratioSA,ratioSB,ratioSC,ratioSD];
clear dummySA dummySB dummySC dummySD;

avgABC=mavgSA+mavgSB+mavgSC+mavgSD;  % NEED TO INDEX -99 VALS FOR EACH VARIABLE THEN CONVERT TO NAN BEFORE AVERAGE

SIT.sa(all99Sa)=mavgSA(all99Sa); 
SIT.sb(all99Sb)=mavgSB(all99Sb);
SIT.sc(all99Sc)=mavgSC(all99Sc);
SIT.sd(all99Sd)=mavgSD(all99Sd);
SIT.sa(saFill)=mavgSA(saFill);


% Fill other odd nans
SAnan = find(isnan(SIT.sa)==1); SBnan = find(isnan(SIT.sb)==1);
SCnan = find(isnan(SIT.sc)==1); SDnan = find(isnan(SIT.sd)==1);

SIT.sa(SAnan) = mavgSA(SAnan); SIT.sb(SBnan) = mavgSB(SBnan);
SIT.sc(SCnan) = mavgSC(SCnan); SIT.sd(SDnan) = mavgSD(SDnan);

% redefine iceburgs as nan
SIT.sa(icebergs) = nan; 
SIT.sb(icebergs) = nan; SIT.sc(icebergs) = nan; SIT.sd(icebergs) = nan;



clear gg aa yy mm rr

dummyCA=SIT.ca; dummyCB=SIT.cb; dummyCC=SIT.cc;
dummyCD=SIT.cd; dummyCT=SIT.ct;
            
% --- new Moving Average below ---
% 
mavgCA = nan(length(SIT.lon), length(SIT.dn)-(sdateloc-1));
mavgCB = mavgCA; mavgCC = mavgCA; mavgCD = mavgCA; mavgCT = mavgCA;




yrs = unique(newdv(:,1));
mnths = unique(newdv(:,2));
allyrs = unique(SIT.dv(:,1));
allmnths = unique(SIT.dv(:,2));
refsL(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))"; % only one year (the last year)
for cc = 1:length(allyrs)-1
    refsL(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==allyrs(end-"+num2str(cc)+"))";
end


disp('Begin SIC Monthly Average Loop');
for yy = 1:length(yrs)
    tic
    for mm = 1:length(mnths)
         disp(['SIC ',num2str(yrs(yy)),'  ',num2str(mnths(mm))])
        for gg = 1:length(SIT.lon)
            
            if yy == length(yrs)
                lstm = SIT.dv(end,2);
                if mm > lstm;
                    continue
                else
                    for rr = 3:length(refsL) % takes yy-rr
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummyCA(gg,ind)),'all') >= avInt
                            goodca = ind;
                            mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCA(gg, goodca)); clear goodca;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsL) 
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummyCB(gg,ind)),'all') >= avInt
                            goodcb = ind;
                            mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCB(gg, goodcb)); clear goodcb;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsL) 
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummyCC(gg,ind)),'all') >= avInt
                            goodcc = ind;
                            mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCC(gg, goodcc)); clear goodcc;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsL) 
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummyCT(gg,ind)),'all') >= avInt
                            goodct = ind;
                            mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCT(gg, goodct)); clear goodct;
                            break
                        end
                    end; clear rr
                    for rr = 3:length(refsL) 
                        ind = find(eval(join(refsL(1:rr))));
                        if sum(~isnan(dummyCD(gg,ind)),'all') >= avInt
                            goodcd = ind;
                            mavgCD(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mnths(mm))) = nanmean(dummyCD(gg, goodcd)); clear goodcd;
                            break
                        end
                    end; clear rr
                end
            
            end
        end
    end
    toc
end

SIT.ca(all99Ca)=mavgCA(all99Ca); 
SIT.cb(all99Cb)=mavgCB(all99Cb);
SIT.cc(all99Cc)=mavgCC(all99Cc);
SIT.cd(all99Cd)=mavgCD(all99Cd);

%
mavgCA(icebergs) = nan; mavgCB(icebergs) = nan; mavgCC(icebergs) = nan; mavgCD(icebergs) = nan; mavgCT(icebergs) = nan;

% NOW SHORTEN AVERAGES
mavgCA = mavgCA(:,end-(newnum-1):end);
mavgCB = mavgCB(:,end-(newnum-1):end);
mavgCC = mavgCC(:,end-(newnum-1):end);
mavgCD = mavgCD(:,end-(newnum-1):end);
mavgCT = mavgCT(:,end-(newnum-1):end);


% Create ratios ~~THE MOST IMPORTANT PART~~
ratioCA = zero_compatible_divide(mavgCA,mavgCT); % use compatible divide to prevent 0/0 from being NaN
ratioCB = zero_compatible_divide(mavgCB,mavgCT); % use compatible divide to prevent 0/0 from being NaN
ratioCC = zero_compatible_divide(mavgCC,mavgCT); % use compatible divide to prevent 0/0 from being NaN
ratioCD = zero_compatible_divide(mavgCD,mavgCT); % use compatible divide to prevent 0/0 from being NaN



avgABC=mavgCA+mavgCB+mavgCC+mavgCD; 


%%%
% ~~ THE OTHER MOST IMPORTANT PART ~~
for i = 1:length(avgSIC(1,:)) % create high resolution partial concentrations from the Bremen SIC data
   CAhires(:,i)=avgSIC(:,i).*ratioCA(:,i); 
   CBhires(:,i)=avgSIC(:,i).*ratioCB(:,i);
   CChires(:,i)=avgSIC(:,i).*ratioCC(:,i);
   CDhires(:,i)=avgSIC(:,i).*ratioCD(:,i);
end



clear test Cbc IB IC tempnanSA tempnanSB tempnanSC dummyCA dummyCB dummyCC dummyCT dummyCD all99Ca all99Cb all99Cc all99Cd all99Ct all99Sa all99Sb all99Sc all99Sd avInt cc gg mm;
clear percca perccb perccc percct percsa percsb percsc yy yrs



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Step 6 | Calculate Sea Ice Thickness in cm

% Define short variables to use
funcSA = SIT.sa(:,end-(newnum-1):end);
funcSB = SIT.sb(:,end-(newnum-1):end);
funcSC = SIT.sc(:,end-(newnum-1):end);
funcSD = SIT.sd(:,end-(newnum-1):end);

shorterrSA = SIT.error.sa(:,end-(newnum-1):end);
shorterrSB = SIT.error.sb(:,end-(newnum-1):end);
shorterrSC = SIT.error.sc(:,end-(newnum-1):end);
shorterrSD = SIT.error.sd(:,end-(newnum-1):end);


disp('Calculating Thickness')
% THIS covers all possibilities though many are unlikely
for i=1:length(newdn);
    for j=1:length(SIT.lon);
        termA=(CAhires(j,i)/100)*funcSA(j,i); Era = (CAhires(j,i)/100)*shorterrSA(j,i);
        termB=(CBhires(j,i)/100)*funcSB(j,i); Erb = (CBhires(j,i)/100)*shorterrSB(j,i);
        termC=(CChires(j,i)/100)*funcSC(j,i); Erc = (CChires(j,i)/100)*shorterrSC(j,i);
        termD=(CDhires(j,i)/100)*funcSD(j,i); Erd = (CDhires(j,i)/100)*shorterrSD(j,i);
        if isfinite(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % ABCD
            shortSIT.H(j,i)=termA+termB+termC+termD;
            %disp('case 1')
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % ABC
            shortSIT.H(j,i)=termA+termB+termC;
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % ABD
            shortSIT.H(j,i)=termA+termB+termD;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % ACD
            shortSIT.H(j,i)=termA+termC+termD;
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isnan(termD)==1 % AB
            shortSIT.H(j,i)=termA+termB;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % AC
            shortSIT.H(j,i)=termA+termC;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % AD
            shortSIT.H(j,i)=termA+termD;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isnan(termC)==1 & isnan(termD)==1 % A
            shortSIT.H(j,i)=termA;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % BCD
            shortSIT.H(j,i)=termB+termC+termD;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % BC
            shortSIT.H(j,i)=termB+termC;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % BD
            shortSIT.H(j,i)=termB+termD;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isnan(termD)==1 % B
            shortSIT.H(j,i)=termB;
        elseif isnan(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % CD
            shortSIT.H(j,i)=termC+termD;
        elseif isnan(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % C
            shortSIT.H(j,i)=termC;
        elseif isnan(termA)==1 & isnan(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % D
            shortSIT.H(j,i)=termD;
        else
            shortSIT.H(j,i)=termA+termB+termC+termD; 
            %disp(['Else at i = ',num2str(i), ' j = ',num2str(j)])
        end
        
        % now for error - this is separate from above to avoid nan summing 
        if isfinite(Era)==1 & isfinite(Erb)==1 & isfinite(Erc)==1 & isfinite(Erd)==1 % ABCD
            shortSIT.error.H(j,i)=Era+Erb+Erc+Erd;
        elseif isfinite(Era)==1 & isfinite(Erb)==1 & isfinite(Erc)==1 & isnan(Erd)==1 % ABC
            shortSIT.error.H(j,i)=Era+Erb+Erc;
        elseif isfinite(Era)==1 & isfinite(Erb)==1 & isnan(Erc)==1 & isfinite(Erd)==1 % ABD
            shortSIT.error.H(j,i)=Era+Erb+Erd;
        elseif isfinite(Era)==1 & isnan(Erb)==1 & isfinite(Erc)==1 & isfinite(Erd)==1 % ACD
            shortSIT.error.H(j,i)=Era+Erc+Erd;
        elseif isfinite(Era)==1 & isfinite(Erb)==1 & isnan(Erc)==1 & isnan(Erd)==1 % AB
            shortSIT.error.H(j,i)=Era+Erb;
        elseif isfinite(Era)==1 & isnan(Erb)==1 & isfinite(Erc)==1 & isnan(Erd)==1 % AC
            shortSIT.error.H(j,i)=Era+Erc;
        elseif isfinite(Era)==1 & isnan(Erb)==1 & isnan(Erc)==1 & isfinite(Erd)==1 % AD
            shortSIT.error.H(j,i)=Era+Erd;
        elseif isfinite(Era)==1 & isnan(Erb)==1 & isnan(Erc)==1 & isnan(Erd)==1 % A
            shortSIT.error.H(j,i)=Era;
        elseif isnan(Era)==1 & isfinite(Erb)==1 & isfinite(Erc)==1 & isfinite(Erd)==1 % BCD
            shortSIT.error.H(j,i)=Erb+Erc+Erd;
        elseif isnan(Era)==1 & isfinite(Erb)==1 & isfinite(Erc)==1 & isnan(Erd)==1 % BC
            shortSIT.error.H(j,i)=Erb+Erc;
        elseif isnan(Era)==1 & isfinite(Erb)==1 & isnan(Erc)==1 & isfinite(Erd)==1 % BD
            shortSIT.error.H(j,i)=Erb+Erd;
        elseif isnan(Era)==1 & isfinite(Erb)==1 & isnan(Erc)==1 & isnan(Erd)==1 % B
            shortSIT.error.H(j,i)=Erb;
        elseif isnan(Era)==1 & isnan(Erb)==1 & isfinite(Erc)==1 & isfinite(Erd)==1 % CD
            shortSIT.error.H(j,i)=Erc+Erd;
        elseif isnan(Era)==1 & isnan(Erb)==1 & isfinite(Erc)==1 & isnan(Erd)==1 % C
            shortSIT.error.H(j,i)=Erc;
        elseif isnan(Era)==1 & isnan(Erb)==1 & isnan(Erc)==1 & isfinite(Erd)==1 % D
            shortSIT.error.H(j,i)=Erd;
        else
            shortSIT.error.H(j,i)=Era+Erb+Erc+Erd;
        end
        clear termA termB termC termD Era Erb Erc Erd
    end
    clear j;
end

shortSIT.error.sa = shorterrSA./100;
shortSIT.error.sb = shorterrSB./100;
shortSIT.error.sc = shorterrSC./100;
shortSIT.error.sd = shorterrSD./100;
shortSIT.error.H = shortSIT.error.H./100;


shortSIT.icebergs = icebergs;


disp('Sea Ice Thickness calculation complete')
clear i;




shortSIT.H = shortSIT.H./100; % convert from cm to m


% Step 7 | add the new computed partials to the SIT structure
shortSIT.lon = SIT.lon;
shortSIT.lat = SIT.lat;
shortSIT.ca_hires=CAhires;
shortSIT.cb_hires=CBhires;
shortSIT.cc_hires=CChires;
shortSIT.cd_hires=CDhires;
shortSIT.ct_hires=avgSIC;
shortSIT.icebergs = icebergs;
shortSIT.mavg.CA = mavgCA;
shortSIT.mavg.CB = mavgCB;
shortSIT.mavg.CC = mavgCC;
shortSIT.mavg.CD = mavgCD;
shortSIT.mavg.CT = mavgCT;
shortSIT.mavg.SA = mavgSA;
shortSIT.mavg.SB = mavgSB;
shortSIT.mavg.SC = mavgSC;
shortSIT.mavg.SD = mavgSD;
shortSIT.ca = SIT.ca(:,sdateloc:end);
shortSIT.cb = SIT.cb(:,sdateloc:end);
shortSIT.cc = SIT.cc(:,sdateloc:end);
shortSIT.cd = SIT.cd(:,sdateloc:end);
shortSIT.ct = SIT.ct(:,sdateloc:end);
shortSIT.sa = SIT.sa(:,sdateloc:end);
shortSIT.sb = SIT.sb(:,sdateloc:end);
shortSIT.sc = SIT.sc(:,sdateloc:end);
shortSIT.sd = SIT.sd(:,sdateloc:end);

%%% Step 8 | combine and save
clear SIT
if length(sector)==2
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
else
    if sector(1)=='a'
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones_short/',sector(1:6),'.mat']);
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones_short/',sector(1:11),'.mat']);
    end
end

oSIT = SIT; clear SIT

if length(sector) > 2
    sloc = strfind(sector, 'SIC');
    load(['ICE//ICETHICKNESS/Data/MAT_files/Final/orig_timescale/zones_short/Partials/',sector(1:sloc-2),'_partials.mat']);
    
end

    
% Cut down overlong mavg.SA
slen = length(shortSIT.mavg.SA(1,:));
clen = length(shortSIT.mavg.CA(1,:));
if slen>clen
    shortSIT.mavg.SA = shortSIT.mavg.SA(:,slen-(clen-1):end);
    shortSIT.mavg.SB = shortSIT.mavg.SB(:,slen-(clen-1):end);
    shortSIT.mavg.SC = shortSIT.mavg.SC(:,slen-(clen-1):end);
    shortSIT.mavg.SD = shortSIT.mavg.SD(:,slen-(clen-1):end);
end

lastloc = find(oSIT.dn==datenum(2021,03,11));
rm1 = lastloc+1;
if length(sector)==2 % The Sectors
    % Remove everything after
    oSIT.dv(rm1:end,:) = [];
    oSIT.dn(rm1:end) = [];
    oSIT.sa(:,rm1:end) = [];
    oSIT.sb(:,rm1:end) = [];
    oSIT.sc(:,rm1:end) = [];
    oSIT.sd(:,rm1:end) = [];
    oSIT.ca(:,rm1:end) = [];
    oSIT.cb(:,rm1:end) = [];
    oSIT.cc(:,rm1:end) = [];
    oSIT.cd(:,rm1:end) = [];
    oSIT.ct(:,rm1:end) = [];
    oSIT.H(:,rm1:end) = [];
    oSIT.ca_hires(:,rm1:end) = [];
    oSIT.cb_hires(:,rm1:end) = [];
    oSIT.cc_hires(:,rm1:end) = [];
    oSIT.cd_hires(:,rm1:end) = [];
    oSIT.ct_hires(:,rm1:end) = [];
    oSIT.mavg.CA(:,rm1:end) = [];
    oSIT.mavg.CB(:,rm1:end) = [];
    oSIT.mavg.CC(:,rm1:end) = [];
    oSIT.mavg.CD(:,rm1:end) = [];
    oSIT.mavg.CT(:,rm1:end) = [];
    oSIT.mavg.SA(:,rm1:end) = [];
    oSIT.mavg.SB(:,rm1:end) = [];
    oSIT.mavg.SC(:,rm1:end) = [];
    oSIT.mavg.SD(:,rm1:end) = [];
    oSIT.error.sa(:,rm1:end) = [];
    oSIT.error.sb(:,rm1:end) = [];
    oSIT.error.sc(:,rm1:end) = [];
    oSIT.error.sd(:,rm1:end) = [];
    oSIT.error.H(:,rm1:end) = [];

    % Build new SIT
    SIT.H = [oSIT.H, shortSIT.H];
    SIT.dn = [oSIT.dn; newdn];
    SIT.dv = [oSIT.dv; newdv];
    SIT.icebergs = shortSIT.icebergs;
    SIT.lon = oSIT.lon;
    SIT.lat = oSIT.lat;
    SIT.ca_hires = [oSIT.ca_hires, shortSIT.ca_hires];
    SIT.cb_hires = [oSIT.cb_hires, shortSIT.cb_hires];
    SIT.cc_hires = [oSIT.cc_hires, shortSIT.cc_hires];
    SIT.cd_hires = [oSIT.cd_hires, shortSIT.cd_hires];
    SIT.ct_hires = [oSIT.ct_hires, shortSIT.ct_hires];
    SIT.mavg.CA = [oSIT.mavg.CA, shortSIT.mavg.CA];
    SIT.mavg.CB = [oSIT.mavg.CB, shortSIT.mavg.CB];
    SIT.mavg.CC = [oSIT.mavg.CC, shortSIT.mavg.CC];
    SIT.mavg.CD = [oSIT.mavg.CD, shortSIT.mavg.CD];
    SIT.mavg.CT = [oSIT.mavg.CT, shortSIT.mavg.CT];
    SIT.mavg.SA = [oSIT.mavg.SA, shortSIT.mavg.SA];
    SIT.mavg.SB = [oSIT.mavg.SB, shortSIT.mavg.SB];
    SIT.mavg.SC = [oSIT.mavg.SC, shortSIT.mavg.SC];
    SIT.mavg.SD = [oSIT.mavg.SD, shortSIT.mavg.SD];
    SIT.error.H = [oSIT.error.H, shortSIT.error.H];
    SIT.error.sa = [oSIT.error.sa, shortSIT.error.sa];
    SIT.error.sb = [oSIT.error.sb, shortSIT.error.sb];
    SIT.error.sc = [oSIT.error.sc, shortSIT.error.sc];
    SIT.error.sd = [oSIT.error.sd, shortSIT.error.sd];
    SIT.ca = [oSIT.ca, shortSIT.ca];
    SIT.cb = [oSIT.cb, shortSIT.cb];
    SIT.cc = [oSIT.cc, shortSIT.cc];
    SIT.cd = [oSIT.cd, shortSIT.cd];
    SIT.ct = [oSIT.ct, shortSIT.ct];
    SIT.sa = [oSIT.sa, shortSIT.sa];
    SIT.sb = [oSIT.sb, shortSIT.sb];
    SIT.sc = [oSIT.sc, shortSIT.sc];
    SIT.sd = [oSIT.sd, shortSIT.sd];

else % The zones
    oSIT.dv(rm1:end,:) = [];
    oSIT.dn(rm1:end) = [];
    oSIT.H(:,rm1:end) = [];
    % partials
    partials.sa(:,rm1:end) = [];
    partials.sb(:,rm1:end) = [];
    partials.sc(:,rm1:end) = [];
    partials.sd(:,rm1:end) = [];
    partials.ca(:,rm1:end) = [];
    partials.cb(:,rm1:end) = [];
    partials.cc(:,rm1:end) = [];
    partials.cd(:,rm1:end) = [];
    partials.ct(:,rm1:end) = [];
    partials.ca_hires(:,rm1:end) = [];
    partials.cb_hires(:,rm1:end) = [];
    partials.cc_hires(:,rm1:end) = [];
    partials.cd_hires(:,rm1:end) = [];
    partials.ct_hires(:,rm1:end) = [];
    partials.mavg.CA(:,rm1:end) = [];
    partials.mavg.CB(:,rm1:end) = [];
    partials.mavg.CC(:,rm1:end) = [];
    partials.mavg.CD(:,rm1:end) = [];
    partials.mavg.CT(:,rm1:end) = [];
    partials.mavg.SA(:,rm1:end) = [];
    partials.mavg.SB(:,rm1:end) = [];
    partials.mavg.SC(:,rm1:end) = [];
    partials.mavg.SD(:,rm1:end) = [];
    partials.error.sa(:,rm1:end) = [];
    partials.error.sb(:,rm1:end) = [];
    partials.error.sc(:,rm1:end) = [];
    partials.error.sd(:,rm1:end) = [];
    partials.error.H(:,rm1:end) = [];
    

    % build SIT
    SIT.H = [oSIT.H, shortSIT.H];
    SIT.dn = [oSIT.dn; newdn];
    SIT.dv = [oSIT.dv; newdv];
    SIT.icebergs = shortSIT.icebergs;
    SIT.lon = oSIT.lon;
    SIT.lat = oSIT.lat;
    SIT.ca_hires = [partials.ca_hires, shortSIT.ca_hires];
    SIT.cb_hires = [partials.cb_hires, shortSIT.cb_hires];
    SIT.cc_hires = [partials.cc_hires, shortSIT.cc_hires];
    SIT.cd_hires = [partials.cd_hires, shortSIT.cd_hires];
    SIT.ct_hires = [partials.ct_hires, shortSIT.ct_hires];
    SIT.mavg.CA = [partials.mavg.CA, shortSIT.mavg.CA];
    SIT.mavg.CB = [partials.mavg.CB, shortSIT.mavg.CB];
    SIT.mavg.CC = [partials.mavg.CC, shortSIT.mavg.CC];
    SIT.mavg.CD = [partials.mavg.CD, shortSIT.mavg.CD];
    SIT.mavg.CT = [partials.mavg.CT, shortSIT.mavg.CT];
    SIT.mavg.SA = [partials.mavg.SA, shortSIT.mavg.SA];
    SIT.mavg.SB = [partials.mavg.SB, shortSIT.mavg.SB];
    SIT.mavg.SC = [partials.mavg.SC, shortSIT.mavg.SC];
    SIT.mavg.SD = [partials.mavg.SD, shortSIT.mavg.SD];
    SIT.error.H = [partials.error.H, shortSIT.error.H];
    SIT.error.sa = [partials.error.sa, shortSIT.error.sa];
    SIT.error.sb = [partials.error.sb, shortSIT.error.sb];
    SIT.error.sc = [partials.error.sc, shortSIT.error.sc];
    SIT.error.sd = [partials.error.sd, shortSIT.error.sd];
    SIT.ca = [partials.ca, shortSIT.ca];
    SIT.cb = [partials.cb, shortSIT.cb];
    SIT.cc = [partials.cc, shortSIT.cc];
    SIT.cd = [partials.cd, shortSIT.cd];
    SIT.ct = [partials.ct, shortSIT.ct];
    SIT.sa = [partials.sa, shortSIT.sa];
    SIT.sb = [partials.sb, shortSIT.sb];
    SIT.sc = [partials.sc, shortSIT.sc];
    SIT.sd = [partials.sd, shortSIT.sd];
end

% Sort out iceberg index
numgpoints = length(SIT.lon);
bergs = SIT.icebergs;
% 
% for ii = 1:length(SIT.dn)
% 
%     dnberg = find((bergs <= numgpoints) & (bergs > 0));
% 
%     icebergs{ii} = bergs(dnberg);
% 
%     bergs = bergs-numgpoints;
% 
%     clear dnberg
% end


newbergs = zeros(size(SIT.H));
newbergs(SIT.icebergs) = 1;
SIT.icebergs = newbergs;


% start thicol
% thiscol = 1:length(SIT.lon);
% for ii = 1:length(SIT.dn)
%     thisind = find(SIT.icebergs < thiscol(end) & SIT.icebergs > thiscol(1));
%     newbergs{ii} = SIT.icebergs(thisind);
%     
%     thiscol = thiscol+length(SIT.lon);
%     
%     clear thisind
% end
% SIT.icebergs = newbergs;
    
if length(unique(SIT.dn)) ~= length(SIT.dn)
    disp(['Need to remove a repeat date'])
    [v, w] = unique(SIT.dn, 'stable');
    dups = setdiff(1:numel(SIT.dn), w);
    if length(dups) > 1;
        error('More than 1 duplicate detected... investigate please')
    end
    disp(['Date to remove is ',datestr(SIT.dn(dups)),' Index ',num2str(dups)])
    
    % Now remove from all variables
    SIT.dn(dups) = [];
    SIT.dv(dups,:) = [];
    SIT.H(:,dups) = [];
    SIT.ca(:,dups) = [];
    SIT.cb(:,dups) = [];
    SIT.cc(:,dups) = [];
    SIT.cd(:,dups) = [];
    SIT.ct(:,dups) = [];
    SIT.sa(:,dups) = [];
    SIT.sb(:,dups) = [];
    SIT.sc(:,dups) = [];
    SIT.sd(:,dups) = [];
    SIT.ca_hires(:,dups) = [];
    SIT.cb_hires(:,dups) = [];
    SIT.cc_hires(:,dups) = [];
    SIT.cd_hires(:,dups) = [];
    SIT.ct_hires(:,dups) = [];
    SIT.icebergs(:,dups) = [];
    % now the deeper ones
    SIT.mavg.CA(:,dups) = [];
    SIT.mavg.CB(:,dups) = [];
    SIT.mavg.CC(:,dups) = [];
    SIT.mavg.CD(:,dups) = [];
    SIT.mavg.CT(:,dups) = [];
    SIT.mavg.SA(:,dups) = [];
    SIT.mavg.SB(:,dups) = [];
    SIT.mavg.SC(:,dups) = [];
    SIT.mavg.SD(:,dups) = [];
    SIT.error.H(:,dups) = [];
    SIT.error.sa(:,dups) = [];
    SIT.error.sb(:,dups) = [];
    SIT.error.sc(:,dups) = [];
    SIT.error.sd(:,dups) = [];
    
end
    
disp(['All seems to work... new end date is ',datestr(SIT.dn(end)), '  Remember to save!'])
%%
if length(sector)==2
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
else
    sloc = strfind(sector, 'SIC');
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Zones/',sector(1:sloc-2),'.mat'], 'SIT', '-v7.3');
end

disp(['Finished and updated sector ', sector]);














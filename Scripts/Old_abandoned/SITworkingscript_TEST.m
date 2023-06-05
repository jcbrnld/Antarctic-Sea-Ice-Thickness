%% get shapefiles ready for reading
%  use original version to see what is wrong with mine

fnames=textread('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt','%s');
% Create date variables
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
%--
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
%--
fnames=fnames(ind); % ind are the indices of the sorted files
shpfiles=cell(size(fnames));
% Read in Longitude and Latitude
x=cell(size(fnames));
y=cell(size(fnames));
lon=cell(size(fnames));
lat=cell(size(fnames));
for ii=1:length(fnames)
    disp([num2str(ii) ' of ' num2str(length(dn)) ' : Reading Lon/Lat'])
    ff1=cell2mat(fnames(ii));
    ff2=['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/' ff1];
    shpfiles{ii}=m_shaperead(ff2(1:end-4));
    % loop of number of polygons for each file
    for jj=1:length(shpfiles{ii}.ncst);
        dummyll=shpfiles{ii}.ncst{jj};
        x{ii,jj}=single(dummyll(:,1));
        y{ii,jj}=single(dummyll(:,2));
        [londummy,latdummy]=cart2pol(x{ii,jj},y{ii,jj});
        lat{ii,jj}=single((90-((latdummy/1000)/105))*-1);
        lon{ii,jj}=single((londummy*-180/pi)+270);
        clear dummyll londummy latdummy;
    end
    clear jj ff1 ff2;
end
clear ii x y;
%% load output grid for usage later
% % load /Users/cody/matlab/codyiMac/ICE/MAT_files/regional/reg12sic_v2.mat % Sabrina
% % long=reg12.lon;
% % latg=reg12.lat;
% % clear reg12;
% % % load /Users/cody/matlab/codyiMac/ICE/MAT_files/regional/reg17sic_v2.mat % Mertz
% % % long=reg17.lon;
% % % latg=reg17.lat;
% % % clear reg17;
 reg12=load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/sabrina_commonDN_SS_Slf_FIXED.mat','lon','lat'); 
 long=reg12.lon;
 latg=reg12.lat;
 clear reg12;
% reg17=load('/Users/cody/matlab/codyiMac/WorkingDirectories/MAT_files/mertz_commonDN_SS_Slf_FIXED.mat','lon','lat'); 
% long=reg17.lon;
% latg=reg17.lat;
% clear reg17;
% reg20=load('/Users/cody/matlab/codyiMac/WorkingDirectories/MAT_files/RossSea_common2.mat','lon','lat');
% long=reg20.lon;
% latg=reg20.lat;
% clear reg20;
SIT.H=single(nan(length(long),length(shpfiles)));
SIT.sa=SIT.H;
SIT.sb=SIT.H;
SIT.sc=SIT.H;
SIT.ca=SIT.H;
SIT.cb=SIT.H;
SIT.cc=SIT.H;
SIT.ct=SIT.H;
%% Read only polygons that are within the domain of the output grid from shapefiles
for ii=1:length(fnames); % all files
    icount1=0;
    for jj=2:length(shpfiles{ii}.ncst); % all polygons
        crrt1=0;
        dummylon=lon{ii,jj};
        for kk=1:length(dummylon);
            if (dummylon(kk)>=89.8 & dummylon(kk)<=90.2);
                crrt1=1;
            end
        end
        clear kk;
        if crrt1==1;
            dummylon(dummylon>360)=dummylon(dummylon>360)-360;
            lon{ii,jj}=[];
            lon{ii,jj}=dummylon;
            clear dummylon;
        end
        if min(lon{ii,jj})>max(long) | max(lon{ii,jj})<min(long) | min(lat{ii,jj})>max(latg) | max(lat{ii,jj})<min(latg)
        else
            icount1=icount1+1;
            polyg(icount1)=jj;
        end
        clear crrt1;
    end
    clear jj;
    goodpolys{ii}=polyg;
    
    for kk=1:length(polyg);
        longood{ii,kk}=lon{ii,polyg(kk)};
        latgood{ii,kk}=lat{ii,polyg(kk)};
    end
    clear kk;
    
    junk=cell2mat(shpfiles(ii));
    CA{ii}=single(str2double(junk.dbf.CA(polyg)));
    SA{ii}=single(str2double(junk.dbf.SA(polyg)));
    CB{ii}=single(str2double(junk.dbf.CB(polyg)));
    SB{ii}=single(str2double(junk.dbf.SB(polyg)));
    CC{ii}=single(str2double(junk.dbf.CC(polyg)));
    SC{ii}=single(str2double(junk.dbf.SC(polyg)));
    CT{ii}=single(str2double(junk.dbf.CT(polyg)));
    clear junk polyg icount1;

end
clear ii;
%% SHORTEN (OR SKIP)
iii=30;
dn = dn(1:iii);
dv = dv(1:iii, :);
fnames = fnames(1:iii);
ind = ind(1:iii);
lat = lat(1:iii,:);
lon = lon(1:iii,:);
shpfiles = shpfiles(1:iii);
SA = SA(1:iii);
SB = SB(1:iii);
SC = SC(1:iii);
CA = CA(1:iii);
CB = CB(1:iii);
CC = CC(1:iii);
CT = CT(1:iii);

SIT.sa = SIT.sa(1:iii);
SIT.sb = SIT.sb(1:iii);
SIT.sc = SIT.sc(1:iii);
SIT.ca = SIT.ca(1:iii);
SIT.cb = SIT.cb(1:iii);
SIT.cc = SIT.cc(1:iii);
SIT.ct = SIT.ct(1:iii);

SIT.H = SIT.H(:,1:iii);

%% grid polygon data

for ii=1:length(fnames); % all files
    disp([num2str(ii) ' of ' num2str(length(fnames))])
    tempsa=SA{ii};
    tempsb=SB{ii};
    tempsc=SC{ii};
    tempca=CA{ii};
    tempcb=CB{ii};
    tempcc=CC{ii};
    tempct=CT{ii};
    for jj=1:length(tempsa); % all good polygons
        nnn1=find(isnan(longood{ii,jj})==1);
        if ~isempty(nnn1)
            polyind1=1:(nnn1-1); % the first index up to the last finite value before the first NaN
        else
            polyind1=':'; % no NaN values were found, use all values
        end
        ind1=find(long>=min(longood{ii,jj}) & long<=max(longood{ii,jj}) & latg>=min(latgood{ii,jj}) & latg<=max(latgood{ii,jj}));
        dlon=longood{ii,jj};
        dlat=latgood{ii,jj};
        ISIN=find(isinpoly(long(ind1),latg(ind1),dlon(polyind1),dlat(polyind1))==1);
        clear dlon dlat;
        SIT.sa(ind1(ISIN),ii)=tempsa(jj);
        SIT.sb(ind1(ISIN),ii)=tempsb(jj);
        SIT.sc(ind1(ISIN),ii)=tempsc(jj);
        SIT.ca(ind1(ISIN),ii)=tempca(jj);
        SIT.cb(ind1(ISIN),ii)=tempcb(jj);
        SIT.cc(ind1(ISIN),ii)=tempcc(jj);
        SIT.ct(ind1(ISIN),ii)=tempct(jj);
        clear nnn1 ind1 ISIN
    end
    clear jj tempsa tempsb tempsc tempca tempcb tempcc tempct;
end
clear ii;


% check
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



%% Decode Data

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
SIT.ct(SIT.ct==91)=95; % more than 9/10, but less than 10/10
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

SIT.sa(SIT.sa==-9)=nan;
SIT.sa(SIT.sa==1)=0;
SIT.sa(SIT.sa==2)=1.5;
SIT.sa(SIT.sa==51)=55;
SIT.sa(SIT.sa==52)=60;
SIT.sa(SIT.sa==53)=65;
SIT.sa(SIT.sa==54)=70;
SIT.sa(SIT.sa==55)=75;
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
SIT.sa(SIT.sa==70)=200;
SIT.sa(SIT.sa==71)=250;
SIT.sa(SIT.sa==72)=300;
SIT.sa(SIT.sa==73)=350;
SIT.sa(SIT.sa==74)=400;
SIT.sa(SIT.sa==75)=500;
SIT.sa(SIT.sa==76)=600;
SIT.sa(SIT.sa==77)=700;
SIT.sa(SIT.sa==78)=800;
SIT.sa(SIT.sa==79)=-79;
SIT.sa(SIT.sa==80)=-80;
SIT.sa(SIT.sa==81)=2.5;
SIT.sa(SIT.sa==82)=5;
SIT.sa(SIT.sa==83)=15;
SIT.sa(SIT.sa==84)=12.5;
SIT.sa(SIT.sa==85)=22.5;
SIT.sa(SIT.sa==86)=115;
SIT.sa(SIT.sa==87)=50;
SIT.sa(SIT.sa==88)=40;
SIT.sa(SIT.sa==89)=60;
SIT.sa(SIT.sa==90)=-90;
SIT.sa(SIT.sa==91)=95;
SIT.sa(SIT.sa==92)=-92;
SIT.sa(SIT.sa==93)=160;
SIT.sa(SIT.sa==94)=-94;
SIT.sa(SIT.sa==95)=600;
SIT.sa(SIT.sa==96)=400;
SIT.sa(SIT.sa==97)=800;
SIT.sa(SIT.sa==98)=nan;
SIT.sa(SIT.sa==99)=-99;
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

% There are only -99 values, but no other issues for our questionable codes

% check
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


%% TRY THIS QC METHOD (NEW)

SIT.dn=dn;
SIT.dv=dv;
SIT.lon=long;
SIT.lat=latg;
%clear dn dv long latg polyind1 shpfiles longood latgood lon lat fnames ind SA SB SC CA CB CC CT dummylon goodpolys;
% first compute the record length average of times when all components are
% present
% Stage of Development
tempnanSA=find(SIT.sa<0);
tempnanSB=find(SIT.sb<0);
tempnanSC=find(SIT.sc<0);
dummySA=SIT.sa;
dummySB=SIT.sb;
dummySC=SIT.sc;
dummySA(tempnanSA)=nan;
dummySB(tempnanSB)=nan;
dummySC(tempnanSC)=nan;
avgSA=nanmean(dummySA,2); % The 2 indicates along rows - average in that location across all times
avgSB=nanmean(dummySB,2);
avgSC=nanmean(dummySC,2);
ratioSA=avgSA./(avgSA+avgSB+avgSC);
ratioSB=avgSB./(avgSA+avgSB+avgSC);
ratioSC=avgSC./(avgSA+avgSB+avgSC);
check=ratioSA+ratioSB+ratioSC;
if sum(check)==length(check)
    disp('yes!')
    clear check;
end
stgdevratio=[ratioSA,ratioSB,ratioSC];
clear dummySA dummySB dummySC;
[Cab,IA,IB]=intersect(tempnanSA,tempnanSB);
[Cabc,Iab,IC]=intersect(Cab,tempnanSC);
%clear Cab Cabc IA IB Iab IC stgdevratio; % use tempnanSA...When SIT.sa is -99, so are SIT.sb and SIT.sc
avgABC=avgSA+avgSB+avgSC;
for i=1:length(SIT.dn); % loop through all files - everywhere a -99 appears fill with average at that location across all times
    all99=find(SIT.sa(:,i)==-99);
    SIT.sa(all99,i)=avgABC(all99).*ratioSA(all99); %This is the same as avgSA? 
    SIT.sb(all99,i)=avgABC(all99).*ratioSB(all99);
    SIT.sc(all99,i)=avgABC(all99).*ratioSC(all99);
    clear all99;
end
clear i;
[Cbc,IB,IC]=intersect(tempnanSB,tempnanSC);
for i=1:length(SIT.dn); % loop through all files
    all99=find(SIT.sb(:,i)==-99);
    SIT.sb(all99,i)=avgABC(all99).*ratioSB(all99);
    SIT.sc(all99,i)=avgABC(all99).*ratioSC(all99);
    clear all99;
end
clear i;
for i=1:length(SIT.dn); % loop through all files
    all99=find(SIT.sc(:,i)==-99);
    SIT.sc(all99,i)=avgABC(all99).*ratioSC(all99);
    clear all99;
end
clear i;
% Sea Ice Concentration
% once for initial QC --no longer necessary as it loops itself--
for qq = 1:2;
    for i=1:length(SIT.dn); % all files
        for j=1:length(SIT.lon); % all grid points
            % Case 1: all finite, but do not add up to CT
            if (isfinite(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1 & SIT.ca(j,i)+SIT.cb(j,i)+SIT.cc(j,i)~=SIT.ct(j,i))
                difference=SIT.ct(j,i)-(SIT.ca(j,i)+SIT.cb(j,i)+SIT.cc(j,i));
                if difference<0;
                    SIT.ca(j,i)=nan;SIT.cb(j,i)=nan;SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference>0;
                    % fill in the difference across the partials with their
                    % weighted value
                    if qq==2;
                        SIT.ca(j,i)=SIT.ca(j,i)+difference*ratioCA(j,i); % new MA
                        SIT.cb(j,i)=SIT.cb(j,i)+difference*ratioCB(j,i); % new MA
                        SIT.cc(j,i)=SIT.cc(j,i)+difference*ratioCC(j,i); % new MA
%                         SIT.ca(j,i)=SIT.ca(j,i)+difference*ratioCA(j); % cmmt 1st (not anymore)
%                         SIT.cb(j,i)=SIT.cb(j,i)+difference*ratioCB(j); % cmmt 1st (not anymore)
%                         SIT.cc(j,i)=SIT.cc(j,i)+difference*ratioCC(j); % cmmt 1st (not anymore)
                    end
                elseif difference==0;
                    disp('FLAG - case 1 - This should not have happened')
                    
                end
        
              clear difference;
            % Case 2: CA=nan, but CB, CC, CT are finite    
            elseif (isnan(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1)
                difference=SIT.ct(j,i)-(SIT.cb(j,i)+SIT.cc(j,i));
                if difference<0;
                    SIT.cb(j,i)=nan;SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    SIT.ca(j,i)=0;
                elseif difference>0;
                    SIT.ca(j,i)=difference;
                end
                clear difference
            % Case 3: CB=nan, but CA, CC, CT are finite    
            elseif (isfinite(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                difference=SIT.ct(j,i)-(SIT.ca(j,i)+SIT.cc(j,i));
                if difference<0;
                    SIT.ca(j,i)=nan;SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    SIT.cb(j,i)=0;
                elseif difference>0;
                    SIT.cb(j,i)=difference;
                end
                clear difference;
            % Case 4: CC=nan, but CA, CB, CT are finite    
            elseif (isfinite(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                difference=SIT.ct(j,i)-(SIT.ca(j,i)+SIT.cb(j,i));
                if difference<0;
                    SIT.ca(j,i)=nan;SIT.cb(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    SIT.cc(j,i)=0;
                elseif difference>0;
                    SIT.cc(j,i)=difference;
                end
                clear difference;
            % Case 5: CA, CT are finite, CB, CC are nan   
            elseif (isfinite(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                difference=SIT.ct(j,i)-SIT.ca(j,i);
                if difference<0;
                    SIT.ca(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    SIT.cb(j,i)=0;SIT.cc(j,i)=0;
                elseif difference>0;             
                    % replace remaining partials with their weighted value
                    if qq==2;
                        ratio=ratioCB(j,i)/ratioCC(j,i); % new MA
 %                       ratio=ratioCB(j)/ratioCC(j); % cmmt 1st (not anymore)
                        SIT.cc(j,i)=difference/(ratio+1); % cmmt 1st (not anymore)
                        SIT.cb(j,i)=difference-SIT.cc(j,i); % cmmt 1st (not anymore)
                        clear ratio; % cmmt 1st
                    end
                end
                clear difference;
            % Case 6: CB, CT are finite, CA, CC are nan    
            elseif (isnan(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                difference=SIT.ct(j,i)-SIT.cb(j,i);
                if difference<0;
                    SIT.cb(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    SIT.ca(j,i)=0;SIT.cc(j,i)=0;
                elseif difference>0;
                    % replace remaining partials with their weighted value
                    if qq==2;
                        ratio=ratioCA(j,i)/ratioCC(j,i); % new CA
 %                       ratio=ratioCA(j)/ratioCC(j); % cmmt 1st (not anymore)
                        SIT.cc(j,i)=difference/(ratio+1); % cmmt 1st (not anymore)
                        SIT.ca(j,i)=difference-SIT.cc(j,i); % cmmt 1st (not anymore)
                        clear ratio; % cmmt 1st
                    end
                end
                clear difference;
            % Case 7: CC, CT are finite, CA, CB are nan    
            elseif (isnan(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                difference=SIT.ct(j,i)-SIT.cc(j,i);
                if difference<0;
                    SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
                elseif difference==0;
                    SIT.ca(j,i)=0;SIT.cb(j,i)=0;
                elseif difference>0;
                    % replace remaining partials with their weighted value
                    if qq==2;
                        ratio=ratioCA(j,i)/ratioCB(j,i); % new CA
 %                       ratio=ratioCA(j)/ratioCB(j); % cmmt 1st (not anymore)
                        SIT.cb(j,i)=difference/(ratio+1); % cmmt 1st (not anymore)
                        SIT.ca(j,i)=difference-SIT.cb(j,i); % cmmt 1st (not anymore)
                        clear ratio; % cmmt 1st
                    end
                end
                clear difference;
            % Case 8: finite value for CT, but nan for CA, CB, CC
            elseif (isnan(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                    isfinite(SIT.ct(j,i))==1)
                % replace partials with their weighted value
                if qq==2;
                    SIT.ca(j,i)=ratioCA(j,i)*SIT.ct(j,i); % new MA
                    SIT.cb(j,i)=ratioCB(j,i)*SIT.ct(j,i); % new MA
                    SIT.cc(j,i)=ratioCC(j,i)*SIT.ct(j,i); % new MA
                
%                    SIT.ca(j,i)=ratioCA(j)*SIT.ct(j,i); % cmmt 1st (not anymore)
%                    SIT.cb(j,i)=ratioCB(j)*SIT.ct(j,i); % cmmt 1st (not anymore)
%                    SIT.cc(j,i)=ratioCC(j)*SIT.ct(j,i); % cmmt 1st (not anymore)
                end
            % Case 9: finite CA, CB, CC, but CT=nan    
            elseif (isfinite(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                    isnan(SIT.ct(j,i))==1)
                test=SIT.ca(j,i)+SIT.cb(j,i)+SIT.cc(j,i);
                if test<=100 & test>=0;
                    SIT.ct(j,i)=test;
                else
                    SIT.ca(j,i)=nan;SIT.cb(j,i)=nan;SIT.cc(j,i)=nan;
                end
                clear test;
            % Case 10: one of the partials is nan and CT is nan    
            elseif ((isnan(SIT.ca(j,i))==1 | isnan(SIT.cb(j,i))==1 | isnan(SIT.cc(j,i))==1) & ...
                    isnan(SIT.ct(j,i))==1)
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

%     avgCA=nan(size(avgSA));
%     avgCB=avgCA;
%     avgCC=avgCA;
%     avgCT=avgCA;
%     

%     
%     for i=1:length(SIT.lon);
%         good=find(dummyCA(i,:)+dummyCB(i,:)+dummyCC(i,:)==dummyCT(i,:));
%         avgCA(i)=nanmean(dummyCA(i,good),2); % Average ca across all times where ca+cb+cc=ct at each grid point
%         avgCB(i)=nanmean(dummyCB(i,good),2);
%         avgCC(i)=nanmean(dummyCC(i,good),2);
%         avgCT(i)=nanmean(dummyCT(i,good),2);
%         clear good;
%     end
%     clear i;
% 
%     ratioCA=avgCA./avgCT;
%     ratioCB=avgCB./avgCT;
%     ratioCC=avgCC./avgCT; 
%     test=[ratioCA,ratioCB,ratioCC,ratioCA+ratioCB+ratioCC]; % visually checked

% --- new Moving Average below ---
% 
    mavgCA=nan(size(avgSA));
    mavgCB=mavgCA;
    mavgCC=mavgCA;
    mavgCT=mavgCA;
    
    yrs = unique(SIT.dv(:,1));
    mnths = unique(SIT.dv(:,2));
    for yy = 1:length(yrs); % each year
        disp(yrs(yy))
        for mm = 1:length(mnths) % each month (this could have just been 1:12) but I decided to be a little extra
            for gg = 1:length(SIT.lon); % each grid point
                if yy == 1; % The first year
                    ind = find(SIT.dv(:,1) == yrs(yy)&yrs(yy+1)&yrs(yy+2) & SIT.dv(:,2) == mnths(mm));
                        %good = find(dummyCA(gg,ind)+dummyCB(gg,ind)+dummyCC(gg,ind) == dummyCT(gg,ind)); 
                        good = find(sum([dummyCA(gg,ind),dummyCB(gg,ind),dummyCC(gg,ind)],'omitnan') == dummyCT(gg,ind)); %different addition method
                        %good=ind;
                        mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCA(gg,good),2); 
                        mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCB(gg,good),2); 
                        mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCC(gg,good),2); 
                        mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCT(gg,good),2);
                elseif yy == length(unique(dv(:,1))); % the last year
                    lstm = SIT.dv(end,2);
                    if mm > lstm;
                        continue
                    else
                        ind = find(SIT.dv(:,1) == yrs(yy-2)&yrs(yy-1)&yrs(yy) & SIT.dv(:,2) == mnths(mm));
                        %good = find(dummyCA(gg,ind)+dummyCB(gg,ind)+dummyCC(gg,ind) == dummyCT(gg,ind)); 
                        good = find(sum([dummyCA(gg,ind),dummyCB(gg,ind),dummyCC(gg,ind)],'omitnan') == dummyCT(gg,ind)); %different addition method
                        %good=ind;
                        mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCA(gg,good),2); 
                        mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCB(gg,good),2); 
                        mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCC(gg,good),2); 
                        mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCT(gg,good),2);
                    end
                else % everything in between the first and last years 
                    ind = find(SIT.dv(:,1) == yrs(yy-1)&yrs(yy)&yrs(yy+1) & SIT.dv(:,2) == mnths(mm));
                    %good = find(dummyCA(gg,ind)+dummyCB(gg,ind)+dummyCC(gg,ind) == dummyCT(gg,ind)); 
                    good = find(sum([dummyCA(gg,ind),dummyCB(gg,ind),dummyCC(gg,ind)],'omitnan') == dummyCT(gg,ind)); %different addition method
                    %good=ind;
                    mavgCA(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCA(gg,good),2); 
                    mavgCB(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCB(gg,good),2); 
                    mavgCC(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCC(gg,good),2); 
                    mavgCT(gg,find(dv(:,1)==yrs(yy) & dv(:,2)==mm)) = nanmean(dummyCT(gg,good),2);
                
                end
            end
        
        end
    end
    
    ratioCA=mavgCA./mavgCT;
    ratioCB=mavgCB./mavgCT;
    ratioCC=mavgCC./mavgCT;
    
    
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


%% Quality Control Data

SIT.dn=dn;
SIT.dv=dv;
SIT.lon=long;
SIT.lat=latg;
%clear dn dv long latg polyind1 shpfiles longood latgood lon lat fnames ind SA SB SC CA CB CC CT dummylon goodpolys;
% first compute the record length average of times when all components are
% present
% Stage of Development
tempnanSA=find(SIT.sa<0);
tempnanSB=find(SIT.sb<0);
tempnanSC=find(SIT.sc<0);
dummySA=SIT.sa;
dummySB=SIT.sb;
dummySC=SIT.sc;
dummySA(tempnanSA)=nan;
dummySB(tempnanSB)=nan;
dummySC(tempnanSC)=nan;
avgSA=nanmean(dummySA,2);
avgSB=nanmean(dummySB,2);
avgSC=nanmean(dummySC,2);
ratioSA=avgSA./(avgSA+avgSB+avgSC);
ratioSB=avgSB./(avgSA+avgSB+avgSC);
ratioSC=avgSC./(avgSA+avgSB+avgSC);
check=ratioSA+ratioSB+ratioSC;
if sum(check)==length(check)
    disp('yes!')
    clear check;
end
stgdevratio=[ratioSA,ratioSB,ratioSC];
clear dummySA dummySB dummySC;
[Cab,IA,IB]=intersect(tempnanSA,tempnanSB);
[Cabc,Iab,IC]=intersect(Cab,tempnanSC);
clear Cab Cabc IA IB Iab IC stgdevratio; % use tempnanSA...When SIT.sa is -99, so are SIT.sb and SIT.sc
avgABC=avgSA+avgSB+avgSC;
for i=1:length(SIT.dn); % loop through all files
    all99=find(SIT.sa(:,i)==-99);
    SIT.sa(all99,i)=avgABC(all99).*ratioSA(all99);
    SIT.sb(all99,i)=avgABC(all99).*ratioSB(all99);
    SIT.sc(all99,i)=avgABC(all99).*ratioSC(all99);
    clear all99;
end
clear i;
[Cbc,IB,IC]=intersect(tempnanSB,tempnanSC);
for i=1:length(SIT.dn); % loop through all files
    all99=find(SIT.sb(:,i)==-99);
    SIT.sb(all99,i)=avgABC(all99).*ratioSB(all99);
    SIT.sc(all99,i)=avgABC(all99).*ratioSC(all99);
    clear all99;
end
clear i;
for i=1:length(SIT.dn); % loop through all files
    all99=find(SIT.sc(:,i)==-99);
    SIT.sc(all99,i)=avgABC(all99).*ratioSC(all99);
    clear all99;
end
clear i;
% Sea Ice Concentration
% once for initial QC
for i=1:length(SIT.dn); % all files
    for j=1:length(SIT.lon); % all grid points
        % Case 1: all finite, but do not add up to CT
        if (isfinite(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1 & SIT.ca(j,i)+SIT.cb(j,i)+SIT.cc(j,i)~=SIT.ct(j,i))
            difference=SIT.ct(j,i)-(SIT.ca(j,i)+SIT.cb(j,i)+SIT.cc(j,i));
            if difference<0;
                SIT.ca(j,i)=nan;SIT.cb(j,i)=nan;SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
            elseif difference>0;
                % fill in the difference across the partials with their
                % weighted value
                 SIT.ca(j,i)=SIT.ca(j,i)+difference*ratioCA(j); % cmmt 1st
                SIT.cb(j,i)=SIT.cb(j,i)+difference*ratioCB(j); % cmmt 1st
                 SIT.cc(j,i)=SIT.cc(j,i)+difference*ratioCC(j); % cmmt 1st
            end
            clear difference;
        % Case 2: CA=nan, but CB, CC, CT are finite    
        elseif (isnan(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1)
            difference=SIT.ct(j,i)-(SIT.cb(j,i)+SIT.cc(j,i));
            if difference<0;
                SIT.cb(j,i)=nan;SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
            elseif difference==0;
                SIT.ca(j,i)=0;
            elseif difference>0;
                SIT.ca(j,i)=difference;
            end
            clear difference
        % Case 3: CB=nan, but CA, CC, CT are finite    
        elseif (isfinite(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1)
            difference=SIT.ct(j,i)-(SIT.ca(j,i)+SIT.cc(j,i));
            if difference<0;
                SIT.ca(j,i)=nan;SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
            elseif difference==0;
                SIT.cb(j,i)=0;
            elseif difference>0;
                SIT.cb(j,i)=difference;
            end
            clear difference;
        % Case 4: CC=nan, but CA, CB, CT are finite    
        elseif (isfinite(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1)
            difference=SIT.ct(j,i)-(SIT.ca(j,i)+SIT.cb(j,i));
            if difference<0;
                SIT.ca(j,i)=nan;SIT.cb(j,i)=nan; % fixed by Case 8 on 2nd pass
            elseif difference==0;
                SIT.cc(j,i)=0;
            elseif difference>0;
                SIT.cc(j,i)=difference;
            end
            clear difference;
        % Case 5: CA, CT are finite, CB, CC are nan   
        elseif (isfinite(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1)
            difference=SIT.ct(j,i)-SIT.ca(j,i);
            if difference<0;
                SIT.ca(j,i)=nan; % fixed by Case 8 on 2nd pass
            elseif difference==0;
                SIT.cb(j,i)=0;SIT.cc(j,i)=0;
            elseif difference>0;
                % replace remaining partials with their weighted value
                 ratio=ratioCB(j)/ratioCC(j); % cmmt 1st
                 SIT.cc(j,i)=difference/(ratio+1); % cmmt 1st
                 SIT.cb(j,i)=difference-SIT.cc(j,i); % cmmt 1st
                 clear ratio; % cmmt 1st
            end
            clear difference;
        % Case 6: CB, CT are finite, CA, CC are nan    
        elseif (isnan(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1)
            difference=SIT.ct(j,i)-SIT.cb(j,i);
            if difference<0;
                SIT.cb(j,i)=nan; % fixed by Case 8 on 2nd pass
            elseif difference==0;
                SIT.ca(j,i)=0;SIT.cc(j,i)=0;
            elseif difference>0;
                % replace remaining partials with their weighted value
                 ratio=ratioCA(j)/ratioCC(j); % cmmt 1st
                 SIT.cc(j,i)=difference/(ratio+1); % cmmt 1st
                 SIT.ca(j,i)=difference-SIT.cc(j,i); % cmmt 1st
                 clear ratio; % cmmt 1st
            end
            clear difference;
        % Case 7: CC, CT are finite, CA, CB are nan    
        elseif (isnan(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1)
            difference=SIT.ct(j,i)-SIT.cc(j,i);
            if difference<0;
                SIT.cc(j,i)=nan; % fixed by Case 8 on 2nd pass
            elseif difference==0;
                SIT.ca(j,i)=0;SIT.cb(j,i)=0;
            elseif difference>0;
                % replace remaining partials with their weighted value
                 ratio=ratioCA(j)/ratioCB(j); % cmmt 1st
                 SIT.cb(j,i)=difference/(ratio+1); % cmmt 1st
                 SIT.ca(j,i)=difference-SIT.cb(j,i); % cmmt 1st
                 clear ratio; % cmmt 1st
            end
            clear difference;
        % Case 8: finite value for CT, but nan for CA, CB, CC
        elseif (isnan(SIT.ca(j,i))==1 & isnan(SIT.cb(j,i))==1 & isnan(SIT.cc(j,i))==1 & ...
                isfinite(SIT.ct(j,i))==1)
            % replace partials with their weighted value
             SIT.ca(j,i)=ratioCA(j)*SIT.ct(j,i); % cmmt 1st
             SIT.cb(j,i)=ratioCB(j)*SIT.ct(j,i); % cmmt 1st
             SIT.cc(j,i)=ratioCC(j)*SIT.ct(j,i); % cmmt 1st
        % Case 9: finite CA, CB, CC, but CT=nan    
        elseif (isfinite(SIT.ca(j,i))==1 & isfinite(SIT.cb(j,i))==1 & isfinite(SIT.cc(j,i))==1 & ...
                isnan(SIT.ct(j,i))==1)
            test=SIT.ca(j,i)+SIT.cb(j,i)+SIT.cc(j,i);
            if test<=100 & test>=0;
                SIT.ct(j,i)=test;
            else
                SIT.ca(j,i)=nan;SIT.cb(j,i)=nan;SIT.cc(j,i)=nan;
            end
            clear test;
        % Case 10: one of the partials is nan and CT is nan    
        elseif ((isnan(SIT.ca(j,i))==1 | isnan(SIT.cb(j,i))==1 | isnan(SIT.cc(j,i))==1) & ...
                isnan(SIT.ct(j,i))==1)
            % no way of knowing the truth so fill nan
            SIT.ca(j,i)=nan;SIT.cb(j,i)=nan;SIT.cc(j,i)=nan;
        end
    end
    clear j;
end
clear i;

% compare partial concentration ratios with stage of development ratios
dummyCA=SIT.ca;
dummyCB=SIT.cb;
dummyCC=SIT.cc;
dummyCT=SIT.ct;

avgCA=nan(size(avgSA));
avgCB=avgCA;
avgCC=avgCA;
avgCT=avgCA;
for i=1:length(SIT.lon);
    good=find(dummyCA(i,:)+dummyCB(i,:)+dummyCC(i,:)==dummyCT(i,:));
    avgCA(i)=nanmean(dummyCA(i,good),2);
    avgCB(i)=nanmean(dummyCB(i,good),2);
    avgCC(i)=nanmean(dummyCC(i,good),2);
    avgCT(i)=nanmean(dummyCT(i,good),2);
    clear good;
end
clear i;

ratioCA=avgCA./avgCT;
ratioCB=avgCB./avgCT;
ratioCC=avgCC./avgCT; 
test=[ratioCA,ratioCB,ratioCC,ratioCA+ratioCB+ratioCC]; % visually checked
clear test Cbc IB IC tempnanSA tempnanSB tempnanSC dummyCA dummyCB dummyCC dummyCT;

% check 
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


%%
% use the calculated ratios for the partial concentration to create revised
% partial concentrations from our SIC dataset
% load('/Users/cody/matlab/codyiMac/WorkingDirectories/MAT_files/sabrina_commonDN_SS_Slf_FIXED.mat','SICcorr2','dn') % Sabrina
load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/sabrina_commonDN_SS_Slf_FIXED.mat','SICcorr2','dn', 'lon') % Sabrina
[C,IA,IB]=intersect(dn,SIT.dn); % dn corresponds to the sic date number
sic_compare=single(nan(size(SICcorr2,1),length(C)));
for i=1:length(C);
    sic_compare(:,i)=nanmean(SICcorr2(:,IA(i)-7:IA(i)+7),2); % get an average equivolent to the eggcode average
end
clear i;
for i=1:length(C);
    CAhires(:,i)=sic_compare(:,i).*ratioCA; % multiply our new "CT" by the weighted distribution
    CBhires(:,i)=sic_compare(:,i).*ratioCB;
    CChires(:,i)=sic_compare(:,i).*ratioCC;
end
clear i;

% Below for alt qc
% for i=1:length(C);
%     CAhires(:,i)=sic_compare(:,i).*ratioCA(:,i); % multiply our new "CT" by the weighted distribution
%     CBhires(:,i)=sic_compare(:,i).*ratioCB(:,i);
%     CChires(:,i)=sic_compare(:,i).*ratioCC(:,i);
% end
% clear i;



%% Calculate Sea Ice Thickness in cm

% SIT.H=(CAhires/100).*SIT.sa+(CBhires/100).*SIT.sb+(CChires/100).*SIT.sc;
% this does not allow for a single term with a NaN to compute a NaN for
% thickness unless all terms are NaN
for i=1:length(C);
    for j=1:length(SIT.lon);
        termA=(CAhires(j,i)/100)*SIT.sa(j,IB(i));
        termB=(CBhires(j,i)/100)*SIT.sb(j,IB(i));
        termC=(CChires(j,i)/100)*SIT.sc(j,IB(i));
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
clear i;

%% MAKE A MOVIE
% only after finishing the SIT calculation

for ii = 1:length(SIT.sa(1,:));
    m_basemap('a', [110, 123, 5], [-68, -64, 1])
    set(gcf, 'Position', [600, 500, 800, 700])
    m_scatter(SIT.lon, SIT.lat, 30,SIT.H(:,ii), 'filled')
    if isnan(SIT.dv(ii))==0
        xlabel(datestr(datetime(SIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
    else
        xlabel('-- --- ----')
    end
    colormap jet
    caxis([0,600])
    colorbar
    F(ii) = getframe(gcf);
    close gcf
end

writerobj = VideoWriter('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Figures/Videos/Sabrina_TEST4-old-.avi');
writerobj.FrameRate = 5;

open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp('Success! Video saved')
clear F
%% add the new computed partials to the SIT structure
SIT.ca_hires=CAhires;
SIT.cb_hires=CBhires;
SIT.cc_hires=CChires;
SIT.ct_hires=sic_compare;



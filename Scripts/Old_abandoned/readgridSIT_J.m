function SIT=readgridSIT_J(region,sv);
% SIT=READGRIDSIT(REGIONS,SV);
%   reads,extracts, and grids sea ice thickness data for the record length
%   for the specified region
%   EXAMPLE: acSIT=readgridSIT('ac',1);
%       the 1 tells the function to save a structure to a matfile
%   Cody Webb July 25, 2016

%   Jacob Arnold December 14 2020

% For now regions are 'ac', 'mertz', and 'sabrina'



fnames=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt','%s');
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
clear ii yyyy mm dd xx B dummyfn fnames;
dv=datevec(dn);
% list of actual data file names
fnames=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesIT.txt','%s');

% sort list of actual data files in chronological order
fnames_T1=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITcor.txt','%s');
fnames_T2=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt','%s');
for ii = (1:length(fnames_T1));
    ind(ii) = find(ismember(fnames_T1, fnames_T2(ii)));
end 
ind = ind.';

fnames=fnames(ind); % ind are the indices of the sorted files
H=cell(size(fnames));
shpfiles=cell(size(fnames));
% Create a matrix of thickness data for each file
for ii=1:length(fnames);
    disp([num2str(ii) ' of ' num2str(length(fnames)) ' : Reading shapefiles'])
    ff1=cell2mat(fnames(ii));
    ff2=['/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/' ff1];
    shpfiles{ii}=m_shaperead(ff2(1:end-4));  
    junk=cell2mat(shpfiles(ii));
    CA=single(str2double(junk.dbf.CA));
    SA=single(str2double(junk.dbf.SA));
    CB=single(str2double(junk.dbf.CB));
    SB=single(str2double(junk.dbf.SB));
    CC=single(str2double(junk.dbf.CC));
    SC=single(str2double(junk.dbf.SC));
    
  % convert sea ice concentration data from sigrid to sic
    CA(CA==1)=5; % open water
    CA(CA==2)=5; % bergy water
    CA(CA==91)=95; % more than 9/10, but less than 10/10
    CA(CA==92)=100; % 10/10
    for jj=1:length(CA);
        if    (CA(jj)~=1 || CA(jj)~=2 || CA(jj)~=91 || CA(jj)~=92 || CA(jj)~=20 ||...
                CA(jj)~=30 || CA(jj)~=40 || CA(jj)~=50 || CA(jj)~=60 ||...
                CA(jj)~=70 || CA(jj)~=80 || CA(jj)~=90);
            if isnan(CA(jj))==0; % did not like being a part of the preceding if statement
                [Q,R]=quorem(sym(CA(jj)),sym(10));
                CA(jj)=(Q*10+R*10)/2; % Take the Average of the Sea ice concentration interval
            end
            clear Q R;
        end
    end
    clear jj;

    CB(CB==1)=5; % open water
    CB(CB==2)=5; % bergy water
    CB(CB==91)=95; % more than 9/10, but less than 10/10
    CB(CB==92)=100; % 10/10
    for jj=1:length(CB);
        if    (CB(jj)~=1 || CB(jj)~=2 || CB(jj)~=91 || CB(jj)~=92 || CB(jj)~=20 ||...
                CB(jj)~=30 || CB(jj)~=40 || CB(jj)~=50 || CB(jj)~=60 ||...
                CB(jj)~=70 || CB(jj)~=80 || CB(jj)~=90);
            if isnan(CB(jj))==0; % did not like being a part of the preceding if statement
                [Q,R]=quorem(sym(CB(jj)),sym(10));
                CB(jj)=(Q*10+R*10)/2; % Take the Average of the Sea ice concentration interval
            end
            clear Q R;
        end
    end
    clear jj;

    CC(CC==1)=5; % open water
    CC(CC==2)=5; % bergy water
    CC(CC==91)=95; % more than 9/10, but less than 10/10
    CC(CC==92)=100; % 10/10
    for jj=1:length(CC);
        if    (CC(jj)~=1 || CC(jj)~=2 || CC(jj)~=91 || CC(jj)~=92 || CC(jj)~=20 ||...
                CC(jj)~=30 || CC(jj)~=40 || CC(jj)~=50 || CC(jj)~=60 ||...
                CC(jj)~=70 || CC(jj)~=80 || CC(jj)~=90);
            if isnan(CC(jj))==0; % did not like being a part of the preceding if statement
                [Q,R]=quorem(sym(CC(jj)),sym(10));
                CC(jj)=(Q*10+R*10)/2; % Take the Average of the Sea ice concentration interval
            end
            clear Q R;
        end
    end
    clear jj;
    
    H{ii}={(CA/10).*SA+(CB/10).*SB+(CC/10).*SC};
    
    clear ff1 ff2 CA SA CB SB CC SC junk;
end
clear ii fnames ind;
% Read in Longitude and Latitude
x=cell(size(dn));
y=cell(size(dn));
lon=cell(size(dn));
lat=cell(size(dn));
% loop of files (days)
for ii=1:length(dn)
    disp([num2str(ii) ' of ' num2str(length(dn)) ' : Reading Lon/Lat'])
    % loop of number of polygons for each file
    for jj=1:length(shpfiles{ii}.ncst);
        dummyll=shpfiles{ii}.ncst{jj};
        x{ii,jj}=single(dummyll(:,1));
        y{ii,jj}=single(dummyll(:,2));
        [londummy,latdummy]=cart2pol(x{ii,jj},y{ii,jj});
        lat{ii,jj}={single((90-((latdummy/1000)/105))*-1)};
        lon{ii,jj}={single((londummy*-180/pi)+270)};
        clear dummyll londummy latdummy;
    end
    clear jj;
end
clear ii; 
% convert polygon data to gridded data
eval(['load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/' region 'SIC.mat'])
eval(['long=' region 'SIC.lon;'])
eval(['latg=' region 'SIC.lat;'])
eval(['clear ' region 'SIC;'])
% transfer thickness values from polygons to grid points within polygons
SIT.H=single(nan(length(long),length(shpfiles)));
for kk=1:length(shpfiles); % number of shapefiles
	disp([num2str(kk) ' of ' num2str(length(shpfiles))])
	shapethickness=cell2mat(H{kk});
	for jj=2:length(shapethickness); % number of polygons per shapefile
	lonlati=[cell2mat(lon{kk,jj}) cell2mat(lat{kk,jj})];
	for ll=1:length(lonlati); % Corrects for longitudes spanning 90?E
                if (lonlati(ll,1)>=89.8 && lonlati(ll,1)<=90.2)
                    crrt=find(lonlati(:,1)>360);
                    lonlati(crrt,1)=lonlati(crrt,1)-360;
                end
                clear crrt;
            end
            clear ll;
            if (isfinite(shapethickness(jj))==1 & lonlati(:,1)>=min(long) & lonlati(:,1)<=max(long))% only compute if the thickness value associated with the polygon is finite   
%                 disp(jj)
                [lonlato,xi]=dpsimplify(lonlati,0.025); % 0.025 is the tolerance setting
                nnn1=find(isnan(lonlato(:,1))==1);
                if ~isempty(nnn1)
                    polyind1=1:(nnn1-1); % the first index up to the last finite value before the first NaN is the outermost polygon, the other values represent holes
                else
                    polyind1=':'; % no NaN values were found, so use all the values for lonlato
                end
                polygonthickness=shapethickness(jj);
                ind=find(long>=min(lonlati(:,1)) & long<=max(lonlati(:,1)) & latg>=min(lonlati(:,2)) & latg<=max(lonlati(:,2)));
                ISIN=find(isinpoly(long(ind),latg(ind),lonlato(polyind1,1),lonlato(polyind1,2))==1);

                SIT.H(ind(ISIN),kk)=polygonthickness;
                
                clear ind ISIN polygonthickness lonlato nnn1 polyind1 hax xi;
            end
            clear nn1 XXX YYY lonlati;
            
        end % number of polygons per shapefile
        clear jj shapethickness shapearea;
end % number of shapefiles
clear kk testlatg testlong indc;
% create structure
SIT.dn=dn;clear dn;
SIT.dv=dv;clear dv;
SIT.lon=long;clear long;
SIT.lat=latg;clear latg;
% saving
eval([region 'IT=SIT;'])
if sv==1
	eval(['save /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/' region 'IT.mat ' region 'IT -v7.3'])
end
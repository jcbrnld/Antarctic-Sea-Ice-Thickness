%%
% NAME:
%   read_ICETHICKNESS.m
% PURPOSE:
%   reads in weekly/bi-weekly ice analysis shapefiles provided by NIC 
%
%   contains egg code information needed for computing ice thickness from
%   stage of development information
%               http://www.natice.noaa.gov/products/weekly_products.html
%   
% HISTORY:
%   Cody Webb
%   April 18 March 2016

%   Jacob Arnold
%   December 10 2020
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%%
% makes an nx1 array of indices for the files in fnamesITcor.txt in chronological order
fnames_T1=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITcor.txt','%s');
fnames_T2=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt','%s');
for ii = (1:length(fnames_T1));
    ind(ii) = find(ismember(fnames_T1, fnames_T2(ii)));
end 
ind = ind.';

%% create a working thickness data set 

% Create a variable called fnames with a list of file names as strings
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
%load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/data/Stage_of_development/Hemispheric/datesortindices.mat
%- I couldn't find where the above .mat file was created so the for loop at
% The top of this script provides what the file "datesortedindices.mat would. -Jacob

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
    CA=single(str2double(junk.dbf.CA));% Original code was CA=... ...(junk.CA) but CA was found to be within dbf so keep in mind structuring may change again. 
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
clear ii fnames ;

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

%% try to convert the polygon data to gridded data
load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/grid25kmJaICEMOTION_3.mat
long=grid25kmJaICEMOTION.lon;
latg=grid25kmJaICEMOTION.lat;
clear grid25kmJaICEMOTION;
%%
% transfer thickness values from polygons to grid points within polygons
% (grid the data)
Hgridded=single(nan(length(long),length(shpfiles)));
lll=long-360;
rrr=long+360;
testlong=[lll;long;rrr];
clear lll rrr;
testlatg=[latg;latg;latg];
indc=[1:length(long),1:length(long),1:length(long)]'; % preserve the indices
for kk=1:length(shpfiles); % number of shapefiles
    disp(kk)
    shapethickness=cell2mat(H{kk});
        for jj=2:length(shapethickness);% number of polygons per shapefile
            lonlati=[cell2mat(lon{kk,jj}) cell2mat(lat{kk,jj})];
            for ll=1:length(lonlati); % Corrects for longitudes spanning 90°E
                if (lonlati(ll,1)>=89.8 && lonlati(ll,1)<=90.2)
                    crrt=find(lonlati(:,1)>360);
                    lonlati(crrt,1)=lonlati(crrt,1)-360;
                end
                clear crrt;
            end
            clear ll;
            if (isfinite(shapethickness(jj))==1 && (range(lonlati(:,1))>0.15 && range(lonlati(:,2))>0.15))% only compute if the thickness value associated with the polygon is finite   
%                 disp(jj)
                [lonlato,xi]=dpsimplify(lonlati,0.025); % 0.025 is the tolerance setting
                nnn1=find(isnan(lonlato(:,1))==1);
                if ~isempty(nnn1)
                    polyind1=1:(nnn1-1); % the first index up to the last finite value before the first NaN is the outermost polygon, the other values represent holes
                else
                    polyind1=':'; % no NaN values were found, so use all the values for lonlato
                end
                polygonthickness=shapethickness(jj);
                ind=find(testlong>=min(lonlati(:,1)) & testlong<=max(lonlati(:,1)) & testlatg>=min(lonlati(:,2)) & testlatg<=max(lonlati(:,2)));
                ISIN=find(isinpoly(testlong(ind),testlatg(ind),lonlato(polyind1,1),lonlato(polyind1,2))==1);
                trueindex{kk,jj}=indc(ind(ISIN));
                Hgridded(trueindex{kk,jj},kk)=polygonthickness;
%                 plot(lonlati(:,1),lonlati(:,2),'g+-','linewidth',3)
%                 hax=gca;
%                 axis([hax.XLim(1) hax.XLim(2) hax.YLim(1) hax.YLim(2)])
%                 hold on
%                 plot(lonlato(:,1),lonlato(:,2),'bo-','linewidth',1)
%                 plot(testlong,testlatg,'.','color',[0.7 0.7 0.7],'MarkerSize',10)
%                 plot(testlong(ind(ISIN)),testlatg(ind(ISIN)),'r*','MarkerSize',8)
% %                 pause
%                 pause(2)
%                 close all;
                clear ind ISIN polygonthickness lonlato nnn1 polyind1 hax xi;
            end
            clear nn1 XXX YYY lonlati;
            
        end % number of polygons per shapefile
        clear jj shapethickness shapearea;
end % number of shapefiles
clear kk testlatg testlong indc;

%%
% m_basemap('m',[100 160 10 5],[-72.5 -60 2.5 0.5])
m_basemap('p',[0 360 30],[-90 -50 10])
% make a plot of polygons following Alex and my script
for kk=1%:20:length(shpfiles)-9
    clc;
    for jj=1:length(shpfiles{kk}.ncst);
        m_plot(long(trueindex{kk,jj}),latg(trueindex{kk,jj}),'b*')
        junk(:,1)=cell2mat(lon{kk,jj});
        junk(:,2)=cell2mat(lat{kk,jj});
        for ll=1:length(junk);
            if (junk(ll,1)>=89.8 && junk(ll,1)<=90.2)
                crrt=find(junk(:,1)>360);
                junk(crrt,1)=junk(crrt,1)-360;
            end
            clear crrt;
        end
        clear ll;
        nnn=find(isnan(junk(:,1))==1);
            if ~isempty(nnn);
                m_plot(junk(1:nnn(1),1),junk(1:nnn(1),2),'r-')
                hold on;
                for ii=2:length(nnn-1);
                    m_plot(junk(nnn(ii-1):nnn(ii),1),junk(nnn(ii-1):nnn(ii),2),'r-')
                end
            else
%                 for ii=1:length(junk);
%                     m_plot(junk(ii,1),junk(ii,2),'r.')
%                     disp([junk(ii,1) junk(ii,2)])
%                     hold on;
%                     pause
%                 end
                m_plot(junk(:,1),junk(:,2),'r-')
                hold on
            end
            clear junk nnn;
            
            pause
            close all
    end
    clear ii jj;
    title({datestr(dn(kk));''})
end
clear kk;

%%








load /Users/cody/matlab/codyiMac/ICEMOTION/fluxgate.mat
% interpolate ice thickness data onto the fluxgate grid points
for ii=1:389;
    disp(ii)
    fluxgate.IT.H(:,ii)=griddata(double(long),double(latg),double(Hgridded(:,ii)),double(fluxgate.newlon),double(fluxgate.newlat));
end
clear ii;
fluxgate.IT.dn=dn;
fluxgate.IT.dv=dv;

save /Users/cody/matlab/codyiMac/WorkingDirectories/fluxgate.mat fluxgate












      


% Now we have longitude and  latitude of the polygons...we need to
% spatially cut out the indian sector.

% % repeat the data as necessary to fill gaps to go from weekly and bi-weekly
% % to pseudodaily
% dnNEW=dn(1):1:dn(end);
% dvNEW=datevec(dnNEW);
% [C,IA,IB]=intersect(dnNEW,dn);
% clear C IB;
% %   place a 1 in the hours column (4th column) in order to flag this time
% %   as the original data date
% dvNEW(IA,4)=1;
% %   find out how many times to repeat each data
% numofrpts=diff(IA);
% thicknessNEW=cell(size(thickness));
% for ii=1:length(thicknessNEW)-1;
%     thicknessNEW(IA(ii):IA(ii+1))=thickness(ii);
% end
% thicknessNEW(end)=thickness(end);
% clear ii numofrpts;
% clear thickness dn dv;
% dailyIT.thickness=thicknessNEW;
% dailyIT.dn=dnNEW;
% dailyIT.dv=dvNEW;
% clear thicknessNEW dnNEW dvNEW IA;
% 
% % save to a temporary matfile
% save /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/temp_dailyIT.mat dailyIT
% 
% % place into decades
% %   2000s
% xx=find(dailyIT.dv(:,1)>=2000 & dailyIT.dv(:,1)<=2009);
% dailyIT00.dn=dailyIT.dn(xx);
% dailyIT00.dv=dailyIT.dv(xx,:);
% dailyIT00.thickness=dailyIT.thickness(xx);
% save /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/temp_dailyIT00.mat dailyIT00
% clear xx dailyIT00;
% %   2010s
% xx=find(dailyIT.dv(:,1)>=2010 & dailyIT.dv(:,1)<=2019);
% dailyIT10.dn=dailyIT.dn(xx);
% dailyIT10.dv=dailyIT.dv(xx,:);
% dailyIT10.thickness=dailyIT.thickness(xx);
% save /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/temp_dailyIT10.mat dailyIT10
% clear xx dailyIT10;

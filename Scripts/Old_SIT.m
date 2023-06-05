% Jacob Arnold

% 25-Aug-2021

% Use month averges of SOD and partial C / SIC  ratios to generate SIT
% estimates to 1973

% will need to import three things: 
    % 1. SIT dataset
    % 2. SIC dataset
    % 3. Older charts from which to grab SIC for the early years. 
    %       -also use available SOD values 
    %       -will have to project onto grid to use these
    
disp('Starting section 1')
% section 1    
% Choose sector and import data

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

% SIT
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);

% SIC
temp = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
temp=struct2cell(temp);
SIC = temp{1,1};
SIC2.lon = SIC.lon; SIC2.lat = SIC.lat; SIC2.sic = SIC.sic; SIC2.dn = SIC.dn; 
clear SIC

%_____________________________________________________
%%% TIME CONSUMING
disp('Starting section 2')
% section 2
% interpolate CT to sector grid

% Old Charts
load(['ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/charts_gridded.mat']);


neg = find(charts_gridded.lon<0);
charts_gridded.lon(neg) = charts_gridded.lon(neg)+360;
% Now we have the data on different grids. 
% Use griddata to interpolate from SIGRID1 grid to sector grids

charts_sgrid.CT = nan(length(SIT.lon), length(charts_gridded.dn));
charts_sgrid.CA = charts_sgrid.CT; charts_sgrid.CB = charts_sgrid.CT; charts_sgrid.CC = charts_sgrid.CT; charts_sgrid.CD = charts_sgrid.CT;
charts_sgrid.SA = charts_sgrid.CT; charts_sgrid.SB = charts_sgrid.CT; charts_sgrid.SC = charts_sgrid.CT; charts_sgrid.SD = charts_sgrid.CT;

for ii = 1:length(charts_gridded.dn) % only bother with CT for now since this takes so long - come back for the rest later
   charts_sgrid.CT(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.CT(:,ii), double(SIT.lat), double(SIT.lon)); 
   %charts_sgrid.CA(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.CA(:,ii), double(SIT.lat), double(SIT.lon));  
   %charts_sgrid.CB(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.CB(:,ii), double(SIT.lat), double(SIT.lon));  
   %charts_sgrid.CC(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.CC(:,ii), double(SIT.lat), double(SIT.lon));  
   %charts_sgrid.CD(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.CD(:,ii), double(SIT.lat), double(SIT.lon));  
   %charts_sgrid.SA(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.SA(:,ii), double(SIT.lat), double(SIT.lon)); 
   %charts_sgrid.SB(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.SB(:,ii), double(SIT.lat), double(SIT.lon)); 
   %charts_sgrid.SC(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.SC(:,ii), double(SIT.lat), double(SIT.lon)); 
   %charts_sgrid.SD(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.SD(:,ii), double(SIT.lat), double(SIT.lon)); 
   %charts_sgrid.FA(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.FA(:,ii), double(SIT.lat), double(SIT.lon)); 
   %charts_sgrid.FB(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.FB(:,ii), double(SIT.lat), double(SIT.lon)); 
   %charts_sgrid.FC(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.FC(:,ii), double(SIT.lat), double(SIT.lon)); 
   %charts_sgrid.FD(:,ii) = griddata(charts_gridded.lat, charts_gridded.lon, charts_gridded.FD(:,ii), double(SIT.lat), double(SIT.lon)); 
   
end
clear ii

charts_sgrid.lon = SIT.lon; charts_sgrid.lat = SIT.lat;
charts_sgrid.dn = charts_gridded.dn; charts_sgrid.dv = charts_gridded.dv; 
charts_sgrid.sector = sector;

save(['ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/Sector_specific/sector',sector,'.mat'], 'charts_sgrid', '-v7.3');

%_____________________________________________________
%%% Can skip above section if already performed on sector
% section 3
% Create monthly means of the Si and Ci variables
disp('Starting section 3')

%load(['ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/Sector_specific/sector',sector,'.mat']);

% SIT
%load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);

% create monthly means of CA, CB, CC, CD, SA, SB, SC, SD

% find indices for each month
for ii = 1:12
    inds{ii} = find(SIT.dv(:,2)==ii);
end
clear ii

% recreate and save ratios to mean
ratioCA = zero_compatible_divide(SIT.mavg.CA, SIT.mavg.CT); % use compatible divide to prevent 0/0 from being NaN
ratioCB = zero_compatible_divide(SIT.mavg.CB, SIT.mavg.CT); % use compatible divide to prevent 0/0 from being NaN
ratioCC = zero_compatible_divide(SIT.mavg.CC, SIT.mavg.CT); % use compatible divide to prevent 0/0 from being NaN
ratioCD = zero_compatible_divide(SIT.mavg.CD, SIT.mavg.CT); % use compatible divide to prevent 0/0 from being NaN
SIT.ratioCA = ratioCA; SIT.ratioCB = ratioCB; SIT.ratioCC = ratioCC; SIT.ratioCD = ratioCD;
clear ratioCA ratioCB ratioCC ratioCD


for ii = 1:12 
    
    Mmeans.CA(:,ii) = nanmean(SIT.ca(:,inds{ii}), 2);
    Mmeans.CB(:,ii) = nanmean(SIT.cb(:,inds{ii}), 2);
    Mmeans.CC(:,ii) = nanmean(SIT.cc(:,inds{ii}), 2);
    Mmeans.CD(:,ii) = nanmean(SIT.cd(:,inds{ii}), 2);
    Mmeans.SA(:,ii) = nanmean(SIT.sa(:,inds{ii}), 2);
    Mmeans.SB(:,ii) = nanmean(SIT.sb(:,inds{ii}), 2);
    Mmeans.SC(:,ii) = nanmean(SIT.sc(:,inds{ii}), 2);
    Mmeans.SD(:,ii) = nanmean(SIT.sd(:,inds{ii}), 2);
    Mmeans.ratioCA(:,ii) = nanmean(SIT.ratioCA(:,inds{ii}), 2);
    Mmeans.ratioCB(:,ii) = nanmean(SIT.ratioCB(:,inds{ii}), 2);
    Mmeans.ratioCC(:,ii) = nanmean(SIT.ratioCC(:,inds{ii}), 2);
    Mmeans.ratioCD(:,ii) = nanmean(SIT.ratioCD(:,inds{ii}), 2);
    
end

% 

%_____________________________________________________
%%% 
% section 4
% create total dn; average SIC to spatial scale of charts; create total sic
% dataset using CT for early years (1973-1978)
disp('Starting section 4')

% Now create weekly dn for 1995-10/1997
% then add to the end of charts_sgrid.dn 
gapstart = charts_sgrid.dn(end);
gapend = SIT.dn(1);

Gapdn = [gapstart+7:7:gapend-7];
Gapdv = datevec(Gapdn); Gapdv = Gapdv(:,1:3);


% new dn variable with Gapdn added to end of charts_sgrid.dn

Tdn = [charts_sgrid.dn, Gapdn];
Tdv = [charts_sgrid.dv; Gapdv];


%%% 
% average SIC about chart dates
ctend = find(Tdn > SIC2.dn(1));

badSIC = find(sum(isnan(SIC2.sic))>4000);
SIC2.sic(:,badSIC) = [];



mdn = Tdn(ctend(1):end);
dmdn = diff(mdn); % should be 1xN-1 -> difference between each two values
for ii = 1:length(dmdn)
    lmdn(ii,1) = mdn(ii)+round((dmdn(ii))/2); %provides midpoint values between each dn - should be N-1x1
end
clear ii

for ii = 1:length(lmdn);
    loc1 = find(SIC2.dn==lmdn(ii));
    if isempty(loc1)
        loc2 = find(SIC2.dn==(lmdn(ii)+1));
        if isempty(loc2)
            loc3 = find(SIC2.dn==lmdn(ii)+2);
            if isempty(loc3)
                temp1 = find(SIC2.dn>lmdn(ii));
                mids(ii) = temp1(1);
                
            else
                mids(ii) = loc3;
            end
        else
            mids(ii) = loc2;
       
        end
    else
        mids(ii) = loc1;
    end
    clear loc1 loc2 loc3 temp1
    %mids(ii) = find(SIC2.dn==lmdn(ii)); % should be 1xN-1
end


fd = find(SIC2.dn==mdn(1));
if SIC2.dn(end)>=Tdn(end)
    ld = find(SIC2.dn==mdn(length(lmdn)+1));
else
    ld = length(SIC2.dn);
end

avgSIC = nan(length(charts_sgrid.lon), length(Tdn(ctend(1):end)));
for gg = 1:length(charts_sgrid.lon)
    for ii = 1:length(lmdn)-1
        avgSIC(gg,ii+1) = nanmean(SIC2.sic(gg,mids(ii):mids(ii+1)));
    end 
    avgSIC(gg,1) = nanmean(SIC2.sic(gg,fd:mids(1)));
    avgSIC(gg,length(lmdn)+1) = nanmean(SIC2.sic(gg, mids(end):ld));
end
clear ii gg
%------

clear nantest dmdn fourIt oneIt fd ld lmdn mdn mids  

disp('Done averaging SIC across each weekly/biweekly interval')


tem = SIT; clear SIT
SIT.lon = tem.lon; SIT.lat = tem.lat;
clear tem charts_gridded

%_____________________________________________________
%%%
% section 5
% translate CT and fix any nan anomalies that still exist in SIC
disp('Starting section 5')

% Translate CT values then combine with avgSIC 
 charts_sgrid.CT(charts_sgrid.CT==55)=0;
  charts_sgrid.CT(charts_sgrid.CT==1)=5;
   charts_sgrid.CT(charts_sgrid.CT==2)=5;
 charts_sgrid.CT(charts_sgrid.CT==92)=100;
 charts_sgrid.CT(charts_sgrid.CT==91)=95;
  charts_sgrid.CT(charts_sgrid.CT==89)=85;
 charts_sgrid.CT(charts_sgrid.CT==81)=90;
 charts_sgrid.CT(charts_sgrid.CT==79)=80;
  charts_sgrid.CT(charts_sgrid.CT==78)=75;
  charts_sgrid.CT(charts_sgrid.CT==68)=70;
 charts_sgrid.CT(charts_sgrid.CT==67)=65;
 charts_sgrid.CT(charts_sgrid.CT==57)=60;
 charts_sgrid.CT(charts_sgrid.CT==56)=55;
  charts_sgrid.CT(charts_sgrid.CT==46)=50;
  charts_sgrid.CT(charts_sgrid.CT==35)=40;
  charts_sgrid.CT(charts_sgrid.CT==34)=35;
 charts_sgrid.CT(charts_sgrid.CT==24)=30;
  charts_sgrid.CT(charts_sgrid.CT==23)=25;
  charts_sgrid.CT(charts_sgrid.CT==13)=20;
  charts_sgrid.CT(charts_sgrid.CT==12)=15;
  charts_sgrid.CT(charts_sgrid.CT==-9)=0;
 charts_sgrid.CT(charts_sgrid.CT==99)=-99;





% merge 1973-1978 SIC (charts' CT from 1973 until start of SIC dataset)

TSIC = [charts_sgrid.CT(:,1:ctend(1)-1), avgSIC];
clear avgSIC

early_SIC.sic = TSIC;
early_SIC.dn = Tdn;
early_SIC.dv = Tdv;
early_SIC.lon = SIT.lon;
early_SIC.lat = SIT.lat;
early_SIC.sector = sector;

% final fix on bad nans
misLoc = find(sum(isnan(early_SIC.sic))>4000);
disp(['There were/was ', num2str(length(misLoc)),' bad SIC date(s) to be averaged'])
if misLoc(1) == 1
    cols(:,1) = early_SIC.sic(:,2);
    cols(:,2) = early_SIC.sic(:,3);
    early_SIC.sic(:,1) = nanmean(cols,2); % along second dimension should preserve correct size
    clear cols
    misLoc(1) = [];
end

for ii = 1:length(misLoc)
    
    cols(:,1) = early_SIC.sic(:,misLoc(ii)-1);
    cols(:,2) = early_SIC.sic(:,misLoc(ii)+1);
    early_SIC.sic(:,misLoc(ii)) = nanmean(cols,2); % along second dimension should preserve correct size
    
    clear cols
end

save(['ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/early_SIC(1973-1997)/sector',sector,'.mat'], 'early_SIC', '-v7.3');


%_____________________________________________________
%%% 
% section 6
% create "finalCi" variables using ratios and SIC
disp('Starting section 6')

%load(['ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/Sector_specific/sector',sector,'.mat']);
%load(['ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/early_SIC(1973-1997)/sector',sector,'.mat']);

% The thickness recipe includes: 
    % Cihires
        % = Ciratio.*SIC
            % Ciratio = MmeanCi./CT
    % MmeanSi
    % Incorporate older Si data where available
        % take average of MmeanSI and older SI?
    
        
  % SO
  % We need a new Cihires AND a new SIT.Si
  
  
for ii = 1:12
    mInd{ii} = find(early_SIC.dv(:,2)==ii);
      
end
clear ii

finalCA = nan(size(early_SIC.sic));
finalCB = finalCA; finalCC = finalCA; finalCD = finalCA;
% create a version of "Cihires" from SITworkingscript_Final for older data
for ii = 1:12
    finalCA(:,mInd{ii}) = early_SIC.sic(:,mInd{ii}).*Mmeans.ratioCA(:,ii);
    finalCB(:,mInd{ii}) = early_SIC.sic(:,mInd{ii}).*Mmeans.ratioCB(:,ii);
    finalCC(:,mInd{ii}) = early_SIC.sic(:,mInd{ii}).*Mmeans.ratioCC(:,ii);
    finalCD(:,mInd{ii}) = early_SIC.sic(:,mInd{ii}).*Mmeans.ratioCD(:,ii);

end    
        

%_____________________________________________________    
%%% now we are ready for thickness
% section 7
% Calculate H
disp('Starting section 7')

old_SIT.H = nan(size(finalCA));

for ii = 1:length(early_SIC.dn)
    month_indicator(ii) = early_SIC.dv(ii,2);
    for jj = 1:length(early_SIC.lon)
        termA = (finalCA(jj,ii)/100)*Mmeans.SA(jj,month_indicator(ii));
        termB = (finalCB(jj,ii)/100)*Mmeans.SB(jj,month_indicator(ii));
        termC = (finalCC(jj,ii)/100)*Mmeans.SC(jj,month_indicator(ii));
        termD = (finalCD(jj,ii)/100)*Mmeans.SD(jj,month_indicator(ii));
        
        
        old_SIT.H(jj,ii) = nansum([termA,termB,termC,termD]);
        
        
        clear termA termB termC termD
    end
    
end
disp('SIT calculation complete')

%_____________________________________________________
%%% Add final components and save
% Section 8
% add all variables to structure and save
disp('Starting section 8')

old_SIT.lon = SIT.lon;
old_SIT.lat = SIT.lat;
old_SIT.sector = sector;
old_SIT.dn = early_SIC.dn; old_SIT.dv = early_SIC.dv;
old_SIT.finalCA = finalCA; old_SIT.finalCB = finalCB; old_SIT.finalCC = finalCC; old_SIT.finalCD = finalCD;
old_SIT.Mmeans = Mmeans;

m_basemap('p', [0,360], [-90, -50]);
m_scatter(old_SIT.lon, old_SIT.lat, 5, old_SIT.H(:,600));
colorbar;

save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/old_sector',sector,'.mat'], 'old_SIT', '-v7.3');




















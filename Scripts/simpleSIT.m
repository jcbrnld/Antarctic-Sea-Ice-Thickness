% Jacob Arnold

% 17-Feb-2022

% as an example calculate SIT without using moving average loop. 
% Due to a lack of Partial concentration data before 21-Sep-2007 this will only be
% for the dates 21-Sep-2007 to 31-Dec-2021


% 1 --> load in raw gridded SIG (no need for E00)
% 2 --> translate from SIGRID to cm and %
% 3 --> load in SIC and average to same timescale
% 4 --> fill non-permanent-after-2002 SIC nans with CT
% 5 --> calc. ratios of Cn to Ct and multiply by SIC (make Cn_hires)
% 6 --> calc. H from Cn_hires and translated Sn


% UNFINISHED 18-Feb-22
sector = '17';
% ----------------------------------------------------------------------------------------------------------------------
% STEP 1.
load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpSIG.mat']); 

% snip off range we want to use
startd = datenum(2007,09,21);
sl = find(SIT.dn==startd);
if isempty(sl)
    error('Oops, that date is not in this gridded dataset')
else
    disp('Start date found. Clipping earlier dates off')
end

SIT.H = SIT.H(:,sl:end);
SIT.sa = SIT.sa(:,sl:end);
SIT.sb = SIT.sb(:,sl:end);
SIT.sc = SIT.sc(:,sl:end);
SIT.sd = SIT.sd(:,sl:end);
SIT.ca = SIT.ca(:,sl:end);
SIT.cb = SIT.cb(:,sl:end);
SIT.cc = SIT.cc(:,sl:end);
SIT.cd = SIT.cd(:,sl:end);
SIT.ct = SIT.ct(:,sl:end);
SIT.dn = SIT.dn(sl:end);
SIT.dv = SIT.dv(sl:end,:);

% ----------------------------------------------------------------------------------------------------------------------
% STEP 2.
% Special considerations
dind = find(SIT.sd~=-9 & isnan(SIT.sd)==0 & SIT.sd~=99 & SIT.sd~=0);
dvar = SIT.ct(dind)-(SIT.ca(dind)+SIT.cb(dind)+SIT.cc(dind));
dpos = find(dvar>0);dzer=find(dvar==0);

%define where there are 4 ice types (thus where cd needs to be calcd)
SIT.cd(dind(dpos))=-10; 
SIT.cd(dind(dzer))=0;
saFill = find(SIT.sa==-9 & SIT.ct~=0);

oneind = find((SIT.ca==-9 | SIT.ca==99 | isnan(SIT.ca)==1 | SIT.ca==0) & (SIT.cb==-9 | SIT.cb==99 | isnan(SIT.cb)==1 | SIT.cb==0)...
    & (SIT.cc==-9 | SIT.cc==99 | isnan(SIT.cc)==1 | SIT.cc==0) & (SIT.ct~=-9 & SIT.ct~=99 & isnan(SIT.ct)==0 & SIT.ct~=0) ...
    & (SIT.sa~=-9 & SIT.sa~=99 & isnan(SIT.sa)==0 & SIT.sa~=0) & (SIT.sb==-9 | SIT.sb==99 | isnan(SIT.sb)==1 | SIT.sb==0)...
    & (SIT.sc==-9 | SIT.sc==99 | isnan(SIT.sc)==1 | SIT.sc==0) & (SIT.sd==-9 | SIT.sd==99 | isnan(SIT.sd)==1 | SIT.sd==0));
SIT.ca(oneind) = SIT.ct(oneind);
%oneIt=zeros(size(SIT.ca));oneIt(oneind)=1; % diagnostic
SIT.cb(oneind)=0; SIT.cc(oneind)=0; SIT.cd(oneind)=0;
clear dind dvar dpos dzer 



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

% ----------------------------------------------------------------------------------------------------------------------
% STEP 3

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
% ----------------------------------------------------------------------------------------------------------------------
% STEP 4
% fill in SIC nans with CT HERE
sicnans = find(isnan(avgSIC));
avgSIC(sicnans) = SIT.ct(sicnans);
% refill permanent nans
permnan = find(sum(isnan(avgSIC),2)==length(avgSIC(1,:)));
avgSIC(permnan,:) = nan; % TEST THIS

% ----------------------------------------------------------------------------------------------------------------------
% STEP 5
% prepare for calculation
% nan out icebergs
SIT.sa(icebergs) = nan; SIT.sb(icebergs) = nan; SIT.sc(icebergs) = nan; SIT.sd(icebergs) = nan;
SIT.ca(icebergs) = nan; SIT.cb(icebergs) = nan; SIT.cc(icebergs) = nan; SIT.cd(icebergs) = nan; SIT.ct(icebergs) = nan;

SIT.cd(SIT.cd==-10)=SIT.ct(SIT.cd==-10) - (SIT.ca(SIT.cd==-10)+SIT.cb(SIT.cd==-10)+SIT.cc(SIT.cd==-10)); % fill in CD values 

% Convert -99s to nans
SIT.sa(SIT.sa<0)=nan; SIT.sb(SIT.sb<0)=nan; 
SIT.sc(SIT.sc<0)=nan; SIT.sd(SIT.sd<0)=nan;
SIT.ca(SIT.ca<0)=nan; SIT.cb(SIT.cb<0)=nan; 
SIT.cc(SIT.cc<0)=nan; SIT.cd(SIT.cd<0)=nan;
SIT.ct(SIT.ct<0)=nan; 
%

% Calculate ratios and create hires concentrations
ratioCA = zero_compatible_divide(SIT.ca,SIT.ct); % use compatible divide to prevent 0/0 from being NaN
ratioCB = zero_compatible_divide(SIT.cb,SIT.ct); % use compatible divide to prevent 0/0 from being NaN
ratioCC = zero_compatible_divide(SIT.cc,SIT.ct); % use compatible divide to prevent 0/0 from being NaN
ratioCD = zero_compatible_divide(SIT.cd,SIT.ct); % use compatible divide to prevent 0/0 from being NaN



ca_hires = ratioca.*avgSIC;
cb_hires = ratiocb.*avgSIC;
cc_hires = ratiocc.*avgSIC;
cd_hires = ratiocd.*avgSIC;



% ----------------------------------------------------------------------------------------------------------------------
% STEP 6
% Calculate H

















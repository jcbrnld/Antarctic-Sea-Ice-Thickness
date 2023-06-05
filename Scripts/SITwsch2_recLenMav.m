
% Jacob Arnold
% 20-Feb-2022

% full title: 
% SIT working script chapter 2 record length monthly average 


% Same as chaper 2 from SITworkingscript_Final.m BUT monthly neighboring
% year moving average has been replaced with record length monthly average




% Chapter 2 - calculate Sea Ice Thickness
% NAVIGATE TO RESEARCH DIRECTORY BEFORE RUNNING
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
%SIT.ca(SIT.ca==-9)=-9;   SIT.cb(SIT.cb==-9)=0;   SIT.cc(SIT.cc==-9)=0;   SIT.ct(SIT.ct==-9)=0; % ca left as -9 because these need to be filled
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

SIT.sa(SIT.sa==98)=nan;  SIT.sb(SIT.sb==98)=nan;  SIT.sc(SIT.sc==98)=nan;  SIT.sd(SIT.sd==98)=nan; % now icebergs will be nand before the average
SIT.sa(SIT.sa==99)=-99;  SIT.sb(SIT.sb==99)=-99;  SIT.sc(SIT.sc==99)=-99;  SIT.sd(SIT.sd==99)=-99;
SIT.sa(SIT.sa==-9)=0;    SIT.sb(SIT.sb==-9)=0;    SIT.sc(SIT.sc==-9)=0;    SIT.sd(SIT.sd==-9)=0;


% Translate stage of development 
% Based on SIGRID documentation: "SIGRID-3: A Vector Archive Format for Sea
% Ice Charts" Page 19

percca = (sum(isnan(SIT.ca),'all')/(length(SIT.ca(:,1)) * length(SIT.ca(1,:))))*100;
perccb = (sum(isnan(SIT.cb),'all')/(length(SIT.cb(:,1)) * length(SIT.cb(1,:))))*100;
perccc = (sum(isnan(SIT.cc),'all')/(length(SIT.cc(:,1)) * length(SIT.cc(1,:))))*100;
percct = (sum(isnan(SIT.ct),'all')/(length(SIT.ct(:,1)) * length(SIT.ct(1,:))))*100;
percsa = (sum(isnan(SIT.sa),'all')/(length(SIT.sa(:,1)) * length(SIT.sa(1,:))))*100;
percsb = (sum(isnan(SIT.sb),'all')/(length(SIT.sb(:,1)) * length(SIT.sb(1,:))))*100;
percsc = (sum(isnan(SIT.sc),'all')/(length(SIT.sc(:,1)) * length(SIT.sc(1,:))))*100;
disp(['% NaN: ca = ', num2str(percca),'% | ','cb = ', num2str(perccb),'% | ','cc = ', num2str(perccc),'% | ',...
    'ct = ', num2str(percct),'% | ','sa = ', num2str(percsa),'% | ','sb = ', num2str(percsb),'% | ','sc = ', num2str(percsc),'% | '])
clear percca perccb perccc percct percsa percsb percsc jj ii 


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


dummySA=SIT.sa;
dummySB=SIT.sb;
dummySC=SIT.sc;
dummySD=SIT.sd;

dv=SIT.dv;

% 
% avInt = 10; % number of ~nan values accepted when averaging
% mavgSA = nan(size(SIT.sa));
% mavgSB = mavgSA; mavgSC = mavgSA; mavgSD = mavgSA;
% 
% yrs = unique(SIT.dv(:,1));
% mnths = unique(SIT.dv(:,2));
% refsF(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(1))";
% for cc = 1:length(yrs)-1
%     refsF(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(cc)+"))";
% end
% refsL(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))";
% for cc = 1:length(yrs)-1
%     refsL(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(cc)+"))";
% end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Replace SOD looping here
% output should be variables mavgSA mavgSB mavgSC mavgSD 
% which are the same size as all other variables but contain record length
% monthly means. 
avyrsa = nan(length(SIT.lon), 12); avyrsb = avyrsa; avyrsc = avyrsa; avyrsd = avyrsa;
for mm = 1:12
    disp(['SOD month ',num2str(mm)])
    mloc = find(SIT.dv(:,2)==mm);
    
    avyrsa(:,mm) = nanmean(SIT.sa(:,mloc),2);
    avyrsb(:,mm) = nanmean(SIT.sb(:,mloc),2);
    avyrsc(:,mm) = nanmean(SIT.sc(:,mloc),2);
    avyrsd(:,mm) = nanmean(SIT.sd(:,mloc),2);
    
    for bb = 1:length(mloc)
        mavgSA(:,mloc(bb)) = avyrsa(:,mm);
        mavgSB(:,mloc(bb)) = avyrsb(:,mm);
        mavgSC(:,mloc(bb)) = avyrsc(:,mm);
        mavgSD(:,mloc(bb)) = avyrsd(:,mm);
    end
    
    clear mloc
end
% --- Stage of Development average above ---
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



%stgdevratio=[ratioSA,ratioSB,ratioSC,ratioSD];
clear dummySA dummySB dummySC dummySD;

%avgABC=mavgSA+mavgSB+mavgSC+mavgSD;  % NEED TO INDEX -99 VALS FOR EACH VARIABLE THEN CONVERT TO NAN BEFORE AVERAGE

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
mavgCA=nan(size(dummyCA));
mavgCB=mavgCA;
mavgCC=mavgCA;
mavgCT=mavgCA;
mavgCD=mavgCA;



% yrs = unique(SIT.dv(:,1));
% mnths = unique(SIT.dv(:,2));
% refsF(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(1))";
% for cc = 1:length(yrs)-1
%     refsF(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy+"+num2str(cc)+"))";
% end
% refsL(1) = "(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy))";
% for cc = 1:length(yrs)-1
%     refsL(cc+1) = "|(SIT.dv(:,2)==mnths(mm)&SIT.dv(:,1)==yrs(yy-"+num2str(cc)+"))";
% end
% disp('Begin SIC Monthly Average Loop');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Replace SIC looping here
% output should be variables mavgCA mavgCB mavgCC mavgCD mavgCT
% which are the same size as all other variables but contain record length
% monthly means. 


avyrca = nan(length(SIT.lon), 12); avyrcb = avyrca; avyrcc = avyrca; avyrcd = avyrca; avyrct = avyrca;
for mm = 1:12
    disp(['SIC month ',num2str(mm)])
    mloc = find(SIT.dv(:,2)==mm);
    
    avyrca(:,mm) = nanmean(SIT.ca(:,mloc),2);
    avyrcb(:,mm) = nanmean(SIT.cb(:,mloc),2);
    avyrcc(:,mm) = nanmean(SIT.cc(:,mloc),2);
    avyrcd(:,mm) = nanmean(SIT.cd(:,mloc),2);
    avyrct(:,mm) = nanmean(SIT.ct(:,mloc),2);
    
    for bb = 1:length(mloc)
        mavgCA(:,mloc(bb)) = avyrca(:,mm);
        mavgCB(:,mloc(bb)) = avyrcb(:,mm);
        mavgCC(:,mloc(bb)) = avyrcc(:,mm);
        mavgCD(:,mloc(bb)) = avyrcd(:,mm);
        mavgCT(:,mloc(bb)) = avyrct(:,mm);
    end
    
    clear mloc
end

% Test these
% figure;
% set(gcf, 'position', [200,200,1200,200])
% plot(SIT.dn, nanmean(mavgSA), 'linewidth', 1.4)
% hold on
% plot(SIT.dn, nanmean(mavgCA), 'linewidth', 1.4);
% legend('mavgSA', 'mavgCA')
% grid on
% xlim([min(SIT.dn)-50, max(SIT.dn)+50])


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% fill 99s
SIT.ca(all99Ca)=mavgCA(all99Ca); 
SIT.cb(all99Cb)=mavgCB(all99Cb);
SIT.cc(all99Cc)=mavgCC(all99Cc);
SIT.cd(all99Cd)=mavgCD(all99Cd);
SIT.ct(all99Ct)=mavgCT(all99Ct);
mavgCA(icebergs) = nan; mavgCB(icebergs) = nan; mavgCC(icebergs) = nan; mavgCD(icebergs) = nan; mavgCT(icebergs) = nan; % remove icebergs b4 filling nans
% fill nans
SIT.ca(isnan(SIT.ca)) = mavgCA(isnan(SIT.ca));
SIT.cb(isnan(SIT.cb)) = mavgCA(isnan(SIT.cb));
SIT.cc(isnan(SIT.cc)) = mavgCA(isnan(SIT.cc));% CD is intentionally left out as there is a large period where it is completely nan and fill would produce [minimal] overestimation
SIT.ct(isnan(SIT.ct)) = mavgCA(isnan(SIT.ct));

% make sure bergs are nan ---- shouldn't make a difference because Sn are
% already nannd at bergs.
SIT.ca(icebergs) = nan; SIT.cb(icebergs) = nan; SIT.cc(icebergs) = nan; SIT.cd(icebergs) = nan; SIT.ct(icebergs) = nan;


% Create ratios ~~THE MOST IMPORTANT PART~~
ratioCA = zero_compatible_divide(SIT.ca,SIT.ct); % use compatible divide to prevent 0/0 from being NaN % THIS SHOULD BE SIT.ca/SIT.ct NOT mavgCA
ratioCB = zero_compatible_divide(SIT.cb,SIT.ct); % use compatible divide to prevent 0/0 from being NaN
ratioCC = zero_compatible_divide(SIT.cc,SIT.ct); % use compatible divide to prevent 0/0 from being NaN
ratioCD = zero_compatible_divide(SIT.cd,SIT.ct); % use compatible divide to prevent 0/0 from being NaN
% RATIO QC
% 1. If ratio is > 1 reduce to 1
origRCA = ratioCA; origRCB = ratioCB; origRCC = ratioCC; origRCD = ratioCD;
ratioCA(ratioCA>1) = 1;
ratioCB(ratioCB>1) = 1;
ratioCC(ratioCC>1) = 1;
ratioCD(ratioCD>1) = 1;
% 2. If sum of ratios is > 1 proportionally reduce each so sum = 1
rcat = cat(3, ratioCA, ratioCB, ratioCC, ratioCD); % 3d variable to sum
rsum = sum(rcat, 3, 'omitnan'); % sum on third dimension and ignore nans
rsumtoobig = rsum>1;
ratioCA(rsumtoobig) = ratioCA(rsumtoobig)./rsum(rsumtoobig);
ratioCB(rsumtoobig) = ratioCB(rsumtoobig)./rsum(rsumtoobig);
ratioCC(rsumtoobig) = ratioCC(rsumtoobig)./rsum(rsumtoobig);
ratioCD(rsumtoobig) = ratioCD(rsumtoobig)./rsum(rsumtoobig);

avgABC=mavgCA+mavgCB+mavgCC+mavgCD; 

% Address missing SIC
allnan = find(sum(isnan(avgSIC),2)./length(SIT.dn) >= .9); % for backfill 
% __________________________________________________________________________________________
% fill in SIC nans with CT HERE
sicnans = find(isnan(avgSIC));
avgSIC(sicnans) = SIT.ct(sicnans);

% AND backfill where SIC is always nan 
avgSIC(allnan,:) = nan;


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

disp('Calculating Thickness')
% THIS covers all possibilities though many are unlikely
for i=1:length(SIT.dn);
    for j=1:length(SIT.lon);
        termA=(CAhires(j,i)/100)*SIT.sa(j,i); Era = (CAhires(j,i)/100)*SIT.error.sa(j,i);
        termB=(CBhires(j,i)/100)*SIT.sb(j,i); Erb = (CBhires(j,i)/100)*SIT.error.sb(j,i);
        termC=(CChires(j,i)/100)*SIT.sc(j,i); Erc = (CChires(j,i)/100)*SIT.error.sc(j,i);
        termD=(CDhires(j,i)/100)*SIT.sc(j,i); Erd = (CDhires(j,i)/100)*SIT.error.sd(j,i);
        if isfinite(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % ABCD
            SIT.H(j,i)=termA+termB+termC+termD;
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % ABC
            SIT.H(j,i)=termA+termB+termC;
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % ABD
            SIT.H(j,i)=termA+termB+termD;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % ACD
            SIT.H(j,i)=termA+termC+termD;
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isnan(termD)==1 % AB
            SIT.H(j,i)=termA+termB;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % AC
            SIT.H(j,i)=termA+termC;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % AD
            SIT.H(j,i)=termA+termD;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isnan(termC)==1 & isnan(termD)==1 % A
            SIT.H(j,i)=termA;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % BCD
            SIT.H(j,i)=termB+termC+termD;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % BC
            SIT.H(j,i)=termB+termC;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % BD
            SIT.H(j,i)=termB+termD;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isnan(termD)==1 % B
            SIT.H(j,i)=termB;
        elseif isnan(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % CD
            SIT.H(j,i)=termC+termD;
        elseif isnan(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % C
            SIT.H(j,i)=termC;
        elseif isnan(termA)==1 & isnan(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % D
            SIT.H(j,i)=termD;
        else
            Hhires(j,i)=termA+termB+termC;
        end
        
        % now for error - this is separate from above to avoid nan summing 
        if isfinite(Era)==1 & isfinite(Erb)==1 & isfinite(Erc)==1 & isfinite(Erd)==1 % ABCD
            SIT.error.H(j,i)=Era+Erb+Erc+Erd;
        elseif isfinite(Era)==1 & isfinite(Erb)==1 & isfinite(Erc)==1 & isnan(Erd)==1 % ABC
            SIT.error.H(j,i)=Era+Erb+Erc;
        elseif isfinite(Era)==1 & isfinite(Erb)==1 & isnan(Erc)==1 & isfinite(Erd)==1 % ABD
            SIT.error.H(j,i)=Era+Erb+Erd;
        elseif isfinite(Era)==1 & isnan(Erb)==1 & isfinite(Erc)==1 & isfinite(Erd)==1 % ACD
            SIT.error.H(j,i)=Era+Erc+Erd;
        elseif isfinite(Era)==1 & isfinite(Erb)==1 & isnan(Erc)==1 & isnan(Erd)==1 % AB
            SIT.error.H(j,i)=Era+Erb;
        elseif isfinite(Era)==1 & isnan(Erb)==1 & isfinite(Erc)==1 & isnan(Erd)==1 % AC
            SIT.error.H(j,i)=Era+Erc;
        elseif isfinite(Era)==1 & isnan(Erb)==1 & isnan(Erc)==1 & isfinite(Erd)==1 % AD
            SIT.error.H(j,i)=Era+Erd;
        elseif isfinite(Era)==1 & isnan(Erb)==1 & isnan(Erc)==1 & isnan(Erd)==1 % A
            SIT.error.H(j,i)=Era;
        elseif isnan(Era)==1 & isfinite(Erb)==1 & isfinite(Erc)==1 & isfinite(Erd)==1 % BCD
            SIT.error.H(j,i)=Erb+Erc+Erd;
        elseif isnan(Era)==1 & isfinite(Erb)==1 & isfinite(Erc)==1 & isnan(Erd)==1 % BC
            SIT.error.H(j,i)=Erb+Erc;
        elseif isnan(Era)==1 & isfinite(Erb)==1 & isnan(Erc)==1 & isfinite(Erd)==1 % BD
            SIT.error.H(j,i)=Erb+Erd;
        elseif isnan(Era)==1 & isfinite(Erb)==1 & isnan(Erc)==1 & isnan(Erd)==1 % B
            SIT.error.H(j,i)=Erb;
        elseif isnan(Era)==1 & isnan(Erb)==1 & isfinite(Erc)==1 & isfinite(Erd)==1 % CD
            SIT.error.H(j,i)=Erc+Erd;
        elseif isnan(Era)==1 & isnan(Erb)==1 & isfinite(Erc)==1 & isnan(Erd)==1 % C
            SIT.error.H(j,i)=Erc;
        elseif isnan(Era)==1 & isnan(Erb)==1 & isnan(Erc)==1 & isfinite(Erd)==1 % D
            SIT.error.H(j,i)=Erd;
        else
            Herrorhires(j,i)=termA+termB+termC;
        end
        clear termA termB termC termD Era Erb Erc Erd
    end
    clear j;
end

SIT.error.sa = SIT.error.sa(:,1:length(SIT.dn))./100;
SIT.error.sb = SIT.error.sb(:,1:length(SIT.dn))./100;
SIT.error.sc = SIT.error.sc(:,1:length(SIT.dn))./100;
SIT.error.sd = SIT.error.sd(:,1:length(SIT.dn))./100;
SIT.error.H = SIT.error.H(:,1:length(SIT.dn))./100;
SIT.icebergs = icebergs;


disp('Sea Ice Thickness calculation complete')
clear i;





SIT.H = SIT.H./100; % convert from cm to m

ticker = (1997:2022)';
ticker(:,2:3) = 1;
ticker = datenum(ticker);
figure;
set(gcf, 'position', [200,200,900,700])
subplot(4,1,1:2)
plot(SIT.dn, nanmean(SIT.H), 'linewidth', 1.3, 'color', [0.3,0.8,0.5])
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
grid on
xtickangle(27);
title(['Sector ',sector,' Mean SIT']);
ylabel('SIT [m]');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);

subplot(4,1,3)
histogram(SIT.H, 'FaceColor', [.4,.5,.8], 'EdgeColor', [0.1,.1,.1]);
title(['Sector ',sector,' Sea Ice Thickness Distribution']);
xlabel('SIT [m]')

subplot(4,1,4)
plot(SIT.dn, (sum(isnan(SIT.H))./length(SIT.lon)).*100, 'linewidth', 1.2, 'color', [0.99,0.2,0.2])
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
grid on
xtickangle(27);
title(['Sector ',sector,' % NaN']);
ylabel('[% of grid]');
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
ylim([0,100])

print(['ICE/ICETHICKNESS/Figures/Running_SIT/sector_',sector,'_newlyCalcd_SIT.png'], '-dpng', '-r500');


% Step 7 | add the new computed partials to the SIT structure
SIT.ca_hires=CAhires;
SIT.cb_hires=CBhires;
SIT.cc_hires=CChires;
SIT.cd_hires=CDhires;
SIT.ct_hires=avgSIC;
SIT.icebergs = icebergs;
SIT.mavg.CA = mavgCA;
SIT.mavg.CB = mavgCB;
SIT.mavg.CC = mavgCC;
SIT.mavg.CD = mavgCD;
SIT.mavg.CT = mavgCT;
SIT.mavg.SA = mavgSA;
SIT.mavg.SB = mavgSB;
SIT.mavg.SC = mavgSC;
SIT.mavg.SD = mavgSD;
SIT.ratio.ca = ratioCA;
SIT.ratio.cb = ratioCB;
SIT.ratio.cc = ratioCC;
SIT.ratio.cd = ratioCD;
SIT.ratio.origCA = origRCA;
SIT.ratio.origCB = origRCB;
SIT.ratio.origCC = origRCC;
SIT.ratio.origCD = origRCD;
SIT.ratio.note = {'orig variables are the original ratios before reducing any ratio value above 1 to 1',...
    'and before proportionally reducing sums above 1 to 1'};


% Step 8 | save the final product
if length(sector)==2
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'_reclenav.mat'], 'SIT', '-v7.3');
else
    sloc = strfind(sector, 'SIC');
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/zones/',sector(1:sloc-2),'_reclenav.mat'], 'SIT', '-v7.3');
end

disp(['Finished and saved sector ', sector]);


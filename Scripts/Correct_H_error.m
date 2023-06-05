% Jacob Arnold

% 26-Aug-2021

% fix SIT error summation without rerunning second chapter of SITworkingscript

path2research=[];
% Step 1 | load gridded raw data
%path2research=['/Users/jacobarnold/Documents/Classes/Research/'];% uncomment this to start at the root
%path2research=['/Volumes/Data/Research/'];

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

clearvars -except sa_Error sb_Error sc_Error sd_Error sector

%________________________________________________________________________________________________
%%% run above to include 0 correction

% sector = '14' no need for this if above section is run

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);

SIT.error.sa = sa_Error; SIT.error.sb = sb_Error; SIT.error.sc = sc_Error; SIT.error.sd = sd_Error;


CAhires = SIT.ca_hires;
CBhires = SIT.cb_hires;
CChires = SIT.cc_hires;
CDhires = SIT.cd_hires;
%CThires = SIT.ct_hires;

CAhires(CAhires==inf) = 0; CBhires(CBhires==inf) = 0;
CChires(CChires==inf) = 0; CDhires(CDhires==inf) = 0;

% ratioCA = zero_compatible_divide(CAhires,CThires);
% ratioCB = zero_compatible_divide(CBhires,CThires);
% ratioCC = zero_compatible_divide(CChires,CThires);
% ratioCD = zero_compatible_divide(CDhires,CThires);
% ratioCA(ratioCA==inf) = 0; ratioCB(ratioCB==inf) = 0;
% ratioCC(ratioCC==inf) = 0; ratioCD(ratioCD==inf) = 0;



disp('Calculating Thickness and error')
% THIS covers all possibilities though many are unlikely
for i=1:length(SIT.dn);
    for j=1:length(SIT.lon);
        termA=(CAhires(j,i)/100)*SIT.sa(j,i); Era = (CAhires(j,i)/100)*SIT.error.sa(j,i);
        termB=(CBhires(j,i)/100)*SIT.sb(j,i); Erb = (CBhires(j,i)/100)*SIT.error.sb(j,i);
        termC=(CChires(j,i)/100)*SIT.sc(j,i); Erc = (CChires(j,i)/100)*SIT.error.sc(j,i);
        termD=(CDhires(j,i)/100)*SIT.sc(j,i); Erd = (CDhires(j,i)/100)*SIT.error.sd(j,i);
        
     % SIT
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
            Hhires(j,i)=termA+termB+termC;
        end
        clear termA termB termC termD Era Erb Erc Erd
    end
    clear j;
    if i == length(SIT.dn)-100
        disp('Almost done');
    end
end

SIT.error.sa = SIT.error.sa(:,1:length(SIT.dn))./100;
SIT.error.sb = SIT.error.sb(:,1:length(SIT.dn))./100;
SIT.error.sc = SIT.error.sc(:,1:length(SIT.dn))./100;
SIT.error.sd = SIT.error.sd(:,1:length(SIT.dn))./100;
SIT.error.H = SIT.error.H(:,1:length(SIT.dn))./100;



disp('Sea Ice Thickness calculation complete')
clear i;


SIT.H = SIT.H./100; % convert from cm to m


figure;plot(sum(isnan(SIT.error.H)));


% Step 8 | save the final product
if length(sector)==2
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
else
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/',sector,'.mat'], 'SIT', '-v7.3');
end

disp(['Finished and saved sector ', sector]);
















% Jacob Arnold

% 27-Aug-2021

% Combine old_SIT and SIT to produce continuous dataset of SIT from
% 1973 to 2021. 
% Also add indicator to show which bits are "ad hoc" (made from averages
% and SIC) and which bits are more authentic.


% Bring in the data
clearvars

sector = '18'
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/old_sector',sector,'.mat'])
old_SIT.dn = old_SIT.dn.';
SIT.dv(:,4:6) = [];
old_SIT.H = old_SIT.H./100;
 
%


allSIT.H = [old_SIT.H, SIT.H];
allSIT.dn = [old_SIT.dn; SIT.dn];
allSIT.dv = [old_SIT.dv; SIT.dv];
allSIT.CAhires = [old_SIT.finalCA, SIT.ca_hires];
allSIT.CBhires = [old_SIT.finalCB, SIT.cb_hires];
allSIT.CChires = [old_SIT.finalCC, SIT.cc_hires];
allSIT.CDhires = [old_SIT.finalCD, SIT.cd_hires];
allSIT.lon = SIT.lon; allSIT.lat = SIT.lat;
allSIT.newdn = SIT.dn; allSIT.newdv = SIT.dv;
allSIT.olddn = old_SIT.dn; allSIT.olddv = old_SIT.dv;
allSIT.error = SIT.error;
allSIT.H(allSIT.H==inf)=nan;
allSIT.dv(866,1) = 1989;
allSIT.dn = datenum(allSIT.dv);


indicator = nan(length(allSIT.dn));
indicator(1:length(old_SIT.dn)) = 1;
indicator(end+1:end) = 2;
indicator_meaning = ["1 designates SIT data created using the 'ad hoc' approach relying on averages for SOD and partial concentration.",...
    "2 designates SIT data created using at least mostly real data rather than averages.", ...
    "for Cihires a 1 indicates it is created primarily from averages times SIC and 2 is primarily from partial concentrations times SIC"];


save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Full_length/sector',sector,'.mat'], 'allSIT', '-v7.3');






% 08-June-2021

% Jacob Arnold

% Fill in areas that were nan after averaging but have finite raw non-averaged ca,
% cb, and/or cc values

% have to rerun averaging anyway to include hires values for some of the
% sectors so I am not running this code yet. 

% to finish this code add the SIT calculation code from the end of
% SITworkingscript_JNoQC


canan = find(isnan(SIT.cahires)==1);
cbnan = find(isnan(SIT.cbhires)==1);
ccnan = find(isnan(SIT.cchires)==1);

SIT.cahires(canan) = SIT.ca(canan);
SIT.cbhires(cbnan) = SIT.cb(cbnan);
SIT.cchires(ccnan) = SIT.cc(ccnan);


CAhires = SIT.cahires;
CBhires = SIT.cbhires;
CChires = SIT.cchires;
CDhires = SIT.cdhires;



% view nans
numnans = sum(isnan(SIT.H));
pernans = (numnans./length(SIT.H(:,1)))*100;
numnansCA = sum(isnan(SIT.ca));pernansCA = (numnansCA./length(SIT.ca(:,1)))*100;
numnansCB = sum(isnan(SIT.cb));pernansCB = (numnansCB./length(SIT.cb(:,1)))*100;
numnansCC = sum(isnan(SIT.cc));pernansCC = (numnansCC./length(SIT.cc(:,1)))*100;
numnansCT = sum(isnan(SIT.ct));pernansCT = (numnansCT./length(SIT.ct(:,1)))*100;
%numnansSIC = sum(isnan(avgSIC));pernansSIC = (numnansSIC./length(avgSIC(:,1)))*100;
numnansCAH = sum(isnan(CAhires));pernansCAH = (numnansCAH./length(CAhires(:,1)))*100;


figure
set(gcf, 'Position', [600, 500, 800,1100])
subplot(3,1,1);
plot( SIT.dn, pernans, 'LineWidth', 1.3);hold on
yline(mean(pernans), 'r--', 'LineWidth', 1.4);
plot(SIT.dn, pernansCA,'LineWidth', 1.3);
plot(SIT.dn, pernansCB,'LineWidth', 1.3);
plot(SIT.dn, pernansCC,'LineWidth', 1.3);
plot(SIT.dn, pernansCT,'LineWidth', 1.3);
title('Sector 10')
ylabel('% Not a Number')
datetick('x', 'mmm yyyy', 'keeplimits')
xlim([min(SIT.dn-70),max(SIT.dn+70)])
ylim([5,60]);
grid on
legend('SIT', 'SIT Mean','CA','CB','CC','CT');
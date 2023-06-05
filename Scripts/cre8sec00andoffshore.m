% Jacob Arnold

% 10-Feb-2022

% Create sector00 and offshore .mat files of SIT

% First the sectors
newlon = []; newlat = [];  newH = [];
 newsa = [];  newsb = []; newsc = [];
 newsd = [];  newca = []; newcb = [];
 newcc = [];  newcd = []; newct = [];
 newSIV = zeros(1,1262);
for ii = 1:18
    if ii < 10
        sector = ['0',num2str(ii)];
    else 
        sector = num2str(ii);
    end
    
    disp(['Loading sector ',sector])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    
    
    newlon = [newlon;SIT.lon]; newlat = [newlat;SIT.lat];  newH = [newH;SIT.H];
     newsa = [newsa;SIT.sa];  newsb = [newsb;SIT.sb]; newsc = [newsc;SIT.sc];
     newsd = [newsd;SIT.sd];  newca = [newca;SIT.ca]; newcb = [newcb;SIT.cb];
     newcc = [newcc;SIT.cc];  newcd = [newcd;SIT.cd]; newct = [newct;SIT.ct];
     newSIV = newSIV+nansum((SIT.H./1000).*3.125); % Sea ice volume in km^3
     
     if str2num(sector) == 10
         newdn = SIT.dn;
         newdv = SIT.dv;
         
     end
     clear SIT
end

SIT.lon = newlon;
SIT.lat = newlat;
SIT.H = newH;
SIT.sa = newsa;
SIT.sb = newsb;
SIT.sc = newsc;
SIT.sd = newsd;
SIT.ca = newca;
SIT.cb = newcb;
SIT.cc = newcc;
SIT.cd = newcd;
SIT.ct = newct;
SIT.SIV = newSIV;
SIT.dn = newdn;
SIT.dv = newdv;

ticker = (1997:2022)';
ticker(:,2:3) = 1; xl = ticker(1:end-1,:);
ticker = datenum(ticker);
xl(:,2) = 7; xl = datenum(xl);

figure;
plot_dim(1200,300);
plot(SIT.dn, SIT.SIV, 'linewidth', 1.2, 'color', [0.99, 0.2,0.32]);hold on
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(25);
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
grid on
title('Sector 00 Sea Ice Volume');
ylabel('Sea Ice Volume [km^3]');
for ii = 1:length(xl(:,1))
    xline(xl(ii), '--','linewidth', .5,'color', [0.75,0.75,0.75]);
end
plot(SIT.dn, SIT.SIV, 'linewidth', 1.2, 'color', [0.99, 0.2,0.32]); % replot to ensure our curve is on top of july lines

%% print the plot and save sector00
print('ICE/ICETHICKNESS/Figures/Sectors/Sector00/sec00SIV.png', '-dpng', '-r500');

save('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat', 'SIT', '-v7.3');




%% Now the zones

zones = {'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};

newlon = []; newlat = [];  newH = [];
 newsa = [];  newsb = []; newsc = [];
 newsd = [];  newca = []; newcb = [];
 newcc = [];  newcd = []; newct = [];
 newSIV = zeros(1,1262);
for ii = 1:6
    sector = zones{ii};
    
    disp(['Loading zone ',sector])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/',sector,'.mat']);
    
    
    newlon = [newlon;SIT.lon]; newlat = [newlat;SIT.lat];  newH = [newH;SIT.H];
     newsa = [newsa;SIT.sa];  newsb = [newsb;SIT.sb]; newsc = [newsc;SIT.sc];
     newsd = [newsd;SIT.sd];  newca = [newca;SIT.ca]; newcb = [newcb;SIT.cb];
     newcc = [newcc;SIT.cc];  newcd = [newcd;SIT.cd]; newct = [newct;SIT.ct];
     
    
     newSIV = newSIV+nansum((SIT.H./1000).*25); % sea ice volume in km^3
     
     if ii == 1
         newdn = SIT.dn;
         newdv = SIT.dv;
         
     end
     clear SIT
end

SIT.lon = newlon;
SIT.lat = newlat;
SIT.H = newH;
SIT.sa = newsa;
SIT.sb = newsb;
SIT.sc = newsc;
SIT.sd = newsd;
SIT.ca = newca;
SIT.cb = newcb;
SIT.cc = newcc;
SIT.cd = newcd;
SIT.ct = newct;
SIT.SIV = newSIV;
SIT.dn = newdn;
SIT.dv = newdv;

ticker = (1997:2022)';
ticker(:,2:3) = 1; xl = ticker(1:end-1,:);
ticker = datenum(ticker);
xl(:,2) = 7; xl = datenum(xl);

figure;
plot_dim(1200,300);
plot(SIT.dn, SIT.SIV, 'linewidth', 1.2, 'color', [0.99, 0.2,0.32]);hold on
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(25);
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
grid on
title('Offshore Sea Ice Volume');
ylabel('Sea Ice Volume [km^3]');
for ii = 1:length(xl(:,1))
    xline(xl(ii), '--','linewidth', .5,'color', [0.75,0.75,0.75]);
end
plot(SIT.dn, SIT.SIV, 'linewidth', 1.2, 'color', [0.99, 0.2,0.32]); % replot to ensure our curve is on top of july lines


%% print the plot and save offshore
%print('ICE/ICETHICKNESS/Figures/Zones/offshore/offshoreSIV.png', '-dpng', '-r500');

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/offshore.mat', 'SIT', '-v7.3');






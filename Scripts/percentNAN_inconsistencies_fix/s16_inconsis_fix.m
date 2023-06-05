% Jacob Arnold

% 25-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 16

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector16.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1998,08,31
%  --> 1999,10,25
%  --> 2000,07,24
%  --> 2001,11,19
%  --> 2006,05,19
%  --> 


% 2. vanishing icebergs
% s--> 2002,12,02
% s--> 2003,01,13
% s--> 2010,04,03
% r--> 2009,03,23 to 2009,05,18 Use week before
% r--> 2009,01,05 to 2009,02,09 Use week after

dummyH = SIT.H;
dummybergs = SIT.icebergs;

%% s16: 1. 


d1(1) = find(SIT.dn==datenum(1998,08,31));
d1(2) = find(SIT.dn==datenum(1999,10,25));
d1(3) = find(SIT.dn==datenum(2000,07,24));
d1(4) = find(SIT.dn==datenum(2001,11,19));
d1(5) = find(SIT.dn==datenum(2006,05,19));

for ii = 1:length(d1)
    
    nani = find(isnan(SIT.H(:,d1(ii))));
    
    dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-1)+ dummyH(nani,d1(ii)+1))./2;
    
    clear nani
end


% view
ticker = unique(SIT.dv(:,1));
ticker(end+1) = 2022;
ticker(:,2:3) = 1;
ticker = datenum(ticker);

figure
plot_dim(800,200)
plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.lon), 'linewidth', 1, 'color', [0.4,0.7,0.9]);
hold on
plot(SIT.dn, sum(isnan(dummyH))./length(SIT.lon), 'linewidth', 1.5, 'color', [0.9, 0.3,0.4]);
legend('Before', 'After')
xticks(ticker);
ylim([0,max(sum(isnan(SIT.H))./length(SIT.lon))+.10])
datetick('x', 'mm-yyyy', 'keepticks')
grid on
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
title('After first correction');
xtickangle(30);




%% s16: 2.


d2(1) = find(SIT.dn==datenum(2002,12,02));
d2(2) = find(SIT.dn==datenum(2003,01,13));
d2(3) = find(SIT.dn==datenum(2010,04,03));

for ii = 1:3
    nani = find(isnan(SIT.H(:,d2(ii)-1)));
    bergi = find(dummybergs(:,d2(ii)-1)==1);
    
    dummyH(nani,d2(ii)) = nan;
    dummybergs(bergi,d2(ii)) = 1;
   
    clear nani bergi
end




d3 = find(SIT.dn==datenum(2009,03,23));
d4 = find(SIT.dn==datenum(2009,05,18));

nan3 = find(isnan(SIT.H(:,d3-1)));
berg3 = find(dummybergs(:,d3-1)==1);

dummyH(nan3,d3:d4) = nan;
dummybergs(berg3,d3:d4) = 1;


d5 = find(SIT.dn==datenum(2009,01,05));
d6 = find(SIT.dn==datenum(2009,02,09));

nan5 = find(isnan(SIT.H(:,d6+1)));
berg5 = find(dummybergs(:,d6+1)==1);

dummyH(nan5,d5:d6) = nan;
dummybergs(berg5, d5:d6) = 1;


figure
plot_dim(800,200)
plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.lon), 'linewidth', 1, 'color', [0.4,0.7,0.9]);
hold on
plot(SIT.dn, sum(isnan(dummyH))./length(SIT.lon), 'linewidth', 1.5, 'color', [0.9, 0.3,0.4]);
legend('Before', 'After')
xticks(ticker);
ylim([0,max(sum(isnan(SIT.H))./length(SIT.lon))+.10])
datetick('x', 'mm-yyyy', 'keepticks')
grid on
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
title('After second correction');
xtickangle(30);







%% Check final


figure
plot_dim(800,200)
plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.lon), 'linewidth', 1, 'color', [0.4,0.7,0.9]);
hold on
plot(SIT.dn, sum(isnan(dummyH))./length(SIT.lon), 'linewidth', 1.5, 'color', [0.9, 0.3,0.4]);
legend('Before', 'After')
xticks(ticker);
ylim([0,max(sum(isnan(SIT.H))./length(SIT.lon))+.10])
datetick('x', 'mm-yyyy', 'keepticks')
grid on
xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
ylabel('% NaN')
title('Sector 16 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector16pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector16.mat', 'SIT', '-v7.3');






















































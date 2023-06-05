% Jacob Arnold

% 25-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 18

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector18.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1999,08,30
%  --> 2006,04,03 btb1
%  --> 2006,04,17 btb1
%  --> 2006,11,03 btb2
%  --> 2006,11,17 btb2
%  --> 2007,02,08 btb3
%  --> 2007,02,23 btb3
%  --> 2007,03,05 btb3
%  --> 2007,03,22 btb3
%  --> 2011,03,21



% 2. vanishing icebergs
% s--> none!

dummyH = SIT.H;
dummybergs = SIT.icebergs;

%% s18: 1. 

d1(1) = find(SIT.dn==datenum(1999,08,30)); 
d1(2) = find(SIT.dn==datenum(2006,04,03)); % btb1
d1(3) = find(SIT.dn==datenum(2006,04,17)); % btb1
d1(4) = find(SIT.dn==datenum(2006,11,03)); % btb2
d1(5) = find(SIT.dn==datenum(2006,11,17)); % btb2
d1(6) = find(SIT.dn==datenum(2007,02,08)); % btb3
d1(7) = find(SIT.dn==datenum(2007,02,23)); % btb3
d1(8) = find(SIT.dn==datenum(2007,03,05)); % btb3
d1(9) = find(SIT.dn==datenum(2007,03,22)); % btb3
d1(10) = find(SIT.dn==datenum(2011,03,21));



for ii = 1:length(d1)
    
    nani = find(isnan(SIT.H(:,d1(ii))));
    
    if ii == 2 | ii == 4
        dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-1) + dummyH(nani,d1(ii)+2))./2;
    elseif ii == 3 | ii == 5
        dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-2) + dummyH(nani,d1(ii)+1))./2;
    elseif ii == 6 | ii == 7 | ii == 8 | ii == 9
        dummyH(nani,d1(ii)) = (dummyH(nani,d1(6)-1) + dummyH(nani,d1(9)+1))./2;
    else
        dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-1) + dummyH(nani,d1(ii)+1))./2;
    end
    
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
title('Sector 18 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector18pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector18.mat', 'SIT', '-v7.3');





































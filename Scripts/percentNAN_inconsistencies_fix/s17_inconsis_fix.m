% Jacob Arnold

% 25-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 17

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector17.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1998,09,14
%  --> 1998,11,09
%  --> 1999,08,30
%  --> 1999,09,27
%  --> 1999,11,01
%  --> 2000,04,17
%  --> 2000,07,14
%  --> 2009,03,09 and 2009,03,23 (back to back) 



% 2. vanishing icebergs
% s--> none!

dummyH = SIT.H;
dummybergs = SIT.icebergs;

%% s17: 1. 



d1(1) = find(SIT.dn==datenum(1998,09,14));
d1(2) = find(SIT.dn==datenum(1998,11,09));
d1(3) = find(SIT.dn==datenum(1999,08,30));
d1(4) = find(SIT.dn==datenum(1999,09,27));
d1(5) = find(SIT.dn==datenum(1999,11,01));
d1(6) = find(SIT.dn==datenum(2000,04,17));
d1(7) = find(SIT.dn==datenum(2000,07,24));
d1(8) = find(SIT.dn==datenum(2009,03,09));
d1(9) = find(SIT.dn==datenum(2009,03,23));


for ii = 1:length(d1)
    
    nani = find(isnan(SIT.H(:,d1(ii))));
    
    if ii < 8
        dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-1) + dummyH(nani,d1(ii)+1))./2;
    elseif ii == 8
        dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-1) + dummyH(nani,d1(ii)+2))./2;
    elseif ii==9
        dummyH(nani,d1(ii)) = (dummyH(nani,d1(ii)-2) + dummyH(nani,d1(ii)+1))./2;

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
title('Sector 17 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector17pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector17.mat', 'SIT', '-v7.3');











































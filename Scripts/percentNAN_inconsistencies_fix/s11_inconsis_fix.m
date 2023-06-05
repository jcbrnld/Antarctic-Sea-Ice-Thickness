% Jacob Arnold

% 19-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 11

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector11.mat;


% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1997-11-03
%  --> 1997-12-01
%  --> 1998-03-16
%  --> 1998-04-20
%  --> 1998-05-25
%  --> 1998-06-22
%  --> 1998-07-13
%  --> 1998-07-27
%  --> 1998-08-10 AND -17 AVERAGE Two days b4 for 17 and two days after for 18
%  --> 2000-07-10

% 2. same as 10 -> vanishing icebergs - dates listed below 


dummyH = SIT.H;
dummybergs = SIT.icebergs;



%% sector11: 1.

d1(1) = find(SIT.dn==datenum(1997,11,03));
d1(2) = find(SIT.dn==datenum(1997,12,01));
d1(3) = find(SIT.dn==datenum(1998,03,16));
d1(4) = find(SIT.dn==datenum(1998,04,20));
d1(5) = find(SIT.dn==datenum(1998,05,25));
d1(6) = find(SIT.dn==datenum(1998,06,22));
d1(7) = find(SIT.dn==datenum(1998,07,13));
d1(8) = find(SIT.dn==datenum(1998,07,27));
d1(9) = find(SIT.dn==datenum(1998,08,10));
d1(10) = find(SIT.dn==datenum(1998,08,17));
d1(11) = find(SIT.dn==datenum(2000,07,10));
d1(12) = find(SIT.dn==datenum(2016,11,10));


for ii = 1:length(d1)
    
    nan1 = find(isnan(SIT.H(:,d1(ii))));
    
    if ii == 9 
        new1 = (dummyH(nan1,d1(ii)-1)+dummyH(nan1,d1(ii)+2))./2;
    elseif ii == 10
        new1 = (dummyH(nan1,d1(ii)-2)+dummyH(nan1,d1(ii)+1))./2;
    else
        new1 = (dummyH(nan1,d1(ii)-1)+dummyH(nan1,d1(ii)+1))./2;
    end
    
    dummyH(nan1,d1(ii)) = new1;
    clear nan1 new1

end


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

%% s11: 2.

% dates: 
% s--> 2005-11-28 - use week before
% s--> 2006-06-02 - use week before
% s--> 2006-08-01 - use week before
% s--> 2007-11-26 - use week before
% s--> 2008-01-07 - use week before
% s--> 2018-08-23 - use week before
% s--> 2021-05-20 - use week before
% s--> 2021-07-15 - use week before

% should be easy enough - nothing major to mess with


d2(1) = find(SIT.dn==datenum(2005,11,28));
d2(2) = find(SIT.dn==datenum(2006,06,02));
d2(3) = find(SIT.dn==datenum(2006,08,01));
d2(4) = find(SIT.dn==datenum(2007,11,26));
d2(5) = find(SIT.dn==datenum(2008,01,07));
d2(6) = find(SIT.dn==datenum(2018,08,23));
d2(7) = find(SIT.dn==datenum(2021,05,20));
d2(8) = find(SIT.dn==datenum(2021,07,15));


for ii = 1:length(d2);
    
    nan2 = find(isnan(SIT.H(:,d2(ii)-1)));
    berg2 = find(dummybergs(:,d2(ii)-1)==1);
    
    dummyH(nan2,d2(ii)) = nan;
    dummybergs(berg2,d2(ii)) = 1;
    
    clear nan2 berg2
    
end

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





% Check final


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
title('Sector 11 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector11pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector11.mat', 'SIT', '-v7.3');

































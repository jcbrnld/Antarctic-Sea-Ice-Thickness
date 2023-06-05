% Jacob Arnold

% 19-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 08

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector08.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1997-10-27 (first day) use vals from next day
%  --> 1997-11-24 
%  --> 1997-12-08 - 1998-01-12 % take average before first date and after last
%  --> 1998-08-03
%  --> 2003-01-27
%  --> 2003-03-10
%  --> 2003-04-07 - 2003-06-16 % take average before first date and after last
%  --> 2003-07-14 
%  --> 2003-07-28 [back to back with 07-14]
%  --> 2004-03-08
%  --> 2004-03-22 [back to back with 03-08]

% 2. Vanishing Icebergs
% s--> 2006-05-01 to 2006-08-01 use week after
% s--> 2006-11-03 to 2007-03-22 use week after
% s--> 2009-06-29 to 2009-09-21
% s--> 2010-04-03 use week after
% s--> 2010-08-09 to 2010-09-20 use week after
% s--> 2012-05-14 to 2012-06-25 use week before
% s--> 2014-03-26 use week before
% s--> 2017-06-22 use week before
% s--> 2021-05-20 use week before

dummyH = SIT.H;
dummybergs = SIT.icebergs;



%% S08: 1. 

d1(1) = find(SIT.dn==datenum(1997,10,27));
d1(2) = find(SIT.dn==datenum(1997,11,24));
d1(3) = find(SIT.dn==datenum(1997,12,08));%r
d1(4) = find(SIT.dn==datenum(1997,12,15));%r
d1(5) = find(SIT.dn==datenum(1997,12,22));%r
d1(6) = find(SIT.dn==datenum(1997,12,29));%r
d1(7) = find(SIT.dn==datenum(1998,01,05));%r
d1(8) = find(SIT.dn==datenum(1998,01,12));%r
d1(9) = find(SIT.dn==datenum(1998,08,03));
d1(10) = find(SIT.dn==datenum(2003,01,27));
d1(11) = find(SIT.dn==datenum(2003,03,10));
d1(12) = find(SIT.dn==datenum(2003,04,07));%r
d1(13) = find(SIT.dn==datenum(2003,04,21));%r
d1(14) = find(SIT.dn==datenum(2003,05,05));%r
d1(15) = find(SIT.dn==datenum(2003,05,19));%r
d1(16) = find(SIT.dn==datenum(2003,06,02));%ii-1
d1(17) = find(SIT.dn==datenum(2003,06,16));%ii-2
d1(18) = find(SIT.dn==datenum(2003,07,14));%bb
d1(19) = find(SIT.dn==datenum(2003,07,28));%bb
d1(20) = find(SIT.dn==datenum(2004,03,08));%bb2
d1(21) = find(SIT.dn==datenum(2004,03,22));%bb2





for ii = 1:length(d1)
    
    if ii==16 | ii==17
        nan1 = find(isnan(SIT.H(:,d1(16)-1)));
    else
        nan1 = find(isnan(SIT.H(:,d1(ii))));
    end
    
    if ii == 1
        new1 = dummyH(nan1,d1(ii)+1);
    elseif ii == 3 | ii==4 | ii==5 | ii==6 | ii==7 | ii==8 % lots in a row
        new1 = (dummyH(nan1,d1(3)-1)+dummyH(nan1,d1(8)+1))./2;
    elseif ii==12 | ii==13 | ii==14 | ii==15 | ii==16 | ii==17 % lots in a row
        new1 = (dummyH(nan1,d1(12)-1)+dummyH(nan1,d1(15)+1))./2;
    elseif ii == 18 | ii==20 % first of back to back pair
        new1 = (dummyH(nan1,d1(ii)-1)+dummyH(nan1,d1(ii)+2))./2;
    elseif ii == 19 | ii==21 % second of back to back pair
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



%% s08 2. 

% s--> 2006-05-01 to 2006-08-01 use week after
% s--> 2006-11-03 to 2007-03-22 use week after
% s--> 2009-06-29 to 2009-09-21 use week before
% s--> 2010-04-03 use week after
% s--> 2010-08-09 to 2010-09-20 use week after
% s--> 2012-05-14 to 2012-06-25 use week before
% s--> 2014-03-26 use week before
% s--> 2017-06-22 use week before
% s--> 2021-05-20 use week before



% non-ranges first
d2(1) = find(SIT.dn==datenum(2010, 04, 03));
d2(2) = find(SIT.dn==datenum(2014,03,26));
d2(3) = find(SIT.dn==datenum(2017,06,22));
d2(4) = find(SIT.dn==datenum(2021,05,20));

for ii = 1:length(d2)
    if ii==1
        nani = find(isnan(SIT.H(:,d2(ii)+1)));
        bergi = find(dummybergs(:,d2(ii)+1)==1);
    else
        nani = find(isnan(SIT.H(:,d2(ii)-1)));
        bergi = find(dummybergs(:,d2(ii)-1)==1);
    end
    
    dummyH(nani,d2(ii)) = nan;
    dummybergs(bergi,d2(ii)) = 1;
    
    clear nani
end


% now for the ranges 
% 1. s--> 2006-05-01 to 2006-08-01 use week after

d3 = find(SIT.dn==datenum(2006,05,01));
d4 = find(SIT.dn==datenum(2006,08,01));
nan2 = find(isnan(SIT.H(:,d4+1)));
berg2 = find(dummybergs(:,d4+1)==1);

dummyH(nan2,d3:d4) = nan;
dummybergs(berg2,d3:d4) = 1;


% 2. s--> 2006-11-03 to 2007-03-22 use week after

d5 = find(SIT.dn==datenum(2006,11,03));
d6 = find(SIT.dn==datenum(2007,03,22));
nan3 = find(isnan(SIT.H(:,d6+1)));
berg3 = find(dummybergs(:,d6+1)==1);

dummyH(nan3,d5:d6) = nan;
dummybergs(berg3,d5:d6) = 1;

% 3. s--> 2010-08-09 to 2010-09-20 use week after

d7 = find(SIT.dn==datenum(2010,08,09));
d8 = find(SIT.dn==datenum(2010,09,20));
nan4 = find(isnan(SIT.H(:,d8+1)));
berg4 = find(dummybergs(:,d8+1)==1);

dummyH(nan4,d7:d8) = nan;
dummybergs(berg4,d7:d8) = 1;

% 4. s--> 2012-05-14 to 2012-06-25 use week before

d9 = find(SIT.dn==datenum(2012,05,14));
d10 = find(SIT.dn==datenum(2012,06,25));
nan5 = find(isnan(SIT.H(:,d9-1)));
berg5 = find(dummybergs(:,d9-1)==1);

dummyH(nan5,d9:d10) = nan;
dummybergs(berg5,d9:d10) = 1;

% 5. [oops forgot this one]
% s--> 2009-06-29 to 2009-09-21 use week before

d11 = find(SIT.dn==datenum(2009,06,29));
d12 = find(SIT.dn==datenum(2009,09,21));
nan6 = find(isnan(SIT.H(:,d11-1)));
berg6 = find(dummybergs(:,d11-1)==1);

dummyH(nan6,d11:d12) = nan;
dummybergs(berg6,d11:d12) = 1;



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


% Looks good! Good job!

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
title('Sector 08 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector08pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector08.mat', 'SIT', '-v7.3');





























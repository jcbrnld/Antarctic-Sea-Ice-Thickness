% Jacob Arnold

% 19-Jan-2022

% Fix inconsistencies in icebergs and other %nan in each sector 
% It will be helpful to have videos from nan_movie.m on hand for each
% sector. 

%% Sector 09

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Backup18jan22/sector09.mat;

% Log of fixes
% 1. same as sector 10 there are some dates where too much along the
%    continent was traced as nan --> need to temporally average to fill
%  --> 1997-10-27 (first day) use vals from next day
%  --> 1997-11-24 
%  --> 1998-10-26 
%  --> 1998-11-02 (right after -26) 
%  --> 2005-05-02


% 2. NO vanishing icebergs! woohoo

dummyH = SIT.H;
dummybergs = SIT.icebergs;




%% s09: 1. 


d1(1) = find(SIT.dn==datenum(1997,10,27));
d1(2) = find(SIT.dn==datenum(1997,11,24));
d1(3) = find(SIT.dn==datenum(1998,10,26));
d1(4) = find(SIT.dn==datenum(1998,11,02));
d1(5) = find(SIT.dn==datenum(2005,05,02));


for ii = 1:length(d1)
    
    nan1 = find(isnan(SIT.H(:,d1(ii))));
    
    if ii == 3 
        new1 = (dummyH(nan1,d1(ii)-1)+dummyH(nan1,d1(ii)+2))./2;
    elseif ii == 4
        new1 = (dummyH(nan1,d1(ii)-2)+dummyH(nan1,d1(ii)+1))./2;
    elseif ii == 1
        new1 = dummyH(nan1,d1(ii)+1);
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
title('Sector 09 Corrections');
xtickangle(30);
%print('ICE/ICETHICKNESS/Figures/Diagnostic/fix_pernan_inconsistencies/sector09pernan.png', '-dpng', '-r500');


%% Finally, save


SIT.H = dummyH;
SIT.icebergs = dummybergs;

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector09.mat', 'SIT', '-v7.3');














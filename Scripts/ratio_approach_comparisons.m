% Jacob Arnold

% 18-Feb-2022

% I think my winter dip problem is because I used the moving average values
% to create concentration ratios rather than using them to fill 99s and
% nans in the original data then taking ratios from filled original data.


% Test the result doing it the second way. 

load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector17_0.mat;
fSIT = SIT; clear SIT
meanct = mean(fSIT.ct,2);

for ii = 1:length(fSIT.dn)
    loc = find(isnan(fSIT.ct(:,ii)));
    fSIT.ct(loc,ii) = meanct(loc);
    clear loc
end


%%

% Ratio differences 
ratioCA = zero_compatible_divide(fSIT.ca, fSIT.ct);
ratioCB = zero_compatible_divide(fSIT.cb, fSIT.ct);
ratioCC = zero_compatible_divide(fSIT.cc, fSIT.ct);
ratioCD = zero_compatible_divide(fSIT.cd, fSIT.ct);

OratioCA = zero_compatible_divide(fSIT.mavg.CA, fSIT.mavg.CT);
OratioCB = zero_compatible_divide(fSIT.mavg.CB, fSIT.mavg.CT);
OratioCC = zero_compatible_divide(fSIT.mavg.CC, fSIT.mavg.CT);
OratioCD = zero_compatible_divide(fSIT.mavg.CD, fSIT.mavg.CT);



%% View differences

figure;
plot_dim(1200,300);
p1 = plot(nanmean(ratioCA));
hold on
%plot(nanmean(OratioCA))
p2 = plot((sum(ratioCA>1)./length(fSIT.lon)));
yline(1,'--', 'linewidth', 2);
legend([p1,p2],'Mean ratioCA', 'Amount of ratioCAs>1')

figure;
plot_dim(1200,300);
p1 = plot(nanmean(ratioCB));
hold on
%plot(nanmean(OratioCA))
p2 = plot((sum(ratioCB>1)./length(fSIT.lon)));
yline(1,'--', 'linewidth', 2);
legend([p1,p2],'Mean ratioCB', 'Amount of ratioCAs>1')

figure;
plot_dim(1200,300);
p1 = plot(nanmean(ratioCC));
hold on
%plot(nanmean(OratioCA))
p2 = plot((sum(ratioCC>1)./length(fSIT.lon)));
yline(1,'--', 'linewidth', 2);
legend([p1,p2],'Mean ratioCC', 'Amount of ratioCAs>1')


% heres the kicker 
temp = cat(3,ratioCA, ratioCB, ratioCC);
newr = sum(temp,3,'omitnan');
temp = cat(3, OratioCA, OratioCB, OratioCC);
oldr = sum(temp,3,'omitnan');
figure;plot_dim(1200,300);
plot(nanmean(newr), 'linewidth', 1.2);
hold on
plot(nanmean(oldr), 'linewidth', 1.2);
yline(1,'--', 'linewidth', 2);
legend('New ratio sum', 'Old ratio sum', 'Theoretical Max')

%% See how it looks in raw gridded form

load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector17_shpSIG.mat
SIT.ca(SIT.ca<0 | SIT.ca==99) = nan;
SIT.cb(SIT.cb<0 | SIT.cb==99) = nan;
SIT.cc(SIT.cc<0 | SIT.cc==99) = nan;
SIT.cd(SIT.ct<0 | SIT.ct==99) = nan;


meanct2 = mean(SIT.ct,2);

for ii = 1:length(SIT.dn)
    loc = find(isnan(SIT.ct(:,ii)));
    SIT.ct(loc,ii) = meanct2(loc);
    clear loc
end

% Ratio differences 
ratioCA2 = zero_compatible_divide(SIT.ca, SIT.ct);
ratioCB2 = zero_compatible_divide(SIT.cb, SIT.ct);
ratioCC2 = zero_compatible_divide(SIT.cc, SIT.ct);
ratioCD2 = zero_compatible_divide(SIT.cd, SIT.ct);

%%

figure; plot_dim(1200,300);
plot(nanmean(ratioCA2), 'linewidth', 1.2)







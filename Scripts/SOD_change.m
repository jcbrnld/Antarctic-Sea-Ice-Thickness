% 17-June-2021

% Jacob Arnold

% View gridded SOD data and extract details 
% Specifically look for how old ice presence has changed during the record
% length




load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector10SIG.mat


for ii = 1:length(SIT.sa(1,:));
    loc95{ii} = find(SIT.sa(:,ii)==95 | SIT.sb(:,ii)==95 | SIT.sc(:,ii)==95 | SIT.sd(:,ii)==95);
    leng95(ii) = length(loc95{ii});
    per95(ii) = (leng95(ii)/length(SIT.sa(:,1)))*100;
    conc95(ii) = nanmean(SIT.ct(loc95{ii},ii));
end

dif1 = conc95-per95;
dif2 = per95-nanmean(SIT.ct); % Difference between ct and percent grid with SOD==95


%% view


figure;
plot(SIT.dn, per95);hold on
%plot(SIT.dn, conc95);
plot(SIT.dn, nanmean(SIT.ct));
datetick('x', 'mm-yyyy');xlim([min(SIT.dn)-100, max(SIT.dn)+100]);
set(gca, 'xticklabelrotation', 35);
set(gcf, 'position', [500,600,1000,400]);
title({'Percent of grid points with SA,SB,SC, OR SD value of 95','and mean CT'});
ylabel('[%]');
legend('SOD', 'CT', 'location','northeastoutside');




figure;
plot(SIT.dn, dif2); 
datetick('x', 'mm-yyyy');xlim([min(SIT.dn)-100, max(SIT.dn)+100]);
yline(0, 'r--');
set(gca, 'xticklabelrotation', 35);
set(gcf, 'position', [500,600,1000,400]);
title({'Difference between percent of grid with SOD==95 and mean CT '});
grid on; grid minor;


%% concentration change of old ice
load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector01SIG.mat

% first translate the concentration data. 

disp('Converting concentrations from SIGRID to %')
%        CA                       CB                      CC                     CT
SIT.ca(SIT.ca==55)=0;   SIT.cb(SIT.cb==55)=0;   SIT.cc(SIT.cc==55)=0;   SIT.ct(SIT.ct==55)=0;
SIT.ca(SIT.ca==1)=5;    SIT.cb(SIT.cb==1)=5;    SIT.cc(SIT.cc==1)=5;    SIT.ct(SIT.ct==1)=5;
SIT.ca(SIT.ca==2)=5;    SIT.cb(SIT.cb==2)=5;    SIT.cc(SIT.cc==2)=5;    SIT.ct(SIT.ct==2)=5;
SIT.ca(SIT.ca==92)=100; SIT.cb(SIT.cb==92)=100; SIT.cc(SIT.cc==92)=100; SIT.ct(SIT.ct==92)=100;
SIT.ca(SIT.ca==91)=95;  SIT.cb(SIT.cb==91)=95;  SIT.cc(SIT.cc==91)=95;  SIT.ct(SIT.ct==91)=95;
SIT.ca(SIT.ca==89)=85;  SIT.cb(SIT.cb==89)=85;  SIT.cc(SIT.cc==89)=85;  SIT.ct(SIT.ct==89)=85;
SIT.ca(SIT.ca==81)=90;  SIT.cb(SIT.cb==81)=90;  SIT.cc(SIT.cc==81)=90;  SIT.ct(SIT.ct==81)=90;
SIT.ca(SIT.ca==79)=80;  SIT.cb(SIT.cb==79)=80;  SIT.cc(SIT.cc==79)=80;  SIT.ct(SIT.ct==79)=80;
SIT.ca(SIT.ca==78)=75;  SIT.cb(SIT.cb==78)=75;  SIT.cc(SIT.cc==78)=75;  SIT.ct(SIT.ct==78)=75;
SIT.ca(SIT.ca==68)=70;  SIT.cb(SIT.cb==68)=70;  SIT.cc(SIT.cc==68)=70;  SIT.ct(SIT.ct==68)=70;
SIT.ca(SIT.ca==67)=65;  SIT.cb(SIT.cb==67)=65;  SIT.cc(SIT.cc==67)=65;  SIT.ct(SIT.ct==67)=65;
SIT.ca(SIT.ca==57)=60;  SIT.cb(SIT.cb==57)=60;  SIT.cc(SIT.cc==57)=60;  SIT.ct(SIT.ct==57)=60;
SIT.ca(SIT.ca==56)=55;  SIT.cb(SIT.cb==56)=55;  SIT.cc(SIT.cc==56)=55;  SIT.ct(SIT.ct==56)=55;
SIT.ca(SIT.ca==46)=50;  SIT.cb(SIT.cb==46)=50;  SIT.cc(SIT.cc==46)=50;  SIT.ct(SIT.ct==46)=50;
SIT.ca(SIT.ca==35)=40;  SIT.cb(SIT.cb==35)=40;  SIT.cc(SIT.cc==35)=40;  SIT.ct(SIT.ct==35)=40;
SIT.ca(SIT.ca==34)=35;  SIT.cb(SIT.cb==34)=35;  SIT.cc(SIT.cc==34)=35;  SIT.ct(SIT.ct==34)=35;
SIT.ca(SIT.ca==24)=30;  SIT.cb(SIT.cb==24)=30;  SIT.cc(SIT.cc==24)=30;  SIT.ct(SIT.ct==24)=30;
SIT.ca(SIT.ca==23)=25;  SIT.cb(SIT.cb==23)=25;  SIT.cc(SIT.cc==23)=25;  SIT.ct(SIT.ct==23)=25;
SIT.ca(SIT.ca==13)=20;  SIT.cb(SIT.cb==13)=20;  SIT.cc(SIT.cc==13)=20;  SIT.ct(SIT.ct==13)=20;
SIT.ca(SIT.ca==12)=15;  SIT.cb(SIT.cb==12)=15;  SIT.cc(SIT.cc==12)=15;  SIT.ct(SIT.ct==12)=15;
SIT.ca(SIT.ca==-9)=0;   SIT.cb(SIT.cb==-9)=0;   SIT.cc(SIT.cc==-9)=0;   SIT.ct(SIT.ct==-9)=0;
SIT.ca(SIT.ca==99)=nan; SIT.cb(SIT.cb==99)=nan; SIT.cc(SIT.cc==99)=nan; SIT.ct(SIT.ct==99)=nan;
disp('done')

%% Next find the concentrations of old ice
load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector02.mat

for ii = 1:length(SIT.sa(1,:));
    loc95sa{ii} = find(SIT.sa(:,ii)==95); 
    loc95sb{ii} = find(SIT.sb(:,ii)==95); 
    loc95sc{ii} = find(SIT.sc(:,ii)==95); 
    loc95sd{ii} = find(SIT.sd(:,ii)==95); 
    ca95(ii) = nanmean(SIT.ca(loc95sa{ii},ii));
    cb95(ii) = nanmean(SIT.cb(loc95sb{ii},ii));
    cc95(ii) = nanmean(SIT.cc(loc95sc{ii},ii));
    cd95(ii) = nanmean(SIT.cd(loc95sd{ii},ii));
    
end
% This is wrong. Need to loop through all grid points and find the exact
% ones with SOD==95 and determine its concentration 

for gg = 1:length(SIT.sa(:,1))
    for dd = 1:length(SIT.sa(1,:))
        if SIT.sa(gg,dd)==95
            C_old(gg,dd) = SIT.ca(gg,dd);
        elseif SIT.sb(gg,dd)==95
            C_old(gg,dd) = SIT.cb(gg,dd);
        elseif SIT.sc(gg,dd)==95
            C_old(gg,dd) = SIT.cc(gg,dd);
        elseif SIT.sd(gg,dd)==95
            C_old(gg,dd) = SIT.cd(gg,dd);
        else
            C_old(gg,dd) = nan;
            
        end
            
        
    end
end

    
% 
% ca95(isnan(ca95)==1)=0;cb95(isnan(cb95)==1)=0;cc95(isnan(cc95)==1)=0;cd95(isnan(cd95)==1)=0;
% 
% C_old = ca95+cb95+cc95+cd95; % first 120 zeros. May need to use hires version from SIT


%%


figure;
plot(C_old);









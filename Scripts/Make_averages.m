% 07/19/21

% Jacob Arnold

% Create plots of averages 
clear all


sector = '04'

load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);

%% Mean SIT
figure;
plot(SIT.dn, nanmean(SIT.H), 'linewidth', 1.2);
grid on
set(gcf,'position', [500,600,1000,400])
datetick('x', 'dd-mmm-yyyy');
title(['Sector ',sector,' Sea Ice Thickness']);
ylabel('Thickness [cm]');
xlim([min(SIT.dn-49),max(SIT.dn+49)]);
ylim([0,260]);
%set(gca, 'color',[0.95,0.95,0.95]);

answer = questdlg(['Save in Figures/Averages/sector_',sector,'?']);

if answer(1)=='C'
    disp('Figure NOT saved')
elseif answer(1)=='Y'
    print(['ICE/ICETHICKNESS/Figures/Averages/Sector_',sector,'/mean_SIT.png'],'-dpng','-r400');
    disp('Figure saved')
elseif answer(1)=='N'
    newpath = inputdlg('Where would you like to save the figure?');
    if isempty(newpath)==1
        disp('Figure NOT saved')
    else
        print([newpath{1,1},'/Sector',sector,'SIT.png'],'-dpng','-r400');
    end
end


%% Percent NaN

figure;
plot(SIT.dn, sum(isnan(SIT.H))./length(SIT.H(:,1)), 'linewidth', 1.2);
grid on
set(gcf,'position', [500,600,1000,400])
datetick('x', 'dd-mmm-yyyy');
title(['Sector ',sector,' percent NaN']);
ylabel('Percent');
xlim([min(SIT.dn-49),max(SIT.dn+49)]);
ylim([0,1]);
%set(gca, 'color',[0.95,0.95,0.95]);

answer = questdlg(['Save in Figures/Averages/sector_',sector,'?']);

if answer(1)=='C'
    disp('Figure NOT saved')
elseif answer(1)=='Y'
    print(['ICE/ICETHICKNESS/Figures/Averages/Sector_',sector,'/percent_nan.png'],'-dpng','-r400');
    disp('Figure saved')
elseif answer(1)=='N'
    newpath = inputdlg('Where would you like to save the figure?');
    if isempty(newpath)==1
        disp('Figure NOT saved')
    else
        print([newpath{1,1},'/Sector',sector,'SIT.png'],'-dpng','-r400');
    end
end
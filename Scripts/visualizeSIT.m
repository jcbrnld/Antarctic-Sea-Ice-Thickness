% Name: 
%     visualize_SIT.m
% 
% Purpose:
%     Plot gridded sea ice thickness data to view the output of the 
%     readgridSIT fuction. 
%    
%     Also used as a workbook to compare output from Jacob running the
%     script compared to the .mat files with the corresponding name that
%     were created by Cody. 
% 
% History:
% 
% Jacob Arnold
% 16 December, 2020


% Notes:
%   There is a 'qc' version of the .mat files output by readgridSIT
%   ('...qc.mat') that seem to have removed absurd readings (in the first
%   120) or may have controlled for a standard exaggeration AND filled in
%   all nan values. 

load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/sabrinaIT.mat
m_basemap('p',[0 360 30],[-90 -50 10]) %entire hemisphere
m_scatter(sabrinaIT.lon, sabrinaIT.lat, 20, sabrinaIT.H(:,2))


%%

m_basemap('a', [108, 128, 5], [-70, -60, 1])
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(sabrinaIT.lon, sabrinaIT.lat, 20,sabrinaIT.H(:,300))
colormap jet
caxis([0,2673])
colorbar

figure
set(gcf, 'Position', [600, 500, 500, 600])
hist(sabrinaIT.H)

%%

figure
scatter(sabrinaIT.lon, sabrinaIT.lat, 20, sabrinaIT.H(:,1))
colormap winter


%% make a video of gridded thickness data 


for ii = 1:648;
    m_basemap('a', [108, 128, 5], [-70, -60, 1])
    set(gcf, 'Position', [600, 500, 800, 700])
    m_scatter(sabrinaIT.lon, sabrinaIT.lat, 20,sabrinaIT.H(:,ii))
    if isnan(sabrinaIT.dv(ii))==0
        xlabel(datestr(datetime(sabrinaIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
    else
        xlabel('-- --- ----')
    end
%    xlabel(datestr(datetime(sabrinaIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
    colormap jet
    caxis([0,600])
    colorbar
    F(ii) = getframe(gcf);
    close all
end

writerobj = VideoWriter('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Figures/Sabrina_IT02-20_V2.avi');
writerobj.FrameRate = 5;

open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
clear F
close all



%% Test with matfile made by Cody


clear all
load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/ICETHICKNESS_Webb/MAT_files_Webb/SabrinaIT.mat %Cody's
saboh = sabrinaIT.h;
sabolo = sabrinaIT.lon;
sabola = sabrinaIT.lat;
sabdv = sabrinaIT.dv;
clear sabrinaIT
load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/ICETHICKNESS_Webb/MAT_files_Webb/SabrinaSITqc.mat %Cody's
load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/sabrinaIT.mat %Jacob's
load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/ICETHICKNESS_Webb/MAT_files_Webb/SabrinaSITqcbw.mat %Cody's


m_basemap('a', [108, 128, 5], [-70, -60, 1])
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(sabrinaIT.lon, sabrinaIT.lat, 20,sabrinaIT.H(:,1)) %The mat file that I created
colormap jet
caxis([0,600])
colorbar
xlabel('NON QC (Jacob)')
% datetime(sabrinaIT.dv(100,:))
% ans = 
%   datetime
%    17-Nov-2006 00:00:00


m_basemap('a', [108, 128, 5], [-70, -60, 1]) 
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(sabolo, sabola, 20,saboh(:,1)) %the basic file that cody created (non qc)
colormap jet
caxis([0,600])
colorbar
xlabel('NON QC (Cody)') %slightly different... hmm
% datetime(sabdv(100,:))
% ans = 
%   datetime
%    14-Dec-2006 00:00:00


% 1. Where did the QC version come from? 
% 2. Where is the script doing the quality controlling? 
% 3. what does BW stand for and where did that one come from? 
% 4. Why is its index different than the others?

% 4. - because 2006/01/23 repeats and the 11 recordings after 120 are
% empty/average to 0 (after the last ridiculously high values). 

% Why is his non qc index changed?
% LOG
%  C missing/ommitted 2006/01/09
%  J extra 2006/01/23 (this date occurrs twice)


m_basemap('a', [110, 123, 5], [-68, -64, 1])
set(gcf, 'Position', [600, 100, 800, 700])
m_scatter(SIT.lon, SIT.lat, 35,SIT.H(:,101), 'filled')
colormap jet
caxis([0,600])
colorbar
xlabel(datestr(datetime(SIT.dv(101,:), 'Format', 'dd MMM yyyy')))

m_basemap('a', [108, 128, 5], [-70, -60, 1])
set(gcf, 'Position', [600, 100, 800, 700])
m_scatter(SITbw.lon, SITbw.lat, 20,SITbw.H(:,1))
colormap jet
caxis([0,600])
colorbar
xlabel('QC BW')

hist(sabrinaIT.H(:, 1:120))%SHOWS that the extreme values seem to
title('Recordings 1 to 120')% dissappear after the 119th recording - datetime 21-Sep-2007 00:00:00.
%print('/Users/jacobarnold/Documents/Classes/Orsi/Meetings/dec182020/hist1.png','-dpng', '-r500')


hist(sabrinaIT.H(:, 121:648))%SHOWS that the extreme values seem to
title('Recordings 121 to 648')
% confirmns the above. 
%print('/Users/jacobarnold/Documents/Classes/Orsi/Meetings/dec182020/hist2.png','-dpng', '-r500')


%hist(saboh(:,1:100))
%hist(saboh(:,110:200))  %Similar trend to mine but slightly offput it seems. 

%% Try impaint_nans

% start with a subset

clear all
close all

load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/sabrinaIT.mat %Jacob's

subh = sabrinaIT.H(:,1:10);
subhi = inpaint_nans(subh)

% Doesn't work

%% Find repeated dates

indrep = zeros(length(sabrinaIT.dv(:,1)), 1);
for ff = 6:length(sabrinaIT.dv)
    for gg = 1:5
        if sabrinaIT.dv(ff, 3)==sabrinaIT.dv(ff-gg, 3) & sabrinaIT.dv(ff,2)==sabrinaIT.dv(ff-gg, 2);
            indrep(ff) = gg;
            disp(ff)
        end
    end
end

% This shows that only the one date (2006/01/23) is repeated and only once.


m_basemap('a', [108, 128, 5], [-70, -60, 1])
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(sabrinaIT.lon, sabrinaIT.lat, 20,sabrinaIT.H(:,79)) %The mat file that I created
colormap jet
caxis([0,600])
colorbar
xlabel(datestr(datetime(sabrinaIT.dv(79,:), 'Format', 'dd MMM yyyy')))

m_basemap('a', [108, 128, 5], [-70, -60, 1])
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(sabrinaIT.lon, sabrinaIT.lat, 20,sabrinaIT.H(:,80)) %The mat file that I created
colormap jet
caxis([0,600])
colorbar
xlabel(datestr(datetime(sabrinaIT.dv(80,:), 'Format', 'dd MMM yyyy')))

% The two recordings for 2006/01/23 are extremely similar 
% There are two available on the  for that date: 
% https://usicecenter.gov/Products/ArchiveSearch?table=WeeklyAntarctic&product=Antarctic%20Weekly%20Shapefile&linkChange=ant-two


sabmeans = nanmean(sabrinaIT.H);
figure
set(gcf, 'Position', [600, 500, 800, 300])
plot(sabmeans)
title('Sabrina region mean thickness values')
%print('/Users/jacobarnold/Documents/Classes/Orsi/Meetings/dec182020/avgvals.png','-dpng', '-r500')

% Looks the same as some I found in Cody's work.




%% Play with my data to gain isight into Cody's qc procedure

load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/sabrinaIT.mat %Jacob's

sabrinaIT.H(:,80) = (sabrinaIT.H(:,79)+sabrinaIT.H(:,80))./2; % Removes the repeated date and replaces it with the average of the two. Note: the average is the same as the original second recording for that date (index 80).
sabrinaIT.H(:,79) = [];

mns = nanmean(sabrinaIT.H); % see how far the outlandish values reach in the indices.
% Result: Until index 119. NOTE*** 120 to 130 mean values are just 0 !!!

% Let's try dividing the group of outlandish values (first 119) by 10 
divtemp = sabrinaIT.H(:,1:119)./10;
sabrinaIT.H(:,1:119) = divtemp;

% Now lets see what some of them look like
m_basemap('a', [108, 128, 5], [-70, -60, 1])
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(sabrinaIT.lon, sabrinaIT.lat, 20,sabrinaIT.H(:,90)) % first 119 each divided by 10
colormap jet
caxis([0,600])
colorbar
xlabel(datestr(datetime(sabrinaIT.dv(90,:), 'Format', 'dd MMM yyyy')))
% Definitely looks more reasonable but is it right? how to know? NO

% Let's compare to Cody's qc version 
load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/ICETHICKNESS_Webb/MAT_files_Webb/SabrinaSITqc.mat %Cody's
m_basemap('a', [108, 128, 5], [-70, -60, 1])
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(SIT.lon, SIT.lat, 20,SIT.H(:,90)) 
colormap jet
caxis([0,600])
colorbar
xlabel(datestr(datetime(SIT.dv(90,:), 'Format', 'dd MMM yyyy')))

% DEFINITELY not the correct qc


% It does look like the 0 recordings were removed AND the repeated day
% corrected. 



%% Compare some of the values from the mat file created by me vs Cody
% After the 128th one
clear all
close all

load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/sabrinaIT.mat %Jacob's
load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/ICETHICKNESS_Webb/MAT_files_Webb/SabrinaSITqc.mat %Cody's

%To actually compare will need to match dates
% the easy way - find where qc is the same date as raw
% ans =
%   datetime
%    27-Oct-2008 00:00:00

% --- the 148th of qc is the same as the 150th of raw



m_basemap('a', [108, 128, 5], [-70, -60, 1])
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(sabrinaIT.lon, sabrinaIT.lat, 20,sabrinaIT.H(:,150)) 
colormap jet
caxis([0,600])
colorbar
xlabel('Jacobs (non qc) 27-Oct-2008')
%print('/Users/jacobarnold/Documents/Classes/Orsi/Meetings/dec182020/new_example.png','-dpng', '-r500')

m_basemap('a', [108, 128, 5], [-70, -60, 1])
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(SIT.lon, SIT.lat, 20,SIT.H(:,148)) 
colormap jet
caxis([0,600])
colorbar
xlabel('Codys (qc) 27-Oct-2008')
%print('/Users/jacobarnold/Documents/Classes/Orsi/Meetings/dec182020/cody_example.png','-dpng', '-r500')
% Still really different plots - more than just nan filling is occurring -
% a lot more.










     
    
    
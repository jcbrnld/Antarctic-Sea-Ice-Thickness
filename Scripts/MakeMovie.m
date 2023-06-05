% 03-June-2021

% Jacob Arnold

% Make basemap grid movies

clear all
close all

path2research = [];
list={'Sector01', 'Sector02', 'Sector03', 'Sector04', 'Sector05', 'Sector06',...
    'Sector07', 'Sector08', 'Sector09', 'Sector10', 'Sector11', 'Sector12', 'Sector13',...
    'Sector14', 'Sector15', 'Sector16', 'Sector17', 'Sector18','All Shelf', 'All Subpolar', 'Subpolar Atlantic',...
    'Subpolar Indian', 'Subpolar Pacific'};
[indx,tf] = listdlg('PromptString',{'Which sector do you wish to use?'},...
    'SelectionMode','single','ListString', list);
if indx<10
    sector = ['0', num2str(indx)];
elseif indx<19 & indx>9
    sector = num2str(indx);
elseif indx==19;sector='All_Shelf';
elseif indx==20;sector = 'subpolar';elseif indx==21; sector='subpolar_ao_SIC';
elseif indx==22;sector='subpolario';elseif indx==23; sector='subpolar_po_SIC';
end
if tf==0
    error('Cancel selected at sector selection')
end


answer = questdlg('Plot with sector boundary ice motion vectors?');
if answer(1)=='C'
    error('Cancel selected at vector question')
end

visquest = questdlg('See plots momentarily as they are created?');
if visquest(1)=='C'
    error('Cancel selected at visibility question')
end
% Can't load wind data for All_Shelf yet
if answer(1) == 'Y'
    if length(sector)==2
        sect = load([path2research,'ICE/Concentration/ant-sectors/sector',sector,'.mat']);
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    else
        sect = load([path2research,'ICE/Concentration/so-zones/',sector,'_SIC.mat']);
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/',sector,'.mat']); 

    end
    sectC = struct2cell(sect);
    clear sect
elseif answer(1) == 'C'
    warning('Ice motion will not be included')
else
    if length(sector)==2
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    else
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/',sector,'.mat']); %
    end
    disp('Sector boundary ice motion data not imported')
end
 

SIT.H = SIT.H(:, 1:length(SIT.ca(1,:)));

splot{1,1}=[289 312]; splot{1,2}=[-73 -60]; splot{2,1}=[296 337]; splot{2,2}=[-79 -70];
splot{3,1}=[332 358]; splot{3,2}=[-77 -69]; splot{4,1}=[0 26]; splot{4,2}=[-71 -68];
splot{5,1}=[24 55]; splot{5,2}=[-71 -65]; splot{6,1}=[53 69]; splot{6,2}=[-68 -65.1];
splot{7,1}=[66.5 86.5]; splot{7,2}=[-71 -64.5]; splot{8,1}=[84.5 100.5]; splot{8,2}=[-67.5 -63.5];
splot{9,1}=[99 114]; splot{9,2}=[-67.5 -63.5]; splot{10,1}=[112 123]; splot{10,2}=[-67.5 -64.5];
splot{11,1}=[120.5 135]; splot{11,2}=[-67.5 -64.2]; splot{12,1}=[132.5 151.5]; splot{12,2}=[-69.3 -64.2];
splot{13,1}=[148 174]; splot{13,2}=[-72.5 -65]; splot{14,1}=[159.5 207]; splot{14,2}=[-79.5 -69];
splot{15,1}=[200 236]; splot{15,2}=[-78 -71.9]; splot{16,1}=[232 262]; splot{16,2}=[-76.2 -69];
splot{17,1}=[258 295]; splot{17,2}=[-75 -67]; splot{18,1}=[282.5 308]; splot{18,2}=[-69 -59];

if length(sector)==2
    londom = splot{str2num(sector),1}; latdom = splot{str2num(sector),2};
end
if answer(1)=='Y'
    dn = sectC{1,1}.dn;
    SICcorr2 = sectC{1,1}.sic;
    polyu = sectC{1,1}.polyu;
    polyv = sectC{1,1}.polyv;
    dnuv = sectC{1,1}.dnuv;

    mdn = SIT.dn;
    dmdn = diff(mdn); % should be 1xN-1 -> difference between each two values
    for ii = 1:length(dmdn)
        lmdn(ii,1) = mdn(ii)+round((dmdn(ii))/2); %provides midpoint values between each dn - should be N-1x1
    end
    clear ii

    for ii = 1:length(lmdn);
        mids(ii) = find(dn==lmdn(ii)); % should be 1xN-1
    end

    fd = find(dn==mdn(1));
    if dn(end)>=SIT.dn(end)
        ld = find(dn==mdn(length(lmdn)+1));
    else
        ld = length(dn);
    end
    avgSIC = nan(length(SIT.lon), length(SIT.dn));% CHECK THIS METHOD NOOOW
    for gg = 1:length(SIT.lon)
        for ii = 1:length(lmdn)-1
            avgSIC(gg,ii+1) = nanmean(SICcorr2(gg,mids(ii):mids(ii+1)));

        end 
        avgSIC(gg,1) = nanmean(SICcorr2(gg,fd:mids(1)));
        avgSIC(gg,length(lmdn)+1) = nanmean(SICcorr2(gg, mids(end):ld));
    end
    clear gg ii mdn dmdn mids fd ld lmdn




    % poly edge U and V

    mdn = SIT.dn;
    mdn = mdn(find(mdn <= dnuv(end)));
    dmdn = diff(mdn); % should be 1xN-1 -> difference between each two values
    for ii = 1:length(dmdn)
        lmdn(ii,1) = mdn(ii)+round((dmdn(ii))/2); %provides midpoint values between each dn - should be N-1x1
    end
    clear ii

    for ii = 1:length(lmdn);
        mids(ii) = find(dnuv==lmdn(ii)); % should be 1xN-1
    end

    fd = find(dnuv==mdn(1));
    if dnuv(end)>=SIT.dn(end)
        ld = find(dnuv==mdn(length(lmdn)+1));
    else
        ld = length(dnuv);
    end


    avgpolyU = nan(length(sectC{1,1}.polylon), length(SIT.dn));
    avgpolyV = nan(length(sectC{1,1}.polylon), length(SIT.dn));

    for gg = 1:length(sectC{1,1}.polylon)
        for ii = 1:length(lmdn)-1
            avgpolyU(gg,ii+1) = nanmean(polyu(gg,mids(ii):mids(ii+1)));
            avgpolyV(gg,ii+1) = nanmean(polyv(gg,mids(ii):mids(ii+1)));

        end 
        avgpolyU(gg,1) = nanmean(polyu(gg,fd:mids(1)));
        avgpolyV(gg,1) = nanmean(polyv(gg,fd:mids(1)));
        avgpolyU(gg,length(lmdn)+1) = nanmean(polyu(gg, mids(end):ld));
        avgpolyV(gg,length(lmdn)+1) = nanmean(polyv(gg, mids(end):ld));
    end
    clear ii gg



    disp('Done averaging SIC across each weekly/biweekly interval')
else
    disp('No SIC Imported')
end

% Sector sizes
% Sector 01:8; Sector 02:12; Sector 03:10; Sector 04:12; Sector 05:10; Sector 06:28;
% Sector 07:13; Sector 08:25; Sector 09:26; Sector 10:45; Sector 11:28;
% Sector 12:20; Sector 13:12; Sector 14:9; Sector 15:16; Sector 16:15;
% Sector 17:9; Sector 18:9

sdotsize = [8 12 10 12 10 28 13 25 26 45 28 20 12 9 16 15 9 9];

% Make the movie: Notice where it saves

cntr = [1:50:2000];
mnths = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"];

for ii = 1:length(SIT.H(1,:));
    if ismember(ii,cntr)
        disp(['Finished through... ' num2str(SIT.dv(ii,3)) '-' mnths(SIT.dv(ii,2)) '-' num2str(SIT.dv(ii,1))])
    end
    if length(sector)==2
        size = sdotsize(str2num(sector));
        if visquest(1)=='Y'
            m_basemap('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1]) % change projection to 'm' if using vectors
        else
            m_basemap2('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1]) 
        end
    elseif sector=='All_Shelf'
        if visquest(1)=='Y'
            m_basemap('p', [0,360,60], [-89, -57], 'sdL_v10', [2000,4000], [8,8]); % 2000 and 4000 m isobaths
        else
            m_basemap2('p', [0,360,60], [-89, -57], 'sdL_v10', [2000,4000], [8,8]); % 2000 and 4000 m isobaths
        end
        size = 3;
    end
    m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
    set(gcf, 'Position', [1000, 500, 1000, 700])
    m_scatter(SIT.lon, SIT.lat, size,SIT.H(:,ii), 'filled');hold on
    if answer(1)=='Y'
        m_scatter(sectC{1,1}.polylon, sectC{1,1}.polylat,10, 'filled', 'markerfacecolor',[0.5, 0.9, 0]);
        m_vec(100, sectC{1,1}.polylon, sectC{1,1}.polylat, avgpolyU(:,ii),avgpolyV(:,ii),'headwidth', 0, 'shaftwidth',...
        .25, 'FaceColor', 'r', 'EdgeColor', 'r', 'FaceAlpha', .3, 'EdgeAlpha', .3);
    end
    if isnan(SIT.dv(ii))==0
        xlabel(datestr(datetime(SIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
    else
        xlabel('-- --- ----')
    end
    colormap(jet(12))
    %cmocean('ice', 12);
    caxis([0,3])
    %caxis([0,1])
    cbh = colorbar;
    cbh.Ticks = [0:0.25:3];
    cbh.Label.String = ('Sea Ice Thickness [cm]');
    F(ii) = getframe(gcf);
    close gcf
end
if answer(1)=='Y'    
    writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Sectors/With_border_vectors/Sector',sector,'.mp4'], 'MPEG-4');
else
    writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Sectors/Plain_Thickness/Sector',sector,'.mp4'], 'MPEG-4');
end    

writerobj.FrameRate = 5;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp(['Success! Sector ',sector,' Video saved'])
clear F 









%%

%m_propmap(1, 'a', [296 337], [-79 -70], 'd', SIT.lon, SIT.lat, SIT.H(:,186), 4, 'ver', 'Thickness [cm]', 'linear', [0:25:300]);

num = 300;
m_basemap('m', [296 337], [-79 -70],'sdL_v10',[2000,4000],[8, 1])
set(gcf, 'position', [2000,10,900,800])
m_scatter(SIT.lon, SIT.lat, 25,SIT.ct(:,num), 'filled');hold on
m_scatter(sectC{1,1}.polylon, sectC{1,1}.polylat,10, 'filled', 'markerfacecolor',[0.5, 0.9, 0]);
m_vec(10, sectC{1,1}.polylon, sectC{1,1}.polylat, avgpolyU(:,num),avgpolyV(:,num),'headwidth', 0, 'shaftwidth',...
    .25, 'FaceColor', 'r', 'EdgeColor', 'r', 'FaceAlpha', .3, 'EdgeAlpha', .3);
%colormap(wocealk);
cmocean('ice', 12);

caxis([0,300]);
cbh = colorbar;
cbh.Ticks = [0:25:300];
cbh.Label.String = ('Sea Ice Thickness [cm]');






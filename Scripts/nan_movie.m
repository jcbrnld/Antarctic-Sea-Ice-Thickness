% Jacob Arnold

% 18-Jan-2022

% Create movies of sectors' nan grid points over time
% Include timeseries of % nan 


% to practice:
%_________________
ss = 14;
%-----------------

% CHECK WHERE IT SAVES 



if ss < 10
    sector = ['0',num2str(ss)];
else
    sector = num2str(ss);
end
load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);

dticker = unique(SIT.dv(:,1));
dticker(end+1) = 2022;
dticker(:,2:3) = 1;
dticker = datenum(dticker);

cntr = [1:50:2000];
[londom, latdom] = sectordomain(str2num(sector));
sdot = sectordotsize(str2num(sector));
ii = 500; % to test

 %%
for ii = 1:length(SIT.H(1,:));
    if ismember(ii,cntr)
        disp(['Finished through... ' datestr(SIT.dn(ii))])
    end

    nanlocs = find(isnan(SIT.H(:,ii)));

    figure;
    s1 = subplot(4,1,1:3); 
    set(s1, 'Position', [0.1,0.3,0.81,0.6])
    plot_dim(800,800);
    %plot_dim(800,950); % sector 01
    m_basemap_subplot('a', londom, latdom);
    scat1 = m_scatter(SIT.lon, SIT.lat, sdot+sdot*0.5, [0.7,0.7,0.7], 'filled');% adjust xx in sdot*.xx
    scat2 = m_scatter(SIT.lon(nanlocs), SIT.lat(nanlocs), sdot, [0.9,0.4,0.5], 'filled');
    %_________________________________________________________
    %lpos = [0.7,0.75,.17,.05]; % [top right] sectors 10, 12, 09, 13, 16, 02
    %lpos = [0.67,0.41,.17,.05]; % [bottom right] sector 11, 08
    %lpos = [0.260,0.81,.17,.05]; % [top left] sector 01,
    %lpos = [0.599,0.45,.17,.05]; % [bottom right] sector 15
    %lpos = [0.20,0.75,.17,.05]; % [top left] sector 17, 07, 18, 03
    %lpos = [0.20,0.65,.17,.05]; % [top left] sector 04
    %lpos = [0.20,0.7,.17,.05]; % [top left] sector 05
    lpos = [0.7,0.70,.17,.05]; % [top right] sector 06, 14
    %_________________________________________________________
    
    legend([scat1, scat2], ['Sector ',sector,' grid'], 'Points with NaN',...
        'fontsize', 12, 'position', lpos);
    %_________________________________________________________
    %xpos = [0,-0.045]; % sector 12
    %xpos = [0,-0.028]; % sector 10
    %xpos = [0,-0.0308]; % sector 11, 04
    %xpos = [0,-0.036]; % sector 09, 08
    %xpos = [0,-0.069]; % sector 13
    %xpos = [0,-0.119]; % sector 01
    %xpos = [0,-0.087]; % sector 02
    xpos = [0,-0.097]; % sector 14
    %xpos = [0,-0.061]; % sector 15, 07, 05
    %xpos = [0,-0.065]; % sector 16
    %xpos = [0,-0.076]; % sector 17
    %xpos = [0,-0.093]; % sector 18
    %xpos = [0,-0.074]; % sector 03
    %xpos = [0,-0.0272]; % sector 06
    %_________________________________________________________
    
    xlabel(['Sector ',sector,': ',datestr(SIT.dn(ii))],...
        'Position', xpos, 'fontsize', 15, 'fontweight', 'bold');

    s2 = subplot(4,1,4);
    linevar = (sum(isnan(SIT.H))./length(SIT.lon)).*100;
    %_________________________________________________________
    %set(s2, 'Position', [0.12,0.2,0.77,0.13]) % sector 12, 09, 17
    %set(s2, 'Position', [0.12,0.17,0.77,0.13]) % sector 10
    %set(s2, 'Position', [0.12,0.165,0.77,0.13]) % sector 16
    %set(s2, 'Position', [0.12,0.22,0.77,0.13]) % sector 11, 08, 05
    %set(s2, 'Position', [0.12,0.15,0.77,0.13]) % sector 13, 02
    %set(s2, 'Position', [0.12,0.1365,0.77,0.13]) % sector 01, 07, 18, 03
    set(s2, 'Position', [0.12,0.182,0.77,0.13]) % sector 14, 15
    %set(s2, 'Position', [0.12,0.3,0.77,0.13]) % sector 04
    %set(s2, 'Position', [0.12,0.26,0.77,0.13]) % sector 06
    %_________________________________________________________
    
    plot(SIT.dn, linevar, 'linewidth', 1.6,'color', [0.9,0.4,0.5])
    xline(SIT.dn(ii), 'linewidth', 1.2, 'color', [0.3, 0.9, 0.6]);
    xticks(dticker);
    datetick('x', 'mm-yyyy', 'keepticks')
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    xtickangle(33)
    ylim([0, max(linevar) + 10])
    ylabel('% NaN')
    grid on

    F(ii) = getframe(gcf);

    clear nanlocs s1 s2 
    close gcf

end

writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/nan_gpoints/sector',sector,'nansBeforeCorrection.mp4'], 'MPEG-4');
%writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/nan_gpoints/sector',sector,'nansAFTER_First_Correction.mp4'], 'MPEG-4');

writerobj.FrameRate = 5;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp(['Success! Sector ',sector,' Video saved'])

clearvars






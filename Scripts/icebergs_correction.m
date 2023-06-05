% Jacob Arnold

% 07-Jan-22

% Extract icebergs from raw continental ice classification during SIT
% Assign new iceberg variables to SIT structure and save
% Create some plots and movies of icebergs
% AFter saving, 'rawicebergs' will be the same as the original 'icebergs' in
% the SIT structure


for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    elseif ss == 10
        continue
    elseif ss > 10
        sector = num2str(ss);
    end
    
    disp(['Beginning Sector ',sector])

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);

    [londom, latdom] = sectordomain(str2num(sector));

    sz = size(SIT.icebergs);
    if sz(2) > 1
        warning('Woah, already did this one my friend')
        continue

    end

    %%% icebergs


    numgpoints = length(SIT.lon);
    bergs = SIT.icebergs;

    for ii = 1:length(SIT.dn)

        dnberg = find((bergs <= numgpoints) & (bergs > 0));

        icebergs{ii} = bergs(dnberg);

        bergs = bergs-numgpoints;

        clear dnberg
    end



    %
    for ii = 1:length(icebergs)
        numbergpoints(ii) = length(icebergs{ii});
    end

    %

    %figure;
    %plot(numbergpoints)


    %%% Exclude permanent ice along margains


    load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);

    permInds = SIC.permIceInds; clear SIC

    %%% Correction 1: remove points that are permanently NaN in SIC

    [londom, latdom] = sectordomain(str2num(sector));
    m_basemap('a', londom, latdom)
    dots = sectordotsize(str2num(sector));
    sectorexpand(str2num(sector))
    m_scatter(SIT.lon, SIT.lat, dots, 'filled', 'markerfacecolor', [0.7,0.7,0.7])
    m_scatter(SIT.lon(permInds), SIT.lat(permInds),dots, 'm', 'filled')
    xlabel(['Sector ',sector, ' Grid points to remove from ICEBERGS (correction 1)']);
    %print(['ICE/ICETHICKNESS/Figures/Icebergs/sector',sector,'_correction1.png'], '-dpng', '-r400');


    icebergs1 = icebergs;
    for ii = 1:length(icebergs)
        if length(icebergs{ii})>0
            overlap = find(ismember(icebergs{ii}, permInds));
            icebergs1{ii}(overlap) = [];
        end
        newsize(ii) = length(icebergs1{ii});

    end

    %%% Correction 2: remove continental ice that appears before september 2002


    icebergs2 = zeros(size(SIT.H));
    % first convert to logical structure (zeros and ones)
    for ii = 1:length(icebergs1)
        if length(icebergs1{ii}>0);

            icebergs2(icebergs1{ii},ii) = 1;
        end
    end

    % Now find which grid points appear more than 10% of the time before
    % 2002-09-23 (index 220)

    morecoast = find(sum(icebergs2(:,1:202),2)/202 >= 0.00010);


    [londom, latdom] = sectordomain(str2num(sector));
    m_basemap('a', londom, latdom)
    dots = sectordotsize(str2num(sector))
    sectorexpand(str2num(sector))
    m_scatter(SIT.lon, SIT.lat, dots, 'filled', 'markerfacecolor', [0.7,0.7,0.7])
    m_scatter(SIT.lon(morecoast), SIT.lat(morecoast),dots, 'm', 'filled')
    xlabel({'Grid points to remove from ICEBERGS (correction 2)','These should all be coastal/permanent ice areas'})
    %print(['ICE/ICETHICKNESS/Figures/Icebergs/sector',sector,'_correction2.png'], '-dpng', '-r400');


    %%% IF THE ABOVE FIGURE LOOKS GOOD (all dots are along coast/not icebergs)

    icebergs2(morecoast,:) = 0;

    % Now convert back to cell

    for ii = 1:length(icebergs1)
        icebergs3{ii} = find(icebergs2(:,ii)==1);
    end

    icebergs1 = icebergs3;
    newsize = sum(icebergs2);

    %%% Plot glacial ice before and after correction

    ticker = unique(SIT.dv(:,1));ticker(length(ticker)+1) = 2022;
    ticker(:,2:3) = 1;
    ticker = datenum(ticker);

    figure;
    plot_dim(1000,300)
    plot(SIT.dn, numbergpoints, 'linewidth', 1.2);
    hold on
    plot(SIT.dn, newsize, 'linewidth', 1.2);
    title(['Sector ',sector,' glacial ice before and after iceberg correction']);
    legend('Original Glacial Ice', 'Icebergs Only');
    xticks(ticker);
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(25)
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    grid on
    %print(['ICE/ICETHICKNESS/Figures/Icebergs/sector',sector,'_edgecorrection.png'],'-dpng','-r400');


    hasberg = find(sum(icebergs2,2)>0);
    m_basemap('a', londom, latdom)
    size1 = sectordotsize(str2num(sector));
    sectorexpand(str2num(sector));
    dot1 = m_scatter(SIT.lon, SIT.lat, size1, 'filled', 'markerfacecolor',[0.7,0.7,0.7])
    dot2 = m_scatter(SIT.lon(hasberg), SIT.lat(hasberg), size1,'m', 'filled');
    legend([dot1, dot2], 'Sector grid', 'Grid cells touched by icebergs');
    %print(['ICE/ICETHICKNESS/Figures/Icebergs/sector',sector,'_dotstouched.png'],'-dpng','-r400');

    %%% Fix in SIT structure 
    SIT.rawicebergs = SIT.icebergs;
    SIT.icebergs_inds = icebergs1;
    SIT.icebergs = icebergs2;


    %%% Timeseries of icebergs
    ticker = unique(SIT.dv(:,1));ticker(length(ticker)+1) = 2022;
    ticker(:,2:3) = 1;
    ticker = datenum(ticker);

    figure;
    plot_dim(800,200);
    plot(SIT.dn, sum(SIT.icebergs)./length(SIT.lon).*100, 'linewidth', 1.1);
    title(['Sector ',sector,' % of grid cells with icebergs']);
    xticks(ticker);
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(25)
    xlim([min(SIT.dn)-50, max(SIT.dn)+50]);
    grid on
    ylabel('Percent of grid cells in sector'); 
    %print(['ICE/ICETHICKNESS/Figures/Icebergs/sector',sector,'_perc_bergs.png'],'-dpng','-r400');


    %%% Finally if all looks good SAVE

    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');

    clearvars
    close all

end


%% make movie of "continental ice"


cntr = [1:50:2000];
[londom, latdom] = sectordomain(str2num(sector));
size1 = sectordotsize(str2num(sector));

for ii = 1:length(icebergs1);
    if ismember(ii,cntr)
        disp(['Finished through... ' datestr(SIT.dn(ii))])
    end
    m_basemap2('a', londom, latdom,'sdL_v10',[2000,4000],[8, 1]) 
    m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
    sectorexpand(str2num(sector));
    m_scatter(SIT.lon, SIT.lat, size1, 'filled', 'markerfacecolor', [0.8,0.85,0.9]);
    m_scatter(SIT.lon(icebergs1{ii}), SIT.lat(icebergs1{ii}), size1, 'm', 'filled');
    if isnan(SIT.dv(ii))==0
        xlabel(datestr(datetime(SIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
    else
        xlabel('-- --- ----')
    end

    F(ii) = getframe(gcf);
    close gcf
end
writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Icebergs/Sector',sector,'_bergs.mp4'], 'MPEG-4');
 

writerobj.FrameRate = 5;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end

close(writerobj);



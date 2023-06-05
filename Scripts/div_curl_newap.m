% Jacob Arnold

% 03-Mar-2022

% calculate sea ice divergence using new approach
% need to use Greene's cdtdivergence 
% to calculate divergence, data must be on uniform monotonic
% lat/lon grid. 
% here I will generate a qualifying grid with similar spacing but uniform
% lat and lon. longitudinal spacing will be the spacing required to meet
% 3.125 km between points at the maximum longitude (thus the grid will
% always be finer resolution than 3.125 km

% WAIT
% reconsider how to generage the new grids based on discussion with Alex. 
% I am going to play with converting to xy then creating monotonic grid in
% xy, interpolating, calculating divergence, and interpolating back. 

for ss = 1:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else 
        sector = num2str(ss);
    end
    
    disp(['Beginning sector ',sector,'...']);
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);

    load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);

    %%%
    % make new grid
    mi = min(seaice.lon)-0.2;
    ma = max(seaice.lon)+0.2;
    di = ma-mi;
    la = max(seaice.lat);

    dv = (-max(seaice.lat)+0.1)+(min(seaice.lat)-0.1);
    % distance in km along bottom edge (min lat) of minlon:maxlon
    horizdistance = di*cos(deg2rad(-la))*111;
    vertdistance = dv*111;

    % now decide how many gpoints there should be across this region
    nph = horizdistance/3.125;
    npv = vertdistance/3.125;

    % now determine deg. step
    dsh = di/nph;
    dsv = dv/npv;

    defx = (min(seaice.lon)-0.2):dsh:(max(seaice.lon)+0.2);
    defy = (min(seaice.lat)-0.1):dsv:(max(seaice.lat)+0.1);

    [tlon, tlat] = meshgrid(defx, defy); % NEW GRID
    [tx, ty] = ll2ps(tlat, tlon); % NEW GRID IN XY
    
     % Average u and v to H timescale
    newU = nan(length(SIC.lon), length(seaice.dn));
    newV = newU;
    for ii = 1:length(seaice.dn)
        if seaice.dn(ii) > max(SIC.dnuv);
            newU(:,ii) = nan;
            newV(:,ii) = nan;
            continue
        end

        dnloc = find(SIC.dnuv==seaice.dn(ii));

        if SIC.dnuv(dnloc)+3>max(SIC.dnuv)
            newU(:,ii) = nanmean(SIC.u(:,dnloc-3:end),2);
            newV(:,ii) = nanmean(SIC.v(:,dnloc-3:end),2);
        else
            newU(:,ii) = nanmean(SIC.u(:,dnloc-3:dnloc+3),2);
            newV(:,ii) = nanmean(SIC.v(:,dnloc-3:dnloc+3),2);

        end

        clear dnloc

    end
    
    [ox, oy] = ll2ps(SIC.lat, SIC.lon);

     %%% calculate divergence in the sector
    disp(['Calculating sector ',sector,' sea ice divergence'])
    div = nan(length(SIC.lon), length(seaice.dn));
    
    for ii = 1:length(seaice.dn)
        % first interpolate to new grid
        tu = griddata(double(ox), double(oy), double(SIC.u(:,ii)), double(tx), double(ty));
        tv = griddata(double(ox), double(oy), double(SIC.v(:,ii)), double(tx), double(ty));
        
        % now calculate divergence
        tdiv(:,:,ii) = cdtdivergence(tlat, tlon, tu, tv);
        tdiv2(:,:,ii) = divergence(tx, ty, tu, tv);
        t = tdiv(:,:,ii);
        t2 = tdiv2(:,:,ii);
        ttt(:,ii) = t(:);
        ttt2(:,ii) = t2(:);
        % now interpolate to sector grid
        div(:,ii) = griddata(double(tx(:)), double(ty(:)), double(ttt(:,ii)), double(ox), double(oy));
        div2(:,ii) = griddata(double(tx(:)), double(ty(:)), double(ttt2(:,ii)), double(ox), double(oy));
        clear tu tv t t2

    end
%     figure;
%     scatter(tx(:), ty(:), 10, ttt(:,900), 'filled');colorbar;
    figure;
    scatter(ox, oy, 10, div(:,900), 'filled');colorbar;
%     figure
%     scatter(tx(:), ty(:), 10, ttt(:,900), 'filled');colorbar;
%     
    %seaice.olddiv = seaice.divergence;
    seaice.divergence = div; 
    seaice.matdiv = div2;
    
    
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat'], 'seaice');
    
    
    
    
    clearvars
    
end

    
    
    
    
    
    
    

















%% test it a bit
% ** will need to reinterpolate SIM before this process can be performed

sector = '10';

load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);


%% now fild a good example day and plot the SIM vectors
% index 6000
%pos = find(SIC.u(:,6000)>0);
spd = sqrt((SIC.u(:,6000).^2) + (SIC.v(:,6000).^2));

[londom, latdom] = sectordomain(str2num(sector));
m_basemap('m', londom, latdom);plot_dim(1000,700);
%m_scatter(SIC.lon(pos), SIC.lat(pos), 15, 'm', 'filled');
%m_quiver(SIC.lon, SIC.lat, SIC.u(:,6000), SIC.v(:,6000));  
m_scatter(SIC.lon, SIC.lat, 30, spd, 's','filled');
colormap(mycolormap('mi2'));
cbh = colorbar;
title(['Sector ',sector,' Sea Ice Speed']);
caxis([0,5.2]);
cbh.Ticks = ([0:0.5:5]);

% ok cool
% now need to generate my new monotonic grid and verify

% make new grid
mi = min(SIC.lon)-0.2;
ma = max(SIC.lon)+0.2;
di = ma-mi;
la = max(SIC.lat);

dv = (-max(SIC.lat)+0.1)+(min(SIC.lat)-0.1);
% distance in km along bottom edge (min lat) of minlon:maxlon
horizdistance = di*cos(deg2rad(-la))*111;
vertdistance = dv*111;

% now decide how many gpoints there should be across this region
nph = horizdistance/3.125;
npv = vertdistance/3.125;

% now determine deg. step
dsh = di/nph;
dsv = dv/npv;

defx = (min(SIC.lon)-0.2):dsh:(max(SIC.lon)+0.2);
defy = (min(SIC.lat)-0.1):dsv:(max(SIC.lat)+0.1);

[tlon, tlat] = meshgrid(defx, defy); % NEW GRID
[tx, ty] = ll2ps(tlat, tlon); % NEW GRID IN XY

% visualize old vs new grid
m_basemap('a', londom, latdom); sectorexpand(str2num(sector));
dots = sectordotsize(str2num(sector));
s1 = m_scatter(SIC.lon, SIC.lat, dots-dots*0.2, [0.99,0.4,0.5], 'filled');
s2 = m_scatter(tlon(:), tlat(:), dots-dots*0.5, [0.6,0.8,0.6], 'filled');
xlabel(['Sector ',sector,' sector grid and monotonic SIM grid'])
legend([s1, s2], 'Sector grid', 'Monotonic grid')
    
%% interpolate to new grid, calculate divergence, and interpolate back

[ox, oy] = ll2ps(SIC.lat, SIC.lon); % convert sector grid to xy 

% interpolate --> griddata is linear by default
newu = griddata(double(ox), double(oy), double(SIC.u(:,6000)), double(tx), double(ty));
newv = griddata(double(ox), double(oy), double(SIC.v(:,6000)), double(tx), double(ty));

tspd = sqrt((newu.^2)+(newv.^2));

m_basemap('a', londom, latdom);
m_scatter(tlon(:), tlat(:), 20, tspd(:), 'filled');



%% now divergence

tdiv = cdtdivergence(tlat, tlon, newu, newv);
tdiv2 = divergence(tx, ty, newu, newv);

m_basemap('a', londom, latdom);
m_scatter(tlon(:), tlat(:), 20, tdiv(:), 'filled');
colorbar
caxis([-0.00002, 0.00002])
colormap(mycolormap('grp'));
xlabel('cdt Divergence')

m_basemap('a', londom, latdom);
m_scatter(tlon(:), tlat(:), 20, tdiv2(:), 'filled');
colorbar
caxis([-0.00002, 0.00002])
colormap(mycolormap('grp'));
xlabel('Matlab Divergence')
    
    
%vectors for comparison
[londom, latdom] = sectordomain(str2num(sector));
m_basemap('m', londom, latdom);plot_dim(1000,700);
%m_scatter(SIC.lon(pos), SIC.lat(pos), 15, 'm', 'filled');
m_quiver(tlon(:), tlat(:), newu(:), newv(:));  
%m_scatter(SIC.lon, SIC.lat, 30, spd, 's','filled');
title(['Sector ',sector,' Sea Ice Velocity']);

%% now interpolate back

fdiv = griddata(double(tx), double(ty), tdiv, double(ox), double(oy));


m_basemap('a', londom, latdom);
m_scatter(SIC.lon, SIC.lat, 20, fdiv, 'filled');
colorbar
caxis([-0.00002, 0.00002])
colormap(mycolormap('grp'));
xlabel('Final Divergence')






% OKAY SO it looks like this idea works just fine 
% I believe the output from the full loop (top of this script) was wrong so
% it may have an error somewhere within. 










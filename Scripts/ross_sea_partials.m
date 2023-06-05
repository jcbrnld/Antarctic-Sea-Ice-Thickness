% Jacob Arnold

% 27-Jan-2022

% Check out eastern ross ice shelf in raw gridded data


load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector14_shpSIG.mat;
gSIT = SIT; clear SIT

load ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector14_shpE00.mat;
e00SIT = SIT; clear SIT


load ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector14.mat;

[londom, latdom] = sectordomain(14);
dots = sectordotsize(14);

% B15 calved in march 2000

%% partials

indi = 599;
m_basemap('a', londom, latdom);
sectorexpand(14);
m_scatter(gSIT.lon, gSIT.lat, dots, gSIT.sb(:,indi));
%colormap(colormapinterp(mycolormap('mint'),254))
colormap(colormapinterp(mycolormap('mint'),8))
colorbar
xlabel(['sb ind:',num2str(indi)], 'fontweight', 'bold', 'fontsize', 15)

%% partials

indi = 127;
m_basemap('a', londom, latdom);
sectorexpand(14);
m_scatter(e00SIT.lon, e00SIT.lat, dots, e00SIT.ct(:,indi));
%colormap(colormapinterp(mycolormap('mint'),254))
colormap(colormapinterp(mycolormap('mint'),8))
colorbar
xlabel(['sb ind:',num2str(indi)], 'fontweight', 'bold', 'fontsize', 15)


%% SIT

m_basemap('a', londom, latdom)
sectorexpand(14);
m_scatter(SIT.lon, SIT.lat, dots, SIT.H(:,indi), 'filled');
colormap(colormapinterp(mycolormap('mint'),8))
colorbar
xlabel(['SIT ind:',num2str(indi)], 'fontweight', 'bold', 'fontsize', 15)



%% allways nan

nanh = find(sum(isnan(SIT.H),2)./length(SIT.dn)==1);
m_basemap('a', londom, latdom)
sectorexpand(14);
m_scatter(SIT.lon, SIT.lat, dots, [0.67,0.7,0.67],'filled');
m_scatter(SIT.lon(nanh), SIT.lat(nanh), dots, [0.9,0.5,0.4]);
xlabel('Always NaN')

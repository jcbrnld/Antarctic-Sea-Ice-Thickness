% Jacob Arnold
% Plot hemispheric mean SIT
% 16-Aug-2022



load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/so.mat;
load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat;

mh = mean(SIT.H, 2, 'omitnan');
mhs = mh(SIT.shelf);
mho = mh(SIT.offshore);


datzer1 = mhs>0;
datzer2 = mho>0;

mhs = mhs(datzer1);
mho = mho(datzer2);

slon = SIT.lon(SIT.shelf); slat = SIT.lat(SIT.shelf);
olon = SIT.lon(SIT.offshore); olat = SIT.lat(SIT.offshore);

slon = slon(datzer1); slat = slat(datzer1);
olon = olon(datzer2); olat = olat(datzer2);

%%
sector = 'so';
m_basemap('p', [0,360], [-90,-51]);
plot_dim(1000,800);
m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]); %more useful for polar plots
textloc = [-0.1, 0];


sdots = 1; odots = 14;
% shelf
m_scatter(slon, slat,  sdots, mhs, 's', 'filled')

% Offshore
m_scatter(olon, olat, odots, mho, 's', 'filled');

ind11 = find(mhs<=0.05 & mhs>0);
ind21 = find(mhs>0.05 & mhs<0.2);

ind12 = find(mho<=0.05 & mho>0);
ind22 = find(mho>0.05 & mho<0.2);

cmap = colormap(colormapinterp(mycolormap('id3'),11, [0.99    0.76    0.6469], [0,0,0])); % ASSIGN this color to 0
caxis([-0.2,2]);

 m_scatter(slon(ind21), slat(ind21), sdots, cmap(2,:), 's','filled'); % 
 m_scatter(slon(ind11), slat(ind11), sdots, cmap(1,:), 's','filled'); % 
 
 m_scatter(olon(ind22), olat(ind22), odots, cmap(2,:), 's','filled'); % 
 m_scatter(olon(ind12), olat(ind12), odots, cmap(1,:), 's','filled'); % 
 
 
cbh = colorbar;
cbh.Ticks = [-0.2:0.2:1.8];
cbh.FontSize = 13;
cbh.TickLength =.055;
%cbh.TickLength =0;
cbh.Position =  [0.867 0.2080 0.027 0.6150];

cbh.TickLabels = {'0','0.05','0.2','0.4','0.6','0.8','1','1.2','1.4','1.6', '1.8', '2'};



   print(['ICE/ICETHICKNESS/Figures/Zones/',sector,'/',sector,'_meanH.png'], '-dpng', '-r500');


    
%% Monthly means
% Plot 12 plots of mean monthly hemispheric SIT



load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/so.mat;
load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat;

month = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
for ii = 1:12
    mloc = find(SIT.dv(:,2)==ii);
    mh = mean(SIT.H(:,mloc), 2, 'omitnan');
    mhs = mh(SIT.shelf);
    mho = mh(SIT.offshore);


    datzer1 = mhs>0;
    datzer2 = mho>0;

    mhs = mhs(datzer1);
    mho = mho(datzer2);

    slon = SIT.lon(SIT.shelf); slat = SIT.lat(SIT.shelf);
    olon = SIT.lon(SIT.offshore); olat = SIT.lat(SIT.offshore);

    slon = slon(datzer1); slat = slat(datzer1);
    olon = olon(datzer2); olat = olat(datzer2);

    %
    sector = 'so';
    m_basemap('p', [0,360], [-90,-51]);
    plot_dim(500,400);
    %m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]); %more useful for polar plots
    textloc = [-0.1, 0];


    sdots = 0.5; odots = 7;
    % shelf
    m_scatter(slon, slat,  sdots, mhs, 's', 'filled')

    % Offshore
    m_scatter(olon, olat, odots, mho, 's', 'filled');

    ind11 = find(mhs<=0.05 & mhs>0);
    ind21 = find(mhs>0.05 & mhs<0.2);

    ind12 = find(mho<=0.05 & mho>0);
    ind22 = find(mho>0.05 & mho<0.2);

    cmap = colormap(colormapinterp(mycolormap('id3'),11, [0.99    0.76    0.6469], [0,0,0])); % ASSIGN this color to 0
    caxis([-0.2,2]);

     m_scatter(slon(ind21), slat(ind21), sdots, cmap(2,:), 's','filled'); % 
     m_scatter(slon(ind11), slat(ind11), sdots, cmap(1,:), 's','filled'); % 

     m_scatter(olon(ind22), olat(ind22), odots, cmap(2,:), 's','filled'); % 
     m_scatter(olon(ind12), olat(ind12), odots, cmap(1,:), 's','filled'); % 


    %cbh = colorbar;
    %cbh.Ticks = [-0.2:0.2:1.8];
    %cbh.FontSize = 13;
    %cbh.TickLength =.055;
    %cbh.TickLength =0;
    %cbh.Position =  [0.867 0.2080 0.027 0.6150];

    %cbh.TickLabels = {'0','0.05','0.2','0.4','0.6','0.8','1','1.2','1.4','1.6', '1.8', '2'};
    text(-0.079,0,month{ii}, 'fontsize', 22, 'fontweight', 'bold')


   print(['ICE/ICETHICKNESS/Figures/Zones/',sector,'/months/',sector,'_',month{ii},'_meanH.png'], '-dpng', '-r500');
    
   %print(['ICE/ICETHICKNESS/Figures/Zones/',sector,'/months/',sector,'_',month{ii},'_meanH.pdf'], '-dpdf', '-r500');
   close

end








    
    
    
    
    
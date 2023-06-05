% Jacob Arnold

% 28-Jan-2022

% View location of iceberg b15



% Data
data = readmatrix('ICE/ICETHICKNESS/Data/Icebergs_Database/consol/b16.csv');
% columns 2 and 5 are lat
% columns 3 and 6 are lon

lat = data(:,5);
lon = data(:,6);

lon(lon==0) = [];
lat(lat==0) = [];

%%



m_basemap('p', [0,360], [-90,-50])
m_plot(lon,lat, 'linewidth', 1.5);



%% read in and markup images - label icebergs
% 15-Apr-2000

A = imread('~/Downloads/rosse_2000106_1300_modis_ch32.png');

figure
imshow(A);

text(150,50,'MODIS: 15-April-2000', 'fontweight', 'bold', 'fontsize', 16)
text(550,550, 'B15', 'color', [1,1,1], 'fontsize', 18);
text(1500,800, 'B17', 'color', [1,1,1], 'fontsize', 18);
text(550,1000, 'Ross Ice Shelf', 'color', [1,1,1], 'fontsize', 18);
text(1400,1100, 'Roosevelt Island', 'color', [1,1,1], 'fontsize', 18, 'rotation', -60);


set(gcf, 'InvertHardCopy', 'off');
print('ICE/ICETHICKNESS/Figures/Icebergs/Images/b15_b17_1.png', '-dpng', '-r600');

%%
% 30-May-2000

A = imread('~/Downloads/rosse_2000151_1230_modis_ch32.png');

figure
imshow(A);

text(150,50,'MODIS: 07-June-2000', 'fontweight', 'bold', 'fontsize', 16)
text(350,370, 'B15-A', 'color', [1,1,1], 'fontsize', 18);
text(690,600, 'B15-B', 'color', [1,1,1], 'fontsize', 18);
text(1270,800, 'B17', 'color', [1,1,1], 'fontsize', 18);
text(550,1000, 'Ross Ice Shelf', 'color', [1,1,1], 'fontsize', 18);
text(1400,1100, 'Roosevelt Island', 'color', [1,1,1], 'fontsize', 18, 'rotation', -60);


set(gcf, 'InvertHardCopy', 'off');

%print('ICE/ICETHICKNESS/Figures/Icebergs/Images/b15_b17_2.png', '-dpng', '-r600');



%%
% 07-June-2000

A = imread('~/Downloads/rosse_2000159_1950_modis_ch32.png');

figure
imshow(A);

text(150,50,'MODIS: 07-June-2000', 'fontweight', 'bold', 'fontsize', 16)
text(150,200, 'B15-A', 'color', [1,1,1], 'fontsize', 18);
text(550,580, 'B15-B', 'color', [1,1,1], 'fontsize', 18);
text(1240,770, 'B17', 'color', [1,1,1], 'fontsize', 18);
text(550,1000, 'Ross Ice Shelf', 'color', [1,1,1], 'fontsize', 18);
text(1400,1100, 'Roosevelt Island', 'color', [1,1,1], 'fontsize', 18, 'rotation', -60);


set(gcf, 'InvertHardCopy', 'off');

print('ICE/ICETHICKNESS/Figures/Icebergs/Images/b15_b17_3.png', '-dpng', '-r600');














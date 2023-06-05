
% Jacob Arnold
% 
% 20-July-2021
% 
% Test converting from lat/lon grids to polar stereographic xy 
% Use ll2ps with 'TrueLat',-60
% ALSO create improved plots of all sector grids.



% load data

for ii = 1:18
    if ii<10
        sector = load(['ICE/Concentration/ant-sectors/sector0',num2str(ii),'.mat']);
    else
        sector = load(['ICE/Concentration/ant-sectors/sector',num2str(ii),'.mat']);
    end
    sector_C = struct2cell(sector);
    lon{ii} = sector_C{1,1}.lon;
    lat{ii} = sector_C{1,1}.lat;
    clear sector_C sector
end

clear ii



%% make diagram in lat/lon

colors = ["[0.46,.55,0.55]";"[0.66,.85,0.05]";"[0.66,.55,0.05]";"[0.86,.35,0.25]";...
    "[0.96,.15,0.05]";"[0.96,.55,0.05]";"[0.9,.15,0.65]";"[0.96,.75,0.75]";"[0.96,.95,0.8]";...
    "[0.96,.05,1]";"[0.66,.25,0.55]";"[0.66,.45,0.95]";"[0.66,.65,0.95]";"[0.76,.85,0.75]";...
    "[0.46,.85,0.95]";"[0.26,.65,0.95]";"[0.26,.25,0.95]";"[0.26,.25,0.55]"];

%m_basemap('p', [0 360 60], [-90 -42 10],'sdL_v10',[4000],[ 8]);
m_basemap('p', [0 360 60], [-90 -53 10],'sdL_v10',[4000],[ 8]);
set(gcf,'Position',[500,600,1000,900]);
m_elev([1000:1000:6000],'color',[0.6,0.6,0.6]);
for ii = 1:18
    m_scatter(lon{ii},lat{ii}, 3,eval(colors(ii)));
end
%print('ICE/Sectors/Shelf/All_shelf.png','-dpng', '-r800')




%% make diagram in ps xy

colors = ["[0.46,.55,0.55]";"[0.66,.85,0.05]";"[0.66,.55,0.05]";"[0.86,.35,0.25]";...
    "[0.96,.15,0.05]";"[0.96,.55,0.05]";"[0.9,.15,0.65]";"[0.96,.75,0.75]";"[0.96,.95,0.8]";...
    "[0.96,.05,1]";"[0.66,.25,0.55]";"[0.66,.45,0.95]";"[0.66,.65,0.95]";"[0.76,.85,0.75]";...
    "[0.46,.85,0.95]";"[0.26,.65,0.95]";"[0.26,.25,0.95]";"[0.26,.25,0.55]"];

figure;
set(gcf,'position',[500,600,1000,900]);

for ii = 1:18;
   [x{ii},y{ii}] = ll2ps(lat{ii},lon{ii}-180, 'TrueLat',-60);
   
   scatter(x{ii},y{ii},3,eval(colors(ii))); % ***** THIS IS THE conversion needed for prjecting onto grid in first portion of SITworkingscript_final
   hold on
   %xlim([-4000000,4000000]);
   %ylim([-4000000,4000000]); 
   
end

Sfile_1 = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/ANTARC200813');
Sfile_2 = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/ANTARC120611');
Sfile_3 = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/ANTARC170803');

Sfile{1} = Sfile_1; Sfile{2} = Sfile_2; Sfile{3} = Sfile_3; clear Sfile_1 Sfile_2 Sfile_3;
for jj = 1:3;
    for ii = 1:length(Sfile{jj}.ncst)
    xvals{ii,jj} = Sfile{jj}.ncst{ii}(:,1);
    yvals{ii,jj} =Sfile{jj}.ncst{ii}(:,2);
    end
end
clear ii jj

% compare against shapefiles
color=['m','g','b'];
for jj = 1:3
    for ii = 1:length(xvals(:,jj))
        plot(xvals{ii,jj},yvals{ii,jj}, color(jj));
        hold on
        
    end
end

%print('ICE/Sectors/Shelf/xy_space/All_shelf_example_polygons.png','-dpng', '-r800')
















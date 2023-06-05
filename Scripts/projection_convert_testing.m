% Jacob Arnold
% 
% 28-July-2021
% 
% Figure out how to convert between shapefile polygon projection and lat/lon





%______________________________________________v
% testing projection

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



% HERE USE THE INVERSE OF THIS TO TRANSLATE THE GRID 
m_basemap('p',[0,360],[-85,-45]);
for jj = 1:3
    if jj==1
        color = 'm';
    elseif jj==2
        color = 'g';
    elseif jj==3
        color = 'b';
    end
    for ii = 1:length(xvals(:,jj))
    %[latT,lonT] =
    %ps2ll(xvals{ii,jj},yvals{ii,jj},'EarthRadius',6117830);%THIS works BUT below is correct
    [latT,lonT] = ps2ll(xvals{ii,jj},yvals{ii,jj},'TrueLat',-60); % HERE 
    m_plot(lonT+180,latT,color)
    hold on
    end
end
clear ii jj




























%% old/testing
for jj = 1:3
    for ii = 1:length(xvals(:,jj))
        [londummy,latdummy]=cart2pol(xvals{ii,jj},yvals{ii,jj}); % theta and rho
        latdumdiv = ((latdummy./1000)./105);
        lat{ii,jj}=single(((90-latdumdiv).*-1));
        lon{ii,jj}=single((londummy.*-180/pi)+270);
    end
end
clear ii jj


m_basemap('p',[0,360],[-85,-45]);
for jj = 1:3
    if jj==1
        color = 'm';
    elseif jj==2
        color = 'g';
    elseif jj==3
        color = 'b';
    end
    for ii = 1:length(lat(:,jj))
        m_plot(lon{ii,jj},lat{ii,jj},color);
        hold on
    end
end 
clear ii jj

%print('ICE/ICETHICKNESS/Data/Projections/Figures/Old_method4.png','-dpng','-r400');

%% try m_xy2ll


m_proj('Stereographic'); 
for jj = 1:3
    for ii = 1:1:length(xvals(:,jj))
        [long{ii,jj},lat{ii,jj}] = m_xy2ll(xvals{ii,jj}, yvals{ii,jj});
    end
end

m_basemap('p',[0,360],[-85,-45]);
for jj = 1:3
    if jj==1
        color = 'm';
    elseif jj==2
        color = 'g';
    elseif jj==3
        color = 'b';
    end
    for ii = 1:length(xvals(:,jj))
    m_plot(long{ii,jj},lat{ii,jj},color)
    hold on
    end
end


%%

% test polarstereo_fwd
%[x,y] = polarstereo_fwd(latg,long-180, 6378273, 0.081816153, -70);
%[x,y] = ll2ps(latg,long-180); no luck with either

figure
for ii = 1:length(test_sfile.ncst)
    plot(test_sfile.ncst{ii}(:,1),test_sfile.ncst{ii}(:,2));
    hold on
end
scatter(x,y,'filled');


% HERE USE THE INVERSE OF THIS TO TRANSLATE THE GRID 
m_basemap('p',[0,360],[-85,-45]);
for jj = 1:3
    if jj==1
        color = 'm';
    elseif jj==2
        color = 'g';
    elseif jj==3
        color = 'b';
    end
    for ii = 1:length(xvals(:,jj))
    %[latT,lonT] =
    %ps2ll(xvals{ii,jj},yvals{ii,jj},'EarthRadius',6117830);%THIS works BUT below is correct
    [latT,lonT] = ps2ll(xvals{ii,jj},yvals{ii,jj},'TrueLat',-60); % HERE 
    m_plot(lonT+180,latT,color)
    hold on
    end
end
clear ii jj






%m_basemap('s',0,-90);
m_basemap('p',[0,360],[-90,-45]);
for jj = 1:3
    for ii = 1:1:length(xvals(:,jj))
        [long{ii,jj},lat{ii,jj}] = m_xy2ll(xvals{ii,jj}, yvals{ii,jj});
    end
end


for jj = 1:3
    if jj==1
        color = 'm';
    elseif jj==2
        color = 'g';
    elseif jj==3
        color = 'b';
    end
    for ii = 1:length(long(:,jj))

    m_plot(long{ii,jj},lat{ii,jj},color)
    hold on
    end
end
clear ii jj




%print('ICE/ICETHICKNESS/Data/Projections/Figures/global.eps','-depsc2');







%______________________________________________^

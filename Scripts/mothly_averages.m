% Jacob Arnold

% 18-Nov-2021
% Create monthly averages of SIT data


load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat

%%

% Get monthly indices 
for ii = 1:12
    
    minds{ii} = find(SO_SIT.dv(:,2)==ii);
    
    mmeans(:,ii) = nanmean(SO_SIT.H(:,minds{ii}),2);
    
end



%% View

months = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};

for ii = 1:12
    
    m_basemap('p',[0,360], [-90,-45]);
    set(gcf, 'position', [200,200,1200,900]);
    m_scatter(SO_SIT.lon(SO_SIT.shelf_ind), SO_SIT.lat(SO_SIT.shelf_ind), 1, mmeans(SO_SIT.shelf_ind,ii), 'filled') %shelf
    m_scatter(SO_SIT.lon(SO_SIT.offshore_ind), SO_SIT.lat(SO_SIT.offshore_ind), 10, mmeans(SO_SIT.offshore_ind,ii), 'filled') %offshore

    cmocean('ice', 10);
    caxis([0,2])
    cbh = colorbar;
    cbh.Ticks = [0:0.2:2];
    cbh.Label.String = ('Sea Ice Thickness [cm]');
    cbh.FontSize = 14;
    cbh.Label.FontSize = 16;
    
    text(-0.08, 0, [months{ii}], 'fontweight', 'bold', 'fontsize', 14);
    
    print(['ICE/ICETHICKNESS/Figures/Southern_Ocean/Monthly_Av/',months{ii},'.png'], '-dpng', '-r600');

end




%% view with contourf 

months = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};

for ii = 1:12
    shelfData = nan(size(SO_SIT.slon));
    shelfData(SO_SIT.grid_indices.shelf) = mmeans(SO_SIT.shelf_ind,ii);
    offshoreData = nan(size(SO_SIT.olon));
    offshoreData(SO_SIT.grid_indices.offshore) = mmeans(SO_SIT.offshore_ind,ii);
    m_basemap('p',[0,360], [-90,-48]);
    set(gcf, 'position', [200,200,1200,900]);
    
    m_scatter(SO_SIT.lon(SO_SIT.shelf_ind), SO_SIT.lat(SO_SIT.shelf_ind), 10, mmeans(SO_SIT.shelf_ind,ii), 'filled') %shelf
   % Include the scatter in the background to fill white space between
   % contours
    m_contourf(SO_SIT.slon, SO_SIT.slat, shelfData, [0:0.2:1.8]);
    m_contourf(SO_SIT.olon, SO_SIT.olat, offshoreData, [0:0.2:1.8]);

    cmocean('ice', 10);
    caxis([0,2])
    cbh = colorbar;
    cbh.Ticks = [0:0.2:2];
    cbh.Label.String = ('Sea Ice Thickness [cm]');
    cbh.FontSize = 14;
    cbh.Label.FontSize = 16;
    
    text(-0.08, 0, [months{ii}], 'fontweight', 'bold', 'fontsize', 14);
    
    print(['ICE/ICETHICKNESS/Figures/Southern_Ocean/Monthly_Av/',months{ii},'_contour_gapscat.png'], '-dpng', '-r600');

end


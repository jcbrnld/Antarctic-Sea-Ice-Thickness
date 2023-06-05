% Jacob Arnold

% 08_Dec_2021

% Investigate nan change. 
% Bremen 3.125 km SIC data are only available from 2002 onward. Before this
% time, we interpolate SIC from ____ on 25km grid to the Bremen 3.125 km grid. 
% As a result there are more nan values around the edges than with the
% Bremen data. 




for ii = 1:18
    if ii<10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    disp(['Working on Sector ',sector, ' now...'])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    
    xtickmakerdv = [unique(SIT.dv(:,1)),ones(length(unique(SIT.dv(:,1))),1), ones(length(unique(SIT.dv(:,1))),1)];
    xtickmaker = datenum(xtickmakerdv);

%     figure
%     plot_dim(1200,350);
%     plot(SIT.dn, (sum(isnan(SIT.H))/length(SIT.H(:,1))).*100, 'linewidth', 1.5, 'color', [0.4,0.7,0.55]);
%     xticks(xtickmaker)
%     datetick('x', 'mm-yyyy', 'keepticks')
%     xtickangle(22);
%     xlim([SIT.dn(1)-50, SIT.dn(end)+50]);
%     ylim([0,50])
%     grid on
%     title(['Sector ', sector,' % NAN values in SIT data'],  'fontsize', 14)
%     ylabel('% Of Grid Cells with NAN',  'fontsize', 14)
%     print(['ICE/ICETHICKNESS/Figures/Diagnostic/investigating_nans/sector_',sector,'/SIT_percent_nans.png'],'-dpng','-r500');
%     
    
    % now from SIC
    data1 = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    data2 = struct2cell(data1);
    SIC = data2{1,1}; clear data1 data2
    
    tind = [5188:1:length(SIC.dn)];
    
    figure;
    plot_dim(1200,350);
    plot(SIC.dn(tind), (sum(isnan(SIC.sic(:,tind)))./length(SIC.lon)).*100, 'linewidth', 1.5, 'color', [0.7,0.6,0.5])
    hold on
    plot(SIT.dn, (sum(isnan(SIT.H))/length(SIT.H(:,1))).*100, 'linewidth', 1.5, 'color', [0.4,0.7,0.55]);
    xticks(xtickmaker)
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(22);
    xlim([SIC.dn(tind(1))-50, SIC.dn(end)+50]);
    ylim([0,50])
    grid on
    title(['Sector ', sector,' % NAN values'], 'fontsize', 14)
    ylabel('% Of Grid Cells with NAN', 'fontsize', 14)
    legend('% NAN from SIC', '% NAN from SIT')
    print(['ICE/ICETHICKNESS/Figures/Diagnostic/investigating_nans/sector_',sector,'/SICnSIT_percent_nans.png'],'-dpng','-r500');
    

%     oldnans = find(sum(isnan(SIT.H(:,1:219)),2)./219 > 0.99);
%     newnans = find(sum(isnan(SIT.H(:,272:end)),2)./945 > 0.99);
%     
%     [londom, latdom] = sectordomain(ii);
%     m_basemap('a', londom, latdom)
%     plot_dim(1000,800);
%     l1 = m_scatter(SIT.lon, SIT.lat, 10,[0.7,0.7,0.7], 'filled');
%     l2 = m_scatter(SIT.lon(oldnans), SIT.lat(oldnans), 20,[0.7,0.9,0.5], 'filled');
%     legend([l1,l2],'Sector Grid', 'NAN 1997-2001');
%     xlabel(['Sector ',sector,' Interpolated SIC']);
%     print(['ICE/ICETHICKNESS/Figures/Diagnostic/investigating_nans/sector_',sector,'/nan_b4_2002.png'],'-dpng','-r500');
%     close
%     
%     m_basemap('a', londom, latdom)
%     plot_dim(1000,800);
%     l1 = m_scatter(SIT.lon, SIT.lat, 10,[0.7,0.7,0.7], 'filled');
%     l2 = m_scatter(SIT.lon(newnans), SIT.lat(newnans), 20,[0.7,0.9,0.5], 'filled');
%     legend([l1,l2], 'Sector Grid', 'NAN 2003-2021');
%     xlabel(['Sector ',sector,' Bremen SIC']);
%     print(['ICE/ICETHICKNESS/Figures/Diagnostic/investigating_nans/sector_',sector,'/nan_after_2002.png'],'-dpng','-r500');
%     close
%     
    clear SIT oldnans newnans l1 l2 londom latdom

end




%% Look at SIC data 



load ICE/Concentration/ant-sectors/sector10.mat;

tind = [5188:1:length(sector10.dn)];
figure;
plot(sector10.dn(tind), (sum(isnan(sector10.sic(:,tind)))./length(sector10.lon)).*100);





















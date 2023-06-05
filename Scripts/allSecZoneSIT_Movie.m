% Jacob Arnold

% 10-Feb-2022

% Movie of entire southern ocean SIT


load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector00.mat;
shelf = SIT; clear SIT

load ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/offshore.mat;
offshore = SIT; clear SIT

load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/so.mat;
SIV = seaice.SIV;
%%

dticker = unique(shelf.dv(:,1));
dticker(end+1) = 2022;
dticker(:,2:3) = 1;
dticker = datenum(dticker);

cntr = [1:50:2000];

 ii = 510; % to test single frame

%[lpos, xpos, s2pos, tickl, multfac]
% try contouring beyond color range
contvec = [2.4,2.7,3];
osize = 9;
ssize = 0.5;
 %%%
for ii = 1:length(shelf.H(1,:));
    if ismember(ii,cntr)
        disp(['Finished through... ' datestr(shelf.dn(ii))])
    end

    figure;
    s1 = subplot(4,1,1:3); 
    set(s1, 'Position', [0.1,0.3,0.81,0.6])
    
    plot_dim(1000,1100);

    %zeroind = find(SIT.H(:,ii)==0);
    othinind = find(offshore.H(:,ii)<=0.05 & offshore.H(:,ii)>0);
    sthinind = find(shelf.H(:,ii)<=0.05 & shelf.H(:,ii)>0);
    
    ocat2 = find(offshore.H(:,ii)>0.05 & offshore.H(:,ii)<0.3);
    shcat2 = find(shelf.H(:,ii)>0.05 & shelf.H(:,ii)<0.3);
    
    % Use these to only plot where SIT is not zero
    shelfzer = shelf.H(:,ii)>0;
    offshorezer = offshore.H(:,ii)>0;
    
    m_basemap_subplot('p', [0,360], [-90,-51]);
    %m_basemap_subplot('p', [0,360], [-90,-53], 'sdL_v10', [2000,4000], [8,8]); % 2000 and 4000 m isobaths
    m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]); %more useful for polar plots
    scat1 = m_scatter(offshore.lon(offshorezer), offshore.lat(offshorezer), osize, offshore.H(offshorezer,ii), 'filled'); % offshore
    scat2 = m_scatter(shelf.lon(shelfzer), shelf.lat(shelfzer), ssize, shelf.H(shelfzer,ii), 'filled'); % shelf

    cmap = colormap(colormapinterp(mycolormap('id3'),10, [0,0,0], [0.99    0.76    0.6469])); % ASSIGN this color to 0
    % Scatter plot specifc categories
    m_scatter(offshore.lon(othinind), offshore.lat(othinind), osize, cmap(1,:),'s', 'filled'); % 
    m_scatter(offshore.lon(ocat2), offshore.lat(ocat2), osize, cmap(2,:), 's','filled'); % 
    m_scatter(shelf.lon(sthinind), shelf.lat(sthinind), ssize, cmap(1,:), 's','filled'); % 
    m_scatter(shelf.lon(shcat2), shelf.lat(shcat2), ssize, cmap(2,:), 's','filled'); % 
    
    % uncomment to CONTOUR higher levels
    %m_contour(lon2d, lat2d, newH, contvec, 'color', [0.5,0.5,0.5], 'ShowText', 'on');
    cbh = colorbar;
    cbh.Ticks = [-0.3:0.3:2.4];
    cbh.Label.String = ('Sea Ice Thickness [m]');
    cbh.FontSize = 15;
    cbh.Label.FontSize = 19;
    cbh.Label.FontWeight = 'bold';
    caxis([-0.3,2.7]);
    %cbh.TickDirection = 'out'
    cbh.TickLength = 0.05;
    cbh.TickLabels = {'0','0.05','0.3','0.6','0.9','1.2','1.5','1.8','2.1','2.4'};
    cbh.Position = [0.82 0.3 0.027 0.6];

    text(-0.12,0,datestr(shelf.dn(ii)), 'fontsize', 17, 'fontweight', 'bold');

    s2 = subplot(4,1,4);
    linevar = SIV;
    set(s2, 'Position', [0.23, 0.17, 0.63, 0.1]);

    plot(shelf.dn, linevar, 'linewidth', 1.5,'color', [0.2,0.7,0.6])
    xline(shelf.dn(ii), 'linewidth', 1.2, 'color', [0.99, 0.2, 0.3]);
    xticks(dticker);
    datetick('x', 'mm-yyyy', 'keepticks')
    xlim([min(shelf.dn)-50, max(shelf.dn)+50]);
    xtickangle(33)
    %ylim([0, max(linevar) + 10])
    ylabel('Sea Ice Volume [km^3]', 'fontweight', 'bold')
    grid on
%

    F(ii) = getframe(gcf);

    clear nanlocs s1 s2 
    close gcf

end
%
writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Southern_Ocean/AllSO_SIT_SIV_id3.mp4'], 'MPEG-4');

writerobj.FrameRate = 5;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp(['Success!  Video saved'])











% Jacob Arnold

% 01-dec-2021

% Create movie of SIT with only one contour -> so really a movie of ice
% extent. 
% Include acc fronts

load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat
load ICE/Concentration/so-zones/fronts_0_360_lons.mat

% add a nan to separate the second island
Nsaccf = [saccf(1:478,:);nan nan; saccf(479:end,:)];
%%

m_basemap('p', [0,360], [-90,-49]);
plot_dim(1000,800)
m_contourf(SO_SIT.olon, SO_SIT.olat, SO_SIT.OcontH(:,:,400),1)
cmocean('ice')

acc1 = m_plot(pf(2:end-1,1), pf(2:end-1,2), 'color', [0.9,0.5,0.6], 'linewidth',1.5);
acc2 = m_plot(Nsaccf(2:end-1,1), Nsaccf(2:end-1,2), 'color', [0.1,0.9,0.7], 'linewidth', 1.5);
acc3 = m_plot(sbdy(2:end-1,1), sbdy(2:end-1,2), 'color', [0.6,0.7,0.99], 'linewidth', 1.5);

legend([acc1,acc2,acc3], 'ACC Polar Front', 'Southern ACC Front', 'ACC Southern Boundary',...
    'position', [0.5055,0.57,0.12,0.08], 'fontsize', 12)
%%
m_basemap('p', [0,360], [-90,-49])
%m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
plot_dim(1000,800);
m_contourf(SO_SIT.olon, SO_SIT.olat, SO_SIT.OcontH(:,:,420),[0,0.01,0.05,0.1,0.15,0.2])
cmocean('ice')
cbh = colorbar;
%caxis([0,0.55]);
cbh.Ticks = [0,.1,.2,.3,.4,.5];
cbh.FontSize = 12;
cbh.Label.String = ('Sea Ice Thickness [m]');
cbh.Label.FontSize = 16;
acc1 = m_plot(pf(2:end-1,1), pf(2:end-1,2), 'color', [0.9,0.5,0.6], 'linewidth',1.5);
acc2 = m_plot(Nsaccf(2:end-1,1), Nsaccf(2:end-1,2), 'color', [0.1,0.9,0.7], 'linewidth', 1.5);
acc3 = m_plot(sbdy(2:end-1,1), sbdy(2:end-1,2), 'color', [0.6,0.7,0.99], 'linewidth', 1.5);
legend([acc1,acc2,acc3], 'ACC Polar Front', 'Southern ACC Front', 'ACC Southern Boundary',...
    'position', [0.5055,0.56,0.12,0.08], 'fontsize', 12);
text(-0.07,0,datestr(datetime(SO_SIT.dv(420,:), 'Format', 'dd MMM yyyy')), 'fontsize', 12, 'fontweight', 'bold')

%% try with m_propmap

m_propmap(1,'p',[0,360],[-90,-49],'c',SO_SIT.olon, SO_SIT.olat, SO_SIT.OcontH(:,:,420),...
    25,'ver','m','linear',[0,0.01,0.1,0.2,0.3,0.4,0.5]);

% Not so good

%% The movie


sector = 'Southern Ocean';


visquest = questdlg('See plots momentarily as they are created?');
if visquest(1)=='C'
    error('Cancel selected at visibility question')
end

% Make the movie: Notice where it saves

cntr = [1:50:20000];
mnths = {'jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'};

for ii = 1:length(SO_SIT.OcontH(1,:,:));
    if ismember(ii,cntr)
        disp(['Finished through...     ', num2str(SO_SIT.dv(ii,3)), '-', mnths{SO_SIT.dv(ii,2)}, '-', num2str(SO_SIT.dv(ii,1))])
    end
    if visquest(1)=='Y'
        m_basemap('p', [0,360], [-90,-49])
    else
        m_basemap2('p', [0,360], [-90,-49]) 
    end


    %m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]); %
    %this interrupts m_contourf
    plot_dim(1000,800);
    m_contourf(SO_SIT.olon, SO_SIT.olat, SO_SIT.OcontH(:,:,ii),[0,0.01,0.04,0.06,0.08,0.1])
    cmocean('ice')
    cbh = colorbar;
    cbh.Ticks = [0,.04,.06,.08,.1];
    cbh.FontSize = 12;
    cbh.Label.String = ('Sea Ice Thickness [m]');
    cbh.Label.FontSize = 16;

    acc1 = m_plot(pf(2:end-1,1), pf(2:end-1,2), 'color', [0.9,0.5,0.6], 'linewidth',1.5);
    %acc2 = m_plot(Nsaccf(2:end-1,1), Nsaccf(2:end-1,2), 'color', [0.1,0.9,0.7], 'linewidth', 1.5);
    %acc3 = m_plot(sbdy(2:end-1,1), sbdy(2:end-1,2), 'color', [0.6,0.7,0.99], 'linewidth', 1.5);

    %legend([acc1,acc2,acc3], 'ACC Polar Front', 'Southern ACC Front', 'ACC Southern Boundary',...
        %'position', [0.5055,0.56,0.12,0.08], 'fontsize', 12);

    
    
    if isnan(SO_SIT.dv(ii))==0
        %xlabel(datestr(datetime(SO_SIT.dv(ii,:), 'Format', 'dd MMM yyyy')))
        text(-0.07,0,datestr(datetime(SO_SIT.dv(ii,:), 'Format', 'dd MMM yyyy')),...
            'fontsize', 12, 'fontweight', 'bold')
    else
        xlabel('-- --- ----')
    end

    F(ii) = getframe(gcf);
    close gcf
end

writerobj = VideoWriter(['ICE/ICETHICKNESS/Figures/Videos/Sectors/Full_length/',sector,' SIT_Thinice4_pf.mp4'], 'MPEG-4');

writerobj.FrameRate = 5;
open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp(['Success! Sector ',sector,' Video saved'])
clear F 

%% NOW run with only the one boundary (ice/no ice) and save the polygon of that boundary separately 
% then overplot all and see how they compare with acc fronts. 







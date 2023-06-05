% Jacob Arnold

% 11-Jan-2022

% Try making a colormap


figure
plot_dim(840,800)
for ii = 1:256
    reverse = 1:256;
    reverse = flip(reverse);
    jj = reverse(ii);
    c1 = ((jj/256)+.6)/2;
    c2 = ((ii/256)+.5)/2;
    c3 = ((ii/256)+.7)/2;
    red = c1; green = c3; blue = c2;
    
    %disp(['ii = ',num2str(ii),' R = ', num2str(red), '; G = ', num2str(green), '; B = ',num2str(blue)])
    cmix = [red, green, blue];
    subplot(16,16,ii)
    scatter(1,1,5500, 'filled', 's','markerfacecolor',cmix);xlim([0,2]);ylim([0,2]);
    set(gca, 'xticklabel',[])
    set(gca, 'yticklabel',[])
    
    col1(ii,1) = c1;
    col2(ii,1) = c2;
    col3(ii,1) = c3;
end
newmap = [col1,col2,col3];

% This works BUT its just muddy in the middle
% Should try defining the first half and second half separately

%%

figure
plot_dim(840,800)
for ii = 1:256
    
    if ii<=128
    
        rstart = 0.7;
        rend = 0.9;
        rinc = (rend-rstart)/128;

        gstart = 0.1;
        gend = 0.7;
        ginc = (gend-gstart)/128;

        bstart = 0.7;
        bend = 0.9;
        binc = (bend-bstart)/128;
        
        c1 = rstart+rinc*ii;
        c2 = gstart+ginc*ii;
        %c2 = .1;
        %c3 = bstart+binc*ii;
        c3 = .1;
        red = c1; green = c2; blue = c3;
        
        %disp(['ii = ',num2str(ii),' R = ', num2str(red), '; G = ', num2str(green), '; B = ',num2str(blue)])
        cmix = [red, green, blue];
        subplot(16,16,ii)
        scatter(1,1,4500, 'filled', 's','markerfacecolor',cmix);xlim([0,2]);ylim([0,2]);
        set(gca, 'xticklabel',[])
        set(gca, 'yticklabel',[])
        
    elseif ii > 128
        adjii = ii-128;
        
        rstart = 0.9;
        rend = 0.3;
        rinc = (rstart-rend)/128;

        gstart = 0.6;
        gend = 0.7;
        ginc = (gend-gstart)/128;

        bstart = 0.2;
        bend = 0.99;
        binc = (bend-bstart)/128.1;
        
        %c1 = rstart-rinc*ii;
        c1 = 0.01;
        c2 = gstart+ginc*ii;
        %c2 = 0.3;
        c3 = bstart+binc*adjii;
        %c3 = .1;
        red = c1; green = c2; blue = c3;
        
        %disp(['ii = ',num2str(ii),' R = ', num2str(red), '; G = ', num2str(green), '; B = ',num2str(blue)])
        cmix = [red, green, blue];
        subplot(16,16,ii)
        scatter(1,1,4500, 'filled', 's','markerfacecolor',cmix);xlim([0,2]);ylim([0,2]);
        set(gca, 'xticklabel',[])
        set(gca, 'yticklabel',[])

        
        
        
    end
    
    col1(ii,1) = c1;
    col2(ii,1) = c2;
    col3(ii,1) = c3;
    
    
end
newmap = [flip(col1),flip(col2),flip(col3)];

%%


[londom, latdom] = sectordomain(10);
m_basemap('a', londom, latdom)
sectorexpand(10);
sdots = sectordotsize(10);
m_scatter(SIT.lon, SIT.lat, sdots, SIT.H(:,500), 'filled')
colormap(newmap);
colorbar



%% Try something else

% Find 4 colors that work well together 

%% mint
c1 = [0.03,0.2,0.4];
c2 = [0.2,0.8,0.99];
c3 = [0.55,0.95,0.65];
c4 = [0.95,0.999,0.95];
mint = [c1;c2;c3;c4];



%%
c1 = [0.3,0.1,0.3];
c2 = [0.5,0.9,0.999];
c3 = [0.999,0.97,0.92];
c4 = [0.999,0.75,0.65]; 

tangerine = [c1;c2;c3;c4];

%%

colo = tangerine;
figure
plot_dim(1000,180)
for ii = 1:4
    subplot(1,4,ii);
    scatter(1,1,40000,'s','filled', 'markerfacecolor',colo(ii,:))
    set(gca, 'xticklabel',[])
    set(gca, 'yticklabel',[])
    
end

% make 4 into 256
newmap2 = nan(256,3);
newmap2(:,1) = interp1([1,85,170,256],colo(:,1), 1:256);
newmap2(:,2) = interp1([1,85,170,256],colo(:,2), 1:256);
newmap2(:,3) = interp1([1,85,170,256],colo(:,3), 1:256);

% make 3 into 256
% newmap2 = nan(256,3);
% newmap2(:,1) = interp1([1,128,256],colo(:,1), 1:256);
% newmap2(:,2) = interp1([1,128,256],colo(:,2), 1:256);
% newmap2(:,3) = interp1([1,128,256],colo(:,3), 1:256);


%%

[londom, latdom] = sectordomain(10);
m_basemap('a', londom, latdom)
sectorexpand(10);
sdots = sectordotsize(10);
m_scatter(SIT.lon, SIT.lat, sdots, SIT.H(:,500), 'filled')
colormap(colormapinterp(newmap2, 8));
%colormap(newmap2)
caxis([0,2.4])
cbh = colorbar;
cbh.Ticks = [0:0.3:2.4];






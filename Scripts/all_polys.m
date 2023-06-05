% Jacob Arnold

% 02/07/2022

% Sector polyplay

% Grab all the poly info, this might take a few minutes (it took 6 minutes)
tic
for ss = 1:18
    if ss<10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    disp(['Starting sector ',sector]);
    
    load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    plons{ss} = SIC.poly.lon;
    plats{ss} = SIC.poly.lat;
    
    clear SIC
end
disp(['Time taken to load all SICs and grab sector poly info:'])
toc

%%

m_basemap('p', [0,360], [-90,-50]);
plot_dim(1200,1000);
for ss = 1:18
    m_plot(plons{ss}, plats{ss}, 'linestyle', ':', 'color',[0.9,0.3,0.5], 'linewidth', 1.1);
end


figure
plot_dim(1000,850);
for ss = 1:18
    if ss<10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end

    [px{ss},py{ss}] = ll2ps(plats{ss}, plons{ss});
    
    plot(px{ss}, py{ss}, 'linestyle', ':', 'color',[0.9,0.2,0.4], 'linewidth', 1);
    hold on
    
end
box off
set(gca,'Visible','off')
set(gcf, 'color', 'none'); set(gca, 'color', 'none'); 
export_fig('~/Desktop/sectorlimoverlay.png', '-png', '-transparent','-r700');

%print('~/Desktop/sectorlimoverlay.eps', '-deps', '-r700');





%% Try with imread


A = imread('~/Documents/Maps/IBCSO_v1_Antarctic_digital_chart_pdfA.png');

figure
imshow(A);

hold on
for ss = 1:18
    if ss<10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end

    [px{ss},py{ss}] = ll2ps(plats{ss}, plons{ss});
    
    plot(px{ss}./500+5000, py{ss}./500+5000, 'linestyle', ':', 'color',[0.9,0.2,0.4], 'linewidth', 1.8);
    hold on
    
end

% Getting it closer but this is not the best approach




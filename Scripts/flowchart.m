



% test making a flow chart

scat = [20,90; ...
        20,68];
    
rect1 = [15,87,10,7];
rect2 = [15,68,10,7];
    
quiv = [20,85,0,-7; ...
        20,66,0,-7];

figure
plot_dim(1000,1000)
rectangle('position',rect1, 'facecolor', [0.87,0.95,0.9],...
    'curvature', [0.1,0.1], 'edgecolor', [0.7,0.7,0.7])
hold on

rectangle('position',rect2, 'facecolor', [0.87,0.95,0.9],...
    'curvature', [0.1,0.1], 'edgecolor', [0.7,0.7,0.7])
quiver(quiv(:,1),quiv(:,2),quiv(:,3),quiv(:,4), 'maxheadsize',100,...
    'linewidth',6, 'autoscale', 'off', 'color', [0.2,0.2,0.5])
text(16.2,90.2,{'This is the', 'First Box'}, 'fontsize',14, 'fontname','times')

xlim([0,100]);
ylim([0,100]);
set(gca,'xtick',[])
set(gca,'ytick',[])



%set(gca,'Visible','off') % Removes the entire axis.

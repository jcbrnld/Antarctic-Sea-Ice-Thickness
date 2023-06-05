% Figure out how to use scatteredinterpolant


load ('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/Old_experimental/sector10SIT.mat');

daytofill = double(SIT.H(:,find(SIT.dv(:,1)==2015 & SIT.dv(:,2)==7 & SIT.dv(:,3)==30))); % good example of a day with a big mid sector non-zero (probably) gap


m_basemap('a', [112 123], [-67.5 -64.5],'sdL_v10',[2000,4000],[8, 1]);
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(SIT.lon, SIT.lat,15,daytofill, 'filled')
colormap(jet(12));caxis([0,600]);cbh = colorbar;cbh.Ticks = [0:50:600];
lon = double(SIT.lon);
lat = double(SIT.lat);
%%
filled = inpaint_nans(daytofill, 4);
m_basemap('a', [112 123], [-67.5 -64.5],'sdL_v10',[2000,4000],[8, 1]);
set(gcf, 'Position', [600, 500, 800, 700])
m_scatter(SIT.lon, SIT.lat,15,filled, 'filled')
colormap(jet(12));caxis([0,600]);cbh = colorbar;cbh.Ticks = [0:50:600];




%%
tout = scatteredInterpolant(lon, lat,daytofill);





%%

%Example:
      % Construct a scatteredInterpolant F from locations x,y and values v
        t = linspace(3/4*pi,2*pi,50)';
        x = [3*cos(t); 2*cos(t); 0.7*cos(t)];
        y = [3*sin(t); 2*sin(t); 0.7*sin(t)];
        v = repelem([-0.5; 1.5; 2],length(t));
        F = scatteredInterpolant(x,y,v)
      % Evaluate F at query locations xq,yq to obtain interpolated values vq
        tq = linspace(3/4*pi+0.2,2*pi-0.2,40)';
        xq = [2.8*cos(tq); 1.7*cos(tq); cos(tq)];
        yq = [2.8*sin(tq); 1.7*sin(tq); sin(tq)];
        vq = F(xq,yq);
      % Plot the sample data (x,y,v) and interpolated query data (xq,yq,vq)
        plot3(x,y,v,'.',xq,yq,vq,'.'), grid on
        title('Linear Interpolation')
        xlabel('x'), ylabel('y'), zlabel('Values')
        legend('sample data','interpolated query data','Location','best')
      
        
        
        
        
        
        
        
        
        

% 20-may-2021

% Jacob Arnold

% Calculate sea ice thickness from partial concentrations without high
% resolution Bremen data. 
clear all

load /Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Data/MAT_files/Final/sector10SIT2.mat 


% THIS covers all possibilities though many are unlikely
for i=1:length(SIT.ca(1,:));
    for j=1:length(SIT.lon);
        termA=(SIT.ca(j,i)/100)*SIT.sa(j,i);
        termB=(SIT.cb(j,i)/100)*SIT.sb(j,i);
        termC=(SIT.cc(j,i)/100)*SIT.sc(j,i);
        termD=(SIT.cd(j,i)/100)*SIT.sc(j,i);
        if isfinite(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % ABCD
            SIT.Hnic(j,i)=termA+termB+termC+termD;
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isfinite(termC==1) & isnan(termD)==1 % ABC
            SIT.Hnic(j,i)=termA+termB+termC;
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isnan(termC==1) & isfinite(termD)==1 % ABD
            SIT.Hnic(j,i)=termA+termB+termD;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isfinite(termC==1) & isfinite(termD)==1 % ACD
            SIT.Hnic(j,i)=termA+termC+termD;
        elseif isfinite(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isnan(termD)==1 % AB
            SIT.Hnic(j,i)=termA+termB;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % AC
            SIT.Hnic(j,i)=termA+termC;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % AD
            SIT.Hnic(j,i)=termA+termD;
        elseif isfinite(termA)==1 & isnan(termB)==1 & isnan(termC)==1 & isnan(termD)==1 % A
            SIT.Hnic(j,i)=termA;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % BCD
            SIT.Hnic(j,i)=termB+termC+termD;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % BC
            SIT.Hnic(j,i)=termB+termC;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % BD
            SIT.Hnic(j,i)=termB+termD;
        elseif isnan(termA)==1 & isfinite(termB)==1 & isnan(termC)==1 & isnan(termD)==1 % B
            SIT.Hnic(j,i)=termB;
        elseif isnan(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isfinite(termD)==1 % CD
            SIT.Hnic(j,i)=termC+termD;
        elseif isnan(termA)==1 & isnan(termB)==1 & isfinite(termC)==1 & isnan(termD)==1 % C
            SIT.Hnic(j,i)=termC;
        elseif isnan(termA)==1 & isnan(termB)==1 & isnan(termC)==1 & isfinite(termD)==1 % D
            SIT.Hnic(j,i)=termC;
        else
            Hhires(j,i)=termA+termB+termC;
        end
        clear termA termB termC
    end
    clear j;
end

%  no_ice = find(avgSIC==0);
%  SIT.H(no_ice)=0;

disp('Sea Ice Thickness calculation complete')
clear i;

SIT1=SIT;

figure;plot(SIT1.dn,nanmean(SIT1.H), 'linewidth', 1.2);hold on;
set(gcf, 'Position', [500, 600, 1200, 500])
plot(SIT.dn,nanmean(SIT.Hnic), 'linewidth', 1.2)
datetick('x', 'yyyy', 'keepticks')
legend('SIT hires', 'SIT direct from polys');
xlim([min(SIT1.dn),max(SIT1.dn)])
grid on; grid minor
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/Highres_direct.png','-dpng', '-r400')



figure;plot(SIT1.dn,nanmean(SIT1.H), 'linewidth', 1.2);hold on;
set(gcf, 'Position', [500, 600, 1200, 500])
plot(SIT1.dn,nanmean(SIT1.Hnic), 'linewidth', 1.2)
%plot(S10SIT.dn,nanmean(S10SIT.H), 'linewidth', 1.2)
plot(WebbSIT.dn,nanmean(WebbSIT.H), 'linewidth', 1.2)
datetick('x', 'yyyy', 'keepticks')
xlim([min(SIT1.dn),max(SIT1.dn)])
legend('SIT hires', 'SIT direct from polys', 'Webb SIT');
grid on; grid minor
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/allHcompare.png','-dpng', '-r400')

figure;plot(SIT1.dn,nanmean(SIT1.Hnic), 'linewidth', 1.2);hold on;
set(gcf, 'Position', [500, 600, 1200, 500])
plot(S10SIT.dn,nanmean(S10SIT.H), 'linewidth', 1.2)
datetick('x', 'yyyy', 'keepticks')
legend('SIT direct from polys', 'SIT with less averaged');
xlim([min(SIT1.dn),max(SIT1.dn)])
grid on; grid minor
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/HnicVSlowAVh.png','-dpng', '-r400')


figure;plot(SIT1.dn, nanmean(SIT1.Hnic), 'linewidth', 1.2);hold on;
set(gcf, 'Position', [500, 600, 1200, 500])
plot(WebbSIT.dn, nanmean(WebbSIT.H), 'linewidth', 1.2)
datetick('x', 'yyyy', 'keepticks')
legend('NIC-Direct', 'Webb SIT');
xlim([min(SIT1.dn),max(SIT1.dn)])
grid on; grid minor
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/directVSwebb.png','-dpng', '-r400')




for ii = 1:length(SIT1.Hnic(1,:));
    m_basemap('a', [112, 123, 5], [-67.6, -64.5, 1],'sdL_v10',[2000,4000],[8, 1]) %sector10
    set(gcf, 'Position', [600, 500, 1000, 700]) %subpolarEP
    %set(gcf, 'Position', [600, 500, 800, 700])
    m_scatter(SIT1.lon, SIT1.lat, 25,SIT1.Hnic(:,ii), 'filled')
    if isnan(SIT1.dv(ii))==0
        xlabel(datestr(datetime(SIT1.dv(ii,:), 'Format', 'dd MMM yyyy')))
    else
        xlabel('-- --- ----')
    end
    colormap(jet(12))
    caxis([0,300])
    %caxis([0,1])
    cbh = colorbar
    cbh.Ticks = [0:25:300];
    F(ii) = getframe(gcf);
    close gcf
end

writerobj = VideoWriter('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Videos/S_10DirectNIC_SIT.avi');
writerobj.FrameRate = 5;

open (writerobj);

for jj=1:length(F)
    frame = F(jj);
    writeVideo(writerobj, frame);
end
close(writerobj);
disp('Success! Video saved')
clear F 


% Scatters
onetoone=[0,500;0,500];
figure
scatter(nanmean(SIT.H), nanmean(SIT.Hnic),20,[.1 .7 .6],'filled');hold on
plot(onetoone(1,:),onetoone(2,:), 'r--') 
xlabel('Hires SIT');
ylabel('Polygon-Direct SIT')
print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/directVShires_scatter.png','-dpng', '-r400')

figure
scatter(nanmean(SIT1.H), nanmean(WebbSIT.H),20,[.1 .7 .6],'filled')
xlabel('Hires SIT');
ylabel('Polygon-Direct SIT')
%print('/Users/jacobarnold/Documents/Classes/Research/ICE/ICETHICKNESS/Figures/Averages/Sector_10/directVShires_scatter.png','-dpng', '-r400')








% 01-June-2021

% Jacob Arnold

% Compare selected sector grid boundaries with boundary function



list={'Sector01', 'Sector02', 'Sector03', 'Sector04', 'Sector05', 'Sector06',...
    'Sector07', 'Sector08', 'Sector09', 'Sector10', 'Sector11', 'Sector12', 'Sector13',...
    'Sector14', 'Sector15', 'Sector16', 'Sector17', 'Sector18'};

splot{1,1}=[289 312]; splot{1,2}=[-73 -60]; splot{2,1}=[296 337]; splot{2,2}=[-79 -70];
splot{3,1}=[332 358]; splot{3,2}=[-77 -69]; splot{4,1}=[0 26]; splot{4,2}=[-71 -68];
splot{5,1}=[24 55]; splot{5,2}=[-71 -65]; splot{6,1}=[53.5 68.5]; splot{6,2}=[-68 -65.2];
splot{7,1}=[67 86]; splot{7,2}=[-70.5 -65]; splot{8,1}=[84.5 100.5]; splot{8,2}=[-67.5 -63.5];
splot{9,1}=[99.5 113.5]; splot{9,2}=[-67.5 -63.5]; splot{10,1}=[112 123]; splot{10,2}=[-67.5 -64.5];
splot{11,1}=[121 135]; splot{11,2}=[-67.5 -64.2]; splot{12,1}=[133.5 150.5]; splot{12,2}=[-69 -64.5];
splot{13,1}=[149 173]; splot{13,2}=[-72 -65]; splot{14,1}=[160 207]; splot{14,2}=[-79 -69];
splot{15,1}=[202 235.5]; splot{15,2}=[-78 -71.9]; splot{16,1}=[232 262]; splot{16,2}=[-76.2 -69];
splot{17,1}=[258 295]; splot{17,2}=[-75 -67]; splot{18,1}=[282.5 308]; splot{18,2}=[-70 -59];


for ii = 1:length(list)
    sect = load(['ICE/Concentration/ant-sectors/',lower(list{ii}),'.mat']);
    sect2 = struct2cell(sect);
    plon = sect2{1,1}.plon; plat = sect2{1,1}.plat;
    
    boundind = boundary(double(sect2{1,1}.lon), double(sect2{1,1}.lat));
    blonP = sect2{1,1}.lon(boundind); blatP = sect2{1,1}.lat(boundind);
    
    londom = splot{ii,1}; latdom = splot{ii,2};

    m_basemap('a', londom, latdom, 'sdL_v10',[2000,4000],[8, 1]);
    set(gcf, 'position', [500,600,700, 700]);
    m_scatter(blonP, blatP, 150, [0.1, 0.7, 0.2],'LineWidth', 0.9); hold on;
    m_scatter(plon, plat, 25, [0.1, 0.7, 0.9], 'filled');
    m_plot(blonP, blatP, 'm', 'linewidth', 1.1);
    m_plot(plon, plat, 'c', 'linewidth', 1.1);
    xlabel({[list{ii}], 'Blue dots are plon (selected boundary)', 'Green circles are from boundary function',...
        'Magenta line is the polygon tracing the green circles', 'Cyan line is the polygon tracing the blue circles'})
    
    print(['ICE/ICETHICKNESS/Figures/Sectors/CompareBounds/', list{ii}, '.png'],'-dpng', '-r400')
    clear sect sect2 plon plat boundind blonP blatP londom
    
end





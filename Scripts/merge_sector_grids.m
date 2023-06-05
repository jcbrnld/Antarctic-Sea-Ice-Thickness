% 06-June-2021

% Jacob Arnold

% Create grid of all shelf sector grids and write out some values
clear all

sectors = {'sector01','sector02','sector03','sector04','sector05','sector06',...
    'sector07','sector08','sector09','sector10','sector11','sector12','sector13',...
    'sector14','sector15','sector16','sector17','sector18'};
Tlon = [];Tlat = [];
Shelf_H = [];
Tca=[];Tcb=[];Tcc=[];Tcd=[];Tct=[];Tsa=[];Tsb=[];Tsc=[];Tsd=[];
Tcah = []; Tcbh = []; Tcch = []; Tcth = [];
for ii = 1:18
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/',cell2mat(sectors(ii)),'.mat']);
    Tlon = [Tlon;SIT.lon];
    Tlat = [Tlat;SIT.lat];
    tH = SIT.H(:,1:657);
    Shelf_H = [Shelf_H;tH];
    Tca = [Tca;SIT.ca(:,1:657)];
    Tcb = [Tcb;SIT.cb(:,1:657)];
    Tcc = [Tcc;SIT.cc(:,1:657)];
    Tcd = [Tcd;SIT.cd(:,1:657)];
    Tct = [Tct;SIT.ct(:,1:657)];
    Tsa = [Tsa;SIT.sa(:,1:657)];
    Tsb = [Tsb;SIT.sb(:,1:657)];
    Tsc = [Tsc;SIT.sc(:,1:657)];
    Tsd = [Tsd;SIT.sd(:,1:657)];
    Tcah = [Tcah;SIT.ca_hires(:,1:657)];
    Tcbh = [Tcbh;SIT.cb_hires(:,1:657)];
    Tcch = [Tcch;SIT.cc_hires(:,1:657)];
    Tcth = [Tcth;SIT.ct_hires(:,1:657)];
    grid_sizes(ii) = length(SIT.lon);
    grid_areas(ii) = length(SIT.lon)*3.125;
    if ii ==1;
        Tdn = SIT.dn(1:657);
        Tdv = SIT.dv(1:657,:);
    end
    clear SIT tH
    
end

SIT.lon = Tlon; 
SIT.lat = Tlat; 
SIT.H = Shelf_H;
SIT.dn = Tdn;
SIT.dv = Tdv;
SIT.ca = Tca;
SIT.cb = Tcb;
SIT.cc = Tcc;
SIT.cd = Tcd;
SIT.ct = Tct;
SIT.sa = Tsa;
SIT.sb = Tsb;
SIT.sc = Tsc;
SIT.sd = Tsd;
SIT.ca_hires = Tcah;
SIT.cb_hires = Tcbh;
SIT.cc_hires = Tcch;
SIT.ct_hires = Tcth;
clear Tlon Tlat Shelf_H Tdn Tdv Tca Tcb Tcc Tcd Tct Tsa Tsb Tsc Tsd Tcah Tcbh Tcch Tcth;



%% view product


m_basemap('p', [0,360,60], [-89, -57], 'sdL_v10', [2000,4000], [8,8]);
m_elev('contour', [1000,2000,3000,4000],'color', [0.6,0.6,0.6]);
%m_ruler([0.4,0.55],0.5, 5, 'tickdir', 'out')
set(gcf, 'position', [1500,600,900, 800]);
m_scatter(SIT.lon, SIT.lat, 3, SIT.H(:,210),'filled');
cmocean('ice', 12);
%colormap(jet(12));
caxis([0,300])
cbh = colorbar;
cbh.Ticks = [0:25:300];
cbh.Label.String = ('Sea Ice Thickness [cm]');


%save('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/All_Shelf.mat', 'SIT', '-v7.3');





% Grid sizes and areas for each of the 18 sectors
% Total size: 288576
% Total area: 901,800 km^2










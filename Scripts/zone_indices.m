% 






load ICE/ICETHICKNESS/Data/MAT_files/Final/full_g.mat

load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/subpolar_po.mat
spo = SIT;
load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/subpolar_ao.mat
sao = SIT;
load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/subpolar_io.mat
sio = SIT; clear SIT
%%
load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_po.mat
apo = SIT;
load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_ao.mat
aao = SIT;

load ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_io.mat
aio = SIT;


%%
loc=68;
m_basemap('p', [0,360], [-90, -45])
%m_scatter(fullg.lon, fullg.lat, 5, 'filled')
m_scatter(sao.lon, sao.lat, 3, 'markerfacealpha', .5)
m_scatter(sio.lon, sio.lat, 3, 'markerfacealpha', .5)
m_scatter(spo.lon, spo.lat, 3, 'markerfacealpha', .5)
m_scatter(apo.lon, apo.lat, 3, 'markerfacealpha', .5)
m_scatter(aio.lon, aio.lat, 3, 'markerfacealpha', .5)
m_scatter(aao.lon, aao.lat, 3, 'markerfacealpha', .5)


m_scatter(fullg.lon(fullg.misspoint_ind(loc)), fullg.lat(fullg.misspoint_ind(loc)), 15, 'filled', 'm')


%%
sub_po = [8:14,16, 17, 18, 20, 80, 81];

m_basemap('p', [0,360], [-90, -45])
m_scatter(SIT.lon, SIT.lat, 3, 'markerfacealpha', .5)
m_scatter(fullg.lon, fullg.lat, 5, 'filled')
m_scatter(SIT.lon, SIT.lat, 3, 'markerfacealpha', .5)
m_scatter(fullg.lon(fullg.misspoint_ind(sub_po)), fullg.lat(fullg.misspoint_ind(sub_po)), 15, 'filled')

%% 
sub_io = [15,19,  21:24, 32, 83];

m_basemap('p', [0,360], [-90, -45])
%m_scatter(fullg.lon, fullg.lat, 5, 'filled')
m_scatter(sao.lon, sao.lat, 3, 'markerfacealpha', .5)
m_scatter(sio.lon, sio.lat, 3, 'markerfacealpha', .5)
m_scatter(spo.lon, spo.lat, 3, 'markerfacealpha', .5)

m_scatter(fullg.lon(fullg.misspoint_ind(sub_io)), fullg.lat(fullg.misspoint_ind(sub_io)), 15, 'filled')



%%
 sub_ao = [30, 31, 33, 34, 35, 36, 37:45, 46:55, 56, 57, 58, 60, 64, 65, 66, 67, 69:75, 76, 77, 78, 79, 82];

m_basemap('p', [0,360], [-90, -45])
%m_scatter(fullg.lon, fullg.lat, 5, 'filled')
m_scatter(sao.lon, sao.lat, 3, 'markerfacealpha', .5)
m_scatter(sio.lon, sio.lat, 3, 'markerfacealpha', .5)
m_scatter(spo.lon, spo.lat, 3, 'markerfacealpha', .5)

m_scatter(fullg.lon(fullg.misspoint_ind(sub_ao)), fullg.lat(fullg.misspoint_ind(sub_ao)), 15, 'filled')

%% 
 accpo = [1:7, 25:29];

%% 
 accao = [59,68];

%% 
 accio = [61:63];


 %% now we have indices, load in so dataset and find corresponding SIT vals
 
 load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so_sit.mat
 
 %%
 
 m_basemap('p', [0,360], [-90,-45])
 m_scatter(SO_SIT.lon(length(SO_SIT.lon)-82:length(SO_SIT.lon)), ...
     SO_SIT.lat(length(SO_SIT.lat)-82:length(SO_SIT.lat)), 15,'filled');
 
 %%
 
 gaplon = SO_SIT.lon(length(SO_SIT.lon)-82:length(SO_SIT.lon));
 gaplat = SO_SIT.lat(length(SO_SIT.lat)-82:length(SO_SIT.lat));
 
 gapSIT = SO_SIT.H(length(SO_SIT.H(:,1))-82:length(SO_SIT.H(:,1)), :);
 
 
 %% Subpolar ao
 % divide partials from H and save new variables
 
 Gsaolon = gaplon(sub_ao);
 Gsaolat = gaplat(sub_ao);
 GsaoH = gapSIT(sub_ao,:);
 
 
 partials.dn = sao.dn;
 partials.dv = sao.dv;
 partials.sa = sao.sa;
 partials.sb = sao.sb;
 partials.sc = sao.sc;
 partials.sd = sao.sd;
 partials.ct = sao.ct;
 partials.ca = sao.ca;
 partials.cb = sao.cb;
 partials.cc = sao.cc;
 partials.cd = sao.cd;
 partials.lon = sao.lon;
 partials.lat = sao.lat;
 partials.ca_hires = sao.ca_hires;
 partials.cb_hires = sao.cb_hires;
 partials.cc_hires = sao.cc_hires;
 partials.cd_hires = sao.cd_hires;
 partials.ct_hires = sao.ct_hires;
 partials.mavg = sao.mavg;
 partials.missinglon = Gsaolon;
 partials.missinglat = Gsaolat;
 partials.error = sao.error;
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/Partials/subpolar_ao_partials.mat', 'partials', '-v7.3');;

 
 SIT.lon = [sao.lon; Gsaolon]; 
 SIT.lat = [sao.lat; Gsaolat];
 SIT.H = [sao.H; GsaoH];
 SIT.dn = sao.dn;
 SIT.dv = sao.dv;
 SIT.icebergs = sao.icebergs
 
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/subpolar_ao.mat', 'SIT');
 
 % Ran for ao -ja
 
 
 %% subpolar io
 % divide partials from H and save new variables
 
 Gsiolon = gaplon(sub_io);
 Gsiolat = gaplat(sub_io);
 GsioH = gapSIT(sub_io,:);
 
 clear sao
 sao = sio;
 partials.dn = sao.dn;
 partials.dv = sao.dv;
 partials.sa = sao.sa;
 partials.sb = sao.sb;
 partials.sc = sao.sc;
 partials.sd = sao.sd;
 partials.ct = sao.ct;
 partials.ca = sao.ca;
 partials.cb = sao.cb;
 partials.cc = sao.cc;
 partials.cd = sao.cd;
 partials.lon = sao.lon;
 partials.lat = sao.lat;
 partials.ca_hires = sao.ca_hires;
 partials.cb_hires = sao.cb_hires;
 partials.cc_hires = sao.cc_hires;
 partials.cd_hires = sao.cd_hires;
 partials.ct_hires = sao.ct_hires;
 partials.mavg = sao.mavg;
 partials.missinglon = Gsiolon;
 partials.missinglat = Gsiolat;
 partials.error = sao.error;
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/Partials/subpolar_io_partials.mat', 'partials', '-v7.3');;

 
 SIT.lon = [sao.lon; Gsiolon]; 
 SIT.lat = [sao.lat; Gsiolat];
 SIT.H = [sao.H; GsioH];
 SIT.dn = sao.dn;
 SIT.dv = sao.dv;
 SIT.icebergs = sao.icebergs
 
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/subpolar_io.mat', 'SIT');
 
 % ran for io -ja
 % Now will check ao and io before procedding
 % Looks good
 
 %% subpolar po
  % divide partials from H and save new variables
 
 Gspolon = gaplon(sub_po);
 Gspolat = gaplat(sub_po);
 GspoH = gapSIT(sub_po,:);
 
 clear sao
 sao = spo;
 partials.dn = sao.dn;
 partials.dv = sao.dv;
 partials.sa = sao.sa;
 partials.sb = sao.sb;
 partials.sc = sao.sc;
 partials.sd = sao.sd;
 partials.ct = sao.ct;
 partials.ca = sao.ca;
 partials.cb = sao.cb;
 partials.cc = sao.cc;
 partials.cd = sao.cd;
 partials.lon = sao.lon;
 partials.lat = sao.lat;
 partials.ca_hires = sao.ca_hires;
 partials.cb_hires = sao.cb_hires;
 partials.cc_hires = sao.cc_hires;
 partials.cd_hires = sao.cd_hires;
 partials.ct_hires = sao.ct_hires;
 partials.mavg = sao.mavg;
 partials.missinglon = Gspolon;
 partials.missinglat = Gspolat;
 partials.error = sao.error;
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/Partials/subpolar_po_partials.mat', 'partials', '-v7.3');;

 
 SIT.lon = [sao.lon; Gspolon]; 
 SIT.lat = [sao.lat; Gspolat];
 SIT.H = [sao.H; GspoH];
 SIT.dn = sao.dn;
 SIT.dv = sao.dv;
 SIT.icebergs = sao.icebergs
 
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/subpolar_po.mat', 'SIT');
 
 % Finished for subpolar po and verified
 
 %%
   % divide partials from H and save new variables
 
 Gapolon = gaplon(accpo);
 Gapolat = gaplat(accpo);
 GapoH = gapSIT(accpo,:);
 
 clear sao
 sao = apo;
 partials.dn = sao.dn;
 partials.dv = sao.dv;
 partials.sa = sao.sa;
 partials.sb = sao.sb;
 partials.sc = sao.sc;
 partials.sd = sao.sd;
 partials.ct = sao.ct;
 partials.ca = sao.ca;
 partials.cb = sao.cb;
 partials.cc = sao.cc;
 partials.cd = sao.cd;
 partials.lon = sao.lon;
 partials.lat = sao.lat;
 partials.ca_hires = sao.ca_hires;
 partials.cb_hires = sao.cb_hires;
 partials.cc_hires = sao.cc_hires;
 partials.cd_hires = sao.cd_hires;
 partials.ct_hires = sao.ct_hires;
 partials.mavg = sao.mavg;
 partials.missinglon = Gapolon;
 partials.missinglat = Gapolat;
 partials.error = sao.error;
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/Partials/acc_po_partials.mat', 'partials', '-v7.3');;

 
 SIT.lon = [sao.lon; Gapolon]; 
 SIT.lat = [sao.lat; Gapolat];
 SIT.H = [sao.H; GapoH];
 SIT.dn = sao.dn;
 SIT.dv = sao.dv;
 SIT.icebergs = sao.icebergs
 
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_po.mat', 'SIT');
 
 % Ran for accpo and verified
 
 
 %% acc io
 
    % divide partials from H and save new variables
 
 Gaiolon = gaplon(accio);
 Gaiolat = gaplat(accio);
 GaioH = gapSIT(accio,:);
 
 clear sao
 sao = aio;
 partials.dn = sao.dn;
 partials.dv = sao.dv;
 partials.sa = sao.sa;
 partials.sb = sao.sb;
 partials.sc = sao.sc;
 partials.sd = sao.sd;
 partials.ct = sao.ct;
 partials.ca = sao.ca;
 partials.cb = sao.cb;
 partials.cc = sao.cc;
 partials.cd = sao.cd;
 partials.lon = sao.lon;
 partials.lat = sao.lat;
 partials.ca_hires = sao.ca_hires;
 partials.cb_hires = sao.cb_hires;
 partials.cc_hires = sao.cc_hires;
 partials.cd_hires = sao.cd_hires;
 partials.ct_hires = sao.ct_hires;
 partials.mavg = sao.mavg;
 partials.missinglon = Gaiolon;
 partials.missinglat = Gaiolat;
 partials.error = sao.error;
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/Partials/acc_io_partials.mat', 'partials', '-v7.3');;

 
 SIT.lon = [sao.lon; Gaiolon]; 
 SIT.lat = [sao.lat; Gaiolat];
 SIT.H = [sao.H; GaioH];
 SIT.dn = sao.dn;
 SIT.dv = sao.dv;
 SIT.icebergs = sao.icebergs
 
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_io.mat', 'SIT');
 

 % Ran for accio and verified
 
 
 %% ACC ao
 
  % divide partials from H and save new variables
 
 Gaaolon = gaplon(accao);
 Gaaolat = gaplat(accao);
 GaaoH = gapSIT(accao,:);
 
 clear sao
 sao = aao;
 partials.dn = sao.dn;
 partials.dv = sao.dv;
 partials.sa = sao.sa;
 partials.sb = sao.sb;
 partials.sc = sao.sc;
 partials.sd = sao.sd;
 partials.ct = sao.ct;
 partials.ca = sao.ca;
 partials.cb = sao.cb;
 partials.cc = sao.cc;
 partials.cd = sao.cd;
 partials.lon = sao.lon;
 partials.lat = sao.lat;
 partials.ca_hires = sao.ca_hires;
 partials.cb_hires = sao.cb_hires;
 partials.cc_hires = sao.cc_hires;
 partials.cd_hires = sao.cd_hires;
 partials.ct_hires = sao.ct_hires;
 partials.mavg = sao.mavg;
 partials.missinglon = Gaaolon;
 partials.missinglat = Gaaolat;
 partials.error = sao.error;
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/Partials/acc_ao_partials.mat', 'partials', '-v7.3');;

 
 SIT.lon = [sao.lon; Gaaolon]; 
 SIT.lat = [sao.lat; Gaaolat];
 SIT.H = [sao.H; GaaoH];
 SIT.dn = sao.dn;
 SIT.dv = sao.dv;
 SIT.icebergs = sao.icebergs
 
 
 save('ICE/ICETHICKNESS/Data/MAT_files/Final/zones/acc_ao.mat', 'SIT');
 

 % Ran and verified for acc ao
 
 
 
 
 
 
 
 
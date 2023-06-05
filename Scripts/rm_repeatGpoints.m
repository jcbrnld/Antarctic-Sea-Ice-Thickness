% Jacob Arnold

% 06-Dec-2021

% Remove repeated grid points
% There are 9 total in sectors 08, 13, 15
% the indices:
% 
% s08rep =
% 
%         8671
%         8818
%         8731
%         8825
% 
% s13rep
% 
% s13rep =
% 
%            4
%        12133
%           10
%        12142
%           18
%        12151
%           29
%        12159
%           56
%        12172
%           74
%        12179
% 
% s15rep
% 
% s15rep =
% 
%         8616
%         8729

ind08 = [8671, 8818, 8731, 8825];
ind13 = [4, 12133, 10, 12142, 18, 12151, 29, 12159, 56, 12172, 74, 12179];
ind15 = [8616, 8729];

% I believe each pair are the same point - ind08(1:2) are the same,
% ind08(5:6) are the same... etc. 
% Verify this before proceeding. 

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector08.mat;
SIT08 = SIT; clear SIT

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector13.mat;
SIT13 = SIT; clear SIT 

load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector15.mat;
SIT15 = SIT; clear SIT 

[lon13, lat13] = sectordomain(13);
m_basemap('a', lon13, lat13);
m_scatter(SIT13.lon, SIT13.lat, 'filled', 'markerfacecolor', [.6,.6,.6]);
for ii = 1:length(ind13)
    
    m_scatter(SIT13.lon(ind13(ii)), SIT13.lat(ind13(ii)), 20, 'filled');
    
    pause(3);
    
end


% Yes confirmed. Each pair are the indices for the same point.

% Figure out which one is out of place
[lon08, lat08] = sectordomain(08);

%% Sector 13

m_basemap('a', [169, 173], [-72, -71]);
plot_dim(900,700)
s1 = m_scatter(SIT13.lon, SIT13.lat,80, 'filled', 'markerfacecolor', [.6,.6,.6]);
s2 = m_scatter(SIT13.lon(12104:12183), SIT13.lat(12104:12183),120,  'filled','markerfacecolor',[0.5,0.7, 0.95]);
s4 = m_scatter(SIT13.lon(1:80), SIT13.lat(1:80), 120, 'filled', 'markerfacecolor', [0.5, 0.95, 0.7]);
s3 = m_scatter(SIT13.lon(ind13(:)), SIT13.lat(ind13(:)), 120, 'm', 'filled'); 
legend([s1,s2,s4,s3], 'Sector 13', 'last 80 indices', 'first 80 indices', 'repeated points', 'fontsize', 14)
%print('ICE/ICETHICKNESS/Figures/Diagnostic/Repeat_gridpoints/s13_first80_last80.png', '-dpng', '-r500');

%% Sector 08

m_basemap('a', lon08, lat08)
m_scatter(SIT08.lon, SIT08.lat, 80, 'filled', 'markerfacecolor', [.6,.6,.6]);
m_scatter(SIT08.lon(8660:8740), SIT08.lat(8660:8740), 100, 'filled','markerfacecolor',[0.5,0.7, 0.95]);
m_scatter(SIT08.lon(8800:8843), SIT08.lat(8800:8843), 100, 'filled','markerfacecolor',[0.5, 0.95, 0.7]);

m_scatter(SIT08.lon(ind08), SIT08.lat(ind08), 100, 'm', 'filled');

%% create variables of indices to remove then carefully remove those indices from ALL necessary places. 
% Also store the removed indices in the SIT structure incase the points
% need to be removed elsewhere. 



rm08 = [8818, 8825]'; drm08 = [8671,8731]'; 
rm13 = [12133 12142 12151 12159 12172 12179]'; drm13 = [4, 10, 18, 29, 56, 74]';
rm15 = 8729; drm15 = 8616;

%% 08

%load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector08.mat;


SIT.lon(rm08) = [];
SIT.lat(rm08) = [];
SIT.H(rm08,:) = [];
SIT.index(rm08) = [];

SIT.rm_gpoint{1,1} = [drm08,rm08];
SIT.rm_gpoint{1,2} = ['The firt column is the indices of the points that were repeated. These in the first column still remain and can be used to identify which were removed.'];
SIT.rm_gpoint{1,3} = ['The second column is the indices that were removed. If a variable is found which still includes the repeats (8843 rather than 8841 vector length), the second column indices should be removed.'];


%save('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector08.mat', 'SIT');

clear SIT

%load ICE/Concentration/ant-sectors/sector08.mat

sector08.lon(rm08) = [];
sector08.lat(rm08) = [];
sector08.bat(rm08) = [];
sector08.index(rm08) = [];
sector08.sic(rm08,:) = [];
sector08.u(rm08,:) = [];
sector08.v(rm08,:) = [];
sector08.h(rm08,:) = [];
sector08.hdaily(rm08,:) = [];
sector08.rm_gpoint{1,1} = [drm08,rm08];
sector08.rm_gpoint{1,2} = ['The firt column is the indices of the points that were repeated. These in the first column still remain and can be used to identify which were removed.'];
sector08.rm_gpoint{1,3} = ['The second column is the indices that were removed. If a variable is found which still includes the repeats (8843 rather than 8841 vector length), the second column indices should be removed.'];

%save('ICE/Concentration/ant-sectors/sector08.mat', 'sector08', '-v7.3');


%% 13

%load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector13.mat;


SIT.lon(rm13) = [];
SIT.lat(rm13) = [];
SIT.H(rm13,:) = [];
SIT.index(rm13) = [];

SIT.rm_gpoint{1,1} = [drm13,rm13];
SIT.rm_gpoint{1,2} = ['The firt column is the indices of the points that were repeated. These in the first column still remain and can be used to identify which were removed.'];
SIT.rm_gpoint{1,3} = ['The second column is the indices that were removed. If a variable is found which still includes the repeats (12187 rather than 12181 vector length), the second column indices should be removed.'];

%save('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector13.mat', 'SIT');

clear SIT


%load ICE/Concentration/ant-sectors/sector13.mat
sector13.lon(rm13) = [];
sector13.lat(rm13) = [];
sector13.bat(rm13) = [];
sector13.index(rm13) = [];
sector13.sic(rm13,:) = [];
sector13.u(rm13,:) = [];
sector13.v(rm13,:) = [];
sector13.h(rm13,:) = [];
sector13.hdaily(rm13,:) = [];
sector13.rm_gpoint{1,1} = [drm13,rm13];
sector13.rm_gpoint{1,2} = ['The firt column is the indices of the points that were repeated. These in the first column still remain and can be used to identify which were removed.'];
sector13.rm_gpoint{1,3} = ['The second column is the indices that were removed. If a variable is found which still includes the repeats (12187 rather than 12181 vector length), the second column indices should be removed.'];

%save('ICE/Concentration/ant-sectors/sector13.mat', 'sector13', '-v7.3');


%% 15

%load ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector15.mat;


SIT.lon(rm15) = [];
SIT.lat(rm15) = [];
SIT.H(rm15,:) = [];
SIT.index(rm15) = [];

SIT.rm_gpoint{1,1} = [drm15,rm15];
SIT.rm_gpoint{1,2} = ['The firt column is the indices of the points that were repeated. These in the first column still remain and can be used to identify which were removed.'];
SIT.rm_gpoint{1,3} = ['The second column is the indices that were removed. If a variable is found which still includes the repeats (8922 rather than 8921 vector length), the second column indices should be removed.'];


%save('ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector15.mat', 'SIT');

clear SIT

%load ICE/Concentration/ant-sectors/sector15.mat
sector15.lon(rm15) = [];
sector15.lat(rm15) = [];
sector15.bat(rm15) = [];
sector15.index(rm15) = [];
sector15.sic(rm15,:) = [];
sector15.u(rm15,:) = [];
sector15.v(rm15,:) = [];
sector15.h(rm15,:) = [];
sector15.hdaily(rm15,:) = [];
sector15.rm_gpoint{1,1} = [drm15,rm15];
sector15.rm_gpoint{1,2} = ['The firt column is the indices of the points that were repeated. These in the first column still remain and can be used to identify which were removed.'];
sector15.rm_gpoint{1,3} = ['The second column is the indices that were removed. If a variable is found which still includes the repeats (8922 rather than 8921 vector length), the second column indices should be removed.'];

%save('ICE/Concentration/ant-sectors/sector15.mat', 'sector15', '-v7.3');



%%
































% Jacob Arnold
% 24-May-2022

% Add grid cell area field to all gridded structures

% NVM I don't trust the grid cell area file from Bremen. 
% Just use 3.125 as area


% Sectors first
load ICE/ICETHICKNESS/Data/MAT_files/gridCellArea_3125m.mat

for ii = 0:18
    if ii < 10;
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii)
    end
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat']);
    
    
    a = area(SIT.index);
    
    SIT.cellarea = a;
    SIT.cellareaCOMMENT = {'cellarea is the area of each grid cell from the s3125GridCellArea file from Bremen'};
    
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');

    if ii == 0
        zar = a; % hang on to this for global
    end
   
    clearvars -except area zar
    
end



%%

%       1270
%        |
% 1199--1200--1201
%        |
%       1130

% Area of 1200?

% distances:
%       3.0906
%  3.0801    3.0896 
%       3.0793

% grid cell:
% (3.0793/2 + 3.0906/2) X (3.0801/2 + 3.0896/2);

% 3.0850 X 3.0848

% SO area = 9.5166 km^2
% BUT from the bremen file: 7.9539
% WHILE 3.125^2 = 9.7656



% ANOTHER POINT

%         2010
%          |
% 1929 -- 1930 -- 1931
%          |
%         1851

% distances:
%        3.0861
% 3.0769       3.0864
%        3.0774

% 3.0817 X 3.0816
% SO area = 9.4966
% BUT from the bremen file: 9.5140
% WHILE 3.125^2 = 9.7656
% Jacob Arnold

% 03-Dec-2021

% Add index and MxN grid from each sector's SIC file to the SIT file
% Index is the index of the MxN grid for lat lon locs of sector grid vector




for ii = 1:18
    
    if ii<10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    disp(['Starting sector ',sector])
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector', sector, '.mat']);
    data = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    data2 = struct2cell(data);
    SIC = data2{1,1};
    
    SIT.grid3p125km = SIC.grid3p125km;
    SIT.poly.lon = SIC.week.poly.lon;
    SIT.poly.lat = SIC.week.poly.lat;
    SIT.index = SIC.index;
    
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT');
    
    clear SIT SIC data data2
    
    
end
    
    
    
    
    
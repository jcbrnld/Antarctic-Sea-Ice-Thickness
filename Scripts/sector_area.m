% Jacob Arnold

% 02-May-2022

% Find grid sizes and % of shelf area


numgpoints = [];
vol = [];
for ii = 1:18
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end

    disp(['Starting sector ',sector, '...'])
    load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
    
    numgpoints(ii,1) = length(gate.inside.in);
    
    dat = load(['/Volumes/Data/Research_long/ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    data = struct2cell(dat); clear dat
    SIC = data{1,1}; clear data
    bat = SIC.bat(gate.inside.in);
    
    vol(ii,1) = sum((-bat./1000).*(3.125^2), 'all', 'omitnan');
    clear gate SIC
end



areas = numgpoints.*(3.125^2);

totalarea = sum(areas);
perarea = (areas./totalarea).*100;

totalvol = sum(vol);
pervol = (vol./totalvol).*100;







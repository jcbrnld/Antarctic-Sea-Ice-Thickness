% Jacob Arnold

% 02-Aug-2021

% View some of the older SIGRID (gridded) SOD files 
% and begin considering how to import them and project 
% onto the 3.125 km grid. 


% data1 = textread('ICE/ICETHICKNESS/Data/Stage_of_development/Sigrid1/NIC/ANT/1980/198045.ANT');

% Prepare to loop through and load all files
DataYears = string([1973:1:1994]);
%DataYears = string(1974);
dcount = 0;
for yy = 1:length(DataYears)
    disp(['Year = ',char(DataYears(yy))])
    fnames=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Sigrid1/NIC/ANT/',char(DataYears(yy)),'/fileNames.txt'],'%s');
    for ff = 1:length(fnames)
        dcount = dcount+1;
        FID = fopen(['ICE/ICETHICKNESS/Data/Stage_of_development/Sigrid1/NIC/ANT/',char(DataYears(yy)),'/',fnames{ff}]);

        Data1 = textscan(FID, '%s'); % reads in as nx1 cell
        % Should be able to split this up as needed after reading in. 
        fclose(FID);clear FID
        data2{ff,yy} = Data1{1,1}; % open into the first cell
        clear Data1

        dnloc = find(data2{ff,yy}{2}=='E');
        dv(dcount,1) = str2num(['19',data2{ff,yy}{2}(dnloc+2:dnloc+3)]);
        dv(dcount,2) = str2num(data2{ff,yy}{2}(dnloc+4:dnloc+5));
        dv(dcount,3) = str2num(data2{ff,yy}{2}(dnloc+6:dnloc+7));

        dn(dcount) = datenum(dv(dcount,:));
        
        
        % Split gridlines from headers
        counter2 = 0;
        for ii = 1:length(data2{ff,yy})
            if data2{ff,yy}{ii,1}(1) == '='
                counter2 = counter2+1;
                ind(counter2,1) = ii;
            end
        end
        clear ii counter

        lineNum = diff(ind)-1; % number of lines following line header that all describe one grid line 
        lineNum(length(lineNum)+1) = length(data2{ff,yy})-ind(end);
        
        header = [data2{ff,yy}{1} data2{ff,yy}{2}];


        data3{ff,yy} = cell(length(ind),1);
        
        jrefs(1) = "data3{ff,yy}{ii} = [data2{ff,yy}{ind(ii)+1},";
        for kk = 2:100
            jrefs(kk) = string(['data2{ff,yy}{ind(ii)+',num2str(kk),'},']);
        end                

        for ii = 1:length(ind)
            GlineHeader{ff,yy}{ii,1} = data2{ff,yy}{ind(ii)}; % Fill in header lines
            tref = char(join(jrefs(1:lineNum(ii))));
            tref(end)=[]; tref(end+1) = ']'; tref(end+1) = ';';
            tref2 = string(tref);
            eval(tref2);
            clear tref tref2
            if lineNum(ii)>100
                warning(['More than 100 lines at ',num2str(ii),' of ', fnames{ff}])
            end


        end
        clear lineNum 
        
        % Create grids' lats and lons NO LONGER NECESSARY - all share same grid
        % find num lon grid cells
%         for ii = 1:length(GlineHeader{ff,yy})
%             te = find(GlineHeader{ff,yy}{ii}=='M');
%             numPoints{ff,yy}(ii) = str2num(GlineHeader{ff,yy}{ii}(te+1:te+4));
%             clear te
%             
%         end
%         lonsCheck(ff,yy) = mean(numPoints{ff,yy}==numPoints{1});% IF ANY of these are not 1 in the end there is a different grid somewhere
%             
%         clear ii
%         latstep = -0.25; % this is constant
% 
%         lonstep = 360./numPoints{ff,yy}; 
% 
%         Aloc = find(data2{ff,yy}{1,1}=='A'); % Verify that ALL Glats are -50 and ALL Glons are -180
%         Glat{ff,yy}(1,1) = -str2num(data2{ff,yy}{1,1}(Aloc+2:Aloc+3)); % initial lon and lats
%         Glon{ff,yy}(1,1) = -str2num(data2{ff,yy}{1,1}(Aloc+6:Aloc+8)); 


    end
end


% Check lons and lats
% checked visually - JA
% All starting lats and lons are -50 and -180


%% Build the grid  :)


% find num lon grid cells
for ii = 1:length(GlineHeader{10,5})
    te = find(GlineHeader{10,5}{ii}=='M');
    numPoints(ii) = str2num(GlineHeader{10,5}{ii}(te+1:te+4));
    clear te
end

latstep = -0.25; % this is constant

lonstep = 360./numPoints; 

Aloc = find(data2{10,5}{1,1}=='A');
Glat(1,1) = -str2num(data2{10,5}{1,1}(Aloc+2:Aloc+3)); % initial lon and lats
Glon(1,1) = -str2num(data2{10,5}{1,1}(Aloc+6:Aloc+8));

clat = Glat(1,1);
for ii = 1:length(ind)
    
    lvar = length(Glat);
    clon = -180:lonstep(ii):180-lonstep(ii);% test this separately
    
    Glat(1,(lvar+1):(lvar+numPoints(ii))) = clat;
    
    Glon(1,(lvar+1):(lvar+numPoints(ii))) = clon;
    
    
    clat = clat+latstep;
    clear lvar clon
end
Glat(1) = [];Glon(1) = [];

%% Save what we've created thus far

charts.dn = dn;
charts.dv = dv;
charts.lon = Glon;
charts.lat = Glat;
charts.data = data3;
charts.headerlines = GlineHeader;
charts.raw_data_form = data2;


save('ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/charts', 'charts', '-v7.3');



%% plot some grids


m_basemap('p', [-180, 180], [-90, -45]);
set(gcf, 'position', [500,600,1200,1000]);
m_scatter(Glon, Glat, 2, 'filled');
text(-0.04, 0.1, '2\circ lon', 'fontsize', 15, 'fontweight', 'bold')
text(-0.04, 0.17, '1\circ lon', 'fontsize', 15, 'fontweight', 'bold')
text(-0.04, 0.36, '0.5\circ lon', 'fontsize', 15, 'fontweight', 'bold')
text(-0.04, 0.6, '0.25\circ lon', 'fontsize', 15, 'fontweight', 'bold')
%title({'Sample SIGRID1 Grid',''})
%print('ICE/ICETHICKNESS/Figures/SIGRID1/samp_grid_2.png', '-dpng', '-r800');

%% INVESTIGATE odd grid SKIP this section
for ii = 1:length(GlineHeader{11,21})
    te = find(GlineHeader{11,21}{ii}=='M');
    numPoints2(ii) = str2num(GlineHeader{11,21}{ii}(te+1:te+4));
    clear te
end

latstep = -0.25; % this is constant

lonstep = 360./numPoints2; 

Aloc = find(data2{11,21}{1,1}=='A');
Glat2(1,1) = -str2num(data2{11,21}{1,1}(Aloc+2:Aloc+3)); % initial lon and lats
Glon2(1,1) = -str2num(data2{11,21}{1,1}(Aloc+6:Aloc+8));

clat2 = Glat2(1,1);
for ii = 1:length(ind)
    
    lvar = length(Glat2);
    clon = -180:lonstep(ii):180-lonstep(ii);% test this separately
    
    Glat2(1,(lvar+1):(lvar+numPoints2(ii))) = clat2;
    
    Glon2(1,(lvar+1):(lvar+numPoints2(ii))) = clon;
    
    
    clat = clat2+latstep;
    clear lvar clon
end
Glat2(1) = [];Glon2(1) = [];

% it appears there is something fishy with this one file's grid. 
% Otherwise all agree and the same grid can be used. 
% In the case of this weird file it seems that it should be on the same
% grid but number of grid points on some gridlines is wrong by ~1.




%% translate the data - assign to grid points based on R constants 












































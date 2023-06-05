% Jacob Arnold

% 05-Aug-2021

% Fix consecutive dates issue in the concatenated e00 dataset. 
% There are 9 occurrences of consecutive dn recordings due to separate
% sources files for each date. 
% Upon plotting all the polygons at these consecutive dates it has become
% apparent that the first date contains most of the data but is missing one
% or two sectors while the second date has the data for those missing
% sectors. 

% It appears that the first date is correct and the second date needs to be
% removed and the polygons and their data appended to the first.

load ICE/ICETHICKNESS/Data/MAT_files/e00_data/e00_data.mat
%%

Finds = [5 10 24 27 33 42 53 60 124];
subnum = 0;
tempData = e00_data;
for ee = 1:length(Finds)
   
    tempData.shpfiles{Finds(ee)}.ncst = [tempData.shpfiles{Finds(ee)}.ncst;tempData.shpfiles{Finds(ee)+1}.ncst];
    tempData.shpfiles{Finds(ee)}.dbfdata = [tempData.shpfiles{Finds(ee)}.dbfdata;tempData.shpfiles{Finds(ee)+1}.dbfdata];
    
    tempData.shpfiles{Finds(ee)}.dbf.CT = [tempData.shpfiles{Finds(ee)}.dbf.CT;tempData.shpfiles{Finds(ee)+1}.dbf.CT];
    tempData.shpfiles{Finds(ee)}.dbf.CA = [tempData.shpfiles{Finds(ee)}.dbf.CA;tempData.shpfiles{Finds(ee)+1}.dbf.CA];
    tempData.shpfiles{Finds(ee)}.dbf.SA = [tempData.shpfiles{Finds(ee)}.dbf.SA;tempData.shpfiles{Finds(ee)+1}.dbf.SA];
    tempData.shpfiles{Finds(ee)}.dbf.FA = [tempData.shpfiles{Finds(ee)}.dbf.FA;tempData.shpfiles{Finds(ee)+1}.dbf.FA];
    tempData.shpfiles{Finds(ee)}.dbf.CB = [tempData.shpfiles{Finds(ee)}.dbf.CB;tempData.shpfiles{Finds(ee)+1}.dbf.CB];
    tempData.shpfiles{Finds(ee)}.dbf.SB = [tempData.shpfiles{Finds(ee)}.dbf.SB;tempData.shpfiles{Finds(ee)+1}.dbf.SB];
    tempData.shpfiles{Finds(ee)}.dbf.FB = [tempData.shpfiles{Finds(ee)}.dbf.FB;tempData.shpfiles{Finds(ee)+1}.dbf.FB];
    tempData.shpfiles{Finds(ee)}.dbf.CC = [tempData.shpfiles{Finds(ee)}.dbf.CC;tempData.shpfiles{Finds(ee)+1}.dbf.CC];
    tempData.shpfiles{Finds(ee)}.dbf.SC = [tempData.shpfiles{Finds(ee)}.dbf.SC;tempData.shpfiles{Finds(ee)+1}.dbf.SC];
    tempData.shpfiles{Finds(ee)}.dbf.FC = [tempData.shpfiles{Finds(ee)}.dbf.FC;tempData.shpfiles{Finds(ee)+1}.dbf.FC];
    tempData.shpfiles{Finds(ee)}.dbf.CD = [tempData.shpfiles{Finds(ee)}.dbf.CD;tempData.shpfiles{Finds(ee)+1}.dbf.CD];
    tempData.shpfiles{Finds(ee)}.dbf.SD = [tempData.shpfiles{Finds(ee)}.dbf.SD;tempData.shpfiles{Finds(ee)+1}.dbf.SD];
    tempData.shpfiles{Finds(ee)}.dbf.FD = [tempData.shpfiles{Finds(ee)}.dbf.FD;tempData.shpfiles{Finds(ee)+1}.dbf.FD];
    
    tempData.shpfiles((Finds(ee)-subnum)+1) = [];
    subnum = subnum+1;
end

tempData.dn(Finds+1) = [];
tempData.dv(Finds+1,:) = [];

e00_data = tempData;

save('ICE/ICETHICKNESS/Data/MAT_files/e00_data/e00_data.mat', 'e00_data', '-v7.3');


% Jacob Arnold

% 30-Mar-2022

% Investigate the NIC ice charts - see how things change over time

% Consider 
% --> % of polygons with each sod designation
% --> % of polygons with 1,2,3,4 ice types




fnames=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt'],'%s');
% Create date variables
%____

%_____
dummyfn=char(fnames);
xx=nan(size(fnames)); 
ind=xx;
dn=xx;
B=isstrprop(dummyfn,'digit');
for ii=1:length(fnames);
    ind(ii)=find(B(ii,:)==1,1);
    yyyy(ii)=str2double(dummyfn(ii,ind(ii):ind(ii)+3));
    mm(ii)=str2double(dummyfn(ii,ind(ii)+4:ind(ii)+5));
    dd(ii)=str2double(dummyfn(ii,ind(ii)+6:ind(ii)+7));
    dn(ii)=datenum(yyyy(ii),mm(ii),dd(ii));

end
%clear ii yyyy mm dd xx B ind dummyfn fnames;
dv=datevec(dn);
% list of actual data file names
fnames=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesIT.txt'],'%s');

% sort list of actual data files in chronological order
fnames_T1=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITcor.txt'],'%s');
fnames_T2=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt'],'%s');
for ii = (1:length(fnames_T1));
    ind(ii) = find(ismember(fnames_T1, fnames_T2(ii)));
end 
ind = ind.';
fnames=fnames(ind); % ind are the indices of the sorted files
nshpfiles=cell(size(fnames));

% Read in Longitude and Latitude
tic
pool = parpool(feature('numcores')); % should open pool with max number of workers possible
parfor ii=1:length(fnames)
    disp([num2str(ii) ' of ' num2str(length(dn)) ' : Reading Shapefiles'])
    ff1=cell2mat(fnames(ii));
    ff2=['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/' ff1];
    nshpfiles{ii}=m_shaperead(ff2(1:end-4));
end
delete(pool);
toc
% for loop test (s01) elapsed time: 345.3 seconds
% parfor loop test (s01) elapsed time: 152.2 seconds
clear ii x y dd B;
disp('Shapefiles Opened')



% e00
load ICE/ICETHICKNESS/Data/MAT_files/e00_data/e00_data.mat;
e00_data.shpfiles(3) = []; % remove bad date
e00_data.dn(3) = [];
e00_data.dv(3,:) = [];
e00shpfiles = e00_data.shpfiles;
dn = e00_data.dn;
dv = e00_data.dv;


shpfiles = [e00shpfiles;nshpfiles];

clearvars -except shpfiles

%% Now analyse 

% THIS fragment of code would determine the % of polygons with certain ice
% types BUT I don't think it will provide any useful information. It has
% been abandoned at least for now. 

for ii = 1:length(shpfiles);
    tl = length(shpfiles{ii,1}.ncst);
    
    nine5(ii) = (length(find(shpfiles{ii,1}.dbf.SA==95)) + length(find(shpfiles{ii,1}.dbf.SB==95)) +...
        length(find(shpfiles{ii,1}.dbf.SC==95)) + length(find(shpfiles{ii,1}.dbf.SD==95)))/tl; % portion of polys with 98
    
    nine6(ii) = (length(find(shpfiles{ii,1}.dbf.SA==96)) + length(find(shpfiles{ii,1}.dbf.SB==96)) +...
        length(find(shpfiles{ii,1}.dbf.SC==96)) + length(find(shpfiles{ii,1}.dbf.SD==96)))/tl; % portion of polys with 98
    






































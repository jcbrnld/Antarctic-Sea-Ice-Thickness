% Jacob Arnold

% 21-Sep-2022

% check all shapefiles for bad data and record their dates
% Search for two conditions: 1. more than one S defined but C missing/99
%                            2. C defined but S missing/99

% REMEMBER if only 1 S (one ice type) CA should not be defined
% Save number of scenarios 1 and 2 found each week

disp('Loading in E00-based files')
% start with earlier E00 data
 load ICE/ICETHICKNESS/Data/MAT_files/e00_data/e00_data.mat;
e00_data.shpfiles(3) = []; % remove bad date
e00_data.dn(3) = [];
e00_data.dv(3,:) = [];
shpfiles = e00_data.shpfiles;
dn = e00_data.dn;
dv = e00_data.dv;
clear e00_data

disp('Checking E00-based')
counter = 0:10:1000;
for ii = 1:length(shpfiles)
    sfile = shpfiles{ii};
    if ismember(ii,counter)
        disp(['Checking shpfile ',num2str(ii)])
    end
    % create temporary variables to record all instances of scenarios 
    s1 = zeros(size(sfile.dbf.CT));
    s2 = s1;
    
    for jj = 1:length(s1)
        
        SA = str2num(sfile.dbf.SA{jj});
        SB = str2num(sfile.dbf.SB{jj});
        SC = str2num(sfile.dbf.SC{jj});
        CA = str2num(sfile.dbf.CA{jj});
        CB = str2num(sfile.dbf.CB{jj});
        CC = str2num(sfile.dbf.CC{jj});
        if (isempty(SA)|SA==-9) & (isempty(SB)|SB==-9)
            continue
        end
        
        % type 1 
        if isfinite(SA) & SA~=99 & SA~=-9 & SA~=0 % SA IS REAL!
            if isfinite(SB) & SB~=99 & SB~=-9 & SB~=0 % SB IS REAL!
                if isfinite(CA) & CA~=99 & CA~=-9 & CA~=0 % CA IS REAL!
                    if isfinite(CB) & CB~=99 & CB~=-9 & CB~=0 % CB IS REAL!
                        if isfinite(SC) & SC~=99 & SC~=-9 & SC~=0 % SC IS REAL!
                            if isfinite(CC) & CC~=99 & CC~=-9 & CC~=0 % CC IS REAL!
                                s1(jj) = 0;
                            else
                                s1(jj) = 1; % SA, SB, SC but no CC
                            end
                        end
                    else
                        s1(jj) = 1; % SA and SB but no CB
                    end
                else
                    s1(jj) = 1; % SA and SB but no CA
                end
            end
        end
        
        % type 2
        if isfinite(CA) & CA~=99 & CA~=-9 & CA~=0 % CA IS REAL!
            if isfinite(SA) & SA~=99 & SA~=-9 & SA~=0 % SA IS REAL!
                if isfinite(CB) & CB~=99 & CB~=-9 & CB~=0 % CB IS REAL!
                    if isfinite(SB) & SB~=99 & SB~=-9 & SB~=0 % SB IS REAL!
                        if isfinite(CC) & CC~=99 & CC~=-9 & CC~=0 % CC IS REAL!
                            if isfinite(SC) & SC~=99 & SC~=-9 & SC~=0 % CA IS REAL!
                                s2(jj) = 0;
                            else
                                s2(jj) = 1; %CC but no SC
                            end
                        end
                    else
                        s2(jj) = 1; % CB but no SB
                    end
                end
            else 
                s2(jj) = 1; % CA but no SA
            end
        end
        
        clear SA SB SC CA CB CC
    end
   
    scenario1(ii,1) = sum(s1);
    scenario2(ii,1) = sum(s2);
    numpolys(ii,1) = length(s1);
    clear s1 s2
end
    

%%% load in newer non-E00 files
disp('Loading in newer shapefiles');
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
shpfiles=cell(size(fnames));

% Read in Longitude and Latitude
tic
pool = parpool(feature('numcores')); % should open pool with max number of workers possible
parfor ii=1:length(fnames)
    disp([num2str(ii) ' of ' num2str(length(dn)) ' : Reading Shapefiles'])
    ff1=cell2mat(fnames(ii));
    ff2=['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/' ff1];
    shpfiles{ii}=m_shaperead(ff2(1:end-4));
end
delete(pool);
toc
% for loop test (s01) elapsed time: 345.3 seconds
% parfor loop test (s01) elapsed time: 152.2 seconds
clear ii x y dd B;
disp('Shapefiles Opened')


%%% now check the newer (non-E00) files
disp('Checking newer shapefiles')
bump = length(scenario1);
counter = 0:10:1000;
for ii = 1:length(shpfiles)
    sfile = shpfiles{ii};
    if ismember(ii,counter)
        disp(['Checking shpfile ',num2str(ii)])
    end
    % create temporary variables to record all instances of scenarios 
    s1 = zeros(size(sfile.dbf.CT));
    s2 = s1;
    
    for jj = 1:length(s1)
        
        SA = str2num(sfile.dbf.SA{jj});
        SB = str2num(sfile.dbf.SB{jj});
        SC = str2num(sfile.dbf.SC{jj});
        CA = str2num(sfile.dbf.CA{jj});
        CB = str2num(sfile.dbf.CB{jj});
        CC = str2num(sfile.dbf.CC{jj});
        if (isempty(SA)|SA==-9) & (isempty(SB)|SB==-9)
            continue
        end
        
        % type 1 
        if isfinite(SA) & SA~=99 & SA~=-9 & SA~=0 % SA IS REAL!
            if isfinite(SB) & SB~=99 & SB~=-9 & SB~=0 % SB IS REAL!
                if isfinite(CA) & CA~=99 & CA~=-9 & CA~=0 % CA IS REAL!
                    if isfinite(CB) & CB~=99 & CB~=-9 & CB~=0 % CB IS REAL!
                        if isfinite(SC) & SC~=99 & SC~=-9 & SC~=0 % SC IS REAL!
                            if isfinite(CC) & CC~=99 & CC~=-9 & CC~=0 % CC IS REAL!
                                s1(jj) = 0;
                            else
                                s1(jj) = 1; % SA, SB, SC but no CC
                            end
                        end
                    else
                        s1(jj) = 1; % SA and SB but no CB
                    end
                else
                    s1(jj) = 1; % SA and SB but no CA
                end
            end
        end
        
        % type 2
        if isfinite(CA) & CA~=99 & CA~=-9 & CA~=0 % CA IS REAL!
            if isfinite(SA) & SA~=99 & SA~=-9 & SA~=0 % SA IS REAL!
                if isfinite(CB) & CB~=99 & CB~=-9 & CB~=0 % CB IS REAL!
                    if isfinite(SB) & SB~=99 & SB~=-9 & SB~=0 % SB IS REAL!
                        if isfinite(CC) & CC~=99 & CC~=-9 & CC~=0 % CC IS REAL!
                            if isfinite(SC) & SC~=99 & SC~=-9 & SC~=0 % CA IS REAL!
                                s2(jj) = 0;
                            else
                                s2(jj) = 1; %CC but no SC
                            end
                        end
                    else
                        s2(jj) = 1; % CB but no SB
                    end
                end
            else 
                s2(jj) = 1; % CA but no SA
            end
        end
        
        clear SA SB SC CA CB CC
    end
   
    scenario1(bump+ii,1) = sum(s1);
    scenario2(bump+ii,1) = sum(s2);
    numpolys(bump+ii,1) = length(s1);
    clear s1 s2
end


figure;
    plot(scenario1./numpolys); % fraction of polygons with scenario 1
    hold on
    plot(scenario2./numpolys);

%% 

figure; plot_dim(900,220);
plot(newdn, scenario1./numpolys.*100, 'linewidth', 1.1);
xticks(dnticker(1997,2022));
datetick('x', 'mm-yyyy', 'keepticks')
xlim([min(newdn)-50, max(newdn)+50]);
xtickangle(27)
grid on
ylabel(['% of polygons missing C'], 'fontsize', 13);
print('ICE/ICETHICKNESS/Figures/QC_Plots/Polys_Missing_C.png', '-dpng', '-r500');


%% Just look at % 99 S and % 99 C in each chart

disp('Loading in E00-based files')
% start with earlier E00 data
 load ICE/ICETHICKNESS/Data/MAT_files/e00_data/e00_data.mat;
e00_data.shpfiles(3) = []; % remove bad date
e00_data.dn(3) = [];
e00_data.dv(3,:) = [];
shpfiles = e00_data.shpfiles;
dn = e00_data.dn;
dv = e00_data.dv;
clear e00_data

disp('Checking E00-based')
counter = 0:10:1000;
for ii = 1:length(shpfiles)
    sfile = shpfiles{ii};
    if ismember(ii,counter)
        disp(['Checking shpfile ',num2str(ii)])
    end
    
    sa9 = zeros(size(sfile.dbf.SA)); sb9 = sa9; sc9 = sa9; 
    ca9 = sa9; cb9 = sa9; cc9 = sa9; ct9 = sa9;
    for jj = 1:length(sfile.dbf.SA)
        SA = str2num(sfile.dbf.SA{jj});
        SB = str2num(sfile.dbf.SB{jj});
        SC = str2num(sfile.dbf.SC{jj});
        CA = str2num(sfile.dbf.CA{jj});
        CB = str2num(sfile.dbf.CB{jj});
        CC = str2num(sfile.dbf.CC{jj});
        CT = str2num(sfile.dbf.CT{jj});
        
        if (isempty(SA)|SA==-9) & (isempty(SB)|SB==-9)
            continue
        end
        
        if SA==99
            sa9(jj) = 1;
        elseif SB==99
            sb9(jj) = 1;
        elseif SC==99
            sc9(jj) = 1;
        end
        
        if CA==99
            ca9(jj) = 1;
        elseif CB==99
            cb9(jj) = 1;
        elseif CC==99
            cc9(jj) = 1;
        end


        if CT==99
            ct9(jj) = 1;
        end
        
       
        
    end  
        
    totals(ii) = sum(sa9)+sum(sb9)+sum(sc9);
    totalc(ii) = sum(ca9)+sum(cb9)+sum(cc9);
    totalct(ii) = sum(ct9);

    all9(ii) = totals(ii)+totalc(ii)+totalct(ii);
        npoly(ii) = jj;
    clear sa9 sb9 sc9 ca9 cb9 cc9 ct9
end

    figure;
    plot(totals);
    hold on;
    plot(totalc);
    plot(all9);
    
        %%%
clear shpfiles 
disp('Loading in newer shapefiles');
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
shpfiles=cell(size(fnames));

% Read in Longitude and Latitude
tic
pool = parpool(feature('numcores')); % should open pool with max number of workers possible
parfor ii=1:length(fnames)
    disp([num2str(ii) ' of ' num2str(length(dn)) ' : Reading Shapefiles'])
    ff1=cell2mat(fnames(ii));
    ff2=['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/' ff1];
    shpfiles{ii}=m_shaperead(ff2(1:end-4));
end
delete(pool);
toc
% for loop test (s01) elapsed time: 345.3 seconds
% parfor loop test (s01) elapsed time: 152.2 seconds
clear ii x y dd B;
disp('Shapefiles Opened')


%%% now check the newer (non-E00) files
disp('Checking newer shapefiles')
bump = length(all9);
counter = 0:10:1000;

for ii = 1:length(shpfiles)
    sfile = shpfiles{ii};
    if ismember(ii,counter)
        disp(['Checking shpfile ',num2str(ii)])
    end
    
    sa9 = zeros(size(sfile.dbf.SA)); sb9 = sa9; sc9 = sa9; 
    ca9 = sa9; cb9 = sa9; cc9 = sa9; ct9 = sa9;
    for jj = 1:length(sfile.dbf.SA)
        SA = str2num(sfile.dbf.SA{jj});
        SB = str2num(sfile.dbf.SB{jj});
        SC = str2num(sfile.dbf.SC{jj});
        CA = str2num(sfile.dbf.CA{jj});
        CB = str2num(sfile.dbf.CB{jj});
        CC = str2num(sfile.dbf.CC{jj});
        CT = str2num(sfile.dbf.CT{jj});
        
        if (isempty(SA)|SA==-9) & (isempty(SB)|SB==-9)
            continue
        end
        
        if SA==99
            sa9(jj) = 1;
        elseif SB==99
            sb9(jj) = 1;
        elseif SC==99
            sc9(jj) = 1;
        end
        
        if CA==99
            ca9(jj) = 1;
        elseif CB==99
            cb9(jj) = 1;
        elseif CC==99
            cc9(jj) = 1;
        end


        if CT==99
            ct9(jj) = 1;
        end
        
       
        
    end  
    
    totals(bump+ii) = sum(sa9)+sum(sb9)+sum(sc9);
    totalc(bump+ii) = sum(ca9)+sum(cb9)+sum(cc9);
    totalct(bump+ii) = sum(ct9);

    %all9(bump+ii) = totals(ii)+totalc(ii)+totalct(ii);
        npoly(bump+ii) = jj;
    clear sa9 sb9 sc9 ca9 cb9 cc9 ct9
end


all9 = totals+totalc+totalct;
    figure;
    plot(totals);
    hold on;
    plot(totalc);
    plot(all9);




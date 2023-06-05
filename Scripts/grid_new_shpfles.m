% Jacob Arnold

% 01-Jan-2022

% Purpose: 
%   Project NEW shapefiles onto sector and zone grids and add to the
%   current gridded structures.
% First program of the new year!


% Chapter 1 - grid the data IF PROMPT TITLES ARE NOT VISIBLE SEE BELOW
% Box one asks "Are you operating from the Research directory?"
% If answer to box  is 'No', box 2 will appear asking for path from the root directory to Research
% Box three prompts selection of the sector to use


list={'Sector01', 'Sector02', 'Sector03', 'Sector04', 'Sector05', 'Sector06',...
    'Sector07', 'Sector08', 'Sector09', 'Sector10', 'Sector11', 'Sector12', 'Sector13',...
    'Sector14', 'Sector15', 'Sector16', 'Sector17', 'Sector18', 'Subpolar Atlantic',...
    'Subpolar Indian', 'Subpolar Pacific', 'ACC Atlantic', 'ACC Indian', 'ACC Pacific'};
[indx,tf] = listdlg('PromptString',{'Which sector do you wish to use?'},...
    'SelectionMode','single','ListString', list);
if indx<10
    sector = ['0', num2str(indx)];
elseif indx<19 & indx>9
    sector = num2str(indx);
elseif indx==19;sector = 'subpolar_ao_SIC_25km';elseif indx==20; sector='subpolar_io_SIC_25km';
elseif indx==21;sector='subpolar_po_SIC_25km';elseif indx==22; sector='acc_ao_SIC_25km';
elseif indx==23; sector='acc_io_SIC_25km';elseif indx==24; sector='acc_po_SIC_25km';
end

clear tf
    
% USING LOOP BELOW rather than selection above currently.

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Step 1 | read in the shapefiles
% 1.1 read in newer shapefiles (2003-2021+)

%for ii = 1:24;
for jj = 10:24
    if jj < 10
        sector = ['0',num2str(jj)];
    elseif jj > 9 & jj < 19
        sector = num2str(jj);
    elseif jj==19; sector = 'subpolar_ao_SIC_25km';elseif jj==20; sector='subpolar_io_SIC_25km';
    elseif jj==21; sector='subpolar_po_SIC_25km';elseif jj==22; sector='acc_ao_SIC_25km';
    elseif jj==23; sector='acc_io_SIC_25km';elseif jj==24; sector='acc_po_SIC_25km';
    end


    fnames=textread(['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/new_sfiles/newnames.txt'],'%s');
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
        yyyy(ii)=str2double(['20',dummyfn(ii,ind(ii):ind(ii)+1)]);
        mm(ii)=str2double(dummyfn(ii,ind(ii)+2:ind(ii)+3));
        dd(ii)=str2double(dummyfn(ii,ind(ii)+4:ind(ii)+5));
        dn(ii)=datenum(yyyy(ii),mm(ii),dd(ii));

    end

    dv=datevec(dn);

    shpfiles=cell(size(fnames));

    % Read in Longitude and Latitude
    for ii=1:length(fnames)
        disp([num2str(ii) ' of ' num2str(length(dn)) ' : Reading Shapefiles'])
        ff1=cell2mat(fnames(ii));
        ff2=['ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/' ff1];
        shpfiles{ii}=m_shaperead(ff2(1:end-4));
    end

    clear ii x y dd B;
    disp('Shapefiles Opened')
    disp(['Working on sector ',sector])

    savename = ['sector',sector,'_shpSIG.mat'];



    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Step 2 | load sector grid


    % load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/Concentration/ANT/sector18.mat')
    % long=sector18.goodlon;
    % latg = sector18.goodlat;
    % clear sector18

    % load('/Users/jacobarnold/Documents/Classes/Orsi/ICE/Concentration/ant-sectors/sector10.mat')
    % long=sector10.lon;
    % latg = sector10.lat;
    % clear sector10

    if length(sector)==2
        sect = load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);
    else
        sect = load(['ICE/Concentration/so-zones/25km_sic/',sector,'.mat']);

    end

    sectC = struct2cell(sect);

    long = sectC{1,1}.lon;
    latg = sectC{1,1}.lat;
    clear sect sectC



    % find xy coordinates of grid corresponding to shapefile coordinate system

    % vvv ** THIS IS THE OLD METHOD use the new (correct) method below 
    % ilon1 = (long+90).*-pi/180;
    % ilat1 = (90+latg).*105000;
    % [gx, gy] = pol2cart(ilon1, ilat1);
    % ^^^ **


    % THIS IS THE CORRECT version for converting lat/lon to polar stereographic xy of the shapefiles. 
    [gx,gy] = ll2ps(latg,long-180,'TrueLat',-60); % ** TrueLat of -60 is vital to a correct conversion



    SIT.H=single(nan(length(long),length(shpfiles)));
    SIT.sa=SIT.H;
    SIT.sb=SIT.H; 
    SIT.sc=SIT.H;
    SIT.sd=SIT.H;
    SIT.ca=SIT.H;
    SIT.cb=SIT.H;
    SIT.cc=SIT.H;
    SIT.ct=SIT.H;
    SIT.cd=SIT.H;

    disp('Acquired Grid')
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Step 3 | Project polys onto grid in xy space
    disp('Preparing to project polygons onto grid') 


    for ii=1:length(shpfiles);
        junk=cell2mat(shpfiles(ii));
        CA{ii}=single(str2double(junk.dbf.CA));
        SA{ii}=single(str2double(junk.dbf.SA));
        CB{ii}=single(str2double(junk.dbf.CB));
        SB{ii}=single(str2double(junk.dbf.SB));
        CC{ii}=single(str2double(junk.dbf.CC));
        SC{ii}=single(str2double(junk.dbf.SC));
        CT{ii}=single(str2double(junk.dbf.CT));
        if isfield(junk.dbf, 'SD')==1;
            SD{ii}=single(str2double(junk.dbf.SD));
        else
            SD{ii}=single(nan(size(CA{ii})));
        end
        if isfield(junk.dbf, 'CD')==1;
            CD{ii}=single(str2double(junk.dbf.CD));
        else
            CD{ii}=single(nan(size(CA{ii})));
        end
    end

    clear ii

    disp('start')
    for ii = 1:length(shpfiles)
        tic
        disp([num2str(ii) ' of ' num2str(length(shpfiles))]) % *
        tempsa=SA{ii};
        tempsb=SB{ii};
        tempsc=SC{ii};
        tempsd=SD{ii};
        tempca=CA{ii};
        tempcb=CB{ii};
        tempcc=CC{ii};
        tempct=CT{ii};
        tempcd=CD{ii};
        for jj = 1:length(shpfiles{ii,1}.ncst);
            px = shpfiles{ii,1}.ncst{jj,1}(:,1);
            py = shpfiles{ii,1}.ncst{jj,1}(:,2);
            ISIN = find(inpolygon(gx,gy,px,py)==1);
            SIT.sa(ISIN,ii)=tempsa(jj);
            SIT.sb(ISIN,ii)=tempsb(jj);
            SIT.sc(ISIN,ii)=tempsc(jj);
            SIT.sd(ISIN,ii)=tempsd(jj);
            SIT.ca(ISIN,ii)=tempca(jj);
            SIT.cb(ISIN,ii)=tempcb(jj);              
            SIT.cc(ISIN,ii)=tempcc(jj);
            SIT.ct(ISIN,ii)=tempct(jj);
            SIT.cd(ISIN,ii)=tempcd(jj);
        end
        toc
    end
    clear ii jj tempsa tempsb tempsc tempca tempcb tempcc tempct
    dnDup = dn; % problems with overwriting SIT.dn after original dn has been replaced. This duplication allows correction of this when/if necessary. 
    SIT.dn=dn; % Apply current (shapefile) dn to SIT structure because dn will be overwritten with SIC dn in next section
    SIT.dv=dv; % """"
    SIT.lon=long;
    SIT.lat=latg;

    clearvars -except SIT savename sector

    nSIT = SIT; clear SIT

    % Here need to load in the previous gridded file and concatenate
    load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/old_2/',savename]);
    
    oSIT = SIT; clear SIT
    
    
    if str2num(sector) == 08 | str2num(sector) == 13 | str2num(sector) == 15
        disp(['Secror ',sector])
        load(['ICE/ICETHICKNESS/Data/MAT_files//Final/Sectors/sector',sector,'.mat']);
        fSIT = SIT; clear SIT;
        
        rinds = fSIT.rm_gpoint{1};
        rminds = rinds(:,2);
        
        oSIT.H(rminds,:) = [];
        oSIT.sa(rminds,:) = [];
        oSIT.sb(rminds,:) = [];
        oSIT.sc(rminds,:) = [];
        oSIT.sd(rminds,:) = [];
        oSIT.ca(rminds,:) = [];
        oSIT.cb(rminds,:) = [];
        oSIT.cc(rminds,:) = [];
        oSIT.ct(rminds,:) = [];
        oSIT.cd(rminds,:) = [];
        oSIT.lon(rminds) = [];
        oSIT.lat(rminds) = [];
       
        clear fSIT
    end
        

    

    SIT.H = [oSIT.H, nSIT.H];
    SIT.sa = [oSIT.sa, nSIT.sa];
    SIT.sb = [oSIT.sb, nSIT.sb];
    SIT.sc = [oSIT.sc, nSIT.sc];
    SIT.sd = [oSIT.sd, nSIT.sd];
    SIT.ca = [oSIT.ca, nSIT.ca];
    SIT.cb = [oSIT.cb, nSIT.cb];
    SIT.cc = [oSIT.cc, nSIT.cc];
    SIT.ct = [oSIT.ct, nSIT.ct];
    SIT.cd = [oSIT.cd, nSIT.cd];
    SIT.dn = [oSIT.dn; nSIT.dn];
    SIT.dv = [oSIT.dv; nSIT.dv];
    SIT.lon = nSIT.lon;
    SIT.lat = nSIT.lat;

    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Step 4 | Save gridded raw data


    save(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/',savename], 'SIT', '-v7.3');

    disp(['Saved raw gridded data for sector', sector]) 
    
    clearvars

end








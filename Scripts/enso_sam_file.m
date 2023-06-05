% Jacob Arnold

% 01-Mar-2022

% ENSO and SAM
load ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector10.mat;

% THE NOAA sea surface temperature index
ENSO1 = textread('ICE/ENSO/Data/NOAA_ENSO.txt');
% grab just our era
ENSO = ENSO1(48:end,:);
% Match to our timescale

myENSO = nan(length(seaice.dn));
for ii = 1:length(seaice.dv(:,2))
    thecorrectrow = find(ENSO(:,1)==seaice.dv(ii,1));
    myENSO(ii) = ENSO(thecorrectrow, seaice.dv(ii,2)+1);

    clear thecorrectrow
    
end

figure;
plot(seaice.dn, myENSO);


indices.SST_ENSO = ENSO1;
indices.mySSTENSO = myENSO;
indices.mydn = seaice.dn;
indices.note = {'SLP_ENSO is the standard ENSO pressure anomaly between tahiti and darwin https://climatedataguide.ucar.edu/climate-data/southern-oscillation-indices-signal-noise-and-tahitidarwin-slp-soi',...
    'SST_ENSO is the original El Nino monthly sea surface temperature anomaly index from NOAA: https://origin.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/ONI_v5.php',...
    'SAM is the monthly pressure difference SAM index from Marshall, G. J., 2003: https://climatedataguide.ucar.edu/climate-data/marshall-southern-annular-mode-sam-index-station-based',...
    'my___ are indices on same temporal scale as sea ice thickness. These are not interpolated, rather they are projected so that all weeks within a month have that months index value'};


%% SAM

SAM1 = textread('ICE/SAM/Data/simpsam.txt');
SAM = SAM1(41:end,:);


% Match to our timescale
mySAM = nan(length(seaice.dn));
for ii = 1:length(seaice.dv(:,2))
    thecorrectrow = find(SAM(:,1)==seaice.dv(ii,1));
    mySAM(ii) = SAM(thecorrectrow, seaice.dv(ii,2)+1);

    clear thecorrectrow
    
end

figure;
plot(seaice.dn, mySAM);

indices.SAM = SAM1;
indices.mySAM = mySAM;


figure;
plot(seaice.dn, myENSO);
hold on
plot(seaice.dn, mySAM);
legend('ENSO', 'SAM')
xticks(dnticker(1997,2022));
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(30);
xlim([min(indices.mydn)-50, max(indices.mydn)+50]);




%% SLP enso index
% above I used sst anomaly enso index. 
% Lets compare this with the traditional "darwin anomaly" index
% Which is the SLP anomaly between tahiti and darwin


darwin1 = textread('ICE/ENSO/Data/darwin.anom_.txt');
darwin = darwin1(132:end-1,:); % last row is garbage

myDARWIN = nan(length(seaice.dn));
for ii = 1:length(seaice.dv(:,2))
    thecorrectrow = find(darwin(:,1)==seaice.dv(ii,1));
    if ~isempty(thecorrectrow)
        
        myDARWIN(ii) = darwin(thecorrectrow, seaice.dv(ii,2)+1);
        
    else
        myDARWIN(ii) = nan;
    end

    clear thecorrectrow
    
end


figure;
plot_dim(1200,200);
plot(indices.mydn, myENSO);
hold on
plot(indices.mydn, myDARWIN);
legend('SST ENSO', 'SLP ENSO')
xticks(dnticker(1997,2022));
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(30);
xlim([min(indices.mydn)-50, max(indices.mydn)+50]);

indices.SLP_ENSO = darwin;
indices.mySLPENSO = myDARWIN;


figure;
plot_dim(1200,200);
plot(indices.mydn, myDARWIN, 'linewidth', 1.5);
hold on
plot(indices.mydn, mySAM, 'linewidth', 1.5);
legend('SLP ENSO', 'SAM')
xticks(dnticker(1997,2022));
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(30);
xlim([min(indices.mydn)-50, max(indices.mydn)+50]);


% how about a sam-enso

sedif = mySAM-myDARWIN;

figure;
subplot(2,1,1)
plot_dim(1200,500);
plot(indices.mydn, sedif, 'linewidth', 1.5);
xticks(dnticker(1997,2022));
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(30);
xlim([min(indices.mydn)-50, max(indices.mydn)+50]);

subplot(2,1,2)
plot(seaice.dn, seaice.SIV, 'linewidth', 1.5);
xticks(dnticker(1997,2022));
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(30);
xlim([min(indices.mydn)-50, max(indices.mydn)+50]);



%%
save('ICE/ENSO_SAM/indices.mat', 'indices');




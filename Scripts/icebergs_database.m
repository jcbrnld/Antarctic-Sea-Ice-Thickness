% Jacob Arnold

% 17-Jan-2022



% read in icebergs from Antarctic Iceberg Database 
anames = textread('ICE/ICETHICKNESS/Data/Icebergs_Database/consol/anames.txt', '%s');
adate = []; alon = []; alat = [];

for ii = 1:length(anames)
    data = readmatrix(['ICE/ICETHICKNESS/Data/Icebergs_Database/consol/',anames{ii}]);

    datecol = find(data(1,:)>999999);
    latcol = find(data(1,:)<-30);
    latcol = latcol(1);
    loncol = latcol+1;

    % _________ translate date _________
    conv1 = num2str(data(:,datecol));
    yrs = str2num(conv1(:,1:4));
    day = str2num(conv1(:,5:7));

    startervec = yrs; startervec(:,2:3) = 1;
    datadn = datenum(startervec)+day-1;
    datadv = datevec(datadn);
    % __________________________________


    % m_basemap('p', [0,360], [-90,-50])
    % m_scatter(data(:,loncol), data(:,latcol), 10, datadn, 'filled')

    
    adate = [adate;datadn];
    alon = [alon; data(:,loncol)];
    alat = [alat; data(:,latcol)];


end




%%


uniqdn = unique(adate);

for ii = 1:length(uniqdn)
    loc = find(adate == uniqdn(ii));
    
    allalon{ii} = alon(loc);
    allalat{ii} = alat(loc);
    
end

allalon = allalon.';



startd = datenum(1997, 10, 27);
newrange = find(uniqdn >= startd);
dn = uniqdn(newrange);
lon = allalon(newrange);
lat = allalat(newrange);


%%


m_basemap('p', [0,360], [-90,-50])
for ii = 1:length(dn)
    m_plot(lon{ii}, lat{ii})
end

% Something wrong with the lon and lat readings. 
% Make sure they all import correctly







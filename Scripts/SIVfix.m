% Jacob Arnold

% 24-May-2022

% Recalculate SIV for all sectors and zones


% Start with the sectors
for ii = 0:18
    if ii < 10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    disp(['Fixing SIV in sector ',sector,'...'])
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/old_wrongSIV/sector',sector,'.mat']);
    if isfield(SIT, 'SIV')
        omsiv = nanmean(SIT.SIV);
        SIT.SIV = []; % get rid of the old
    else
        omsiv = sum((SIT.H./1000).*3.125, 1, 'omitnan');
    end
    

%    km^3 =      m  / m/km *  km^2  
    siv = sum((SIT.H./1000).*(3.125^2), 1, 'omitnan');
    
    SIT.SIV = siv;
    
    nmsiv = nanmean(SIT.SIV);
    disp(['Sector ',sector,'--> Old SIV: ',num2str(nanmean(omsiv)),' ||| New SIV: ',num2str(nanmean(nmsiv))])
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
    
end    
    
    
    
    
    
    
    
    
    
    
    
    
%% entire southern ocean


load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat

omsiv = nanmean(SIT.SIV);
SIT.SIV = []; % get rid of the old

siv = (sum((SIT.H(SIT.shelf,:)./1000).*(3.125^2), 1, 'omitnan') + sum((SIT.H(SIT.offshore,:)./1000).*(25^2),1,'omitnan'));
SIT.SIV = siv;

nmsiv = nanmean(SIT.SIV);
disp(['Southern Ocean --> Old SIV: ',num2str(omsiv),' ||| New SIV: ',num2str(nmsiv)])

save('ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat', 'SIT', '-v7.3');






%% Zones

names = {'offshore', 'subpolar_ao', 'subpolar_io', 'subpolar_po', 'acc_ao', 'acc_io', 'acc_po'};

for ii = 1:length(names);
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/old_wrongSIV/',names{ii},'.mat']);
    
    disp(['Fixing SIV in ',names{ii},'...'])
    
    if isfield(SIT, 'SIV')
        omsiv = nanmean(SIT.SIV);
        SIT.SIV = []; % get rid of the old
    else
        omsiv = sum((SIT.H./1000).*25, 1, 'omitnan');
    end
    

%    km^3 =      m  / m/km *  km^2  
    siv = sum((SIT.H./1000).*(25^2), 1, 'omitnan');
    
    SIT.SIV = siv;
    
    nmsiv = nanmean(SIT.SIV);
    disp([names{ii},'--> Old SIV: ',num2str(nanmean(omsiv)),' ||| New SIV: ',num2str(nanmean(nmsiv))])
    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Zones/',names{ii},'.mat'], 'SIT', '-v7.3');
    
    clearvars -except names
end





% Jacob Arnold

% 04-Aug-2021

% Make sea ice area and sea ice extent dataset for all sectors and zones


% for the 18 shelf sectors: 
gridParea = 3.125

for ii = 1:18
    if ii < 10
         
    elseif ii >= 10
        data1 = load(['ICE/Concentration/ant-sectors/sector',num2str(ii),'.mat']);
    end
    
    data2 = struct2cell(data1);
    
    SIA(:,ii) = sum(data2{1,1}.sic.*gridParea, 'omitnan'); 
    
    indicatorSIC = zeros(size(data2{1,1}.sic));
    inds = find(data2{1,1}.sic>=15); 
    indicatorSIC(inds) = 1;
    numpoints = sum(indicatorSIC);
    
    SIE(:,ii) = numpoints.*gridParea; 
    
    dn{ii} = data2{1,1}.dn;
    
    clear data1 data2 indicatorSIC inds numpoints
    
end



%% Calculate SIA and SIA in the zones

% zones: subpolar_po_SIC_SIM.mat subpolar_io_SIC_SIM.mat MISSING ao?
%        pfzone_SIC.mat  
%        sazone_SIC.mat
%        azone_SIC.mat
%        acc_po_SIC_SIM.mat acc_io_SIC_SIM.mat acc_ao_SIC_SIM.mat
% CHECK (plot) ALL THESE





























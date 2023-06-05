% Jacob Arnold

% 21-Jul-2021

% Check out newly converted .e00 files 
% Working on converting them to shapefiles


% load some examples:
Ross = m_shaperead('~/playground/test_data/all_regions/Convert2/ross000710_F/PAL');

Amer = m_shaperead('~/playground/test_data/all_regions/Convert2/amer000710_F/PAL');

Amun = m_shaperead('~/playground/test_data/all_regions/Convert2/amun000710_F/PAL');

Bell = m_shaperead('~/playground/test_data/all_regions/Convert2/bell000710_F/PAL');

Wedd = m_shaperead('~/playground/test_data/all_regions/Convert2/wedd000710_F/PAL');

Wilk = m_shaperead('~/playground/test_data/all_regions/Convert2/wilk000717_F/PAL');




figure
set(gcf, 'position', [500,600,1000,1000]);
for ii = 1:length(Ross.ncst)
    plot(Ross.ncst{ii}(:,2).*-1,Ross.ncst{ii}(:,1),'b');hold on
end

for ii = 1:length(Amer.ncst)
    plot(Amer.ncst{ii}(:,2).*-1,Amer.ncst{ii}(:,1),'c');hold on
end

for ii = 1:length(Amun.ncst)
    plot(Amun.ncst{ii}(:,2).*-1,Amun.ncst{ii}(:,1),'g');hold on
end

for ii = 1:length(Bell.ncst)
    plot(Bell.ncst{ii}(:,2).*-1,Bell.ncst{ii}(:,1),'r');hold on
end

for ii = 1:length(Wedd.ncst)
    plot(Wedd.ncst{ii}(:,2).*-1,Wedd.ncst{ii}(:,1),'m');hold on
end

for ii = 1:length(Wilk.ncst)
    plot(Wilk.ncst{ii}(:,2).*-1,Wilk.ncst{ii}(:,1),'color',[0.2,0.7,0.2]);hold on
end


% print('ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/Coverage.png','-dpng','-r400');


%% Practice appending 
% order: bell wedd amer wilk ross amun
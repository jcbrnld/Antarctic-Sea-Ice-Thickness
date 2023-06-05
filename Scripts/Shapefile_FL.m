% Jacob Arnold
% 27 September 2020
% 
% Read sea ice stage of development shapefiles




%sf = m_shaperead('Orsi/ICE/Stage_of_development/Hemispheric/antarc060821.shp')
% It seems to be looking for files in addition to the .shp

% sample with newly downloaded .zip folder:

sfW = m_shaperead('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/test/ANTARC151210');
sfWO = m_shaperead('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/test/tANTARC151210');
% THIS WORKS --> MUST HAVE ALL(ISH?) FILES IN THE ZIP FOLDER

% How to view data from shapefile?
m_basemap('a', [-180 180 20],[-80 -50 10]) % Third vector component is number of degrees between each line


% Jacob Arnold

% 01-Mar-2022

% load in atmospheric data and calculate divergence and curl 
% calculate dpdy or meridional pressure gradient across each sector

sector = '10';

% NEED TO COPY sector and segment ECMWF data from DATA drive to DATA_Baby

% FROM vewing the EMCWF data it looks like I need to reinterpolate to the
% sector grid (without using inpolygon) OR use .25 degree grid directly

% I think to make the dpdy index I can just use the .25 deg. grid but I
% should interpolate so that I have U10 V10 SST and sp on the grids and
% ready to go. 

%%

































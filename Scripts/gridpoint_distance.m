

% find coordinate point distance

R = 6373.0;

lon1 = deg2rad(sazone.goodlon(10000));
lon2 = deg2rad(sazone.goodlon(10001));
lat1 = deg2rad(sazone.goodlat(10000));
lat2 = deg2rad(sazone.goodlat(10001));

dlon = lon2-lon1;
dlat = lat2-lat1;

a = sin(dlat/2)^2 + cos(lat1) * cos(lat2) * sin(dlon/2)^2; % haversine formula

c = 2 * atan2(sqrt(a), sqrt(1 - a));
distance = R * c
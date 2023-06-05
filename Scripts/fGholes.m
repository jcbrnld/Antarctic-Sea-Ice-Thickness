% Jacob Arnold
% 23-May-2022

% Fix global holes



load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat

m_basemap('p', [0,360], [-90,-45]);
m_scatter(SIT.lon, SIT.lat, 10, [0.7,.7,.7],'filled')
n = find(sum(~isnan(SIT.H),2)==0);
m_scatter(SIT.lon(n), SIT.lat(n), 10, [0.7,0.2,0.2],'filled')


fillind = [];
%% Starting hunting

highlat = -69.65;
lowlat = -68;
highlon = 359.99;
lowlon = 358;

q1 = find(sum(~isnan(SIT.H),2)==0 & SIT.lat > highlat & SIT.lat < lowlat & SIT.lon > lowlon & SIT.lon < highlon);


m_scatter(SIT.lon(q1), SIT.lat(q1), 15, [0.2,0.7,0.4], 'filled');

answer = questdlg('keep these indices?');
if answer(1) == 'Y';
    fillind = [fillind; q1];
else
    disp('Give it another shot!')
    m_scatter(SIT.lon(q1), SIT.lat(q1), 15, [0.7,0.2,0.2],'filled');
end

% OK done. The indices to fill are 
% fillind =
% 
%        10408
%        54017
%        54018
%        54019
%        54020
%        10427
%        10428
%        10430
%        10410
%        10411
%        10412
%        10413
%        10422
%        10424
%        10432
%        10435
%        10438
%        10440
%        10442
%        10443
%        10446
%        10447
%        10448
%        10449
%        12651
%        54011
%        12652
%         2947
%         3096
%         3245
%         3395
%       122607
%         2946
%         3095
%         3244
%         3393
%         3394



%%

lo2fill = SIT.lon(fillind);
la2fill = SIT.lat(fillind);

[x2, y2] = ll2ps(double(la2fill), double(lo2fill));
[sx, sy] = ll2ps(double(SIT.lat), double(SIT.lon));

warning off
counter = 0:100:2000;
for ii = 1:length(SIT.dn);
    if ismember(ii, counter)
        disp(['Interpolated through ',num2str(ii), ' of ',num2str(length(SIT.dn)),'...'])
    end
    % only use grid points with data
    isd = find(~isnan(SIT.H(:,ii))); % isdata
    
    fH = griddata(sx(isd), sy(isd), double(SIT.H(isd,ii)), x2, y2);
    SIT.H(fillind, ii) = fH;
    
    clear fH
end

m_basemap('p', [0,360], [-90,-45]);
m_scatter(SIT.lon, SIT.lat, 10, [0.7,.7,.7],'filled')
n = find(sum(~isnan(SIT.H),2)==0);
m_scatter(SIT.lon(n), SIT.lat(n), 10, [0.7,0.2,0.2],'filled')

%%

save('ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat', 'SIT', '-v7.3');



%% Do same for global SIC


load ICE/Concentration/SO/so.mat;

m_basemap('p', [0,360], [-90,-45]);
m_scatter(SIC.lon, SIC.lat, 10, [0.7,.7,.7],'filled')
n = find(sum(~isnan(SIC.sic),2)==0);
m_scatter(SIC.lon(n), SIC.lat(n), 10, [0.7,0.2,0.2],'filled')


fillind = [];
%% Indices are different... have to convert
 
%load ICE/ICETHICKNESS/Data/MAT_files/Final/Southern_Ocean/so.mat;

ofillind = [10408
       54017
       54018
       54019
       54020
       10427
       10428
       10430
       10410
       10411
       10412
       10413
       10422
       10424
       10432
       10435
       10438
       10440
       10442
       10443
       10446
       10447
       10448
       10449
       12651
       54011
       12652
        2947
        3096
        3245
        3395
      122607
        2946
        3095
        3244
        3393
        3394];


for ii = 1:length(ofillind)
    loc = find(SIC.lon==SIT.lon(ofillind(ii)) & SIC.lat==SIT.lat(ofillind(ii)));
    fillind(ii,1) = loc;
    clear loc
end
clear SIT

%% Now that indices are converted can run this again.


flon = SIC.lon(fillind);
flat = SIC.lat(fillind);

[sx, sy] = ll2ps(double(SIC.lat), double(SIC.lon));
[fx, fy] = ll2ps(double(flat), double(flon));
warning off
counter = 0:100:20000;
for ii = 1:length(SIC.dn)

    if ismember(ii, counter)
        disp(['Interpolated through ',num2str(ii), ' of ',num2str(length(SIC.dn)),'...'])
    end
    % only use grid points with data
    isd = find(~isnan(SIC.sic(:,ii))); % isdata
    if isempty(isd)
        continue
    else
        fH = griddata(sx(isd), sy(isd), double(SIC.sic(isd,ii)), fx, fy);
        SIC.sic(fillind, ii) = fH;
    end
    
    clear fH
end




m_basemap('p', [0,360], [-90,-45]);
m_scatter(SIC.lon, SIC.lat, 20, nanmean(SIC.sic, 2), 'filled');
colorbar;
colormap(colormapinterp(mycolormap('ice'), 8));


%% And save SIC

save('ICE/Concentration/SO/so.mat', 'SIC', '-v7.3');

























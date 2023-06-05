% Jacob Arnold

% 01-Mar-2022

% Check out the sea ice motion data

sector = '10';

% from SIC datasets
load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);

figure;
plot_dim(1200,300);
ticker = dnticker(1997,2022);
sloc = find(SIC.dnuv==729690);
plot(SIC.dnuv(sloc:end), (sum(isnan(SIC.u(:,sloc:end)))./length(SIC.lon)).*100);
hold on
plot(SIC.dnuv(sloc:end), (sum(isnan(SIC.v(:,sloc:end)))./length(SIC.lon)).*100);
xticks(ticker);
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);
xlim([SIC.dnuv(sloc)-50, max(SIC.dnuv)+50]);
legend('U', 'V');
title(['Sector ',sector,' Sea Ice Motion %NaN']);
ylabel('% NaN')

%% 

load ICE/Concentration/ant-sectors/1978-2020-daily-25km-SIM.mat;

sloc = find(SIC.dnuv==729690);
dnuv = SIC.dnuv;

nu = u(:,:,sloc:end);
nv = v(:,:,sloc:end);
clear u v


ndn = dnuv(sloc:end);

lon2d = SIC.grid25km.lon;
lat2d = SIC.grid25km.lat;
lonuv = lon2d(:);
latuv = lat2d(:);

uvec = nan(103041, length(ndn));
vvec = uvec;
counter = 0:1000:10000;
for ii = 1:length(ndn)
    if ismember(ii,counter)
        disp(['Vectorizing ',num2str(ii),' of ',num2str(length(ndn))])
    end
    tu = nu(:,:,ii);
    tv = nv(:,:,ii);
    uvec(:,ii) = tu(:);
    vvec(:,ii) = tv(:);
    
    clear tu tv
end
clear lat2d lon2d nu nv

ticker = dnticker(1997,2022);
figure;
plot_dim(1200,300);
plot(ndn, (sum(isnan(uvec))./length(lonuv)).*100);
hold on
plot(ndn, (sum(isnan(vvec))./length(lonuv)).*100);
xticks(ticker)
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);
xlim([min(ndn)-50, max(ndn)+50]);
title('% nan SO 25 km sea ice motion');
legend('u', 'v');
% This plot essentially just shows seasonal variation


%% interpolate to sector

[x,y] = ll2ps(SIC.lat, SIC.lon);
[x25,y25] = ll2ps(latuv, lonuv);
K = boundary(double(x), double(y), 1);
bx = x(K); by = y(K);

inds = inpolygon(x25, y25, bx, by); % find 25 km indices within sector
% plot to verify/trim as necessary
[londom, latdom] = sectordomain(str2num(sector));
m_basemap('a', londom, latdom); 
m_scatter(lonuv(inds), latuv(inds), 250, 's','filled');
m_plot(SIC.lon(K), SIC.lat(K), 'r', 'linewidth', 1.1)
xlabel(['25 km grid points inside sector ',sector]);

su = uvec(inds,:); % su and sv are just within the sector
sv = vvec(inds,:);

% 25 km grid within sector in xy space
sx = x25(inds);
sy = y25(inds);


% interpolate
u3 = nan(length(SIC.lon), length(ndn));
v3 = u3;
counter = 0:500:10000;
for ii = 1:length(ndn)
    if ismember(ii, counter)
        disp(['Interpolating ',num2str(ii), ' of ',num2str(length(ndn))])
    end
    
    finu = find(isfinite(su(:,ii)));
    finv = find(isfinite(sv(:,ii)));
    if isempty(finu)==0
        
        u3(:,ii) = griddata(double(sx(finu)), double(sy(finu)), su(finu,ii), double(x), double(y));
    end
    if isempty(finv)==0
        v3(:,ii) = griddata(double(sx(finv)), double(sy(finv)), sv(finv,ii), double(x), double(y));
    end
    clear finu finv
end




%%
figure
plot(ndn, (sum(isnan(u3))./length(SIC.lon)).*100);


m_basemap('a', londom, latdom)
m_scatter(SIC.lon, SIC.lat, 20, u3(:,4000), 's', 'filled')

m_basemap('a', londom, latdom)
m_scatter(SIC.lon, SIC.lat, 20, SIC.u(:,6000+sloc-1), 's', 'filled')



% Jacob Arnold

% 02-Mar-2022

% reinterpolate ecmwf data to sectors

sector = '10';

for ss = [1:9,11:18]
    if ss < 10
        sector = ['0', num2str(ss)];
    else
        sector = num2str(ss);
    end
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/properties/sector',sector,'.mat']);

    data = load(['/Volumes/Data/Research/ECMWF/matfiles/segment',sector,'.mat']);
    data2 = struct2cell(data);
    ecmwf1 = data2{1,1}; clear data data2

    %%% convert lats and lons to xy

    [sx,sy] = ll2ps(seaice.lat, seaice.lon);
    [ex,ey] = ll2ps(ecmwf1.lat(:), ecmwf1.lon(:));

    % need to interpolate 
    % u10, v10, t2m, sst, sp, 
    nu = nan(length(seaice.lon), length(ecmwf1.dn));
    nv = nu; nt2m = nu; nsst = nu; nsp = nu;

    counter = 0:500:20000;
    for ii = 1:length(ecmwf1.dn)
        if ismember(ii,counter)
            disp(['Sector ',sector,' interpolating ',num2str(ii), ' of ', num2str(length(ecmwf1.dn))])
        end
        uii = ecmwf1.u10(:,:,ii);
        vii = ecmwf1.v10(:,:,ii);
        t2mii = ecmwf1.t2m(:,:,ii);
        sstii = ecmwf1.sst(:,:,ii);
        spii = ecmwf1.sp(:,:,ii);

        nu(:,ii) = griddata(double(ex), double(ey), uii(:), double(sx), double(sy));
        nv(:,ii) = griddata(double(ex), double(ey), vii(:), double(sx), double(sy));
        nt2m(:,ii) = griddata(double(ex), double(ey), t2mii(:), double(sx), double(sy));
        nsst(:,ii) = griddata(double(ex), double(ey), sstii(:), double(sx), double(sy));
        nsp(:,ii) = griddata(double(ex), double(ey), spii(:), double(sx), double(sy));



        clear uii vii t2mii sstii spii

    end


    % plot example figs

    [londom, latdom] = sectordomain(str2num(sector));
    m_basemap('a', londom, latdom);
    sectorexpand(str2num(sector));
    m_scatter(seaice.lon, seaice.lat, sectordotsize(str2num(sector)), nsst(:,7000), 's', 'filled')
    colormap(mycolormap('tur'))
    xlabel('SST after interpolation')


    m_basemap('a', londom, latdom);
    sectorexpand(str2num(sector));
    m_scatter(seaice.lon, seaice.lat, sectordotsize(str2num(sector)), nsp(:,7000), 's', 'filled')
    colormap(mycolormap('mist'))
    xlabel('Surf. Pres. after interpolation')



    m_basemap('a', londom, latdom);
    sectorexpand(str2num(sector));
    m_scatter(seaice.lon, seaice.lat, sectordotsize(str2num(sector)), nu(:,7000), 's', 'filled')
    colormap(mycolormap('mist'))
    xlabel('U vel after interpolation')

     m_basemap('a', londom, latdom);
    sectorexpand(str2num(sector));
    m_scatter(seaice.lon, seaice.lat, sectordotsize(str2num(sector)), nv(:,7000), 's', 'filled')
    colormap(mycolormap('mist'))
    xlabel('V vel after interpolation')

     m_basemap('a', londom, latdom);
    sectorexpand(str2num(sector));
    m_scatter(seaice.lon, seaice.lat, sectordotsize(str2num(sector)), nt2m(:,7000), 's', 'filled')
    colormap(mycolormap('mist'))
    xlabel('2 m air temp after interpolation')



    ecmwf.sst = nsst;
    ecmwf.lon = seaice.lon;
    ecmwf.lat = seaice.lat;
    ecmwf.dn = ecmwf1.dn;
    ecmwf.u10 = nu;
    ecmwf.v10 = nv;
    ecmwf.t2m = nt2m;
    ecmwf.sp = nsp;
    ecmwf.sst = nsst;

    save(['/Volumes/Data/Research/ECMWF/matfiles/sector',sector,'_ecmwf.mat'], 'ecmwf', '-v7.3');



    clearvars 

end






 
 

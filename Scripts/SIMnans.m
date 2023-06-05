% Jacob Arnold

% 04-Mar-2022

% SIM nans

load ICE/Motion/1978-2020-daily-25km-SIM.mat;
counter = 0:1000:20000;
for ii = 1:length(dn);
    if ismember(ii,counter)
        disp(['Vectorizing ',num2str(ii), ' of ', num2str(length(dn))])
    end
    
    tu = u(:,:,ii);
    tv = v(:,:,ii);
    
    nu(:,ii) = tu(:);
    %nv(:,ii) = tv(:);
    clear tu tv
    
end

lon = lon(:);
lat = lat(:);

lon(lon<0) = lon(lon<0)+360;

fin = find((sum(isnan(nu),2)./length(dn)) < 1);
clearvars -except fin lon lat;
    
for ss = 14:18;
    tic
    if ss < 10
        sector = ['0', num2str(ss)];
    else
        sector = num2str(ss);
    end
    
    disp(['Beginning sector ',sector,'...'])
    
    load(['ICE/Concentration/ant-sectors/sector',sector,'.mat']);

    allnan = find(sum(isnan(SIC.u),2)==length(SIC.dnuv));

    %

    [londom, latdom] = sectordomain(str2num(sector));
    m_basemap('m', londom, latdom); plot_dim(900,700);
    s1 = m_scatter(SIC.lon, SIC.lat, 30, [0.8,0.8,0.8], 'filled');
    s2 = m_scatter(SIC.lon(allnan), SIC.lat(allnan), 30, [0.9,0.5,0.6], 'filled');
    legend([s2,s1], 'Always NaN', 'Not Always NaN', 'fontsize', 13)
    title(['Sector ',sector,' Sea Ice Motion NaNs'], 'fontsize', 14)
    print(['ICE/ICETHICKNESS/Figures/Diagnostic/SIM/setor',sector,'SIMnans.png'], '-dpng', '-r400');

%
    ticker = (1977:2:2022)';
    ticker(:,2:3) = 1;
    ticker = datenum(ticker);
    figure;plot_dim(800,200);
    plot(SIC.dnuv, (sum(isnan(SIC.u))./length(SIC.lon)).*100);
    xticks(ticker);
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(30);
    xlim([min(SIC.dnuv)-100, max(SIC.dnuv)+100]);
    title(['Sector ',sector,' Sea Ice Motion % NaN']);
    ylabel('% NaN');
    print(['ICE/ICETHICKNESS/Figures/Diagnostic/SIM/sector',sector,'simpernans.png'], '-dpng', '-r400');

    % also check out where the actual dots fall
    m_basemap('m', londom, latdom)
    plot_dim(1000,800);
    s3 = m_scatter(SIC.lon, SIC.lat, 22, [0.99,0.85,0.85], 's','filled');
    s4 = m_scatter(lon, lat, 300, [0.8,0.8,0.8], 's', 'filled');
    s5 = m_scatter(lon(fin), lat(fin), 300, [0.5,0.8,0.6],'s', 'filled');
    title(['Sector ',sector,' 25km SIM data location'])
    legend([s3,s5,s4], ['Sector ',sector,' grid'], 'Sometimes has SIM data', 'Never has SIM data');
    print(['ICE/ICETHICKNESS/Figures/Diagnostic/SIM/sector',sector,'25kmSIM.png'], '-dpng', '-r400');

    
    clearvars -except lon lat fin
    
    toc
    
end








%%
dvuv1 = datevec(double(SIC.dnuv));
dvuv = dvuv1(7153:end,:);
sloc = find(dvuv(:,2)==12 | dvuv(:,2)==01 | dvuv(:,2)==02);

su = SIC.u(:,7153:end); % oct 1997 - dec 2020
sv = SIC.v(:,7153:end); % oct 1997 - dec 2020
mu = nanmean(su(:,sloc),2); 
mv = nanmean(sv(:,sloc),2);

[londom, latdom] = sectordomain(str2num(sector));
m_basemap('m', londom, latdom);
m_quiver(SIC.lon, SIC.lat, mu, mv);
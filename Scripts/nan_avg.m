% 06-Jul-2021

% Jacob Arnold


% Create plots of average %nan for each sector across the record length




for ii = 1:18
    disp(['Sector ',num2str(ii)])
   if ii<10
       sec = ['0',num2str(ii)];
   else
       sec = num2str(ii);
   end
   datai = load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sec,'.mat']);
   data = struct2cell(datai); clear datai;
   
   SITnans = isnan(data{1,1}.H);
   gridsize = length(SITnans(:,1));
   
   pernan = (sum(SITnans)./gridsize).*100;
   flags = find(pernan>20);

   figure;
   set(gcf, 'position', [500,600,1000,400]);
   plot(data{1,1}.dn, pernan, 'm', 'LineWidth', 1.2);
   grid on; 
   datetick('x', 'mm-yyyy')
   xlim([min(data{1,1}.dn),max(data{1,1}.dn)])
   set(gca,'XTickLabelRotation',35);
   %ylabel('Percent NaN');
   title(['Percent of Grid Points with NaN Values in Sector ',num2str(ii)]);
   for ff = 1:length(flags);
       text(data{1,1}.dn(flags(ff)), pernan(flags(ff))+2, ['index ',num2str(flags(ff))])
   end

   %set(gca, 'color', [0.2,0.2,0.2]); % change background color
   %ax = gca; ax.GridColor = [1,1,1]; % make grid white if you make background dark gray
   
   print(['ICE/ICETHICKNESS/Figures/Averages/Sector_',sec,'/SIT_Percent_nan_INDEX.png'], '-dpng', '-r400');
   
   
   close gcf; 
   clear data flags  SITnans gridsize pernan sec ; 
    
    
end




%% Now for SIC


load ICE/Concentration/ant-sectors/sector01.mat

SICnans = isnan(sector01.sic);
gridsize = length(SICnans(:,1));

pernan = (sum(SICnans)./gridsize).*100;

figure;
set(gcf, 'position', [500,600,1000,400]);
plot(double(sector01.dn), pernan, 'm', 'linewidth', 1.2);
datetick('x', 'mm-yyyy')
xlim([min(sector01.dn),max(sector01.dn)])
set(gca,'XTickLabelRotation',35);





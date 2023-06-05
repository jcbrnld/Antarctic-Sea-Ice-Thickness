% Jacob Arnold

% 02-sep-2021

% correct bad dn and year dv in sectors 1-12

for ii = 1:12
    if ii < 10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end

    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Full_length/sector',sector,'.mat']);

    allSIT.dv(866,1) = 1989;
    allSIT.dn = datenum(allSIT.dv);

    save(['ICE/ICETHICKNESS/Data/MAT_files/Final/Full_length/sector',sector,'.mat'], 'allSIT', '-v7.3');

    clearvars
end


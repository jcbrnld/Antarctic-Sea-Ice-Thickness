% Jacob Arnold

% 12-Jan-2021

% Fix sector dates
% Not all are the same but some have repeat dates.


% Test 
for ii = 1:18
    if ii == 06
        continue
    end
    if ii<10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
    
    differ{ii} = diff(SIT.dn);
    lendif = length(unique(SIT.dn));
    difdv = length(unique(SIT.dv,'rows')); % Should be the same but doesn't hurt to check
    
    disp(['Sector ',sector,': num dates = ',num2str(length(SIT.dn)),...
        ' num unique = ',num2str(lendif),' (dn) or ',num2str(difdv),' (dv)'])
    
    dn{ii} = SIT.dn;
    
    clearvars -except differ dn
    
end
    
    

%% 
% It appears there are three conditions: 941 original dates, 940 original
% dates, 930 original dates.
% 930 unique dates or 931 unique dates
    

% Sector 01: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 02: num dates = 940 num unique = 929 (dn) or 929 (dv)
% Sector 03: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 04: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 05: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 07: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 08: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 09: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 10: num dates = 930 num unique = 929 (dn) or 929 (dv)
% Sector 11: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 12: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 13: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 14: num dates = 940 num unique = 929 (dn) or 929 (dv)
% Sector 15: num dates = 940 num unique = 929 (dn) or 929 (dv)
% Sector 16: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 17: num dates = 941 num unique = 930 (dn) or 930 (dv)
% Sector 18: num dates = 940 num unique = 929 (dn) or 929 (dv)


%%
figure;
for ii = 1:18;
    if ii == 6;
        continue
    end
    %disp(['start: ',num2str(dn{ii}(1)), ' end ',num2str(dn{ii}(end))])
    
    
    plot(differ{ii});hold on

end

%%

% okay so the ones that are 941 long have the extra date in the third index
% which is why they end up with 930 uniques rather than 929 like the
% others. So need to remove third index IF is is 729704 (see rm_xtra_date.m)

% lets do this first then move on to the next issue

for ii = 1:18 % all sectors
    disp(['On Sector ', num2str(ii)])

    if ii<10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
    sz = size(SIT.icebergs);
    if sz(2)==1
        disp(['Sector ',sector,' still needs icebergs correction'])
        continue
    end
    clear sz
    if length(unique(SIT.dn))==930
        loc = find(SIT.dn==729704);
        if loc~=3
            disp(['Wrong loc, breaking']);
            break
        end
        SIT.dn(3) = [];
        SIT.H(:,3) = [];
        SIT.dv(3,:) = [];
        SIT.ca_hires(:,3) = [];
        SIT.cb_hires(:,3) = [];
        SIT.cc_hires(:,3) = [];
        SIT.cd_hires(:,3) = [];
        SIT.ct_hires(:,3) = [];
        SIT.sa(:,3) = [];
        SIT.sb(:,3) = [];
        SIT.sc(:,3) = [];
        SIT.sd(:,3) = [];
        SIT.ct(:,3) = [];
        SIT.ca(:,3) = [];
        SIT.cb(:,3) = [];
        SIT.cc(:,3) = [];
        SIT.cd(:,3) = [];
        SIT.icebergs(:,3) = [];
        SIT.rawicebergs(3) = [];
        SIT.icebergs_inds(3) = [];
        SIT.mavg.CA(:,3) = [];
        SIT.mavg.CB(:,3) = [];
        SIT.mavg.CC(:,3) = [];
        SIT.mavg.CD(:,3) = [];
        SIT.mavg.CT(:,3) = [];
        SIT.mavg.SA(:,3) = [];
        SIT.mavg.SB(:,3) = [];
        SIT.mavg.SC(:,3) = [];
        SIT.mavg.SD(:,3) = [];
        
        
        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat'], 'SIT', '-v7.3');
        
        
    end
    disp(['Sector',sector,': length dn = ',num2str(length(SIT.dn))])
    
    clearvars
end
    

%% SKIP
% It appears that diff of 1 day in 2019 was real - looked up the files on
% the national ice center website and found this. Should be fixed after
% interp1 to weekly timescale. 

% So all that is left to do is find and remove repeat dates



[C, IA, IC] = unique(dn{1});

counter = 0;clear rval
for ii = 1:length(C)
    cloc = find(dn{1}==C(ii));
    if length(cloc) ~= 1
        counter = counter+1;
        rval{counter} = cloc;
    end
    clear cloc
end

%%
% Wait I think there were a number of repeats in a row: 
% 899:908 repeat from 909:918
% So all we need to do is remove 899:908
% But include clause to make sure this is the case

% also a repeat at 305/306

for ii = 1:18
    disp(['On Sector ', num2str(ii)])

    if ii<10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    load(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat']);
    
    if length(SIT.dn) ~= 940;
        warning(['Sector ',sector,' Wrong Start Length'])
        continue
    end
        
    fvals = SIT.dn(899:908); svals = SIT.dn(909:918);
    fset = 899:908; sset = 909:918;
    
    if fvals == svals
        SIT.dn(fset) = [];
        SIT.H(:,fset) = [];
        SIT.dv(fset,:) = [];
        SIT.ca_hires(:,fset) = [];
        SIT.cb_hires(:,fset) = [];
        SIT.cc_hires(:,fset) = [];
        SIT.cd_hires(:,fset) = [];
        SIT.ct_hires(:,fset) = [];
        SIT.sa(:,fset) = [];
        SIT.sb(:,fset) = [];
        SIT.sc(:,fset) = [];
        SIT.sd(:,fset) = [];
        SIT.ct(:,fset) = [];
        SIT.ca(:,fset) = [];
        SIT.cb(:,fset) = [];
        SIT.cc(:,fset) = [];
        SIT.cd(:,fset) = [];
        SIT.icebergs(:,fset) = [];
        SIT.rawicebergs(fset) = [];
        SIT.icebergs_inds(fset) = [];
        SIT.mavg.CA(:,fset) = [];
        SIT.mavg.CB(:,fset) = [];
        SIT.mavg.CC(:,fset) = [];
        SIT.mavg.CD(:,fset) = [];
        SIT.mavg.CT(:,fset) = [];
        SIT.mavg.SA(:,fset) = [];
        SIT.mavg.SB(:,fset) = [];
        SIT.mavg.SC(:,fset) = [];
        SIT.mavg.SD(:,fset) = [];
        
    else
        warning(['Sector ',sector,' does not repeat 899:908 at 909:918'])
        
    end
    
    if SIT.dn(305) == SIT.dn(306);
        
        SIT.dn(305) = [];
        SIT.H(:,305) = [];
        SIT.dv(305,:) = [];
        SIT.ca_hires(:,305) = [];
        SIT.cb_hires(:,305) = [];
        SIT.cc_hires(:,305) = [];
        SIT.cd_hires(:,305) = [];
        SIT.ct_hires(:,305) = [];
        SIT.sa(:,305) = [];
        SIT.sb(:,305) = [];
        SIT.sc(:,305) = [];
        SIT.sd(:,305) = [];
        SIT.ct(:,305) = [];
        SIT.ca(:,305) = [];
        SIT.cb(:,305) = [];
        SIT.cc(:,305) = [];
        SIT.cd(:,305) = [];
        SIT.icebergs(:,305) = [];
        SIT.rawicebergs(305) = [];
        SIT.icebergs_inds(305) = [];
        SIT.mavg.CA(:,305) = [];
        SIT.mavg.CB(:,305) = [];
        SIT.mavg.CC(:,305) = [];
        SIT.mavg.CD(:,305) = [];
        SIT.mavg.CT(:,305) = [];
        SIT.mavg.SA(:,305) = [];
        SIT.mavg.SB(:,305) = [];
        SIT.mavg.SC(:,305) = [];
        SIT.mavg.SD(:,305) = [];
    else
        warning(['Sector ',sector,' does not repeat 305 at 306'])
        
    end
    
    % test
    disp(['Num unique (',num2str(length(unique(SIT.dn))),...
        ') minus totalnum (',num2str(length(SIT.dn)),') = ',...
        num2str(length(unique(SIT.dn))-length(SIT.dn))])
    
    if length(unique(SIT.dn))-length(SIT.dn) == 0
        save(['ICE/ICETHICKNESS/Data/MAT_files/Final/orig_timescale/Sectors/sector',sector,'.mat'],'SIT','-v7.3');
    else
        warning(['Sector ',sector,' lengths do not match'])
    end
    
end



% On Sector 1
% Num unique (919) minus totalnum (919) = 0
% On Sector 2
% Num unique (919) minus totalnum (919) = 0
% On Sector 3
% Num unique (919) minus totalnum (919) = 0
% On Sector 4
% Num unique (919) minus totalnum (919) = 0
% On Sector 5
% Num unique (919) minus totalnum (919) = 0
% On Sector 6
% Num unique (919) minus totalnum (919) = 0
% On Sector 7
% Num unique (919) minus totalnum (919) = 0
% On Sector 8
% Num unique (919) minus totalnum (919) = 0
% On Sector 9
% Num unique (919) minus totalnum (919) = 0
% On Sector 10
% Warning: Sector 10 Wrong Start Length 
% On Sector 11
% Num unique (919) minus totalnum (919) = 0
% On Sector 12
% Num unique (919) minus totalnum (919) = 0
% On Sector 13
% Num unique (919) minus totalnum (919) = 0
% On Sector 14
% Num unique (919) minus totalnum (919) = 0
% On Sector 15
% Num unique (919) minus totalnum (919) = 0
% On Sector 16
% Num unique (919) minus totalnum (919) = 0
% On Sector 17
% Num unique (919) minus totalnum (919) = 0
% On Sector 18
% Num unique (919) minus totalnum (919) = 0

























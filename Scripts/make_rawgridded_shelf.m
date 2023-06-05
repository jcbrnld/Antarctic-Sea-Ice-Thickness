% Jacob Arnold

% 16-Feb-2022

% Make entire shelf raw gridded ice chart file 
% NOT FINISHED. NEEd to account for different dn sizes 

% initialize
nsit.sa = []; nsit.sb = []; nsit.sc = []; nsit.sd = [];
nsit.ca = []; nsit.cb = []; nsit.cc = []; nsit.cd = []; nsit.ct = [];
nsit.lon = []; nsit.lat = [];
for ii = 1:18
    if ii < 10
        sector = ['0',num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpE00.mat']);
    E00 = SIT; clear SIT;
    load(['ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector',sector,'_shpSIG.mat']);
    SIG = SIT; clear SIT;
    
    if E00.dn(3) == 729704
        E00.sa(:,3) = []; E00.sb(:,3) = []; E00.sc(:,3) = []; E00.sd(:,3) = [];
        E00.ca(:,3) = []; E00.cb(:,3) = []; E00.cc(:,3) = []; E00.cd(:,3) = []; E00.ct(:,3) = [];
        E00.dn(3) = []; E00.dv(3,:) = [];
    end
        
    sa = [E00.sa, SIG.sa];
    sb = [E00.sb, SIG.sb];
    sc = [E00.sc, SIG.sc];
    sd = [E00.sd, SIG.sd];
    ca = [E00.ca, SIG.ca];
    cb = [E00.ca, SIG.cb];
    cc = [E00.ca, SIG.cc];
    cd = [E00.ca, SIG.cd];
    ct = [E00.ca, SIG.ct];
    
    nsit.ca = [nsit.ca; ca];
    nsit.cb = [nsit.cb; cb];
    nsit.cc = [nsit.cc; cc];
    nsit.cd = [nsit.cd; cd];
    nsit.ct = [nsit.ct; ct];
    nsit.sa = [nsit.sa; sa];
    nsit.sb = [nsit.sb; sb];
    nsit.sc = [nsit.sc; sc];
    nsit.sd = [nsit.sd; sd];
    
    nsit.lon = [nsit.lon; SIG.lon];
    nsit.lat = [nsit.lat; SIG.lat];
    
    nsit.dn = [E00.dn; SIG.dn];
    nsit.dv = [E00.dv; SIG.dv];
    
    
    clear sa sb sc sd ca cb cc cd ct E00 SIG
    
end


    
    %%
    
SIT = nsit; clear nsit

save('ICE/ICETHICKNESS/Data/MAT_files/Raw_Gridded/sector00_all.mat', 'SIT', '-v7.3');
    
    
    
    
    
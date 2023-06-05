% want to take sea ice thickness data to bi-weekly


% Originated by Cody Webb

% Jacob Arnold
%   26 Feb. 2021

% start with first file
% load /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/SabrinaSITqc.mat
% load /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/MertzSITqc.mat
%load /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/RossSITqc.mat
load /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/SabrinaSITqcT1.mat


icount1=0;
for i=(SIT.dn(1)+14):14:(SIT.dn(end)+11); % go by 2 weeks starting from the first date through the last
    disp(datevec(i))
    if i==SIT.dn(1)+14
        ind=find(SIT.dn<=i & SIT.dn>=(i-14));
    else
        ind=find(SIT.dn<=i & SIT.dn>(i-14));
    end
    disp(ind);
    icount1=icount1+1;
    if isfinite(ind)==1;
        if length(ind)>1;
            SITbw.H(:,icount1)=nanmean(SIT.H(:,ind(1):ind(end)),2);
            SITbw.sa(:,icount1)=nanmean(SIT.sa(:,ind(1):ind(end)),2);
            SITbw.sb(:,icount1)=nanmean(SIT.sb(:,ind(1):ind(end)),2);
            SITbw.sc(:,icount1)=nanmean(SIT.sc(:,ind(1):ind(end)),2);
            SITbw.ca(:,icount1)=nanmean(SIT.ca_hires(:,ind(1):ind(end)),2);
            SITbw.cb(:,icount1)=nanmean(SIT.cb_hires(:,ind(1):ind(end)),2);
            SITbw.cc(:,icount1)=nanmean(SIT.cc_hires(:,ind(1):ind(end)),2);
            SITbw.ct(:,icount1)=nanmean(SIT.ct_hires(:,ind(1):ind(end)),2);
        elseif length(ind)==1;
            SITbw.H(:,icount1)=SIT.H(:,ind);
            SITbw.sa(:,icount1)=SIT.sa(:,ind);
            SITbw.sb(:,icount1)=SIT.sb(:,ind);
            SITbw.sc(:,icount1)=SIT.sc(:,ind);
            SITbw.ca(:,icount1)=SIT.ca_hires(:,ind);
            SITbw.cb(:,icount1)=SIT.cb_hires(:,ind);
            SITbw.cc(:,icount1)=SIT.cc_hires(:,ind);
            SITbw.ct(:,icount1)=SIT.ct_hires(:,ind);
        end
    else
        SITbw.H(:,icount1)=NaN;
        SITbw.sa(:,icount1)=NaN;
        SITbw.sb(:,icount1)=NaN;
        SITbw.sc(:,icount1)=NaN;
        SITbw.ca(:,icount1)=NaN;
        SITbw.cb(:,icount1)=NaN;
        SITbw.cc(:,icount1)=NaN;
        SITbw.ct(:,icount1)=NaN;
    end
    SITbw.dn(icount1)=i-7;
    clear ind;
%     keyboard
%     pause
end
clear i icount1;
SITbw.dv=datevec(SITbw.dn);
SITbw.lon=SIT.lon;
SITbw.lat=SIT.lat;
clear SIT;
% save /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/SabrinaSITqcbw.mat SITbw -v7.3
% save /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/MertzSITqcbw.mat SITbw -v7.3
% save /Users/cody/matlab/codyiMac/ICETHICKNESS/MAT_files/RossSITqcbw.mat SITbw -v7.3
save /Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/MAT_files/SabrinaSITqcT1bw.mat SITbw -v7.3





% 13-Aug-2021

% Jacob Arnold

% Split up the strings containing gridline data for the older NIC charts. 
% Each string (in charts.data) contains a series of repeater constants and associated values
% for that grid point and how ever many additional are specified by the
% repeater constant. There is also a header line for each gridline (charts.headerlines) with details about the gridline 
% including ratio of lon/lat mesh width, the gridline number (should increase by one for each line),
% the number of points in the gridline (used for grid creation previously),
% and the number of lines the gridline origianlly spanned. This last piece
% is useless because I have put all sublines of a gridline in a single
% cell. 

% charts.data is 53x22 cell which houses data for up to 53 weeks by 22 years

load ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/charts

%% Create ct,ca,cb,cc,cd,sa,sb,sc,sd variables

entrysum = 0;
years = [1973:1:1994];
CT = nan(length(charts.lon),length(charts.dn));
CA = CT; CB = CT; CC = CT; CD = CT;
SA = CT; SB = CT; SC = CT; SD = CT;
FA = CT; FB = CT; FC = CT; FD = CT;
for ff = 1:length(charts.data(1,:))
    disp(['Working on ',num2str(years(ff))])
    for ss = 1:length(charts.data(:,ff))
        if isempty(charts.data{ss,ff})==0
            entrysum = entrysum+1;
            summer = 0;
        
            for ii = 1:length(charts.data{ss,ff})
            
                Line = charts.data{ss,ff}{ii};
                repeater = find(Line=='R');
                repeater(end+1) = length(Line);
                lengVars = diff(repeater);% lengVars should == 8 where only CT is defined and 6 where there is land
                for jj = 1:length(repeater)-1
                   rnum(jj) = str2num(Line(repeater(jj)+1:repeater(jj)+2));
                   summer = summer+rnum(jj);
                   lineseg = Line(repeater(jj):repeater(jj+1));
                   if Line(repeater(jj)+4)=='T' % So far so good. CT works and looks correct
                       CT((summer-rnum(jj))+1:summer, entrysum) = str2num(Line(repeater(jj)+5:repeater(jj)+6));
                   end
                   caloc = strfind(lineseg, 'CA');
                   cbloc = strfind(lineseg, 'CB');
                   ccloc = strfind(lineseg, 'CC');
                   cdloc = strfind(lineseg, 'CD');

                   if isempty(caloc)==0
                       CA((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(caloc+2:caloc+3));
                       SA((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(caloc+4:caloc+5));
                       FA((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(caloc+6:caloc+7));
                   end
                   if isempty(cbloc)==0
                       CB((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(cbloc+2:cbloc+3));
                       SB((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(cbloc+4:cbloc+5));
                       FB((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(cbloc+6:cbloc+7));
                   end
                   if isempty(ccloc)==0
                       CC((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(ccloc+2:ccloc+3));
                       SC((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(ccloc+4:ccloc+5));
                       FC((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(ccloc+6:ccloc+7));
                   end
                   if isempty(cdloc)==0
                       %CD((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(cdloc+2:cdloc+3)); % commented because CD only defines SD and CD = CT-(CA+CB+CC)
                       SD((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(cdloc+2:cdloc+3));
                       %FD((summer-rnum(jj))+1:summer, entrysum) = str2num(lineseg(cdloc+6:cdloc+7)); % commented because FD not specified
                   end
                   clear caloc cbloc ccloc cdloc lineseg

                end
                sums{ss,ff}(ii) = sum(rnum);

                clear repeater Line rnum
            end
        end


    end
end



%% create structure and save

charts_gridded.lon = charts.lon;
charts_gridded.lat = charts.lat;
charts_gridded.dn = charts.dn;
charts_gridded.dv = charts.dv;
charts_gridded.CT = CT;
charts_gridded.CA = CA;
charts_gridded.CB = CB;
charts_gridded.CC = CC;
charts_gridded.CD = CD;
charts_gridded.SA = SA;
charts_gridded.SB = SB;
charts_gridded.SC = SC;
charts_gridded.SD = SD;
charts_gridded.FA = FA;
charts_gridded.FB = FB;
charts_gridded.FC = FC;
charts_gridded.FD = FD;


save('ICE/ICETHICKNESS/Data/MAT_files/SIGRID1/charts_gridded', 'charts_gridded', '-v7.3');










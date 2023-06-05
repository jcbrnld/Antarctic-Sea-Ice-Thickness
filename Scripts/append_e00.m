% Jacob Arnold

% 22-Jul-2021

% Join all 6 regions of the e00 data (1997-2000) 
% the 6 regions are:
% bell wedd amer wilk ross amun

% and they will be joined/appended in that order




% Investigate redundant dates 
% bell = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/e00_data/Data/converted/1997');

ross971020_1 = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/1997/ross197102_F/PAL');
ross971020_2 = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/1997/ross297102_F/PAL');
ross971020_3 = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/1997/ross397102_F/PAL');

ross_test = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/1997/ross971027_F/PAL');


wilk971020_1 = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/1997/wilk197102_F/PAL');
wilk971020_4 = m_shaperead('ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/1997/wilk497102_F/PAL');



figure;
for ii = 1:length(ross_test.ncst)
    plot(ross_test.ncst{ii}(:,2), ross_test.ncst{ii}(:,1),'r')
    hold on
end
for ii = 1:length(ross971020_1.ncst)
    plot(ross971020_1.ncst{ii}(:,2), ross971020_1.ncst{ii}(:,1), 'm', 'linewidth', 1.2)
    hold on
end
for ii = 1:length(ross971020_2.ncst)
    plot(ross971020_2.ncst{ii}(:,2), ross971020_2.ncst{ii}(:,1), 'c', 'linewidth', 1.2)
    hold on
end
for ii = 1:length(ross971020_3.ncst)
    plot(ross971020_3.ncst{ii}(:,2), ross971020_3.ncst{ii}(:,1),'g', 'linewidth', 1.2)
    hold on
end
text(1200000,1500000,'Red=Ross example, other colors are Ross1,2,3 for that 1 date');

% print('ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/redundant_date.png','-dpng','-r400');
totaldn = [];
%% START HERE

% purpose:
% read in and join in useful chronological order shapefiles made from the older .e00 NIC data
% 
% change year and the last part of the sfilesyyyy variables to equal first 1997 then change a year ahead 
% on each pass through 2000. 
% 
% After running this section, hemispheric data from 2001 and 2002 will be loaded in and added. 
% Then run the last sectoin translating the varialb string to individual variables in the shpfile structure.

year_oper = {'1997','1998','1999','2000'};

for tt = 1:length(year_oper)
    
    year = year_oper{tt};
    fnames = textread(['ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/',year,'/names.txt'], '%s');
%     if year == "1997"
%         for gg = 1:35
%             
%             if fnames{gg}(5)~='9'
%                 fnames(gg)=[];
%             end
%         end
%     end
%             

    fnamesOld = fnames;



    dummyfn=char(fnames);
    xx=nan(size(fnames));
    ind=xx;
    dn=xx;
    B=isstrprop(dummyfn,'digit');
    for ii=1:length(fnames);
        ind(ii)=find(B(ii,:)==1,1);
        yyyy(ii)=str2double([year(1:2),dummyfn(ii,ind(ii):ind(ii)+1)]);
        mm(ii)=str2double(dummyfn(ii,ind(ii)+2:ind(ii)+3));
        dd(ii)=str2double(dummyfn(ii,ind(ii)+4:ind(ii)+5));
        dn(ii)=datenum(yyyy(ii),mm(ii),dd(ii));
    end
    clear ii;
    [dn,ind]=sort(dn,'ascend');
    dv=datevec(dn);
    fnames=fnames(ind);
    if year == "1997"
        fnames = fnames(6:length(fnames));
        dn = dn(6:length(dn));
        dv = dv(6:length(dv));
    end



    fnames_2 = cell2mat(fnames);
    allDates = unique(dn);
    regs = cell(length(allDates),6);

    for dd = 1:length(allDates)
        tloc = find(dn==allDates(dd));

        tbell = find(fnames_2(tloc,1)=='b' & fnames_2(tloc,4)=='l');
        twedd = find(fnames_2(tloc,1)=='w' & fnames_2(tloc,4)=='d');
        tamer = find(fnames_2(tloc,1)=='a' & fnames_2(tloc,4)=='r');
        twilk = find(fnames_2(tloc,1)=='w' & fnames_2(tloc,4)=='k');
        tross = find(fnames_2(tloc,1)=='r' & fnames_2(tloc,4)=='s');
        tamun = find(fnames_2(tloc,1)=='a' & fnames_2(tloc,4)=='n');

        regs{dd,1}=fnames_2(tloc(tbell),:);
        regs{dd,2}=fnames_2(tloc(twedd),:);
        regs{dd,3}=fnames_2(tloc(tamer),:);
        regs{dd,4}=fnames_2(tloc(twilk),:);
        regs{dd,5}=fnames_2(tloc(tross),:);
        regs{dd,6}=fnames_2(tloc(tamun),:);

        clear tloc tbell 
    end
%_____________________diagnostic________________________v
    % for qq = 1:length(allDates)
    %     num2000(qq) = length(find(dn==allDates(qq)));
    % end
    % 
    % figure;
    % set(gcf,'position',[500,600,1200,400]);
    % plot(num1997,'linewidth',1.2);hold on
    % plot(num1998,'linewidth',1.2);
    % plot(num1999,'linewidth',1.2);
    % plot(num2000,'linewidth',1.2);
    % ylim([0,7]);
    % legend('1997','1998','1999','2000')
    %print('ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/evaluating/numsectors_2000.png','-dpng','-r300');
%_____________________diagnostic________________________^

    clear ii dd qq

    %________________
    % load in by date

    dn = unique(dn);

    shpfiles = cell(size(regs));
    for ii = 1:length(regs(:,1))
        for jj = 1:6
            if isempty(regs{ii,jj})==1
                continue

            elseif isempty(regs{ii,jj})==0
                dval{ii} = regs{ii,jj}(5:10);
                if isfile(['ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/',year,'/',regs{ii,jj},'/PAL.shx']);
                    shpfiles{ii,jj} = m_shaperead(['ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/',year,'/',regs{ii,jj},'/PAL']);
                end
            end
        end



        clear dval
    end
    clear ii jj
    % view
    num=4;
    % figure
    % for ii = 1:6
    %     if isempty(shpfiles{num,ii})==0
    %         for jj = 1:length(shpfiles{num,ii}.ncst)
    %             plot(shpfiles{num,ii}.ncst{jj}(:,2).*-1,shpfiles{num,ii}.ncst{jj}(:,1));hold on
    %         end
    %     else
    %         continue
    %     end
    % end
    % clear ii jj


    %________________
    % Append all 6 at each date
    mod_shpfiles = cell(size(shpfiles));
    leng = zeros(size(shpfiles));
    for ii = 1:length(shpfiles(:,1))
        for jj = 1:length(shpfiles(1,:))
            if isempty(shpfiles{ii,jj})==0
                leng(ii,jj) = length(shpfiles{ii,jj}.fieldnames);

            
                if leng(ii,jj)>5
                    if shpfiles{ii,jj}.dbfdata{1,5}(1)=='C' | shpfiles{ii,jj}.dbfdata{1,5}(1)=='N'
                        mod_shpfiles{ii,jj}.dbfdata = shpfiles{ii,jj}.dbfdata(:,1:2);
                        mod_shpfiles{ii,jj}.dbfdata(:,3) = shpfiles{ii,jj}.dbfdata(:,5);

                    elseif shpfiles{ii,jj}.dbfdata{1,6}(1)=='C' | shpfiles{ii,jj}.dbfdata{1,6}(1)=='N'
                        mod_shpfiles{ii,jj}.dbfdata = shpfiles{ii,jj}.dbfdata(:,1:2);
                        mod_shpfiles{ii,jj}.dbfdata(:,3) = shpfiles{ii,jj}.dbfdata(:,6);
                    end
                else
                    mod_shpfiles{ii,jj}.dbfdata = shpfiles{ii,jj}.dbfdata(:,1:2);
                    mod_shpfiles{ii,jj}.dbfdata(:,3) = shpfiles{ii,jj}.dbfdata(:,5);
                end
            end
        end
    end


    new_shpfiles = cell(length(mod_shpfiles(:,1)),1);
    tempNcst={};
    tempDbfdata={};
    for ii = 1:length(mod_shpfiles(:,1))
        for jj = 1:6
            if isempty(mod_shpfiles{ii,jj})==0
                tempNcst=[tempNcst;shpfiles{ii,jj}.ncst];
                tempDbfdata=[tempDbfdata;mod_shpfiles{ii,jj}.dbfdata];

            else
                continue
            end


        end
        tempFieldnames = {'AREA','PERIMETER','ICECODE'};
        new_shpfiles{ii}.ncst = tempNcst;
        new_shpfiles{ii}.dbfdata = tempDbfdata;
        tempNcst={};
        tempDbfdata={};
        new_shpfiles{ii}.fieldnames = tempFieldnames;
        clear tempFieldnames
    end

    clear ii jj


    if year == "1997"
        totaldn=[];
        sfiles1997 = new_shpfiles;
    elseif year == "1998" 
        sfiles1998 = new_shpfiles;
    elseif year == "1999"
        sfiles1999 = new_shpfiles;
    elseif year == "2000"
        sfiles2000 = new_shpfiles;
    end
    totaldn = [totaldn;dn];
    clearvars -except sfiles1997 sfiles1998 sfiles1999 sfiles2000 totaldn year_oper
end
clear year_oper tt


%_____________________________________________________________
% import 2001 and 2002 data
year_oper = {'2001','2002'};
for bb = 1:2
    
    year = year_oper{bb};

    fnames = textread(['ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/',year,'/names.txt'], '%s');



    dummyfn=char(fnames);
    xx=nan(size(fnames));
    ind=xx;
    dn=xx;
    B=isstrprop(dummyfn,'digit');
    for ii=1:length(fnames);
        ind(ii)=find(B(ii,:)==1,1);
        yyyy(ii)=str2double([year(1:2),dummyfn(ii,ind(ii):ind(ii)+1)]);
        mm(ii)=str2double(dummyfn(ii,ind(ii)+2:ind(ii)+3));
        dd(ii)=str2double(dummyfn(ii,ind(ii)+4:ind(ii)+5));
        dn(ii)=datenum(yyyy(ii),mm(ii),dd(ii));
    end
    clear ii;
    [dn,ind]=sort(dn,'ascend');
    dv=datevec(dn);
    fnames=fnames(ind);



    shpfiles = cell(size(fnames));
    t_shpfiles = cell(length(shpfiles(:,1)),1);

    for ii = 1:length(shpfiles)
        shpfiles{ii,1} = m_shaperead(['ICE/ICETHICKNESS/Data/Stage_of_development/e00_Data/converted/',year,'/',fnames{ii},'/PAL']);

        t_shpfiles{ii}.ncst = shpfiles{ii}.ncst;
        t_shpfiles{ii}.dbfdata = shpfiles{ii}.dbfdata;
        t_shpfiles{ii}.fieldnames = shpfiles{ii}.fieldnames;

    end
    clear ii
    new_shpfiles = cell(length(t_shpfiles(:,1)),1);
    for jj = 1:length(new_shpfiles)
            if isempty(t_shpfiles{jj,1})==0
                leng(jj) = length(t_shpfiles{jj}.fieldnames);

            
                if leng(jj)>5
                    if (isempty(t_shpfiles{jj}.dbfdata{1,5})==0) & (t_shpfiles{jj}.dbfdata{1,5}(1)=='C' | t_shpfiles{jj}.dbfdata{1,5}(1)=='N')
                        new_shpfiles{jj}.dbfdata = t_shpfiles{jj}.dbfdata(:,1:2);
                        new_shpfiles{jj}.dbfdata(:,3) = t_shpfiles{jj}.dbfdata(:,5);

                    elseif (isempty(t_shpfiles{jj}.dbfdata{1,6})==0) & (t_shpfiles{jj}.dbfdata{1,6}(1)=='C' | t_shpfiles{jj}.dbfdata{1,6}(1)=='N')
                        new_shpfiles{jj}.dbfdata = t_shpfiles{jj}.dbfdata(:,1:2);
                        new_shpfiles{jj}.dbfdata(:,3) = t_shpfiles{jj}.dbfdata(:,6);
                        

                    elseif (isempty(t_shpfiles{jj}.dbfdata{2,5})==0) & (t_shpfiles{jj}.dbfdata{2,5}(1)=='C' | t_shpfiles{jj}.dbfdata{2,5}(1)=='N')
                        new_shpfiles{jj}.dbfdata = t_shpfiles{jj}.dbfdata(:,1:2);
                        new_shpfiles{jj}.dbfdata(:,3) = t_shpfiles{jj}.dbfdata(:,5);

                    elseif (isempty(t_shpfiles{jj}.dbfdata{2,6})==0) & (t_shpfiles{jj}.dbfdata{2,6}(1)=='C' | t_shpfiles{jj}.dbfdata{2,6}(1)=='N')
                        new_shpfiles{jj}.dbfdata = t_shpfiles{jj}.dbfdata(:,1:2);
                        new_shpfiles{jj}.dbfdata(:,3) = t_shpfiles{jj}.dbfdata(:,6);
                        
                    elseif (isempty(t_shpfiles{jj}.dbfdata{3,5})==0) & (t_shpfiles{jj}.dbfdata{3,5}(1)=='C' | t_shpfiles{jj}.dbfdata{3,5}(1)=='N')
                        new_shpfiles{jj}.dbfdata = t_shpfiles{jj}.dbfdata(:,1:2);
                        new_shpfiles{jj}.dbfdata(:,3) = t_shpfiles{jj}.dbfdata(:,5);

                    elseif (isempty(t_shpfiles{jj}.dbfdata{3,6})==0) & (t_shpfiles{jj}.dbfdata{3,6}(1)=='C' | t_shpfiles{jj}.dbfdata{3,6}(1)=='N')
                        new_shpfiles{jj}.dbfdata = t_shpfiles{jj}.dbfdata(:,1:2);
                        new_shpfiles{jj}.dbfdata(:,3) = t_shpfiles{jj}.dbfdata(:,6);
                        
                    elseif (isempty(t_shpfiles{jj}.dbfdata{4,5})==0) & (t_shpfiles{jj}.dbfdata{4,5}(1)=='C' | t_shpfiles{jj}.dbfdata{4,5}(1)=='N')
                        new_shpfiles{jj}.dbfdata = t_shpfiles{jj}.dbfdata(:,1:2);
                        new_shpfiles{jj}.dbfdata(:,3) = t_shpfiles{jj}.dbfdata(:,5);

                    elseif (isempty(t_shpfiles{jj}.dbfdata{4,6})==0) & (t_shpfiles{jj}.dbfdata{4,6}(1)=='C' | t_shpfiles{jj}.dbfdata{4,6}(1)=='N')
                        new_shpfiles{jj}.dbfdata = t_shpfiles{jj}.dbfdata(:,1:2);
                        new_shpfiles{jj}.dbfdata(:,3) = t_shpfiles{jj}.dbfdata(:,6);
                    end
                        
               
                else
                    new_shpfiles{jj}.dbfdata = t_shpfiles{jj}.dbfdata(:,1:2);
                    new_shpfiles{jj}.dbfdata(:,3) = t_shpfiles{jj}.dbfdata(:,5);
                end
            end
            new_shpfiles{jj}.ncst = t_shpfiles{jj}.ncst;
            new_shpfiles{jj}.fieldnames = {'AREA','PERIMETER','ICECODE'};
    end
        

    if year == "2001"
        sfiles2001 = new_shpfiles;
    elseif year == "2002"
        sfiles2002 = new_shpfiles;
    end

    totaldn = [totaldn;dn];



    clearvars -except sfiles1997 sfiles1998 sfiles1999 sfiles2000 sfiles2001 sfiles2002 totaldn year_oper 
end
clear year_oper ii bb

%%  Stitch all together into 1 variable and add them as subfields in ...dbf structure
 
new_shpfiles = [sfiles1997;sfiles1998;sfiles1999;sfiles2000;sfiles2001;sfiles2002];

for ii = 1:length(new_shpfiles)
    % disp(ii)
    tempt = size(new_shpfiles{ii}.dbfdata(1,:));
    t2(ii) = tempt(2);
    t3{ii} = new_shpfiles{ii}.dbfdata{1,3};
    clear tempt
end


%% translate value string to columns
% column 5
% order is: 
% 'CT',$ctval,'CA',$caval,$saval,$faval,'CB',$cbval,$sbval,$fbval,'CC',$ccval,$scval,$fcval,....sometimes CF,CN,CD
% Sometimes one or more of the last few can appear without CC
newNames = {'CT','CA','SA','FA','CB','SB','FB','CC','SC','FC','CD','SD','FD'};

for ii = 1:length(new_shpfiles)
    disp([num2str(ii),' of ',num2str(length(new_shpfiles))])
    
    % col_loc = find(new_shpfiles{ii,1}.fieldnames=="ICECODE"); % don't do this, the right column is always 5.
    col_loc = 3;
    new_shpfiles{ii}.fieldnames(col_loc+1:col_loc+13) = newNames(1:13);
   for jj = 1:length(new_shpfiles{ii}.dbfdata(:,col_loc))
       if (isempty(new_shpfiles{ii}.dbfdata{jj,col_loc})==0) &  (new_shpfiles{ii}.dbfdata{jj,col_loc}(1)=='C')
          Tloc = find(new_shpfiles{ii}.dbfdata{jj,col_loc}=='T');
          Aloc = find(new_shpfiles{ii}.dbfdata{jj,col_loc}=='A');
          Bloc = find(new_shpfiles{ii}.dbfdata{jj,col_loc}=='B');
          Cloc = strfind(new_shpfiles{ii}.dbfdata{jj,col_loc}, 'CC')+1; 
          Dloc = find(new_shpfiles{ii}.dbfdata{jj,col_loc}=='D');
          if isfinite(Tloc)==1
              tCT = new_shpfiles{ii}.dbfdata{jj,col_loc}(Tloc+1:Tloc+2);
          end
          if isfinite(Aloc)==1             
              
              if isfinite(str2num(new_shpfiles{ii}.dbfdata{jj,col_loc}(Aloc+1:Aloc+2)))==1
                  if isfinite(str2num(new_shpfiles{ii}.dbfdata{jj,col_loc}(Aloc+1:Aloc+6)))==1
                      tAs = new_shpfiles{ii}.dbfdata{jj,col_loc}(Aloc+1:Aloc+6);
                          tCA = tAs(1:2);
                          tSA = tAs(3:4);
                          tFA = tAs(5:6);
                  else
                      tAs = new_shpfiles{ii}.dbfdata{jj,col_loc}(Aloc+1:Aloc+2);
                      tCA = -9;
                      tSA = tAs;
                      tFA = -9;
                  end
              else
                  tCA = -9; tSA = -9; tFA = -9;
              end
              
              % above ifif here again
              if isfinite(str2num(new_shpfiles{ii}.dbfdata{jj,col_loc}(Bloc+1:Bloc+2)))==1
                  if isfinite(str2num(new_shpfiles{ii}.dbfdata{jj,col_loc}(Bloc+1:Bloc+6)))==1
                      tBs = new_shpfiles{ii}.dbfdata{jj,col_loc}(Bloc+1:Bloc+6);
                          tCB = tBs(1:2);
                          tSB = tBs(3:4);
                          tFB = tBs(5:6);
                  else
                      tBs = new_shpfiles{ii}.dbfdata{jj,col_loc}(Bloc+1:Bloc+2);
                      tCB = -9;
                      tSB = tBs;
                      tFB = -9;
                  end
              else
                  tCB = -9; tSB = -9; tFB = -9;
              end
              if isfinite(str2num(new_shpfiles{ii}.dbfdata{jj,col_loc}(Cloc+1:Cloc+2)))==1
                  if isfinite(str2num(new_shpfiles{ii}.dbfdata{jj,col_loc}(Cloc+1:Cloc+6)))==1
                      tCs = new_shpfiles{ii}.dbfdata{jj,col_loc}(Cloc+1:Cloc+6);
                          tCC = tCs(1:2);
                          tSC = tCs(3:4);
                          tFC = tCs(5:6);
                  else
                      tCs = new_shpfiles{ii}.dbfdata{jj,col_loc}(Cloc+1:Cloc+2);
                      tCC = -9;
                      tSC = tAs;
                      tFC = -9;
                  end
              else
                  tCC = -9; tSC = -9; tFC = -9;
              end
              if isfinite(str2num(new_shpfiles{ii}.dbfdata{jj,col_loc}(Dloc+1:Dloc+2)))==1
                  tDs = new_shpfiles{ii}.dbfdata{jj,col_loc}(Dloc+1:Dloc+2);
                  tCD = -9;
                  tSD = tDs;
                  tFD = -9;
              else
                  tCD = -9; tSD = -9; tFD = -9;
              end
               new_shpfiles{ii}.dbfdata{jj,4} = tCT;
               new_shpfiles{ii}.dbfdata{jj,5} = tCA;
               new_shpfiles{ii}.dbfdata{jj,6} = tSA;
               new_shpfiles{ii}.dbfdata{jj,7} = tFA;
               new_shpfiles{ii}.dbfdata{jj,8} = tCB;
               new_shpfiles{ii}.dbfdata{jj,9} = tSB;
               new_shpfiles{ii}.dbfdata{jj,10} = tFB;
               new_shpfiles{ii}.dbfdata{jj,11} = tCC;
               new_shpfiles{ii}.dbfdata{jj,12} = tSC;
               new_shpfiles{ii}.dbfdata{jj,13} = tFC;
               new_shpfiles{ii}.dbfdata{jj,14} = tCD;
               new_shpfiles{ii}.dbfdata{jj,15} = tSD;
               new_shpfiles{ii}.dbfdata{jj,16} = tFD;
               
               new_shpfiles{ii}.dbf.CT{jj,1} = tCT;
               new_shpfiles{ii}.dbf.CA{jj,1} = tCA;
               new_shpfiles{ii}.dbf.SA{jj,1} = tSA;
               new_shpfiles{ii}.dbf.FA{jj,1} = tFA;
               new_shpfiles{ii}.dbf.CB{jj,1} = tCB;
               new_shpfiles{ii}.dbf.SB{jj,1} = tSB;
               new_shpfiles{ii}.dbf.FB{jj,1} = tFB;
               new_shpfiles{ii}.dbf.CC{jj,1} = tCC;
               new_shpfiles{ii}.dbf.SC{jj,1} = tSC;
               new_shpfiles{ii}.dbf.FC{jj,1} = tFC;
               new_shpfiles{ii}.dbf.CD{jj,1} = tCD;
               new_shpfiles{ii}.dbf.SD{jj,1} = tSD;
               new_shpfiles{ii}.dbf.FD{jj,1} = tFD;
               clear tCT tCA tSA tFA tCB tSB tFB tCC tSC tFC tCD tSD tFD
          end
       else
           new_shpfiles{ii}.dbfdata{jj,4} = 99;
           new_shpfiles{ii}.dbfdata{jj,5} = 99;
           new_shpfiles{ii}.dbfdata{jj,6} = 99;
           new_shpfiles{ii}.dbfdata{jj,7} = 99;
           new_shpfiles{ii}.dbfdata{jj,8} = 99;
           new_shpfiles{ii}.dbfdata{jj,9} = 99;
           new_shpfiles{ii}.dbfdata{jj,10} = 99;
           new_shpfiles{ii}.dbfdata{jj,11} = 99;
           new_shpfiles{ii}.dbfdata{jj,12} = 99;
           new_shpfiles{ii}.dbfdata{jj,13} = 99;
           new_shpfiles{ii}.dbfdata{jj,14} = 99;
           new_shpfiles{ii}.dbfdata{jj,15} = 99;
           new_shpfiles{ii}.dbfdata{jj,16} = 99;

           new_shpfiles{ii}.dbf.CT{jj,1} = 99;
           new_shpfiles{ii}.dbf.CA{jj,1} = 99;
           new_shpfiles{ii}.dbf.SA{jj,1} = 99;
           new_shpfiles{ii}.dbf.FA{jj,1} = 99;
           new_shpfiles{ii}.dbf.CB{jj,1} = 99;
           new_shpfiles{ii}.dbf.SB{jj,1} = 99;
           new_shpfiles{ii}.dbf.FB{jj,1} = 99;
           new_shpfiles{ii}.dbf.CC{jj,1} = 99;
           new_shpfiles{ii}.dbf.SC{jj,1} = 99;
           new_shpfiles{ii}.dbf.FC{jj,1} = 99;
           new_shpfiles{ii}.dbf.CD{jj,1} = 99;
           new_shpfiles{ii}.dbf.SD{jj,1} = 99;
           new_shpfiles{ii}.dbf.FD{jj,1} = 99;
       end
       
           
       

   end
              
    
    
    
end


%% save shapefiles and dn,dv


e00_data.shpfiles = new_shpfiles;
e00_data.dn = totaldn;
e00_data.dv = datevec(totaldn);

save('ICE/ICETHICKNESS/Data/MAT_files/e00_data/e00_data.mat', 'e00_data', '-v7.3');








%% diagnostic

% Check for strange entries in the ICECODE column

counter = 0;
for ii = 1:length(new_shpfiles)
    
    for jj = 1:length(new_shpfiles{ii}.dbfdata(:,3))
        if isempty(new_shpfiles{ii}.dbfdata{jj,3})==0 
            if (new_shpfiles{ii}.dbfdata{jj,3}(1)~='C') & (new_shpfiles{ii}.dbfdata{jj,3}(1)~='N')
                counter=counter+1;
                oddOnes{counter,1} = new_shpfiles{ii}.dbfdata{jj,3};
                oddOnes{counter,2} = ii;oddOnes{counter,3}=jj;
            else 
                continue
            end
        end
    end
end

























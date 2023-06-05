% Jacob Arnold

% 05-Aug-2021
load ICE/ICETHICKNESS/Data/MAT_files/e00_data/e00_data_strings.mat
e00_orig = e00_data;

%%
% FIX missed interpretation of 'CT00'
ColLoc = nan(length(e00_data.shpfiles),1);

for ff = 1:length(e00_data.shpfiles)
    
   for ww = 1:length(e00_data.shpfiles{ff}.dbfdata(1,:))
       if isempty(e00_data.shpfiles{ff}.dbfdata{1,ww})==0
           if e00_data.shpfiles{ff}.dbfdata{1,ww}(1)=='C'
               ColLoc(ff) = ww;
           else
               ColLoc(ff) = 3;
           end
       end
   end
   
   for nn = 1:length(e00_data.shpfiles{ff}.dbfdata(:,1))
       if isempty(e00_data.shpfiles{ff}.dbfdata(nn,ColLoc(ff)))==0
           if string(e00_data.shpfiles{ff}.dbfdata(nn,ColLoc(ff)))=="CT00"
               if isempty(e00_data.shpfiles{ff}.dbfdata{nn,ColLoc(ff)+1})==1
                   e00_data.shpfiles{ff}.dbfdata{nn,ColLoc(ff)+1}=00;
                   for xx = 2:13
                       e00_data.shpfiles{ff}.dbfdata{nn,ColLoc(ff)+xx}=-9;
                   end
               else
                   %warning(['Not empty at file ',num2str(ff),' ind ', num2str(nn)]);
               end
           end
       end
       for cc = ColLoc(ff)+1:length(e00_data.shpfiles{ff}.dbfdata(1,:))
           if isstr(e00_data.shpfiles{ff}.dbfdata{nn,cc})==0
               e00_data.shpfiles{ff}.dbfdata{nn,cc} = num2str(e00_data.shpfiles{ff}.dbfdata{nn,cc});
           end
       
       end
   end
              
   for zz = 1:length(e00_data.shpfiles{ff}.dbf.CT) % we need the opposite of this... they need to be strings
      if isempty(e00_data.shpfiles{ff}.dbf.CT{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.CT{zz})==0
              e00_data.shpfiles{ff}.dbf.CT{zz} = num2str(e00_data.shpfiles{ff}.dbf.CT{zz});
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.CA{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.CA{zz})==0
              e00_data.shpfiles{ff}.dbf.CA{zz} = num2str(e00_data.shpfiles{ff}.dbf.CA{zz});              
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.SA{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.SA{zz})==0
              e00_data.shpfiles{ff}.dbf.SA{zz} = num2str(e00_data.shpfiles{ff}.dbf.SA{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.FA{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.FA{zz})==0
              e00_data.shpfiles{ff}.dbf.FA{zz} = num2str(e00_data.shpfiles{ff}.dbf.FA{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.CB{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.CB{zz})==0
              e00_data.shpfiles{ff}.dbf.CB{zz} = num2str(e00_data.shpfiles{ff}.dbf.CB{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.SB{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.SB{zz})==0
              e00_data.shpfiles{ff}.dbf.SB{zz} = num2str(e00_data.shpfiles{ff}.dbf.SB{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.FB{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.FB{zz})==0
              e00_data.shpfiles{ff}.dbf.FB{zz} = num2str(e00_data.shpfiles{ff}.dbf.FB{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.CC{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.CC{zz})==0
              e00_data.shpfiles{ff}.dbf.CC{zz} = num2str(e00_data.shpfiles{ff}.dbf.CC{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.SC{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.SC{zz})==0
              e00_data.shpfiles{ff}.dbf.SC{zz} = num2str(e00_data.shpfiles{ff}.dbf.SC{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.FC{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.FC{zz})==0
              e00_data.shpfiles{ff}.dbf.FC{zz} = num2str(e00_data.shpfiles{ff}.dbf.FC{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.CD{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.CD{zz})==0
              e00_data.shpfiles{ff}.dbf.CD{zz} = num2str(e00_data.shpfiles{ff}.dbf.CD{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.SD{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.SD{zz})==0
              e00_data.shpfiles{ff}.dbf.SD{zz} = num2str(e00_data.shpfiles{ff}.dbf.SD{zz});             
          end 
      end
      if isempty(e00_data.shpfiles{ff}.dbf.FD{zz})==0 
          if isstr(e00_data.shpfiles{ff}.dbf.FD{zz})==0
              e00_data.shpfiles{ff}.dbf.FD{zz} = num2str(e00_data.shpfiles{ff}.dbf.FD{zz});             
          end 
      end
      
      

   end
       
    
end

 save('ICE/ICETHICKNESS/Data/MAT_files/e00_data/e00_data.mat', 'e00_data', '-v7.3');


 %%
 % need to change from 00 to 55 in above locations
 
 for ff = 1:length(e00_data.shpfiles)
    
   for ww = 1:length(e00_data.shpfiles{ff}.dbfdata(1,:))
       if isempty(e00_data.shpfiles{ff}.dbfdata{1,ww})==0
           if e00_data.shpfiles{ff}.dbfdata{1,ww}(1)=='C'
               ColLoc(ff) = ww;
           else
               ColLoc(ff) = 3;
           end
       end
   end
   
   for nn = 1:length(e00_data.shpfiles{ff}.dbfdata(:,1))
       if isempty(e00_data.shpfiles{ff}.dbfdata(nn,ColLoc(ff)))==0
           if string(e00_data.shpfiles{ff}.dbfdata(nn,ColLoc(ff)))=="CT00"
              
                   e00_data.shpfiles{ff}.dbfdata{nn,ColLoc(ff)+1}='55';

               end
           end
       end
 end
 
 %% fix dbf fields with dbfdata columns 
 
 %olde = e00_data;
 
for ii = 1:length(e00_data.shpfiles)
    for ww = 1:length(e00_data.shpfiles{ii}.dbfdata(1,:))
        if isempty(e00_data.shpfiles{ii}.dbfdata{1,ww})==0
            if e00_data.shpfiles{ii}.dbfdata{1,ww}(1)=='C'
                ColLoc(ii) = ww;
            else
                ColLoc(ii) = 3;
            end
        end
    end
    e00_data.shpfiles{ii}.dbf.CT = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+1);
    e00_data.shpfiles{ii}.dbf.CA = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+2);
    e00_data.shpfiles{ii}.dbf.SA = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+3);
    e00_data.shpfiles{ii}.dbf.FA = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+4);
    e00_data.shpfiles{ii}.dbf.CB = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+5);
    e00_data.shpfiles{ii}.dbf.SB = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+6);
    e00_data.shpfiles{ii}.dbf.FB = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+7);
    e00_data.shpfiles{ii}.dbf.CC = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+8);
    e00_data.shpfiles{ii}.dbf.SC = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+9);
    e00_data.shpfiles{ii}.dbf.FB = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+10);
    e00_data.shpfiles{ii}.dbf.CD = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+11);
    e00_data.shpfiles{ii}.dbf.SD = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+12);
    e00_data.shpfiles{ii}.dbf.FD = e00_data.shpfiles{ii}.dbfdata(:,ColLoc(ii)+13);
    
    
    
end

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

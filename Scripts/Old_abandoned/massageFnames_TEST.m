%%
% NAME:
%   massageFnames.m
% PURPOSE:
%   creates a uniform date index of the filenames and sorts them
%   chrnologically, so that they can later be read into matlab

% Required Inputs: 
%     A .txt file of all the .shp filenames from the U.S. National Ice Center
%     Also requires creation of blank .txt files named 
%         fnamesITcor.txt 
%         fnamesITsortedcor.txt
%     in the same directory.

%       See make_txt_name_list_README for info on easily creating these. 
%   
% HISTORY:
%   Cody Webb
%   23 March 2016

%   Jacob Arnold
%   09 December 2020 
%   06 February 2021: 
%       Fixed the first loop below. It originally fixed filename references in fnames by looking for 
%       the first number in the name. If that first number was a
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%% massage filenames
% START in /Users/jacobarnold/Documents/Classes/Orsi/ICE 

% Load text file containing the filenames of interest
fnames=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesIT.txt','%s');
dummyfn=char(fnames);
% Find the first number that is part of the date in the filename
xx=nan(size(fnames));
ind=xx;
B=isstrprop(dummyfn,'digit');
for ii=1:length(fnames);
    ind(ii)=find(B(ii,:)==1,1);
    xx(ii)=str2double(dummyfn(ii,ind(ii)));
    if xx(ii)~=2;
        dummyfncor=[dummyfn(ii,1:ind(ii)-1) num2str(20) dummyfn(ii,ind(ii):end)];
        fnames(ii)=cellstr(dummyfncor);
        clear dummyfncor;
    end
end
clear ii;

fid=fopen('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITcor.txt','w');
for ii=1:length(fnames)
    fprintf(fid,'%s\n',fnames{ii,:});
end
fclose(fid);

clear ii fnames dummyfn B fid ind xx;

% read list of files back in with corrected dates
fnames=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITcor.txt','%s');
dummyfn=char(fnames);

% Find the first number that is part of the date in the filename
xx=nan(size(fnames));
ind=xx;
dn=xx;
B=isstrprop(dummyfn,'digit');
for ii=1:length(fnames);
    ind(ii)=find(B(ii,:)==1,1);
    yyyy(ii)=str2double(dummyfn(ii,ind(ii):ind(ii)+3));
    mm(ii)=str2double(dummyfn(ii,ind(ii)+4:ind(ii)+5));
    dd(ii)=str2double(dummyfn(ii,ind(ii)+6:ind(ii)+7));
    dn(ii)=datenum(yyyy(ii),mm(ii),dd(ii));
end
clear ii;
[dn,ind]=sort(dn,'ascend');
dv=datevec(dn);
fnames=fnames(ind);

fid=fopen('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt','w');
for ii=1:length(fnames)
    fprintf(fid,'%s\n',fnames{ii,:});
end
fclose(fid);

clear;

% test to see if the text file is correct
fnames=textread('/Users/jacobarnold/Documents/Classes/Orsi/ICE/ICETHICKNESS/Data/Stage_of_development/Hemispheric/fnamesITsortedcor.txt','%s'); 
    
    
    
    
    
    
    
    
    
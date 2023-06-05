% Jacob Arnold

% 05-oct-2021

% Join and save all the along track KM ICESat SIT data



% Join all TRACK Kurtz and Markus data into one structure and save as .mat file.
names={'ON03', 'FM04', 'MJ04', 'ON04', 'FM05', 'MJ05', 'FM06', 'MJ06',...
    'ON06', 'MA07', 'ON07', 'FM08'};


% Columns are lat, lon, Freeboard, Thickness

ON03 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/ON03.txt');
ON03(ON03==-999)=nan; ON03(:,1) = [];
%ON03(ON03==0)=nan;
ON03dn=datenum(2003,10,01):datenum(2003,11,18);ISatM(1,1)=median(ON03dn);

FM04 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/FM04.txt');
FM04(FM04==-999)=nan; FM04(:,1) = [];
%FM04(FM04==0)=nan;
FM04dn=datenum(2004,02,17):datenum(2004,03,21);ISatM(1,2)=median(FM04dn);
MJ04 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/MJ04.txt');
MJ04(MJ04==-999)=nan; MJ04(:,1) = [];
%MJ04(MJ04==0)=nan;
MJ04dn=datenum(2004,05,18):datenum(2004,06,21);ISatM(1,3)=median(MJ04dn);
ON04 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/ON04.txt');
ON04(ON04==-999)=nan; ON04(:,1) = [];
%ON04(ON04==0)=nan;
ON04dn=datenum(2004,10,03):datenum(2004,11,08);ISatM(1,4)=median(ON04dn);

FM05 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/FM05.txt');
FM05(FM05==-999)=nan; FM05(:,1) = [];
%FM05(FM05==0)=nan;
FM05dn=datenum(2005,02,17):datenum(2005,03,24);ISatM(1,5)=median(FM05dn);
MJ05 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/MJ05.txt');
MJ05(MJ05==-999)=nan; MJ05(:,1) = [];
%MJ05(MJ05==0)=nan;
MJ05dn=datenum(2005,05,20):datenum(2005,06,23);ISatM(1,6)=median(MJ05dn);

% Make example plot halfway through loading
m_basemap('p', [0,360], [-90,-45])
m_scatter(MJ05(:,2), MJ05(:,1), 1, MJ05(:,4), 'filled')

FM06 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/FM06.txt');
FM06(FM06==-999)=nan; FM06(:,1) = [];
%FM06(FM06==0)=nan;
FM06dn=datenum(2006,02,22):datenum(2006,03,27);ISatM(1,7)=median(FM06dn);
MJ06 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/MJ06.txt');
MJ06(MJ06==-999)=nan; MJ06(:,1) = [];
%MJ06(MJ06==0)=nan;
MJ06dn=datenum(2006,05,24):datenum(2006,06,26);ISatM(1,8)=median(MJ06dn);
ON06 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/ON06.txt');
ON06(ON06==-999)=nan; ON06(:,1) = [];
%ON06(ON06==0)=nan;
ON06dn=datenum(2006,10,25):datenum(2006,11,27);ISatM(1,9)=median(ON06dn);

MA07 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/MA07.txt');
MA07(MA07==-999)=nan; MA07(:,1) = [];
%MA07(MA07==0)=nan;
MA07dn=datenum(2007,03,12):datenum(2007,04,14);ISatM(1,10)=median(MA07dn);
ON07 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/ON07.txt');
ON07(ON07==-999)=nan; ON07(:,1) = [];
%ON07(ON07==0)=nan;
ON07dn=datenum(2007,10,02):datenum(2007,11,05);ISatM(1,11)=median(ON07dn);

FM08 = textread('ICE/ICETHICKNESS/Data/Altimetry_SIT/Kurtz_ICESat/Full_res/FM08.txt');
FM08(FM08==-999)=nan; FM08(:,1) = []
%FM08(FM08==0)=nan;
FM08dn=datenum(2008,02,17):datenum(2008,03,21);ISatM(1,12)=median(FM08dn);


% Create mat file of KM global data
%kmSIT.Cruises = ['ON03', 'FM04', 'MJ04', 'ON04', 'FM05', 'MJ05', 'FM06', 'MJ06', 'ON06', 'MA07', 'ON07', 'FM08'];
kmSIT.Cruises = names;


kmSIT.Tlon = {ON03(:,2), FM04(:,2), MJ04(:,2), ON04(:,2), FM05(:,2), MJ05(:,2), FM06(:,2), MJ06(:,2),...
    ON06(:,2), MA07(:,2), ON07(:,2), FM08(:,2)};
kmSIT.Tlat = {ON03(:,1), FM04(:,1), MJ04(:,1), ON04(:,1), FM05(:,1), MJ05(:,1), FM06(:,1), MJ06(:,1),...
    ON06(:,1), MA07(:,1), ON07(:,1), FM08(:,1)};


kmSIT.H = {ON03(:,4), FM04(:,4), MJ04(:,4), ON04(:,4), FM05(:,4), MJ05(:,4), FM06(:,4), MJ06(:,4),...
    ON06(:,4), MA07(:,4), ON07(:,4), FM08(:,4)};

kmSIT.Freeboard = {ON03(:,3), FM04(:,3), MJ04(:,3), ON04(:,3), FM05(:,3), MJ05(:,3), FM06(:,3), MJ06(:,3),...
    ON06(:,3), MA07(:,3), ON07(:,3), FM08(:,3)};


kmSIT.mid_dn = ISatM;
kmSIT.dn_range = {ON03dn.', FM04dn.', MJ04dn.', ON04dn.', FM05dn.', MJ05dn.', FM06dn.'...
    MJ06dn.', ON06dn.', MA07dn.', ON07dn.', FM08dn.'};

save('ICE/ICETHICKNESS/Data/MAT_files/Altimetry/KM_ICESat/kmSIT_track.mat', 'kmSIT');




function [lpos, xpos, s2pos, tickl, multfac] = sector_movie_params(sector, hascolorbar)

% Jacob Arnold
% 02-Feb-2022

% Define locational parameters for plotting a spatial plot of an AA shelf
% sector with a timeseries plot beneath. 
% This is best used to create movies of Sea Ice Thickness with a timeseries
% tracking below. 
% The spatial plot must be generated using m_basemap_subplot 
%   use sector_domain to establish lon and lat lims for basemap
%   use sectordotsize to define scatter grid dot sizes. 

% The three parameters defined here are:
%   lpos: the location of the legend within the spatial plot
%   xpos: the location of the xlabel -> falls right between the spatial plot and timeseries
%   s2pos: the location of the timeseries subplot
%   tickl: length of colorbar ticks (to divide sectioned colorbars)
%   multfac: how much to enlarge dots beyond prescribed dot size 

% Inputs are
% 1. [required] sector as a 2 digit character string
% 2. [optional] hascolorbar --> 0 [default] for no colorbar, 1 for colorbar.


if nargin ==1
    hascolorbar=0;
end

switch sector
    case {'01'}
        lpos = [0.260,0.81,.17,.05]; % [top left] sector 01,
        xpos = [0,-0.119]; % sector 01
        s2pos = [0.12,0.1365,0.77,0.13]; % sector 01, 07, 18, 03
        tickl = 0.029;
        multfac = 0.1;
    case {'02'}
        lpos = [0.7,0.75,.17,.05]; % [top right] sectors 10, 12, 09, 13, 16, 02
        xpos = [0,-0.087]; % sector 02
        s2pos = [0.12,0.15,0.77,0.13]; % sector 13, 02
        tickl = 0.037;
        multfac = 0.1;
    case {'03'}
        lpos = [0.20,0.75,.17,.05]; % [top left] sector 17, 07, 18, 03
        xpos = [0,-0.074]; % sector 03
        s2pos = [0.12,0.1365,0.77,0.13]; % sector 01, 07, 18, 03
        tickl = 0.027;
        multfac = 0.5;
    case {'04'}
        lpos = [0.20,0.65,.17,.05]; % [top left] sector 04
        xpos = [0,-0.0308]; % sector 11, 04
        s2pos = [0.12,0.3,0.77,0.13]; % sector 04
        tickl = 0.075;
        multfac = 0.1;
    case {'05'}
        lpos = [0.20,0.7,.17,.05]; % [top left] sector 05
        xpos = [0,-0.061]; % sector 15, 07, 05
        s2pos = [0.12,0.22,0.77,0.13]; % sector 11, 08, 05
        tickl = 0.05;
        multfac = 0.1;
    case {'06'}
        lpos = [0.7,0.70,.17,.05]; % [top right] sector 06, 14
        xpos = [0,-0.0272]; % sector 06
        s2pos = [0.12,0.26,0.77,0.13]; % sector 06
        tickl = 0.056;
        multfac = 0.7;
    case {'07'} 
        lpos = [0.20,0.75,.17,.05]; % [top left] sector 17, 07, 18, 03
        xpos = [0,-0.061]; % sector 15, 07, 05
        s2pos = [0.12,0.1365,0.77,0.13]; % sector 01, 07, 18, 03
        tickl = 0.033;
        multfac = 0.2;
    case {'08'}
        lpos = [0.67,0.41,.17,.05]; % [bottom right] sector 11, 08
        xpos = [0,-0.036]; % sector 09, 08
        s2pos = [0.12,0.22,0.77,0.13]; % sector 11, 08, 05
        tickl = 0.045;
        multfac = 0.5;
    case {'09'}
        lpos = [0.7,0.75,.17,.05]; % [top right] sectors 10, 12, 09, 13, 16, 02
        xpos = [0,-0.036]; % sector 09, 08
        s2pos = [0.12,0.2,0.77,0.13]; % sector 12, 09, 17
        tickl = 0.042;
        multfac = 0.4;
    case {'10'}
        lpos = [0.7,0.75,.17,.05]; % [top right] sectors 10, 12, 09, 13, 16, 02
        xpos = [0,-0.028]; % sector 10
        s2pos = [0.12,0.17,0.77,0.13]; % sector 10
        multfac = 0.4;
        tickl = 0.042;
    case {'11'}
        lpos = [0.67,0.41,.17,.05]; % [bottom right] sector 11, 08
        xpos = [0,-0.0308]; % sector 11, 04
        s2pos = [0.12,0.22,0.77,0.13]; % sector 11, 08, 05
        tickl = 0.047;
        multfac = 0.3;
    case {'12'}
        lpos = [0.7,0.75,.17,.05]; % [top right] sectors 10, 12, 09, 13, 16, 02
        xpos = [0,-0.045]; % sector 12
        s2pos = [0.12,0.2,0.77,0.13]; % sector 12, 09, 17
        tickl = 0.043;
        multfac = 0.3;
    case {'13'}
        lpos = [0.7,0.75,.17,.05]; % [top right] sectors 10, 12, 09, 13, 16, 02
        xpos = [0,-0.069]; % sector 13
        s2pos = [0.12,0.15,0.77,0.13]; % sector 13, 02
        tickl = 0.037;
        multfac = 0.01;
    case {'14'}
        lpos = [0.7,0.70,.17,.05]; % [top right] sector 06, 14
        xpos = [0,-0.097]; % sector 14
        s2pos = [0.12,0.182,0.77,0.13]; % sector 14, 15
        tickl = 0.04;
        multfac = 0.2;
    case {'15'}
        lpos = [0.599,0.45,.17,.05]; % [bottom right] sector 15
        xpos = [0,-0.061]; % sector 15, 07, 05
        s2pos = [0.12,0.182,0.77,0.13]; % sector 14, 15
        tickl = 0.043;
        multfac = 0.1;
    case {'16'}
        lpos = [0.7,0.75,.17,.05]; % [top right] sectors 10, 12, 09, 13, 16, 02
        xpos = [0,-0.065]; % sector 16
        s2pos = [0.12,0.165,0.77,0.13]; % sector 16
        tickl = 0.038;
        multfac = 0.01;
    case {'17'}
        lpos = [0.20,0.75,.17,.05]; % [top left] sector 17, 07, 18, 03
        xpos = [0,-0.076]; % sector 17
        s2pos = [0.12,0.2,0.77,0.13]; % sector 12, 09, 17
        tickl = 0.043;
        multfac = 0.2;
    case {'18'}
        lpos = [0.20,0.75,.17,.05]; % [top left] sector 17, 07, 18, 03
        xpos = [0,-0.093]; % sector 18
        s2pos = [0.12,0.1365,0.77,0.13]; % sector 01, 07, 18, 03
        tickl = 0.033;
        multfac = 1;
end


if hascolorbar==1
    xpos(2) = xpos(2)+xpos(2)*0.015; % move x label down by 1.5% 
end




end






        
function [zen,az,sunhours] = zenith(lat,lon,height,year,day,hour,min,sec)

% function [zen,az] = zenith(lat,lon,height,year,day,hour,min,sec)
%  Annika 1.4.2005, fixed for SH latitudes in 5.9.2016
%
% Calculates the solar zenith angle at altitude <height>. Returns  solar
% zenith angle and sunlit hours
%
% INPUT:
%  lat = latitude
%  lon = longitude
%  height = altitude in km from surface 
%
% Calls SUNzena

Re = 6371.0; %% Earth radius, approx
d2r = pi/180;

%% Calculate latitude that corresponds to altitude <height>

if lat >=0
    elat = lat - acos(Re/(Re+height))/d2r;
else
    elat = lat + acos(Re/(Re+height))/d2r;
end

[zen,az] = SUNzena(elat,lon,year,day,hour,min,sec);

sunhours=day_length(day,elat);

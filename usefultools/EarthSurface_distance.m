function dist = EarthSurface_distance(lat1,lon1,lat2,lon2)

% function dist = EarthSurface_distance(lat1,lon1,lat2,lon2)
% annika 30.3.2005
%
% Returns the approximate distance in km of two locations on the
% Earth surface.

Re = 6371; %% Earth radius in km

r1 = latlon2vec(lat1,lon1);
r2 = latlon2vec(lat2,lon2);

dist = Re * acos(dot(r1,r2));

function [r] = latlon2vec(lat,lon)

% function [r] = latlon2vec(lat,lon)
% annika 30.3.2005
%
% Returns unit point vector from Earth Center to point (lat,lon)
% INPUT:
%
%  lat = latitude in degrees 
%  lon = longitude in degrees
%
% OUTPUT:
%  r   = Unit vector


%% Longitude system independence
if lon < 0
  lon = 360 + lon;
end

%% Latitude to theta
lat = 90 - lat;

%% To radians
d2r = pi/180;

lat = d2r*lat;
lon = d2r*lon;

%% Point vector
r(1) = sin(lat)*cos(lon); 
r(2) = sin(lat)*sin(lon);
r(3) = cos(lat);

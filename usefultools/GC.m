function  [lat,lon] = GC(city1,city2)

% GC Returns Great Circle coordinates between two locations
% 
% function [lat,lon] = GC(city1,city2)
%
% Annika 19.8.2005
%
% INPUT:
%  city1 = (phi, theta), phi = lon, theta = 90 - lat
%  city2 = (phi, theta), phi = lon, theta = 90 - lat
%
% OUTPUT:
%  lat,lon = great circle coordinates (100 points)

Re = 6371e3;

phi1 = city1(1)*pi/180;
tht1 = city1(2)*pi/180;
[xp1,yp1,zp1] = sph2cart(tht1,phi1,Re);

phi2 = city2(1)*pi/180;
tht2 = city2(2)*pi/180;
[xp2,yp2,zp2] = sph2cart(tht2,phi2,Re);

%% Suunta vektori
X1 = [xp1 yp1 zp1];
X2 = [xp2 yp2 zp2];

X3 = X2 - X1;

X3_0 = X3./100;

t0 = X1;

for jj = 1:100

  t = t0 + X3_0;
  [lon(jj),lat(jj),r] = cart2sph(t(1),t(2),t(3));
  t0 = t;
  
end

lon = lon*180/pi;
lat = lat*180/pi;
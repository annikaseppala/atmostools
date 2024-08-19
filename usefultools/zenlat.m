function  [lat,sunhours] = zenlat(zen,height,year,day,hour,min,sec)
% ZENLAT Returns latitude which corresponds to given zenith angle
%
% function  [lat] = zenlat(zen,height,year,day,hour,min,sec)
%
% Finds the closest latitude (in 0.5 degree grid) at altitude
% <height> where the solar zenith angle is <zen>

lat0 = -90:0.5:90;

ero = 180;

zen0 = 0;

for ii = 1:length(lat0) %% Go through all latitudes
  [zen1,az,sunhour] = zenith(lat0(ii),0,height,year,day,hour,min,sec);
  while abs(zen1-zen) < ero
    ero = abs(zen1-zen);
    lat = lat0(ii);
    sunhours = sunhour;
    zen0 = zen1;
  end  

end

%% Check at the poles: is the zeinth condition fulfilled?
if (abs(lat)==90 & ceil(zen0) < zen)
  lat = NaN;
end

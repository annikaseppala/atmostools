function [mlat,L] = lshell(mlat,L)

% function [mlat,L]=lshell(mlat,L);
% Annika 18.5.2005
%
% Calculates either the L-shell value (given the magnetic latitude)
% or the magnetic latitude (given the L-shell value).
% No distinction between hemispheres for obvious reasons.
%
% INPUT/OUTPUT:
%  mlat = magnetic latitude in degrees
%  L    = the L-shell value in Re (Earth radii)
%
% Example: 
%  Magnetic latitude corresponding to L-shell value 4Re 
%  [mlat,L]=lshell([],4);    (60.0 degrees, by the way)

if isempty(L) == 1

  %disp('Calculate L value')

  mlat = mlat*pi/180; %% to rad
  
  L = 1/(cos(mlat))^2;
  
  mlat = mlat*180/pi; %% back to deg
  
elseif isempty(mlat) == 1
  
  %disp('Calculate magnetic latitude')
  
  mlat = acos(sqrt(1/L));
  
  mlat = mlat*180/pi; %% to deg
  
end
function w = omega_to_w(omega,p,T)

% function w = omega_to_w(omega,p,T)
%
% Converts OMEGA from WACCM output to w - vertical velocity in m/s
% INPUT:
%  omega = vertical velocity matrix in [Pa/s]
%  p     = pressure vector
%  T     = temperature matrix
%
% OUTPUT:
%  w = vertical velocity matrix in [m/s]
%
% Matlab function by Annika, based on https://www.ncl.ucar.edu/Document/Functions/Contributed/omega_to_w.shtml
% 29 Nov 2019

%% Constants
R = 287.058;            % J/(kg-K) => m2/(s2 K)
g = 9.80665;            % m/s2

%% Calculate atmospheric density
[kk,~] = size(omega);
apu = repmat(p,1,kk)';
%apu = reshape(apu,kk,ll,mm,nn);

rho = apu./(R*T);         % density => kg/m3
w = -omega./(rho*g);     % array operation
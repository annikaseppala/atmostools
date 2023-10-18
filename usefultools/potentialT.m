function theta = potentialT(T,p)

% potentialT  Calculates potential temperature
%
% function theta = potentialT(T,p)
%
% Annika 25.10.2005
%
% Returns the potential temperature <theta> calculated from
% Temperature <T> and pressure <p>
%
% theta = T*(p0/p)^kappa,
%  where kappa = 2/7, for ideal diatomic gas, and p0 = 1e5 Pa
%
% Uses the following units:
%
% INPUT:
%  T = temperature [Kelvin, K]
%  p = pressure [hPascal, hPa]
%
% OUTPUT:
%  theta = potential temperature [Kelvin, K]

%% Air:
%c_p = 1005;
%c_v = 719;
%gamma = c_p/c_v;
%kappa = ((gamma-1)/gamma);

%% Ideal diatomic gas:
kappa = 2/7;

%p0 =  1e5; %Pa : 100kPa
p0 =  1e3; %hPa : 1e5 Pa

theta = T.*(p0./p).^kappa;
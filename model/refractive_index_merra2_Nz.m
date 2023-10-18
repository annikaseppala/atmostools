function [n2,q_phi] = refractive_index_merra2_Nz(p,lat,u,s,t)

% function [n2,q_phi] = refractive_index_merra2_Nz(p,lat,U,s,T_now)
% Returns the refractive index, scaled by a^2. Assuming buoyancy frequency
% N is altitude dependent.
%
%   OUTPUTS:
%   n2 = scaled refractive index
%   q_pho = meridional gradient of potential vorticity
%
%   INPUTS (from MERRA2):
%   p = pressure
%   lat = latitude vector
%   u = zonal wind
%   s = zonal wave number, this can be set to 1
%   t = temperature
%
% By Sophie Cook, 2023

%% Set Constants
OMEGA = 7.2921e-5; % Earth's rotation frequency - units are s^-1
a = 6371000; %% radius of Earth in m
rho0 = 1.225; %kg/m^3 Standard sea level density
H = 7000; % scale height of 7 km, in m

ps = 1000; % hPa, surface pressure
logpressalt = -H * log(p./ps); %% in m
rho = rho0*exp(-logpressalt./H);
dec2rad = pi/180;

N = sqrt(5e-4); % buoyancy frequency - number inside square root is an approximation for the middle atmosphere (stratosphere) from Andrews

R = 287; % gas constant for dry air, unit J K^-1 kg^-1
c_p = 1005; % specific heat at constant pressure, unit J K^-1 kg^-1
kappa = R/c_p; % specific gas constant, unitless

%% Using finite differences for gradient calculations

% u = U; % annika commented this out
nlat = length(lat);
nlev = length(p);
n2 = zeros(nlat,nlev);

for ilat=1:nlat
    for ilev=1:nlev
        if ((ilev == 1) || (ilev == nlev))  %one sided finite difference
            u_bar_z(ilat,1)=((u(ilat,2)-u(ilat,1)))/(logpressalt(2)-logpressalt(1));
            u_bar_z(ilat,nlev)=((u(ilat,nlev)-u(ilat,nlev-1)))/(logpressalt(nlev)-logpressalt(nlev-1));
        end
        if ((ilev >= 2) && (ilev <= (nlev-1)))  % center finite difference method
            u_bar_z(ilat,ilev)=((u(ilat,ilev+1)-u(ilat,ilev-1)))/(logpressalt(ilev+1)-logpressalt(ilev-1));
        end
    end
end
%====================================================
for ilat=1:nlat
    for ilev=1:nlev
        if ((ilev == 1) || (ilev == nlev)) %one sided finite difference
            u_bar_z_z(ilat,1)=((u_bar_z(ilat,2)-u_bar_z(ilat,1)))/(logpressalt(2)-logpressalt(1));
            u_bar_z_z(ilat,nlev)=((u_bar_z(ilat,nlev)-u_bar_z(ilat,nlev-1)))/(logpressalt(nlev)-logpressalt(nlev-1));
        end
        if ((ilev >= 2) && (ilev <= (nlev-1)))  % center finite difference method
            u_bar_z_z(ilat,ilev)=((u_bar_z(ilat,ilev+1)-u_bar_z(ilat,ilev-1)))/(logpressalt(ilev+1)-logpressalt(ilev-1));
        end
    end
end

%====================================================
%ro_z: derivate of density respect to height
for ilat=1:nlat
    for ilev=1:nlev
        if ((ilev == 1) || (ilev == nlev)) %one sided finite difference
            ro_z(ilat,1)=((rho(2)-rho(1)))/(logpressalt(2)-logpressalt(1));
            ro_z(ilat,nlev)=((rho(nlev)-rho(nlev-1)))/(logpressalt(nlev)-logpressalt(nlev-1));
        end
        if ((ilev >= 2) && (ilev <= (nlev-1)))  % center finite difference method
            ro_z(ilat,ilev)=((rho(ilev+1)-rho(ilev-1)))/(logpressalt(ilev+1)-logpressalt(ilev-1));

        end
    end
end
%====================================================
for ilat=1:nlat
    for ilev=1:nlev
        if ((ilat == 1) || (ilat == nlat))  %one sided finite difference
            dlat = abs(dec2rad*(lat(2)-lat(1)));
            u_bar_phi(1,ilev)=(u(2,ilev)-u(1,ilev))/dlat;
            u_bar_phi(nlat,ilev)=(u(nlat,ilev)-u(nlat-1,ilev))/dlat;
        end
        if ((ilat >= 2) && (ilat <= nlat-1))  % center finite difference method
            dlat = abs(dec2rad*(lat(3)-lat(1)));
            u_bar_phi(ilat,ilev)=(u(ilat+1,ilev)-u(ilat-1,ilev))/dlat;
        end
    end
end
%============================================
%u_bar_cosphi_phi
for ilat=1:nlat
    for ilev=1:nlev
        u_bar_cosphi_phi(ilat,ilev)=u_bar_phi(ilat,ilev)*cosd(lat(ilat))+(u(ilat,ilev)*(-sind(lat(ilat))));
    end
end
%============================================
%u_bar_cosphi_phi_overphi_phi
for ilat=1:nlat
    for ilev=1:nlev
        if ((ilat == 1) || (ilat == nlat))  %one sided finite difference
            dlat = abs(dec2rad*(lat(2)-lat(1)));
            u_bar_cosphi_phi_phi(1,ilev)=(u_bar_cosphi_phi(2,ilev)-u_bar_cosphi_phi(1,ilev))/dlat;
            u_bar_cosphi_phi_phi(nlat,ilev)=(u_bar_cosphi_phi(nlat,ilev)-u_bar_cosphi_phi(nlat-1,ilev))/dlat;
        end
        if ((ilat >= 2) && (ilat <= nlat-1))  % center finite difference method
            dlat = abs(dec2rad*(lat(3)-lat(1)));
            u_bar_cosphi_phi_phi(ilat,ilev)=(u_bar_cosphi_phi(ilat+1,ilev)-u_bar_cosphi_phi(ilat-1,ilev))/dlat;
        end
    end
end

%============================================

% Now u_bar_cosphi_phi_overphi_phi
for ilat=1:nlat
    for ilev=1:nlev
        u_bar_cosphi_phi_overphi_phi(ilat,ilev) = 1./(a*cosd(lat(ilat))^2)*(u_bar_cosphi_phi_phi(ilat,ilev)*cosd(lat(ilat))+(sind(lat(ilat))*u_bar_cosphi_phi(ilat,ilev)));
    end
end

%============================================
% Sophie added
% Now t_bar_z for calculating N(z)

%t = T_now;
nlat = length(lat);
nlev = length(p);
n2 = zeros(nlat,nlev);

for ilat=1:nlat
    for ilev=1:nlev
        if ((ilev == 1) || (ilev == nlev))  %one sided finite difference
            t_bar_z(ilat,1)=((t(ilat,2)-t(ilat,1)))/(logpressalt(2)-logpressalt(1));
            t_bar_z(ilat,nlev)=((t(ilat,nlev)-t(ilat,nlev-1)))/(logpressalt(nlev)-logpressalt(nlev-1));
        end
        if ((ilev >= 2) && (ilev <= (nlev-1)))  % center finite difference method
            t_bar_z(ilat,ilev)=((t(ilat,ilev+1)-t(ilat,ilev-1)))/(logpressalt(ilev+1)-logpressalt(ilev-1));
        end
    end
end

%============================================

%N_squared = (R/H)*(t_bar_z + ((kappa*T_now)/H)); % buoyancy frequency %
%annika commented above out and replace T_now with t
N_squared = (R/H)*(t_bar_z + ((kappa*t)/H)); % buoyancy frequency
N2 = mean(N_squared(161:361,:),1,'omitnan'); % buoyancy frequency that only varies with z, with lats averaged over 10S to 90N (i.e. the range shown in maps)

%============================================
% Now N2_bar_z

for ilat=1:nlat
    for ilev=1:nlev
        if ((ilev == 1) || (ilev == nlev)) %one sided finite difference
            N2_bar_z(ilat,1)=((N2(2)-N2(1)))/(logpressalt(2)-logpressalt(1));
            N2_bar_z(ilat,nlev)=((N2(nlev)-N2(nlev-1)))/(logpressalt(nlev)-logpressalt(nlev-1));
        end
        if ((ilev >= 2) && (ilev <= (nlev-1)))  % center finite difference method
            N2_bar_z(ilat,ilev)=((N2(ilev+1)-N2(ilev-1)))/(logpressalt(ilev+1)-logpressalt(ilev-1));

        end
    end
end

%============================================
coriolis_parameter_square=((2.0*OMEGA*sind(lat)).^2).*ones(361,42);
%============================================
for ilat=1:nlat
    for ilev=1:nlev
        meridional_gradient_pv_1(ilat,ilev)=(2*OMEGA*cosd(lat(ilat)));
    end
end
%=========
meridional_gradient_pv_2 = -u_bar_cosphi_phi_overphi_phi;
%=========
for ilat=1:nlat
    for ilev=1:nlev
        meridional_gradient_pv_3_1(ilat,ilev)=-a*coriolis_parameter_square(ilat)./N2(ilev).*u_bar_z(ilat,ilev).*ro_z(ilat,ilev)./rho(ilev);
        meridional_gradient_pv_3_2(ilat,ilev)= a*coriolis_parameter_square(ilat)./(N2(ilev).^2).*N2_bar_z(ilat,ilev).*u_bar_z(ilat,ilev); % new term needed for N(z) case
        meridional_gradient_pv_3_3(ilat,ilev)=-a*coriolis_parameter_square(ilat)./N2(ilev)*u_bar_z_z(ilat,ilev);
    end
end
meridional_gradient_pv_3 = meridional_gradient_pv_3_1 + meridional_gradient_pv_3_2 + meridional_gradient_pv_3_3;
%============================================
meridional_gradient_pv = meridional_gradient_pv_1 + meridional_gradient_pv_2 + meridional_gradient_pv_3;
%=========================================

%Refactive Index for stationary planetary waves
Refractive_Index_1 = meridional_gradient_pv./(a*u);

for ilat=1:nlat
    for ilev=1:nlev
        Refractive_Index_2(ilat,ilev) = -(s/(a*cosd(lat(ilat))))^2;
        Refractive_Index_3(ilat,ilev) = -coriolis_parameter_square(ilat,ilev)./(4*N2(ilev)*H^2);
    end
end
%============================================

n2 = a^2 *(Refractive_Index_1 + Refractive_Index_2 + Refractive_Index_3);
q_phi = meridional_gradient_pv;

end
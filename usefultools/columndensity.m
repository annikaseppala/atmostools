function [col,du]=columndensity(n1,alt)
%% [col,du]=columndensity(n1,alt)  Returns the column densities <col> of gas <n1> for altitudes <alt> in a matrix
% 
% by Annika, modified from function pylvas to handle matrices, last updated
% 12.5.2015
%
%
% n1  = Density matrix (cm-3) with dimensions [n,m], where n corresponds to
%       altitude dimension
% alt = Altitudes
%
% a = column density (1/cm2)
% du = column density in Dobson units (Dobson)

% Column densities are calculated as follows:
% !! units !!! [n1(:,2)] =cm-3  [n1(:,1)]= km !!
% Col=0;
% for i=1:length(n1)-1,
%  Col=sum((n1(i,2)+n1(i+1,2))/2*abs(n1(i,1)-n1(i+1,1))*1e5)+a;
% end
% This is the column density.
%
% Dobson units for Ozone (O3):
% 1 DU = 2.69e16 particles/cm2

[aa,tt]=size(n1);


for jj = 1:tt
    col(jj) = 0;
    a = 0;
    for i = 1:aa-1,
        a = sum((n1(i,jj)+n1(i+1,jj))/2*abs(alt(i)-alt(i+1))*1e5)+a;
    end
    
    col(jj) = a;
end

%% In dobson units this is
du = col/(2.69e16);
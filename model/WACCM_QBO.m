function [QBO,QBOe,QBOw] = WACCM_QBO(lev,lat,zmU)
% function [QBO,QBOe,QBOw] = WACCM_QBO(lev,lat,zmU);
%
%  Calculates normalised WBO equatorial winds at <QBOlevel> level (closest
%  pressure level in WACCM) and returns the normalised wind and the phase 
%  years. You need to set the value of <QBOlevel> in the code, or move the 
%  variable to the function call.
%
% INPUT: 
%  lev = hybrid levels
%  lat = latitudes
%  zmU = zonal mean zonal wind
%
% OUTPUT:
%  QBO = Normalised zonal mean wind at <QBOlevel> (set below) and 0 deg
%  QBOe = Years identified as easterly QBO
%  QBOw = Years identified as westerly QBO
%
% By Annika, last modified 26 Nov 2018

%% Set pressure level level (closes level to this will be used)
QBOlevel = 40; %% SH
%QBOlevel = 1; % test
%QBOlevel = 25; %% SH upper 
%QBOlevel = 50; %% NH
%QBOlevel = 30; %% NH upper
disp(['WACCM QBO level: ' int2str(QBOlevel)])


[~,I] = sort(abs(lev-QBOlevel));
QBOlev = (I(1));
[~,I] = sort(abs(lat-0));
QBOlat = (I(1));

QBO = squeeze(zmU(QBOlat,QBOlev,:)) - squeeze(mean(zmU(QBOlat,QBOlev,:),3));
% The following line was used to calclulate an average over equatorial
% latitudes e.g. 5S-5N. Made no difference to results so started using only
% 0deg.
%QBO = squeeze(mean(zmU(QBOlat,QBOlev,:),1)) - squeeze(mean(mean(zmU(QBOlat,QBOlev,:),1),3)); %% averaging over the equatorial region makes no difference.
QBO = QBO/std(QBO); % Normalise with standard devision

%%%%  testplotting
% figure(10),clf
% subplot(1,2,1)
% contour(years,lev,squeeze(zmU(QBOlat,:,:))./std(squeeze(zmU(QBOlat,:,:))),[-1:0.25:1])
% set(gca,'ydir','reverse','yscale','log','ylim',[1 1000]),shading flat,colorbar
% hold on
% contour(years,lev,squeeze(zmU(QBOlat,:,:))./std(squeeze(zmU(QBOlat,:,:))),[0 0],'k-')
% plot([1 100],[50 50],'r-')

%% Find the two phases, with a buffer
QBOe = find(QBO<-0.05);
QBOw = find(QBO>0.05);

%%%%  testplotting
%subplot(1,2,2)
%%plot(years(QBOe),QBO(QBOe),'bo'),hold on, plot(years(QBOw),QBO(QBOw),'rs')
%plot(QBOe,QBO(QBOe),'bo'),hold on, plot(QBOw,QBO(QBOw),'rs')

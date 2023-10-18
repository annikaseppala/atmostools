function [t,md,s,lkm] = runmean(timevec, dens, timegrid, tiks , med)
% -------------------------------------------------------------------
% function [t,md,s,lkm] = runmean(timevec,dens,timegrid,tiks,med)
%
%  Annika 5.5.2004
%
%  Function to calculate running mean densities in given timegrid (hour,
%  day). E.g. 'day' with tiks = 5 calculates 5 day running mean
%  values of given densities.
%
% INPUT:
%  timevec  = time vector, format: [day hour]
%             (e.g. timevec(:,1) = day, timevec(:,2) = hour)
%  dens     = density vector
%  timegrid = 'day', 'hour', or number of samples
%  tiks     = how many days or hours to include in the mean calculation
%  med      = 'mean' = calculate mean (default) or
%             'median' =  median
%
% OUTPUT:
%  t  = time vector
%  md = mean density vector
%  s  = standard deviation
%  lkm = number of data points for each grid point
% -------------------------------------------------------------------

t  = [NaN];
md = [NaN];
s  = [NaN];
lkm = [NaN];

if (nargin < 3)
    disp('Give time grid.')
    return
elseif (nargin < 5)
    med = 'mean';
end

if isstr(timegrid) == 1
    timegrid = lower(timegrid);
else
    nosamples = timegrid;
    timegrid = 'sample';
end

a = 0;

first = min(timevec(:,1)) + (tiks - 1);
last = max(timevec(:,1)) + 1;

switch timegrid

    case 'day' %% Calculate running daily means

        for i = first:last
            apu = [];
            apu = find(timevec(:,1) == i);
            if isempty(apu) == 0

                n = find((timevec(:,1) >= (i - tiks + 1))&(timevec(:,1) <= i));
                if (isempty(n)==0) %% found matches

                    a = a + 1;
                    t(a) = i + 0.5; %% noon time

                    switch med
                        case 'median'
                            %% find min and max values and remove them
                            min1 = find(min(dens(n)) == dens(n));
                            n(min1) = [];
                            max1 = find(max(dens(n)) == dens(n));
                            n(max1) = [];

                            md(a) = median(dens(n));

                            lkm(a) = length(n);
                        otherwise
                            %% find min and max values and remove them
                            min1 = find(min(dens(n)) == dens(n));
                            n(min1) = [];
                            max1 = find(max(dens(n)) == dens(n));
                            n(max1) = [];

                            md(a) = mean(dens(n));
                            lkm(a) = length(n);
                    end
                    s(a) = std(dens(n));
                end
            end %% if (isempty(n)==0)
        end %% for i = first:1:last

    case 'hour' %% Calculate hourly means

        for i = first:last

            n = find(timevec(:,1)==i);


            for h = 0:1:23 %% loop over hours

                hind = [];
                hind = find(timevec(n,2)==h);

                if (isempty(hind)==0) %% found matches

                    a = a + 1;
                    t(a) = i + h/24;

                    switch med
                        case 'median'
                            %% find min and max values and remove them
                            min1 = find(min(dens(hind)) == dens(hind));
                            hind(min1) = [];
                            max1 = find(max(dens(hind)) == dens(hind));
                            hind(max1) = [];

                            md(a) = median(dens(hind));
                            lkm(a) = length(hind);
                        otherwise

                            %% find min and max values and remove them
                            min1 = find(min(dens(hind)) == dens(hind));
                            hind(min1) = [];
                            max1 = find(max(dens(hind)) == dens(hind));
                            hind(max1) = [];

                            md(a) = mean(dens(hind));
                            lkm(a) = length(hind);
                    end

                    s(a) = std(dens(hind));

                end %% if (isempty(hind)==0)
            end %% for h = 0:1:23
        end %% for i = first:1:last (day)

    case 'sample'

        for i = nosamples:nosamples:length(timevec(:,1))
            a = a + 1;
            ind1 = i-nosamples+1;
            ind2 = i;
            hind = ind1:1:ind2;

            switch med
                case 'median'
                    md(a) = median(dens(hind));
                otherwise
                    md(a) = mean(dens(hind));
            end
            lkm(a) = length(hind);
            s(a) = std(dens(hind));
            t(a) = timevec(i,1);
        end

end %% switch timegrid

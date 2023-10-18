function readandsaveWACCM_AS
%% READ and SAVE wanted variables from WACCM runs
% By Annika, feel free to modify to fit your use

%% Change to path where you data is:
datapath = '/Volumes/O3DYN_REF/O3DYN_REF/h0/';

% Set this to the overall file identifier
files = '20151106_FWSC.cam2.h0.'; % for h0 files (monthly)

% Set this to the individual simulation identifier
uniquefileID = 'REF';

% Where do you want the data saved in mat-files
savepath = '/Users/annika/data/WACCM_O3_matfiles/'; 

% You will have to modify the filename generator below to change according
% to "year" and "month" requirements. You another pirce of code to
% run through the files with finer timegrid as the saving dates change

%% Set year range
%years = 1:1:100;
years = 1; % This is not a historical simulation, otherwise change to years = 2000:2014 etc...

%% Set the months you want to save
%months = [10:1:12];
months = 11; % Read and save November

%% Which variable you want to save. Needs to match variable name in file
% To check the variable names in file use: ncdisp('FILENAME')
%wantedvariable = 'QRS_TOT'; % Total Shortwave heating
%wantedvariable = 'QRL_TOT' % Total Longwave heating
wantedvariable = 'O3'; % Ozone

for mm = months
    disp(['Currently saving month:', int2str(mm)])
    %disp('Currently reading year:') % display year to monitor progress
    apuind = 0;
    lat = [];
    lon = [];
    lev = [];
    for ii = years
        %disp(int2str(ii)) % display year to monitor progress
                
        apuind = apuind + 1;
        
        FILENAME = [datapath files num2str(ii,'%04.0f') '-' num2str(mm,'%02.0f') '.nc'];
        
        % latitudes
        VARNAME = 'lat';
        lat = ncread(FILENAME,VARNAME);
        
        % longitudes
        VARNAME = 'lon';
        lon = ncread(FILENAME,VARNAME);
        
        % pressure (altitude) vector
        VARNAME = 'lev';
        lev =  ncread(FILENAME,VARNAME);
        
        % The data you wanted
        data =  ncread(FILENAME,wantedvariable);
        
        eval([wantedvariable '(apuind,:,:,:) = data;'])
        year(apuind) = ii;
        
    end
    
    % Save the data in a mat-file
    eval(['save ' savepath 'WACCM_' uniquefileID '_' wantedvariable '_month' int2str(mm) '.mat lat lon lev year ' wantedvariable ])
    
    eval(['clear ' wantedvariable])

end

if 1 == 0
    % If you need the bacis parameters for anything
    %altitude vector
    VARNAME = 'ilev';
    ilev =  ncread(FILENAME,VARNAME);
    
    VARNAME = 'P0';
    P0 =  ncread(FILENAME,VARNAME);
    
    VARNAME = 'hyam';
    hyam =  ncread(FILENAME,VARNAME);

    VARNAME = 'hybm';
    hybm =  ncread(FILENAME,VARNAME);
    
    VARNAME = 'hyai';
    hyai =  ncread(FILENAME,VARNAME);

    VARNAME = 'hybi';
    hybi =  ncread(FILENAME,VARNAME);
    
    save WACCMbasicparam.mat lat lon lev ilev P0 hyam hybm hyai hybi
    
end
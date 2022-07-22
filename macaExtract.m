%%%%%%%%%%%%%%%%% Test of multiday extraction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function []=macaExtract(gcmfile,gcmfolder,gcmvar)
% gcmfile: the maca file
% gcmfolder: the directory with gcmfile
% gcmvar:  the weather variable
savedir = './';

fips_tabu = readtable('./fipsmaca2011.csv');

sum_fips_area = varfun(@sum,fips_tabu,'InputVariables','AREA','GroupingVariables','fips');
fips_tabu = innerjoin(fips_tabu,sum_fips_area(:,{'fips','sum_AREA'}),'Keys',{'fips'});
fips_tabu.weight = fips_tabu.AREA./fips_tabu.sum_AREA;

clear weather xdata
%% check the total weight for each geoid(fips) equals 1
fips_tabu = fips_tabu(:,{'fips','nid3','weight'});
[fips, ~, ic]   = unique(fips_tabu.fips);
fips_tabu.nid3 = int64(fips_tabu.nid3);

%% extract
filename = gcmfile;
filesplit = strsplit(filename,'_');
fl        = strcat(gcmfolder,'/',filename);

timenum = ncread(fl,'time');
anchortime = datenum('01/01/1900');


% read in key variable
infos    = ncinfo(fl);

gcm_data = infos.Variables(4).Name; % variable in nc file
gcm_model  = filesplit(3);
gcm_scen   = filesplit(5);
gcm_period = strcat(filesplit(6),filesplit(7));
gcm_var    = gcmvar; % weather variable in netcdf file
savefile   = strcat(gcm_model,'_',gcm_scen,'_',gcm_period,'_',gcm_var,'.mat');

timestart   = 1;


tfilebegin = tic;

tic;
timecount = length(timenum);
currtime = timenum(timestart:timestart+timecount-1);

ncid = netcdf.open(fl,'NOWRITE');
varid = netcdf.inqVarID(ncid,gcm_data);
xdata    = netcdf.getVar(ncid,varid,'single');

treading = toc;
fprintf('Reading Data take time %6.2f seconds\n',treading);

%reshape into a vector
cindexorder = 445-(1:444);

xdata = reshape(xdata(:,cindexorder,:),[922*444 timecount]);

% weather is too larger to be handled at one time

fipsweather = zeros(length(fips),timecount);
fipsweight  = zeros(length(fips),timecount);
fips_weight = fips_tabu.weight;

% fipsweather = gpuArray(fipsweather);
% fipsweight  = gpuArray(fipsweight);
% ic          = gpuArray(ic);
% fips_weight = gpuArray(fips_tabu.weight);

for di = 1:timecount
    weather = xdata(fips_tabu.nid3,di);
    posflag   = (weather(:,1) ~= -9999);
    weather(weather==-9999) = 0 ;
    fipsweather(:,di) = accumarray(ic,weather.*fips_weight);
    fipsweight(:,di)  = accumarray(ic,posflag.*fips_weight);
end

fipsfinal = fipsweather./fipsweight;
cpufinal  = gather(fipsfinal);
cpufinal  = reshape(cpufinal,[length(fips)*timecount 1]);

cpufinal(:,2)  = repmat(fips,[timecount 1]);
cpufinal(:,3)  = reshape(repmat(currtime',[length(fips) 1]),[length(fips)*length(currtime) 1]);

%% pair with year month day
[cpufinal(:,4),cpufinal(:,5), cpufinal(:,6)] = ymd(datetime(cpufinal(:,3)+anchortime,'ConvertFrom','datenum'));
cpufinal  = array2table(cpufinal,'VariableNames',[gcm_var,'fips','time','year','month','day']);

save(strcat(savedir,char(savefile)),'cpufinal');
fprintf('%s is done in %6.2f seconds\n',filename,toc(tfilebegin));
end

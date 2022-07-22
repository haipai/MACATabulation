clear;
gcmfolder = './';
gcmfile = 'macav2livneh_tasmax_bcc-csm1-1_r1i1p1_rcp85_2026_2045_CONUS_daily.nc';
gcmvar  = {'tasmax'};

macaExtract(gcmfile,gcmfolder,gcmvar); 

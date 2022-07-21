# MACATabulation
Matlab and R scripts to tabulate weather variables into US counties

# Tech Route
Using Matlab GPU computation power to fast tabulate future weather variables into counties.
1. MACA shapefile map
    + Restricting on each cell, such as designate an agriculture cell if that cell has any crop land (82) from National Land Cover Database
2. County shapefile map 
3. Overlay County map with MACA map to get overlapping areas
4. Using GPU parallel computating power to speed up the calculation 

# Files in this project
sampleDailyMaximumTemperature.m: Matlab script to tabulate daily maxium temperature from macav2livneh_tasmax_bcc-csm1-1_r1i1p1_rcp85_2026_2045_CONUS_daily.nc
sampleData.zip: County2MACA matching csv file

# Note
Since the MACA file is usually in the size of several GBs, I would not share it directly. Instead, please download MACA files directly from the Climatology Lab (https://www.climatologylab.org/maca.html)

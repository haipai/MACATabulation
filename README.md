# MACATabulation
Matlab and R scripts to tabulate weather variables into US counties

# Tech Route
Using Matlab GPU computation power to fast tabulate future weather variables into counties.
1. MACA shapefile map
    + Restricting on each cell, such as designate an agriculture cell if that cell has any crop land (82) from National Land Cover Database
2. County shapefile map 
3. Overlay County map with MACA map to get overlapping areas
4. Using GPU parallel computating power to speed up the calculation 

    $$w_i = \sum^J_{j=1}\frac{a_{ij}*w_j}{\sum a_{ij}}$$
    
    where $w_i$ is the tabulated weather variable for county $i$, $J$ MACA cells have overlapping areas with county $i$, $a_{ij}$ is the overlapping area between MACA cell $j$ and county $i$.
# Files in this project
sampleDailyMaximumTemperature.m: Matlab script to tabulate daily maxium temperature from macav2livneh_tasmax_bcc-csm1-1_r1i1p1_rcp85_2026_2045_CONUS_daily.nc

sampleData.zip: County2MACA matching csv file and MACA shapefile

# Note
1. Since the MACA file is usually in the size of several GBs, I would not share it directly. Instead, please download MACA files directly from the Climatology Lab (https://www.climatologylab.org/maca.html)
2. The example is at the county level, it is straightforward to adapt the script to other spatial levels, like HUC8, HUC12 et al. 

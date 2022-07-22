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
fipsmaca2011.csv: County2MACA matching csv file with 2011 NLCD layer (value 82) as mask 

macaextract.m: MATLAB function script to tabulate daily maxium temperature from macav2livneh_tasmax_bcc-csm1-1_r1i1p1_rcp85_2026_2045_CONUS_daily.nc to counties. The result 'cpufinal' is saved into .mat format since it is faster to save into native data format instead of .csv file.
it takes around 100 seconds to tabulate one nc file which typically covers around 20 years. there are six variables in the table "cpufinal". There are 20 GCMs in the MACA database, each GCM has 78 .nc files. In total, there are around 1600 .nc files as the one in the example. Roughly, tabulating 
all of these files would take around 44 hours. 
 
weather variable, fips, time,year,month,day 

callmacaextract.m: an example of call the function macaextract.m
macamap/macamap.shp: polygon shape file for maca raster cells (~6km by 6km) 

# Note
1. Since the MACA file is usually in the size of several GBs, I would not share it directly. Instead, please download MACA files directly from the Climatology Lab (https://www.climatologylab.org/maca.html)
2. The example is at the county level, it is straightforward to adapt the script to other spatial levels, like HUC8, HUC12 et al. 

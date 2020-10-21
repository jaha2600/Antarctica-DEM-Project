# RMACC Summit Scripts

Batch processing scripts designed to be used with the RMACC Summit supercomputer system.

These codes are designed to automatically generate jobfiles that then coregister DEMs to point clouds using Ames Stereo Pipeline and the `demcoreg` package.

## Dependencies
Requires same dependencies as on main coreg_dems page - ask rc computing at CU Boulder for installation of pygeotools and demcoreg. 

## File locations
#### All DEM files are stored in the scratch seperated into one directory for each year i.e.:
```
/scratch/summit/jaha2600/antarctica_dems/2011/
``` 
For each year subdirectory each dem has the following naming convention:
```
YYYYMMDD_SATID_IMGID1_IMGID2_SEGNUM_dem.tif
For example:
20110113_WV02_10300100092FB200_103001000866EC00_seg1_dem.tif
```

#### Point cloud (or multiple if using variety) in the form of x,y,z csv file are stored in:
```
/scratch/summit/jaha2600/point_clouds/
```

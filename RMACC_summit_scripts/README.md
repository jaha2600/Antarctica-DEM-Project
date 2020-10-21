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
#### Files `genjobs.input`, `generate_jobs.sh`, `template_file_auto.txt` should be placed in
```
/projects/jaha2600/demcoregister/
```

#### Copy `apply_dem_inv_translation.py` to location of demcoreg files, in my case
```
/projects/jaha2600/software/anaconda/envs/pygeo/lib/python2.7/site-packages/demcoreg/
```
### Once all files are in the correct location make following changes to files to specify your usernames / paths etc:
#### `template_file_auto.txt`
`Lines 1 - 12` edit to required number of tasks, account, walltime (note does not currently support multiple nodes - leave at 1)

`Line 18` path to copy of ASP

`Line 21` path to demcoreg apply inverset translation code

`line 24` change to proj string for csv file

`line 36` change path to dem directory above year to correct path (i.e. `/scratch/summitjaha2600/antarctica_dems/`)

`line 37` edit to match ending of dem file - for worldview dems this is normally `*dem.tif`

`line 55` same as above edit to match ending of dem files normally `*dem.tif`

`line 77` same as above edit to ending of files `*dem.tif`
#### `generate_jobs.sh`
`lines 1 - 20` edit to required number of tasks, account, walltime (keep low)

`lines 33 & 36` edit to path of the genjobs.input file (keep `| cut -d" " -f1/2` unedited)

`lines 39` edit to location of `template_file_auto.txt`

`line 43` change path to location of generate_jobs.sh etc. scripts, then add `/jobfiles/` onto the end i.e. `/projects/jaha2600/demcoregister/jobfiles/`

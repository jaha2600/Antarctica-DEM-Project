# RMACC Summit Scripts

Batch processing scripts designed to be used with the RMACC Summit supercomputer system.

Primarily used when testing multiple pointclouds, produces batch scripts for every pointcloud for a certain year.

Can be edited to produce different jobfiles i.e. one job for every dem.

These codes are designed to automatically generate jobfiles that then coregister DEMs to point clouds using Ames Stereo Pipeline and the `demcoreg` package.

## Dependencies
Requires same dependencies as on main coreg_dems page - ask rc computing at CU Boulder for installation of pygeotools and demcoreg. 

## Usage
1. move all files to correct locations detailed in File Locations Section
2. make edits to `template_file_auto.txt` and `generate_jobs.sh files` (changing users, slurm commands, paths, dems endings)
- only needs to be done once if same structure / naming conventions is maintained for multiple jobs
3. edit `genjobs.input` file, format is two column file with space as delimiter:
```
/path/to/pointcloud/ year
For Example:
/scratch/summit/jaha2600/pc_align_point_clouds/ 2011
```
4. log into scompile node if you haven't already `ssh scompile`
5. move to directory with genjobs.input etc in and run `generate_jobs.sh`. This produces a subdirectory called jobfiles, inside of which are multiple qsub files, currently set up as one for each pointcloud in the year specified. If you are using one point cloud you will have one qsub file.
```
sbatch generate_jobs.sh

in ./jobfiles can find qsub* files for each pointcloud for the year specified.
i.e. qsub*point_cloud_1_2011.sh
```
6. move to `jobfiles` subdirectory 
7. Run the qsub file - this is the script that runs in a loop for every dem in the directory of the year specified run coregistration routine, produce translated files and resampled coregistered files. 
```
sbatch qsub*.sh
```


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

`line 36` change path to dem directory above year to correct path (i.e. `/scratch/summit/jaha2600/antarctica_dems/`)

`line 37` edit to match ending of dem file - for worldview dems this is normally `*dem.tif`

`line 55` same as above edit to match ending of dem files normally `*dem.tif`

`line 77` same as above edit to ending of files `*dem.tif`
#### `generate_jobs.sh`
`lines 1 - 20` edit to required number of tasks, account, walltime (keep low)

`lines 33 & 36` edit to path of the genjobs.input file (keep `| cut -d" " -f1/2` unedited)

`lines 39` edit to location of `template_file_auto.txt`

`line 43` change path to location of generate_jobs.sh etc. scripts, then add `/jobfiles/` onto the end i.e. `/projects/jaha2600/demcoregister/jobfiles/`

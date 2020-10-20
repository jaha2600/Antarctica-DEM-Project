# Standard Coregistration Code

This code is designed to work in any standard bash shell.
See main directory for dependency requirements.

## Make Edits to Paths & Hardcoded Variables
Change `line 14` and `line 15` to match your ASP path and location of apply_inv_translation.py

Change `line 21` to hardcode the path to your `$PC_NAME` input.

Change `line 24` to proj string that matches the projection of your input point cloud file
- see example of point cloud format in file `example_point_cloud.csv`

Change `line 29` to ensure `$DEM_NAME_ENDING` matches your file endings (used for wildcards)
- for most produced WV dems this is normally dem.tif

## Usage

`$ ./coregister_dems.sh example_point_cloud.csv`

Key steps in code:

Generate lists of DEMs

For each DEM run pc_align code to generate transform

Copy pc_align.txt files of succesful pc_align runs to new subdirectory

Apply inverse transform from pc_align textfile on DEMs

Main Outputs:
- Translated DEMs at native resolution (located in `/dem_dir/CORRECTED_${PC_NAME}/TRANSLATED_${PC_NAME})`
- Translated DEMs at 30 m resolution (located in `/dem_dir/CORRECTED_${PC_NAME}/TRANSLATED_${PC_NAME/30m})`

If used in publication please reference github repo & author https://github.com/jaha2600/coreg_dems 

Jasmine Hansen, 2020

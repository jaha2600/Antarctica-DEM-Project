# Standard Coregistration Code

This code is designed to work in any standard bash shell.
See main directory for dependency requirements.

## Make Edits to Paths & Hardcoded Variables

First make sure you have copied the apply_inv_translation.py script into your demcoreg_directory 

Change `line 14` and `line 17` to match your ASP path and location of apply_inv_translation.py

Change `line 22` to hardcode the path to your `$PC_NAME` input.

Change `line 25` to proj string that matches the projection of your input point cloud file
- see example of point cloud format in file `example_point_cloud.csv`

Change `line 30` to ensure `$DEM_NAME_ENDING` matches your file endings (used for wildcards)
- for most produced WV dems this is normally dem.tif

Change `line 32` to the dem directory path **** without the end slash ****

## Usage
Run in directory which contains DEMs to coregister. 

`$ ./coregister_dems.sh example_point_cloud_name`

Do not add .csv extension onto end of example_point_cloud_name

Key steps in code:

Generate lists of DEMs

For each DEM run pc_align code to generate transform

Copy pc_align.txt files of succesful pc_align runs to new subdirectory

Apply inverse transform from pc_align textfile on DEMs

Main Outputs:
- Translated DEMs located in `/dem_dir/CORRECTED_DEMS/point_cloud_name`

## Use in Publication
If used in publication please credit Jasmine Hansen and github repo https://github.com/jaha2600/coreg_dems 
and credit [demcoreg](https://github.com/dshean/demcoreg)/[pygeotools](https://github.com/dshean/pygeotools) repositories following their reference requirements.

Jasmine Hansen, 2020

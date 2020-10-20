## Standard Coregistration Code

This code is designed to work in any standard bash shell.
See main directory for dependency requirements.

Change `line 14` and `line 15` to match your ASP path and location of apply_inv_translation.py

Change `line 21` to hardcode the path to your `$PC_NAME` input.

Change `line 24` to proj string that matches the projection of your input point cloud file
- see example of point cloud format in file `example_point_cloud.csv`

Change `line 29` to ensure `$DEM_NAME_ENDING` matches your file endings (used for wildcards)
- for most produced WV dems this is normally dem.tif
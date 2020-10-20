# coreg_dems

## Summary
Codes to coregister digital elevation models to point clouds.

This repository contains bash codes to coregister digital elevation models to a reference point cloud.

## Subdirectories
Trad_Machine = codes set  to run on conventional linux machines 

Supercomputer = codes designed to run on the RMACC summit supercomputer

## Dependencies
Codes require installation of: 
- [GDAL](https://gdal.org/)
- [Ames Stereo Pipeline](https://ti.arc.nasa.gov/tech/asr/groups/intelligent-robotics/ngt/stereo/)
- [`Demcoreg`](https://github.com/dshean/demcoreg)
  - requires GDAL, NumPY and [`pygeotools`](https://github.com/dshean/pygeotools)
  - refer to Demcoreg and pygeotools repositiories for installation instructions
- Modified version of demcoreg apply_dem_translation.py script
  - provided in coreg_dems respository as apply_dem_inv_translation.py 
  - copy this script to the same location as the original apply_dem_translation.py script in demcoreg installation
  - i.e. /location_of_demcoreg_install/demcoreg/demcoreg/


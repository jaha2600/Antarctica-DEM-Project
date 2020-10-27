#!/bin/bash

#script to make template file from each dem in directory
#scheduling code

## This code only looks for one core to do its job.
## Select one node
#SBATCH --nodes=1
## Select 1 core for the job.
#SBATCH --ntasks=1
## Set shas (summit haswell) partition
#SBATCH --partition=shas
#SBATCH --account ucb-summit-mjw
## Set a time limit or walltime of 2 hours - it should be quick for small job lists.
#SBATCH --time=2:00:00

module load intel/17.4
#module load gcc/6.1.0
module load gdal/2.2.1
# I load geos
module load geos/3.6.2
# I load proj.
module load proj/4.9.2
# I load python
module load python/2.7.11

#script to make template file from each dem in directory

#scheduling code
## This code only looks for one core to do its job.

#makes uer the path to genjobs.input file matches your own - change usename at minimum.
pc_directory=$(cat /projects/jaha2600/demcoregister/genjobs.input | cut -d" " -f1)
year=$(cat /projects/jaha2600/demcoregister/genjobs.input | cut -d" " -f2)
dem_file_ending=$(cat /projects/jaha2600/demcoregister/genjobs.input | cut -d" " -f3)
#read in template file
template_file='/projects/jaha2600/demcoregister/template_file.txt'
user=`id -u -n`

#build jobfile directory
jobfile_directory="/projects/jaha2600/demcoregister/jobfiles/"
    if [ ! -d "$jobfile_directory" ]; then mkdir -p "$jobfile_directory"; fi
    
#build jobfiles by substituting specific things in the template script. 
ls ${pc_directory}  > pc_file_list

#for each pointcloud file do this
for filename in $(cat pc_file_list | cut -d"." -f1) ; do
    #job files will be in the demcoregister jobfiles directory	
    jobfilename="${jobfile_directory}qsub_${filename}_${year}.sh"
    #name of directory that has the actual dem in it. i.e. /scratch/summit/jaha2600/dems/tomo/WV01*
    #dem_directory="${region_directory}${filename}"
    #corrected_directory="${dem_directory}/CORRECTED/"
    #replace template file with the jobfile name. 
    
    cp $template_file $jobfilename
    
    #set parameters in the copied jobfilename
    #set the path at the top of script
    sed -i -e "s|PC_PATH_NAME|${pc_directory}|g" $jobfilename
    sed -i -e "s|PC_FILENAME|${filename}|g" $jobfilename
    sed -i -e "s|YEARS|${year}|g" $jobfilename
    sed -i -e "s|DEM_ENDING|${dem_file_ending}|g" $jobfilename
done < "$template_file"

echo "script complete" 

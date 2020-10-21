#!/bin/bash

###### Code written by Jasmine Hansen 2020 ##########
###### Built on origincal code by Michael Willis ###########
###### If used in publication please reference github repo: https://github.com/jaha2600/coreg_dems/ ##########

#run this script in the location of your dem files 
# coregister_dems.sh pointcloud_name
#set up for the WorldView  DEMs with the FOLLOWING NAME STRUCTURE:

#20101116_WV02_1030010007A8AB00_1030010008813A00_seg2_dem_8m.tif

#path to ASP and demcoreg
ASP_CODE=/home/jasmine/Applications/StereoPipeline-2.6.0-2017-06-01-x86_64-Linux/bin/
CODE=/home/jasmine/Applications/demcoreg/demcoreg/apply_dem_inv_translation.py

#the first argument in the command line is the name of the pointcloud you are using
PC_NAME=$1

# hardcode the path in and add filename, good if want to run with multiple pointclouds.
CSVDATA=/data/ANTARCTICA/DATASETS/GEE_MASKS/${PC_NAME}.csv

# state the projection of the point cloud (string below is for EPSG:3031)
CSVPROJECTION='+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'

#set the format of the point cloud file (x,y,z)
CSVFORMAT='1:easting 2:northing 3:height_above_datum'

DEM_NAME_ENDING='dem_8m.tif'
# list all of the dems to text file named 'list'
ls *${DEM_NAME_ENDING} > list

#for each file in list run pc_align 
#produces a new subdirectory called CORRECTED_point_cloud_name, within this are the output files from the pc_align algorithm.
#every pc_align run produces a *pc_align*.txt file, regardless of whether or not it was successful or not.
#*trans_reference.tif files are ONLY produced if the pc_align run is successful
for file in $(cat list) ; do
   echo "operating on " $file
   name=$(echo $file | cut -d"." -f1)
   ${ASPCODE}pc_align --max-displacement 50 --tif-compress=NONE --save-inv-transformed-reference-points --threads 32 -o CORRECTED_${PC_NAME}/${name} --csv-proj4 "$CSVPROJECTION" --csv-format "$CSVFORMAT" ${file} $CSVDATA
done 


# copy all the successful pc align files to the main directory
#move into subdirectory with pc_align files in
cd CORRECTED_${PC_NAME}/
# make a new subdirectory for the end result: translated dems.
mkdir TRANSLATED_${PC_NAME}/
# list the trans reference.tif files which will show which files the pc_align algorithm was successful on
# save only the root of the file (i.e. file id, date, satellite, segment number etc.)

ls *trans_reference.tif | cut -d"." -f1 > trans_list
cat trans_list | cut -d"_" -f1-5 > trans_root_list

mkdir successful

#copy all the successful dem 8m files to corrected subdirectory
for file_root in $(cat trans_root_list) ; do
        
    cp ../${file_root}_*8m.tif ./successful
        
    cp ${file_root}*-log-pc_align*.txt ./successful
done

cd successful
    

# for each pc align file run apply_dem_translation.py 
#this takes the inverse transform from the pc align file and applies it
for infile in $(ls *pc_align*) ; do
	echo "operating on " $infile
	dem_root=$(echo $infile | cut -d"-" -f1) 
	dem_filename=${dem_root}.tif
	dem_filename_shean=${dem_root}_trans.tif
	python ${CODE} ${dem_filename} ${infile} 

# resample the dem to 30m for visualization purposes.
	gdalwarp -tr 30 30 -r bilinear ${dem_root}_trans.tif ${dem_root}_trans_30m.tif 

done 

rm *${DEM_NAME_ENDING} 

#move the pc_align files to their own subdirectory
mkdir pc_align_files
mv *pc_align*txt pc_align_files/
#move this subdirectory up one level to CORRECTED_point_cloud_name
mv pc_align_files ../

mkdir 30m_coreg 
mv *trans_30m.tif 30m_coreg/

mkdir coreg
mv *trans.tif coreg/

echo "Script Complete"

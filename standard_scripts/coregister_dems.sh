#!/bin/bash

###### Code written by Jasmine Hansen 2020 ##########
###### Built on origincal code by Michael Willis ###########
###### If used in publication please reference github repo: https://github.com/jaha2600/coreg_dems/ ##########

#run this script in the location of your dem files 
# coregister_dems.sh pointcloud_name
#set up for the WorldView  DEMs with the FOLLOWING NAME STRUCTURE:

#20101116_WV02_1030010007A8AB00_1030010008813A00_seg2_dem_8m.tif

#path to ASP and demcoreg
#ASP_CODE=/home/jasmine/Applications/StereoPipeline-2.6.0-2017-06-01-x86_64-Linux/bin/
ASP_CODE=/usr/local/StereoPipeline/bin/
#CODE=/home/jasmine/Applications/demcoreg/demcoreg/apply_dem_inv_translation.py
CODE=/home/jhansen/demcoreg/apply_dem_inv_translation.py
#the first argument in the command line is the name of the pointcloud you are using
PC_NAME=$1

# hardcode the path in and add filename, good if want to run with multiple pointclouds.
CSVDATA=/home/jhansen/2020/point_clouds/${PC_NAME}.csv

# state the projection of the point cloud (string below is for EPSG:3031)
CSVPROJECTION='+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'

#set the format of the point cloud file (x,y,z)
CSVFORMAT='1:easting 2:northing 3:height_above_datum'

DEM_NAME_ENDING='dem_8m.tif'

DEM_PATH=/BhaltosMount/Bhaltos/ANTARCTICA/2020_jh_dems/2011/test_files

#move to dem_directory
cd ${DEM_PATH}

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

cd ${DEM_PATH}/CORRECTED_${PC_NAME}/
# list the trans reference.tif files which will show which files the pc_align algorithm was successful on
# save only the root of the file (i.e. file id, date, satellite, segment number etc.)

ls *trans_reference.tif | cut -d"." -f1 > trans_list
cat trans_list | cut -d"_" -f1-5 > trans_root_list

#check there is no existing pc_align list and if there is remove it, otherwise it just appends the new ones to the bottom

rm pc_file_list_${PC_NAME}

#list pc_align files for successful pc_align runs
for file_root in $(cat trans_root_list) ; do
    ls $PWD/${file_root}*pc_align-*.txt >> pc_file_list_${PC_NAME}
    cp pc_file_list_${PC_NAME} ${DEM_PATH}

done

#move to main directory
cd ${DEM_PATH}

# for each pc align file run apply_dem_translation.py 
#this takes the inverse transform from the pc align file and applies it
for infile in $(cat pc_file_list_${PC_NAME}) ; do
	echo "operating on " $infile
	filename=$(echo $infile | awk -F/ '{print $NF}')
	dem_root=$(echo $filename | cut -d"-" -f1) 
	dem_filename=${dem_root}.tif
	dem_filename_shean=${dem_root}_${PC_NAME}_trans.tif
	python ${CODE} ${dem_filename} ${infile} ${PC_NAME}
# resample the dem to 30m for visualization purposes.
	gdalwarp -tr 30 30 -r bilinear ${dem_filename_shean} ${dem_root}_${PC_NAME}_trans_30m.tif

done 

if [ ! -d "CORRECTED_DEMS" ] ; then
	mkdir "CORRECTED_DEMS"
fi

cd CORRECTED_DEMS

#make subdirectory to store dems
#if [ ! -d $PC_NAME ] ; then
#	mkdir "${PC_NAME}"
#fi

#copy translated files to directory
mv ${DEM_PATH}/*${PC_NAME}_trans*.tif ${DEM_PATH}/CORRECTED_DEMS/

#make subdirectory and move them to correct one
mkdir ${PC_NAME}
mv *${PC_NAME}_trans*.tif ${PC_NAME}

echo "Script Complete"

#!/bin/bash

# Directory must have structure:
#  BASE_FOLDER
#     |-- rgb/1x/*png
#     |-- sam2/*mp4
#

directory=$1
condapath=$2
directory=$(realpath $directory)
cd ..
curdir=$(pwd)
echo "Using conda path:" $condapath
echo "Preparing data for directory "$directory

echo "\n IGNORE THE FOLLOWING 'ArgumentError'. The activation was valid."
source $condapath/bin/activate
conda activate pointflownerf

# create dummy camera file
python preprocess/01_format_directory.py --outdir=$directory --image_dir=$directory/rgb/1x
python preprocess/02_format_sam2.py --outdir $directory/segmentation/1x --image_folder_path $directory/rgb/1x --video_folder_path $directory/sam2 --path_fnmatch *png
bash preprocess/03_get_depthanything.sh $directory $condapath
python preprocess/05_generate_eval_render_trajectories.py --outname novelview.json --data_dir $directory --fps 24 --novelview_frame 20 40 60 --novelview_radius 0.15
python preprocess/04_get_cotracker.py --outdir $directory/tracks/1x --image_folder_path $directory/rgb/1x --path_regex .*png --frame_span 15 --grid_size 100
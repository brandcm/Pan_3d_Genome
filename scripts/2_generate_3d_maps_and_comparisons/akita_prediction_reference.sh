#!/bin/bash
#$ -N akita_prediction_reference
#$ -t 1-24
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/akita_prediction_reference.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/akita_prediction_reference.err
#$ -l h_rt=24:00:00
#$ -l mem_free=60G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate basenji

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/reference_fasta

# create output directory and assign variables
mkdir -p /wynton/group/capra/projects/pan_3d_genome/data/predictions/reference
chrs_list="/wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_chrs.txt"
chr=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$chrs_list")
model_directory="/wynton/group/capra/projects/pan_3d_genome/data/model"
output_directory="/wynton/group/capra/projects/pan_3d_genome/data/predictions/reference"
script="/wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/akita_prediction_reference.py"
windows="/wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_windows.txt"

# run
python3 "$script" --windows "$windows" --model_directory "$model_directory" --chr "$chr" --cell_types HFF H1ESC GM12878 IMR90 HCT116 --output_directory "$output_directory" --fasta panTro6_"$chr".fa

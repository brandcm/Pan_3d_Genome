#!/bin/bash
#$ -N akita_prediction_samples
#$ -t 1-1704
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/akita_prediction_samples.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/akita_prediction_samples.err
#$ -l h_rt=24:00:00
#$ -l mem_free=60G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate basenji

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/fastas

# create output directory and assign variables
mkdir -p /wynton/group/capra/projects/pan_3d_genome/data/predictions/samples
ind_chr_IDs="/wynton/group/capra/projects/pan_3d_genome/data/metadata/ind_and_chr_IDs_for_array.txt"
ind=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$ind_chr_IDs")
chr=$(awk -v row=$SGE_TASK_ID 'NR == row {print $2}' "$ind_chr_IDs")
model_directory="/wynton/group/capra/projects/pan_3d_genome/data/model"
output_directory="/wynton/group/capra/projects/pan_3d_genome/data/predictions/samples"
script="/wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/akita_prediction_samples.py"
windows="/wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_windows.txt"

# run
python3 "$script" --windows "$windows" --model_directory "$model_directory" --chr "$chr"  --cell_types HFF GM12878 --output_directory "$output_directory" --individual "$ind" --fasta "$ind"_"$chr".fa

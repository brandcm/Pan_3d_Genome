#!/bin/bash
#$ -N pairwise_comparisons_reference
#$ -t 1-10
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/pairwise_comparisons_reference.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/pairwise_comparisons_reference.err
#$ -l h_rt=48:00:00
#$ -l mem_free=60G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/comparisons/reference

# assign variables
mkdir -p /wynton/group/capra/projects/pan_3d_genome/data/comparisons/reference
cell_type_pairs="/wynton/group/capra/projects/pan_3d_genome/data/metadata/cell_type_pairs.txt"
cell1=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$cell_type_pairs")
cell2=$(awk -v row=$SGE_TASK_ID 'NR == row {print $2}' "$cell_type_pairs")
script="/wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/pairwise_comparisons_reference.py"

# run
python3 "$script" --cell_type_1_predictions /wynton/group/capra/projects/pan_3d_genome/data/predictions/reference/3d_predictions_"$cell1".txt --cell_type_2_predictions /wynton/group/capra/projects/pan_3d_genome/data/predictions/reference/3d_predictions_"$cell2".txt --cell_type_1_ID "$cell1" --cell_type_2_ID "$cell2"
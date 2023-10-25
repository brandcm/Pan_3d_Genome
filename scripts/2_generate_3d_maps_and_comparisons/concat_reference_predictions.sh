#!/bin/bash
#$ -N concat_reference_predictions
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/concat_reference_predictions.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/concat_reference_predictions.err
#$ -l h_rt=6:00:00
#$ -l mem_free=20G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/predictions/reference

# assign variable
cell_types=('GM12878' 'H1ESC' 'HCT116' 'HFF' 'IMR90' )

# concat
for cell_type in ${cell_types[@]}; do cat 3d_predictions_"$cell_type"_*.txt > 3d_predictions_"$cell_type".txt; done
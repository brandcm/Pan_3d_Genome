#!/bin/bash
#$ -N concat_sample_predictions
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/concat_sample_predictions.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/concat_sample_predictions.err
#$ -l h_rt=2:00:00
#$ -l mem_free=20G


# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/predictions/samples

# assign variables
cell_types=('GM12878' 'HFF' )
mapfile -t samples < /wynton/group/capra/projects/pan_3d_genome/data/metadata/sample_names_post_mapping.txt

# concat
for cell_type in ${cell_types[@]}; do for sample in ${samples[@]}; do cat 3d_predictions_"$cell_type"_"$sample"_chr*.txt > 3d_predictions_"$cell_type"_"$sample".txt; done; done
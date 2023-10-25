#!/bin/bash
#$ -N pairwise_comparisons
#$ -t 1-2485
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/pairwise_comparisons.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/pairwise_comparisons.err
#$ -l h_rt=48:00:00
#$ -l mem_free=60G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/comparisons/samples

# assign variables
samples_pairs="/wynton/group/capra/projects/pan_3d_genome/data/metadata/sample_pairs.txt"
ind1=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$sample_pairs")
ind2=$(awk -v row=$SGE_TASK_ID 'NR == row {print $2}' "$sample_pairs")
script="/wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/pairwise_comparisons.py"

# run
python3 "$script" --cell_type 'HFF' --individual_1_predictions /wynton/group/capra/projects/pan_3d_genome/data/predictions/samples/3d_predictions_HFF_"$ind1".txt --individual_2_predictions /wynton/group/capra/projects/pan_3d_genome/data/predictions/samples/3d_predictions_HFF_"$ind2".txt --individual_1_ID "$ind1" --individual_2_ID "$ind2"
python3 "$script" --cell_type 'GM12878' --individual_1_predictions /wynton/group/capra/projects/pan_3d_genome/data/predictions/samples/3d_predictions_GM12878_"$ind1".txt --individual_2_predictions /wynton/group/capra/projects/pan_3d_genome/data/predictions/samples/3d_predictions_GM12878_"$ind2".txt --individual_1_ID "$ind1" --individual_2_ID "$ind2"
echo "$ind1 and $ind2 comparison complete"
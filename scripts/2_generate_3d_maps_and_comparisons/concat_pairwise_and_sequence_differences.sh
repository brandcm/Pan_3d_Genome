#!/bin/bash
#$ -N concat_pairwise_comparisons_and_sequence_differences
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/concat_pairwise_comparisons_and_sequence_differences.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/concat_pairwise_comparisons_and_sequence_differences.err
#$ -l h_rt=6:00:00
#$ -l mem_free=20G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data

# concat
cat comparisons/samples/*_HFF_comparison.txt > comparisons/samples/all_HFF_comparisons.txt
cat comparisons/samples/*_GM12878_comparison.txt > comparisons/samples/all_GM12878_comparisons.txt
cat sequence_differences/*_sequence_differences.txt > sequence_differences/all_sequence_differences.txt
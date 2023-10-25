#!/bin/bash
#$ -N sequence_differences
#$ -t 1-2485
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/sequence_differences.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/sequence_differences.err
#$ -l h_rt=24:00:00
#$ -l mem_free=20G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate ancestral_allele

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/sequence_differences

# assign variables
sample_pairs="/wynton/group/capra/projects/pan_3d_genome/data/metadata/sample_pairs.txt"
ind1=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$sample_pairs")
ind2=$(awk -v row=$SGE_TASK_ID 'NR == row {print $2}' "$sample_pairs")
script="/wynton/group/capra/projects/pan_3d_genome/scripts/2_generate_3d_maps_and_comparisons/sequence_differences.py"
windows="/wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_windows.txt"

# run
python3 "$script" --windows "$windows" --individual_1_FASTA /wynton/group/capra/projects/pan_3d_genome/fastas/"$ind1".fa --individual_2_FASTA /wynton/group/capra/projects/pan_3d_genome/fastas/"$ind2".fa --individual_1_ID "$ind1" --individual_2_ID "$ind2"
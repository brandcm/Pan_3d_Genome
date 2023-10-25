#!/bin/bash
#$ -N complete_linkage_hierarchical_clustering_per_window
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/hierarchical_clustering_per_window.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/hierarchical_clustering_per_window.err
#$ -l h_rt=12:00:00
#$ -l mem_free=20G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate jupyter

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/window_topologies

# assign variable
script="/wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/hierarchical_clustering_per_window_stats.py"
input="/wynton/group/capra/projects/pan_3d_genome/data/dataframes/HFF_comparisons.txt"

# run
python3 "$script" --input "$input" --linkage 'complete' --output 'complete_linkage_clustering_per_window.txt'

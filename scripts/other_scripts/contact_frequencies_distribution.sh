#!/bin/bash
#$ -N contact_frequencies_distribution
#$ -t 1-56
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/contact_frequencies_distribution.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/contact_frequencies_distribution.err
#$ -l h_rt=4:00:00
#$ -l mem_free=60G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/metadata

# assign variables
script="/wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/contact_frequencies_distribution.py"
samples="/wynton/group/capra/projects/pan_3d_genome/data/metadata/sample_names_subset.txt"
ind=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$samples")
predictions_directory="/wynton/group/capra/projects/pan_3d_genome/data/predictions/samples/"

# run
python3 "$script" --input "$predictions_directory"3d_predictions_HFF_"$ind".txt

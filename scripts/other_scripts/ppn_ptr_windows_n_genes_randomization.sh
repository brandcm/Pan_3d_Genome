#!/bin/bash
#$ -N ppn_ptr_windows_n_genes_randomization
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/ppn_ptr_windows_n_genes_randomization.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/ppn_ptr_windows_n_genes_randomization.err
#$ -l h_rt=2:00:00
#$ -l mem_free=20G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate jupyter

# change directories and assign variable
cd /wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows
script='/wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/ppn_ptr_windows_n_genes_randomization.py'

# run
python3 "$script"

#!/bin/bash
#$ -N calculate_3D_modifying_variant_contact_effects
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/calculate_3D_modifying_variant_contact_effects.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/calculate_3D_modifying_variant_contact_effects.err
#$ -l h_rt=3:00:00
#$ -l mem_free=20G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate basics

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows

# assign variables
script="/wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/scripts/calculate_3D_modifying_variant_contact_effects.py"
input="/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows/ppn_ptr_divergent_window_3d_modifying_variants.txt"

# run
python3 "$script" --input "$input" --out ppn_ptr_divergent_window_3d_modifying_variant_contact_effects.txt
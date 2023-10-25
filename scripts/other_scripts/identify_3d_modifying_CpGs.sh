#!/bin/bash
#$ -N identify_3d_modifying_CpGs
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/identify_3d_modifying_CpGs.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/identify_3d_modifying_CpGs.err
#$ -l h_rt=4:00:00
#$ -l mem_free=10G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate ancestral_allele

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows

# assign variables
script="/wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/identify_3d_modifying_CpGs.py"
variants="/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows/divergent_ppn_ptr_window_3d_modifying_variants.txt"
fasta="/wynton/group/capra/projects/pan_3d_genome/data/reference_fasta/filtered_panTro6.fa"
out="/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows/divergent_ppn_ptr_window_3d_modifying_variants_with_CpGs.txt"

# run
python3 "$script" --variants "$variants" --fasta "$fasta" --output "$out"

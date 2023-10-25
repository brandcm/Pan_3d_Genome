#!/bin/bash
#$ -N in_silico_mutagenesis_ptt_specific_variants
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/in_silico_mutagenesis_ptt_specific_variants.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/in_silico_mutagenesis_ptt_specific_variants.err
#$ -l h_rt=24:00:00
#$ -l mem_free=20G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate basenji

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/in_silico_mutagenesis

# assign variables
script="/wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/scripts/in_silico_mutagenesis.py"
fasta="/wynton/group/capra/projects/pan_3d_genome/data/reference_fasta/filtered_panTro6.fa"
input="/wynton/group/capra/projects/pan_3d_genome/data/ptr_subspecies_specific_variants/ptt_specific_variants_with_window.txt"

# run
python3 "$script" --fasta "$fasta" --input "$input" --start 0 --end 150 --out ptt_specific_variants_in_silico_mutagenesis.txt
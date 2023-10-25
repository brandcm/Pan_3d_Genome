#!/bin/bash
#$ -N generate_ppn_ptr_divergent_window_3d_modifying_variant_contact_maps
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/generate_ppn_ptr_divergent_window_3d_modifying_variant_contact_maps.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/generate_ppn_ptr_divergent_window_3d_modifying_variant_contact_maps.err
#$ -l h_rt=6:00:00
#$ -l mem_free=30G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate basenji

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/in_silico_mutagenesis

# create directory for output if needed
mkdir -p /wynton/group/capra/projects/pan_3d_genome/data/in_silico_mutagenesis/ppn_ptr_divergent_window_3d_modifying_variant_predictions

# assign variables
script="/wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/scripts/generate_3d_modifying_variant_contact_maps.py"
fasta="/wynton/group/capra/projects/pan_3d_genome/data/reference_fasta/filtered_panTro6.fa"
input="/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows/ppn_ptr_divergent_window_3d_modifying_variants.txt"
preds="/wynton/group/capra/projects/pan_3d_genome/data/in_silico_mutagenesis/ppn_ptr_divergent_window_3d_modifying_variant_predictions"

# run
python3 "$script" --fasta "$fasta" --input "$input" --prediction_dir "$preds"
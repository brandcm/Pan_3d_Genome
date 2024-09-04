#!/bin/bash
#$ -N in_silico_mutagenesis_ppn_ptr_inversions
#$ -t 1-84
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_ptr_structural_variants/in_silico_mutagenesis_ppn_ptr_inversions.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_ptr_structural_variants/in_silico_mutagenesis_ppn_ptr_inversions.err
#$ -l h_rt=2:00:00
#$ -l mem_free=20G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate basenji

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_structural_variants
mkdir -p inversion_predictions

# assign variables
script="/wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_ptr_structural_variants/in_silico_mutagenesis_ppn_ptr_inversions.py"
reference="/wynton/group/capra/projects/pan_3d_genome/data/reference_fasta/filtered_panTro6.fa"
inversions="/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_structural_variants/Mao_et_al_2021_and_Porubsky_et_al_2020_inversions.bed"
chr=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$inversions")
inv_start=$(awk -v row=$SGE_TASK_ID 'NR == row {print $2}' "$inversions")
inv_end=$(awk -v row=$SGE_TASK_ID 'NR == row {print $3}' "$inversions")
window_start=$(awk -v row=$SGE_TASK_ID 'NR == row {print $4}' "$inversions")

# run
python3 "$script" --fasta "$reference" --chr "$chr" --inv_start "$inv_start" --inv_end "$inv_end" --window_start "$window_start" --out Mao_et_al_2021_and_Porubsky_et_al_2020_inversions.tmp

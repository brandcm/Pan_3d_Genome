#!/bin/bash
#$ -N in_silico_mutagenesis_ppn_specific_variants_in_ppn_ptr_divergent_windows
#$ -t 1-255
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/in_silico_mutagenesis_ppn_specific_variants_in_ppn_ptr_divergent_windows.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/in_silico_mutagenesis_ppn_specific_variants_in_ppn_ptr_divergent_windows.err
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
input="/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows/ppn_specific_variants_in_ppn_ptr_divergent_windows.txt"
splits="/wynton/group/capra/projects/pan_3d_genome/data/metadata/splits_for_ppn_specific_variant_in_silico_mutagenesis_array.txt"
start=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$splits")
end=$(awk -v row=$SGE_TASK_ID 'NR == row {print $2}' "$splits")

# run
python3 "$script" --fasta "$fasta" --input "$input" --start "$start" --end "$end" --out ppn_specific_variants_in_ppn_ptr_divergent_windows_in_silico_mutagenesis_"$SGE_TASK_ID".txt
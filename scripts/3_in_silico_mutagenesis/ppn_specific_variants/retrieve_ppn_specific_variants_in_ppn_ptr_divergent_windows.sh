#!/bin/bash
#$ -N retrieve_ppn_specific_variants_in_ppn_ptr_divergent_windows
#$ -t 1-89
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/retrieve_ppn_specific_variants_in_ppn_ptr_divergent_windows.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/retrieve_ppn_specific_variants_in_ppn_ptr_divergent_windows.err
#$ -l h_rt=12:00:00
#$ -l mem_free=20G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows

# assign variables
genotypes="/wynton/group/capra/projects/pan_3d_genome/data/vcfs/one_zero_genotypes.txt"
script="/wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/scripts/retrieve_private_variants.py"
windows="/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows/ppn_ptr_divergent_windows.bed"

chr=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' "$windows")
start=$(awk -v row=$SGE_TASK_ID 'NR == row {print $2}' "$windows")
end=$(awk -v row=$SGE_TASK_ID 'NR == row {print $3}' "$windows")

# run
python3 "$script" --genotypes "$genotypes" --ids 9 20 22 25 26 33 34 36 45 --out "$chr"_"$start"_ppn_specific_variants_in_ppn_ptr_divergent_windows.tmp --region "$chr" $(($start+1)) $(($end+1))
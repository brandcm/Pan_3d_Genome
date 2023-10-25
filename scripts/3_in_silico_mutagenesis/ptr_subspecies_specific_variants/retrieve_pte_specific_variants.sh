#!/bin/bash
#$ -N retrieve_pte_specific_variants
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/retrieve_pte_specific_variants.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/retrieve_pte_specific_variants.err
#$ -l h_rt=24:00:00
#$ -l mem_free=20G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/ptr_subspecies_specific_variants

# assign variables
script="/wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/scripts/retrieve_private_variants.py"
genotypes="/wynton/group/capra/projects/pan_3d_genome/data/vcfs/one_zero_genotypes.txt"

# run
python3 "$script" --genotypes "$genotypes" --ids 1 19 30 35 48 --out pte_specific_variants.tmp

# sort output
sort -k1,1 -k2n,2 pte_specific_variants.tmp > pte_specific_variants.txt
rm pte_specific_variants.tmp
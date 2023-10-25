#!/bin/bash
#$ -N retrieve_ptt_specific_variants
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/retrieve_ptt_specific_variants.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/retrieve_ptt_specific_variants.err
#$ -l h_rt=24:00:00
#$ -l mem_free=20G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/ptr_subspecies_specific_variants

# assign variables
script="/wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/scripts/retrieve_private_variants.py"
genotypes="/wynton/group/capra/projects/pan_3d_genome/data/vcfs/one_zero_genotypes.txt"

# run
python3 "$script" --genotypes "$genotypes" --ids 2 8 11 14 21 24 29 37 39 40 43 46 49 52 53 56 --out ptt_specific_variants.tmp

# sort output
sort -k1,1 -k2n,2 ptt_specific_variants.tmp > ptt_specific_variants.txt
rm ptt_specific_variants.tmp
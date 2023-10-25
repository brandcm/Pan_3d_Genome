#!/bin/bash
#$ -N concat_retrieved_ppn_specific_variants
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/concat_retrieved_ppn_specific_variants.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/concat_retrieved_ppn_specific_variants.err
#$ -l h_rt=1:00:00
#$ -l mem_free=10G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows

# run
cat *_ppn_specific_variants_in_ppn_ptr_divergent_windows.tmp > ppn_specific_variants_in_ppn_ptr_divergent_windows.tmp
sort -k1,1 -k2n,2 ppn_specific_variants_in_ppn_ptr_divergent_windows.tmp > ppn_specific_variants_in_ppn_ptr_divergent_windows.txt
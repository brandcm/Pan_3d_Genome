#!/bin/bash
#$ -N concat_ppn_specific_variant_in_silico_mutagenesis
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/concat_ppn_specific_variant_in_silico_mutagenesis.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ppn_specific_variants/concat_ppn_specific_variant_in_silico_mutagenesis.err
#$ -l h_rt=1:00:00
#$ -l mem_free=10G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/in_silico_mutagenesis

# run
head -n 1 ppn_specific_variants_in_ppn_ptr_divergent_windows_in_silico_mutagenesis_1.txt > ppn_specific_variants_in_ppn_ptr_divergent_windows_in_silico_mutagenesis.txt
for i in {1..255}; do tail -n +2 ppn_specific_variants_in_ppn_ptr_divergent_windows_in_silico_mutagenesis_"$i".txt >> ppn.tmp; done
sort -k1,1 -k2n,2 ppn.tmp >> ppn_specific_variants_in_ppn_ptr_divergent_windows_in_silico_mutagenesis.txt
rm ppn.tmp
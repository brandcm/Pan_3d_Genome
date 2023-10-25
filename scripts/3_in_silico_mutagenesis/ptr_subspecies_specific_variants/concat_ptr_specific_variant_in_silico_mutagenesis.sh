#!/bin/bash
#$ -N concat_ptr_specific_variant_in_silico_mutagenesis
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/concat_ptr_specific_variant_in_silico_mutagenesis.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/concat_ptr_specific_variant_in_silico_mutagenesis.err
#$ -l h_rt=1:00:00
#$ -l mem_free=10G

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/in_silico_mutagenesis

# pte
head -n 1 pte_specific_variants_in_silico_mutagenesis_1.txt > pte_specific_variants_in_silico_mutagenesis.txt
for i in {1..130}; do tail -n +2 pte_specific_variants_in_silico_mutagenesis_"$i".txt >> pte.tmp; done
sort -k1,1 -k2n,2 pte.tmp >> pte_specific_variants_in_silico_mutagenesis.txt
rm pte.tmp

# ptv
head -n 1 ptv_specific_variants_in_silico_mutagenesis_1.txt > ptv_specific_variants_in_silico_mutagenesis.txt
for i in {1..46}; do tail -n +2 ptv_specific_variants_in_silico_mutagenesis_"$i".txt >> ptv.tmp; done
sort -k1,1 -k2n,2 ptv.tmp >> ptv_specific_variants_in_silico_mutagenesis.txt
rm ptv.tmp
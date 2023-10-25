#!/bin/bash
#$ -N prepare_reference_fasta
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/prepare_reference_fasta.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/prepare_reference_fasta.err
#$ -l h_rt=36:00:00
#$ -l scratch=20G

# load modules
module load CBI
module load samtools/1.18

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/reference_fasta

# assign variable
chrs=('chr1' 'chr2A' 'chr2B' 'chr3' 'chr4' 'chr5' 'chr6' 'chr7' 'chr8' 'chr9' 'chr10' 'chr11' 'chr12' 'chr13' 'chr14' 'chr15' 'chr16' 'chr17' 'chr18' 'chr19' 'chr20' 'chr21' 'chr22' 'chrX' )

# run
samtools faidx -o filtered_panTro6.fa panTro6.fa chr1 chr2A chr2B chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX
samtools faidx filtered_panTro6.fa

for chr in ${chrs[@]}; do samtools faidx filtered_panTro6.fa "$chr" > panTro6_"$chr".fa; done
for chr in ${chrs[@]}; do samtools faidx panTro6_"$chr".fa; done
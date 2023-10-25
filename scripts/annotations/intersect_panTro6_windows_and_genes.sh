#!/bin/bash
#$ -N intersect_panTro6_windows_and_genes
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/intersect_panTro6_windows_and_genes.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/other_scripts/intersect_panTro6_windows_and_genes.err
#$ -l h_rt=2:00:00
#$ -l scratch=40G

# load module
module load CBI
module load bedtools2/2.30.0

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/annotations

# assign variables
windows="/wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_windows_with_full_coverage.bed"
genes="/wynton/group/capra/projects/pan_3d_genome/data/annotations/panTro6_genes.bed"

# run
bedtools intersect -a "$windows" -b "$genes" -wa -wb > windows_genes_intersect.bed


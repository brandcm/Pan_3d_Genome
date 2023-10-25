#!/bin/bash
#$ -N map_window_to_ptr_subspecies_specific_variants
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/map_window_to_ptr_subspecies_specific_variants.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/3_in_silico_mutagenesis/ptr_subspecies_specific_variants/map_window_to_ptr_subspecies_specific_variants.err
#$ -l h_rt=1:00:00
#$ -l mem_free=10G

# load modules
module load CBI
module load bedtools2/2.30.0

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/ptr_subspecies_specific_variants

# assign variables
pops=('pte' 'pts' 'ptt' 'ptv' )
windows="/wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_windows_with_full_coverage.bed"

# generate temp bed files
for p in ${pops[@]}; do awk '{print $1,$2-1,$2,$3,$4}' OFS='\t' "$p"_specific_variants.txt > "$p".bed; done

# intersect
for p in ${pops[@]}; do bedtools intersect -a "$p".bed -b "$windows" -wa -wb > "$p".tmp; done

# format intersection
for p in ${pops[@]}; do awk '{print $1,$3,$4,$5,$6"_"$7}' OFS='\t' "$p".tmp > "$p"_specific_variants_with_window.txt; done

# remove other files
for p in ${pops[@]}; do rm "$p".bed && rm "$p".tmp; done
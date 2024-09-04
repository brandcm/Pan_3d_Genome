#!/bin/bash
# Colin M. Brand, University of California San Francisco, 07/19/2023

# load modules
module load CBI
module load Sali
module load bedtools2/2.31.1
module load python3/pandas/0.25.3

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_structural_variants

# assign variables
liftOver="/wynton/group/capra/bin/liftOver/liftOver"
hg38_panTro6_chain="/wynton/group/capra/projects/pan_3d_genome/scripts/annotations/hg38ToPanTro6.over.chain.gz"
script="/wynton/group/capra/projects/pan_3d_genome/scripts/annotations/merge_strandSeq_intervals.py"
windows="/wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_windows_with_full_coverage.bed"

# download inversion directory
git clone https://github.com/daewoooo/ApeInversion_paper.git

# subset 'INVs' only
awk -F, '($7 == "INV") {print $1,$2,$3,$4,$5,$6,$7}' OFS='\t' ApeInversion_paper/Supplementary_datasets/strandS_inversions.csv > Porubsky_et_al_2020_inversions.bed

# run Python script to assess which inversions are shared
python3 "$script"

# subset chimpanzee and bonobo-specific inversions
awk '($4 == "bonobo") {print $1,$2,$3}'  OFS='\t' merged_Porubsky_et_al_2020_inversions.bed > ppn_inversions.bed
awk '($4 == "chimpanzee") {print $1,$2,$3}' OFS='\t' merged_Porubsky_et_al_2020_inversions.bed > ptr_inversions.bed

# liftover from hg38 to panTro6
"$liftOver" ppn_inversions.bed "$hg38_panTro6_chain" ppn_inversions_panTro6.bed hg38_to_panTro6_ppn_inversions_unlifted.bed
"$liftOver" ptr_inversions.bed "$hg38_panTro6_chain" ptr_inversions_panTro6.bed hg38_to_panTro6_ptr_inversions_unlifted.bed

# move unlifted files to unlifted directory
mkdir -p Porubsky_et_al_2020_unlifted
mv hg38_to_panTro6_ppn_inversions_unlifted.bed Porubsky_et_al_2020_unlifted
mv hg38_to_panTro6_ptr_inversions_unlifted.bed Porubsky_et_al_2020_unlifted

# sort new BED files
sort -k1,1 -k2n,2 ppn_inversions_panTro6.bed > tmp.bed && mv tmp.bed ppn_inversions_panTro6.bed
sort -k1,1 -k2n,2 ptr_inversions_panTro6.bed > tmp.bed && mv tmp.bed ptr_inversions_panTro6.bed

# map window on to intervals and filter intervals than span the entire window
bedtools intersect -a ppn_inversions_panTro6.bed -b "$windows" -wa -wb > ppn.tmp
bedtools intersect -a ptr_inversions_panTro6.bed -b "$windows" -wa -wb > ptr.tmp
awk '($5 < $2) && ($6 > $3) {print $1,$2,$3,$5}' OFS='\t' ppn.tmp > Porubsky_et_al_2020_ppn_inversions_panTro6_with_window.bed
awk '($5 < $2) && ($6 > $3) {print $1,$2,$3,$5}' OFS='\t' ptr.tmp > Porubsky_et_al_2020_ptr_inversions_panTro6_with_window.bed

# remove files no longer needed
rm Porubsky_et_al_202_inversions.bed && rm merged_Porubsky_et_al_2020_inversions.bed
rm ppn_inversions.bed && rm ptr_inversions.bed
rm ppn_inversions_panTro6.bed && rm ptr_inversions_panTro6.bed
rm ppn.tmp && rm ptr.tmp

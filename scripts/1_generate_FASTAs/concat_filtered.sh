#!/bin/bash
#$ -N concat_filtered
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/concat_filtered.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/concat_filtered.err
#$ -l h_rt=12:00:00
#$ -l mem_free=50G

# load modules
module load CBI
module load bcftools/1.18

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/vcfs

# assign variable
mapfile -t samples < /wynton/group/capra/projects/pan_3d_genome/data/metadata/sample_names_original.txt

# concat and index
for sample in ${samples[@]}; do bcftools concat "$sample"_chr*.filtered.vcf.gz -O z -o "$sample"_filtered.vcf.gz; done
for sample in ${samples[@]}; do bcftools index -t "$sample"_filtered.vcf.gz; done

# rename files with "_" in name
mv Cindy_schwein_filtered.vcf.gz Cindy-schwein_filtered.vcf.gz && mv Cindy_schwein_filtered.vcf.gz.tbi Cindy-schwein_filtered.vcf.gz.tbi
mv Cindy_troglodytes_filtered.vcf.gz Cindy-troglodytes_filtered.vcf.gz && mv Cindy_troglodytes_filtered.vcf.gz.tbi Cindy-troglodytes_filtered.vcf.gz.tbi
mv Cindy_verus_filtered.vcf.gz Cindy-verus_filtered.vcf.gz && mv Cindy_verus_filtered.vcf.gz.tbi Cindy-verus_filtered.vcf.gz.tbi
mv Coco_chimp_filtered.vcf.gz Coco-chimp_filtered.vcf.gz && mv Coco_chimp_filtered.vcf.gz.tbi Coco-chimp_filtered.vcf.gz.tbi
mv Julie_A959_filtered.vcf.gz Julie-A959_filtered.vcf.gz && mv Julie_A959_filtered.vcf.gz.tbi Julie-A959_filtered.vcf.gz.tbi
mv Julie_LWC21_filtered.vcf.gz Julie-LWC21_filtered.vcf.gz && mv Julie_LWC21_filtered.vcf.gz.tbi Julie-LWC21_filtered.vcf.gz.tbi

# remove split files
for sample in ${samples[@]}; do rm "$sample"_chr*.filtered.vcf.gz; done
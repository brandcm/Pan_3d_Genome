#!/bin/bash
#$ -N site_filtering
#$ -t 1-24
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/site_filtering.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/site_filtering.err
#$ -l h_rt=24:00:00
#$ -l mem_free=50G

# load modules
module load CBI
module load bcftools/1.18

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/vcfs

# assign variables
chr=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' /wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_chrs.txt)
raw_vcfs_directory="/wynton/group/capra/projects/pan_3d_genome/data/raw_vcfs"

# write filtering function
site_filter () {
        bcftools view -s ^HG00513  "$raw_vcfs_directory"/pantro6."$chr".gatk.called.raw.vcf.gz | # exclude human sample from VCF
        bcftools view -i 'AN=142' -m2 -M2 -v snps | # retain bialleleic SNVs with a genotype called in all individuals
        bcftools filter -i 'QUAL>=30 & QD>2 & MQ>=30' -O z -o filtered_pantro6."$chr".gatk.called.raw.vcf.gz # exclude low-quality sites and output
}

# run
site_filter "$chr"
bcftools index -t filtered_pantro6."$chr".gatk.called.raw.vcf.gz
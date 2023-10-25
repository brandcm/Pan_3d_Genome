#!/bin/bash
#$ -N genotype_filtering
#$ -t 1-1704
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/genotype_filtering.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/genotype_filtering.err
#$ -l h_rt=24:00:00
#$ -l mem_free=50G

# load modules
module load CBI
module load bcftools/1.18

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/vcfs

# assign variables
ind=$(awk -v row=$SGE_TASK_ID 'NR == row {print $1}' /wynton/group/capra/projects/pan_3d_genome/data/metadata/ind_and_chr_IDs_for_array.txt)
chr=$(awk -v row=$SGE_TASK_ID 'NR == row {print $2}' /wynton/group/capra/projects/pan_3d_genome/data/metadata/ind_and_chr_IDs_for_array.txt)

# write filtering function
genotype_filter () {
        bcftools view -s "$ind" filtered_pantro6."$chr".gatk.called.raw.vcf.gz | # subset the individual
        bcftools filter -S 0 -i 'FMT/DP>=10 & FMT/GQ>=30' | # set low-quality genotypes to reference
        bcftools view -e 'FMT/GT="0/0"' -O z -o "$ind"_"$chr".filtered.vcf.gz # exclude fixed ref genotypes and output
}

# run
genotype_filter "$ind" "$chr"
bcftools index -t "$ind"_"$chr".filtered.vcf.gz
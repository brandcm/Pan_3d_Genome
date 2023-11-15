#!/bin/bash
#$ -N phenotype_enrichment_pipeline
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/data/phenotype_enrichment/ppn_ptr_divergent_windows_phenotype_enrichment_pipeline.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/data/phenotype_enrichment/ppn_ptr_divergent_windows_phenotype_enrichment_pipeline.err
#$ -l h_rt=48:00:00
#$ -l mem_free=100G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate phenotype_enrichment

# run
snakemake --use-conda --cluster "qsub -l h_rt={params.time} -l h_vmem={params.mem}G -V" -j 100
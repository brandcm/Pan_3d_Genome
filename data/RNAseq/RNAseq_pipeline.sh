#!/bin/bash
#$ -N RNAseq_pipeline
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/data/RNAseq/RNAseq_pipeline.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/data/RNAseq/RNAseq_pipeline.err
#$ -l h_rt=24:00:00
#$ -l mem_free=40G

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate RNAseq

# run
snakemake --use-conda --cluster "qsub -l h_rt={params.time} -l h_vmem={params.mem}G -V" -j 21

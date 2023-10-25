#!/bin/bash
#$ -N pipeline
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o ~/../../../group/capra/projects/pan_3d_genome/data/RNAseq/pipeline_no.out
#$ -e ~/../../../group/capra/projects/pan_3d_genome/data/RNAseq/pipeline_no.err
#$ -l h_rt=24:00:00
#$ -l mem_free=40G


# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate EPAS1

# run
#snakemake --use-conda --cluster "qsub -l h_rt={params.time} -l h_vmem={params.mem}G -V" -j 21
snakemake -s Snakefile_no --use-conda --cluster "qsub -l h_rt={params.time} -l h_vmem={params.mem}G -V" -j 21

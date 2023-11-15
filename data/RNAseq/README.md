This directory contains data and scripts to run a pipeline that completes quality control, mapping, and quantification of RNAseq data from bonobos and chimpanzees. The raw fastqs are missing from this directory but can be added to a subdirectory named 'fastq'. The bams, reference, and trimmed fastq directories also missing but are generated using the pipeline. To run the pipeline, first create a Conda environment from the requirements.txt file using the following command:

```
conda create --name RNAseq --file requirements.txt
```

The pipeline itself is run using the RNAseq_pipeline.sh script.

&nbsp;

The subdirectories and files in this directory are described below.

- adapters.fa contains Illumina adapter sequences that are trimmed from reads in the pipeline.

- dag.pdf is a directed acyclic graph (DAG) of the pipeline.

- fastqc_results/ contains the output fastqc files. 

- multiqc_results/ contains the output multiqc files.

- read_counts/ contains a single file per sample with read counts per gene calculated using htseq.

- requirements.txt lists the dependencies required to run the pipeline. See above for how to create a Conda environment.

- RNAseq_pipeline.sh is a bash script that launches the pipeline on the HPC cluster.

- Snakefile is the pipeline.

- trimmed_fastqc_results/ contains the output fastqc files from trimmed reads.

- trimmed_multiqc_results/ contains the output multiqc files from trimmed reads.
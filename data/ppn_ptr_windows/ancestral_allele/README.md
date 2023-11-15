This directory contains data and scripts to run a pipeline that retrieves ancestral alleles for bonobo-specific 3d-modifying variants. There are four missing files in this directory. First is the the liftOver executable which can be easily added to this directory. Alternatively, the path can be altered in the Snakefile. The remaining missing files are the FASTA and FASTA indices for the ancestral hg38 sequence from the data/ directory. However, these files are created when running the pipeline. To run the pipeline, first create a Conda environment from the requirements.txt file using the following command:

```
conda create --name myenv --file requirements.txt
```

Activate the environment and then run the pipeline:

```
snakemake --cores 1
```

&nbsp;

The subdirectories and files in this directory are described below.

- chain_files/ contains two chain files used during liftOver.

- chain_files/hg38ToPanTro6.over.chain.gz converts coordinates from hg38 to panTro6.

- chain_files/panTro6ToHg38.over.chain.gz converts coordinates from panTro6 to hg38.

- dag.pdf is a directed acyclic graph (DAG) of the pipeline.

- data/ contains files used and generated from the pipeline.

- data/ppn_ptr_divergent_window_3d_modifying_variants_ancestral_allele.txt is the output file with ancestral allele calls per variant.

- data/ppn_ptr_divergent_window_3d_modifying_variants.bed is a BED file of bonobo-specific 3d-modifying variants.

- data/rename_ancestral_GRCh38_seqs.txt renames contigs in the ancestral genome.

- requirements.txt lists the dependencies required to run the pipeline. See above for how to create a Conda environment.

- scripts/ contains two scripts used in the pipeline.

- scripts/ancestral_allele_to_BED.py retrieves the ancestral allele for a set of variants. This script has three arguments:<br>
	>--fasta, the path to the input FASTA<br><br>
	--bed, the path to the input file of variants in BED format<br><br>
	--output, the path to the output file

- scripts/download_and_rehead_FASTA.sh downloads the hg38 ancestral sequence and renames the contigs. 

- Snakefile is the pipeline.
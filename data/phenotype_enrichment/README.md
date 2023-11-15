This directory contains data and scripts to run a pipeline that conducts an enrichment analysis of genes associated with different phenotypes. Two subdirectories with intermediate files are missing but can be regenerated using the pipeline. To run the pipeline, first create a Conda environment from the requirements.txt file using the following command:

```
conda create --name phenotype_enrichment --file requirements.txt
```

The pipeline itself is run using the ppn_ptr_divergent_windows_phenotype_enrichment_pipeline.sh script.

&nbsp;

The subdirectories and files in this directory are described below.

- dag.pdf is a directed acyclic graph (DAG) of the pipeline.

- data/ contains files used to complete the enrichment analysis.

- enrichment/ contains the final output files from the analysis.

- observed/ contains a file per ontology that indicates which genes are absent (FALSE) or present (TRUE) per phenotype.

- ontologies/ contains the gene-phenotype associations from Enrichr.

- requirements.txt lists the dependencies required to run the pipeline. See above for how to create a Conda environment.

- ppn_ptr_divergent_windows_phenotype_enrichment_pipeline.sh is a bash script that launches the pipeline on the HPC cluster.

- scripts/ contains four scripts used in the pipeline.

- scripts/empiric_counts_shuffle_windows.py generates a null distribution of gene counts per phenotype per ontology. This script has four arguments:<br>
	>--iterations, the number of randomizations to complete (default: 1000) FASTA<br><br>
	--ontology, the name of the ontology<br><br>
	--set_name, the variant set name<br><br>
	--array_ID, the array ID to use if parallelizing, defaults to 0 if not
	
- scripts/empiric_FDR.py estimates the false discovery rate using a subset of the null distribution generated in the script above. This script has three arguments:<br>
	>--ontology, the name of the ontology<br><br>
	--set_name, the variant set name<br><br>
	--subset_size, the number of empiric counts to consider when calculating FDR
	
- scripts/enrichment.py calculates gene enrichment for each term per ontology. This script has two arguments:<br>
	>--ontology, the name of the ontology<br><br>
	--set_name, the variant set name

- scripts/gene_set_to_observed.py generates intermediate files used to generate the null distribution of gene counts per phenotype per ontology. This script has three arguments:<br>
	>--genes, the name of the genes file in data/<br><br>	
	--ontology, the name of the ontology<br><br>
	--set_name, the variant set name

- Snakefile is the pipeline.
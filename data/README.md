This directory contains subdirectories that house input and output data used in analysis and visualization. Subdirectories are briefly described below. I have noted where files and directories are missing due to size constraints.

- annotations contains relevant genomic annotations in BED format.

- in_silico_mutagenesis contains the *in silico* mutagenesis results for bonobo and chimpanzee subspecies-specific variants. The ppn_ptr_divergent_window_3d_modifying_variant_predictions directory housing the predicted contact map for 61 bonobo 3d-modifying variant-window pairs is absent from this directory.

- metadata contains basic information used in various analyses and visualizations including data on partitions for array jobs, samples, and windows. 

- model contains the parameters, statistics, targets, and weights for the Akita model.

- Okhovat_et_al_2023 contains ultraconserved and primate-conserved TAD boundaries in panTro6 coordinates from [Okhovat et al. 2023](https://www.biorxiv.org/content/10.1101/2023.03.07.531534v1) as well as 3d divergence maxima from windows intersecting both TAD boundary sets and windows genome-wide.

- phastCons contains a BED file of phastCons elements in panTro6 coordinates and an output analysis file of those elements in bonobo-chimpanzee divergent windows.

- phenotype_enrichment contains files and scripts to test for gene enrichment associated with different phenotypes among bonobo-chimpanzee divergent windows. The empiric_counts and empiric_FDR directories are not included in this repository.

- ppn_ptr_windows contains data on bonobo-chimpanzee divergent windows. 

- ptr_subspecies_specific_variants contains data on chimpanzee subspecies-specific variants.

- RNAseq contains files and scripts to perform QC, trim, map, and analyze *Pan* gene expression data from [Brawand et al. 2011](https://www.nature.com/articles/nature10532). To replicate this analysis, one must download the fastq files to the absent fastq directory. The bams, reference, and trimmed fastq directories are also not included here due to size.

- window_topologies contains the results and subsequent analysis of hierarchical clustering using complete linkage to identify patterns of 3d divergence per genomic window.

&nbsp;

Multiple directories housing FASTAs and VCFs are not included here due to size:
- comparisons
- fastas
- predictions
- raw_vcfs
- sequence_differences
- vcfs

However, all of these directories and their contents can be produced using the scripts provided in this repository upon generating VCFs in the raw_vcfs directory using [this pipeline](https://github.com/thw17/Pan_reassembly). The main HFF comparisons file from the comparisons directory is available on Dryad.
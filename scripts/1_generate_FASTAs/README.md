This directory contains scripts to generate pseudo-haploid sequences in FASTA format of 71 bonobos and chimpanzees for analysis by Akita. Genome-wide and individual chromosomal sequences are created per individual. Scripts are described below and listed in the order they should be run.

- site_filtering.sh creates site-quality filtered VCFs per chromosome.

- genotype_filtering.sh creates genotype-quality filtered VCFs per sample per chromosome.

- concat_filtered.sh concatenates all chromosomal VCFs per sample.

- prepare_reference.sh filters unmapped contigs from the panTro6 reference sequence, creates individual FASTA files for the autosomes and X chromosome, and indexes the genome-wide and individual chromosomal sequences.

- generate_*_FASTAs.sh generates individual FASTAs per sample constructed from the reference sequence and each sample's variants. These sequences are pseudo-haploid---if a non-reference allele is present it is added to the sequence regardless of whether the genotype is heterozygous or homozygous. A single FASTA with all chromosomes is initially generated, followed by chromosome-level sequences per individual. 
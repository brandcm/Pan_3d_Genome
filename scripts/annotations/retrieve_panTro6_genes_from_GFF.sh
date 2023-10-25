#!/bin/bash

# 08-08-22, Colin M. Brand, University of California San Francisco
# Download and format genes and exon from the chimpanzee reference genome, panTro6.

# This script only uses basic Linux commands.

# retrieve GFF
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/880/755/GCF_002880755.1_Clint_PTRv2/GCF_002880755.1_Clint_PTRv2_genomic.gff.gz 
gzip -d GCF_002880755.1_Clint_PTRv2_genomic.gff.gz

# subset longest transcript per gene to new file
awk '$3 == "mRNA" {print $0}' OFS='\t' GCF_002880755.1_Clint_PTRv2_genomic.gff > tmp.txt # subset transcripts from GFF
awk 'NR == FNR {rep[$1] = $2; next} { for (key in rep) gsub(key, rep[key]); print}' OFS='\t' panTro6_NCBI_contigs.dict tmp.txt | # rename chromosomes
awk -F '[\t,;]' '{print $1,$4,$5,$9,$10}' OFS='\t' | # get relevant fields
awk '{gsub("ID=rna-", "", $4); gsub("Parent=gene-", "", $5); print}' OFS='\t' | # excise unnecessary information from annotation
awk '$6=$3-$2' OFS='\t' | # get transcript length
sort -k5,5 -k6,6nr | # sort transcripts by decreasing length within genes
awk '!seen[$5]++' OFS='\t' | # retain the longest transcript
awk '{print $1,$2-1,$3,$4,$5}' OFS='\t' | sed '/^N/d' | sort -k1,1 -k2,2n > panTro6_genes.bed # print relevant fields, cut annotations for unmapped contigs, resort, and export
awk '{print $4,$5}' OFS='\t' panTro6_genes.bed > panTro6_transcript_gene.dict # create a transcript to gene dictionary for exon extraction below
rm tmp.txt

# get exons for longest transcript per gene from above in new file
awk '$3 == "CDS" {print $0}' OFS='\t' GCF_002880755.1_Clint_PTRv2_genomic.gff > tmp.txt # subset transcripts from GFF
awk 'NR == FNR {rep[$1] = $2; next} { for (key in rep) gsub(key, rep[key]); print}' OFS='\t' panTro6_NCBI_contigs.dict tmp.txt | # rename chromosomes
sed '/^N/d' | awk -F '[\t,;]' '{print $1,$4,$5,$10}' OFS='\t' | # get relevant fields
awk '{gsub("Parent=rna-", "", $4); print}' OFS='\t' > tmp2.txt # excise unnecessary information from annotation
awk 'NR==FNR{a[$4]; next} FNR==1 || $4 in a' OFS='\t' panTro6_genes.bed tmp2.txt | # retain exons that match the longest transcript per gene
sort -k1,1 -k2,2n > tmp3.txt # sort exons
awk 'NR==FNR{map[$1]=$2; next} {$5=map[$4]} {print $1,$2-1,$3,$5}' OFS='\t' panTro6_transcript_gene.dict tmp3.txt > panTro6_exons.bed # print relevant fields
rm tmp.txt && rm tmp2.txt && rm tmp3.txt && rm GCF_002880755.1_Clint_PTRv2_genomic.gff
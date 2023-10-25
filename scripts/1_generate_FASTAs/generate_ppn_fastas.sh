#!/bin/bash
#$ -N generate_ppn_fastas
#$ -M colin.brand@ucsf.edu
#$ -m ae
#$ -cwd
#$ -o /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/generate_ppn_fastas.out
#$ -e /wynton/group/capra/projects/pan_3d_genome/scripts/1_generate_FASTAs/generate_ppn_fastas.err
#$ -l h_rt=36:00:00
#$ -l scratch=30G

# load modules
module load CBI
module load samtools/1.18

# load conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate gatk

# change directories
cd /wynton/group/capra/projects/pan_3d_genome/data/fastas

# assign variables
chrs=('chr1' 'chr2A' 'chr2B' 'chr3' 'chr4' 'chr5' 'chr6' 'chr7' 'chr8' 'chr9' 'chr10' 'chr11' 'chr12' 'chr13' 'chr14' 'chr15' 'chr16' 'chr17' 'chr18' 'chr19' 'chr20' 'chr21' 'chr22' 'chrX' )
fasta="/wynton/group/capra/projects/pan_3d_genome/data/reference_fasta/filtered_panTro6.fa"
new_contig_names="/wynton/group/capra/projects/pan_3d_genome/data/metadata/new_fasta_contig_names.txt"
samples=('Bono' 'Catherine' 'Chipita' 'Desmond' 'Dzeeta' 'Hermien' 'Hortense' 'Kombote' 'Kosana' 'Kumbuka' 'LB502' 'Natalie' 'Salonga' )
vcf_directory="/wynton/group/capra/projects/pan_3d_genome/data/vcfs"

# create dict of FASTA, if not already done so
if [ ! -f "$FILE" ]; then
    gatk CreateSequenceDictionary -R "$fasta"
fi

# write make FASTA function
make_fasta () {
        gatk FastaAlternateReferenceMaker --reference "$fasta" --output $1.fa --variant "vcf_directory"/$1_filtered.vcf.gz
}

# write reheader function
rehead_fasta () {
	echo "$1 FASTA" > $1_header.txt
	cat $1_header.txt $1.fa > new_$1.fa
	awk 'NR==FNR{A[$1]=$2; next} NF==2{$2=A[$2]; print ">" $2; next} 1' FS='\t' "$new_contig_names" FS='>' new_$1.fa | tail -n +2 > rehead_$1.fa
	mv rehead_$1.fa $1.fa
	rm new_$1.fa
	rm $1_header.txt
}

# make and rehead FASTAs
for sample in ${samples[@]}; do make_fasta "$sample"; done
for sample in ${samples[@]}; do rehead_fasta "$sample"; done

# index new FASTAs
for sample in ${samples[@]}; do samtools faidx "$sample".fa; done

# split and reindex new FASTAs
for sample in ${samples[@]}; do for chr in ${chrs[@]}; do samtools faidx "$sample".fa "$chr" > "$sample"_"$chr".fa; done; done
for sample in ${samples[@]}; do for chr in ${chrs[@]}; do samtools faidx "$sample"_"$chr".fa; done; done
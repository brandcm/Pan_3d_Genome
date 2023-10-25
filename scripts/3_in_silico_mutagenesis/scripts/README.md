This directory contains the core scripts used in this set of analyses. Scripts are briefly described below. The get_genotypes.sh script is described first and should be run before any other *in silico* mutagenesis scripts.

- get_genotypes.sh generates a text file that indicates the presence of an alternate allele (0 = both alleles reference, 1 = at least one alternate allele present) per individual for each variant site in the panTro6 genome based on filtered variants from the sample considered in this analysis.

- calculate_3d_modifying_variant_contact_effects.py calculates the summed contact difference between a contact map with and without a 3D-modifying variant. This script has two arguments:<br>
	>--input, the input file formatted as a tab-delimited file where the first five fields indicate the 1) chromosome, 2) 1-based position, 3) reference allele, 4) alternate allele, and 5) 0-based window start for a given 3D-modifying variant<br><br>
	--output, the path to the output file

- generate_3d_modifying_variant_contact_maps.py outputs the contact map for reference sequence with a given 3D-modifying variant. This script has three arguments:<br>
	>--fasta, the path to the input FASTA<br><br>
	--input,  the input file (formatted as the script above)<br><br>
	--prediction_directory, the path to the directory where predictions can be output

- in_silico_mutagenesis.py completes *in silico* mutagenesis for a set of variants. This script has three required and two optional arguments:<br> 
	>--fasta, the path to the input FASTA (required)<br><br>
	--input, the input file, formatted as the script above (required)<br><br>
	--start, 0-based line in input file at which to start *in silico* mutagenesis (optional)<br><br>
	--end, 0-based line in input file at which to end *in silico* mutagenesis (optional)<br><br>
	--output, the path to the output file (required)

- retrieve_private_variants.py identifies variants that are specific to a set of individuals. This script has three required and one optional arguments:<br>
	>--genotypes, the path to a file of one-zero genotypes where 0 indicates a homozygous genotype for the reference allele and 1 indicates a heterozygous or homozygous genotype for the alternate allele. This file should be formatted as a tab-delimited file with the chromosome, position, reference, allele, and subsequent columns per individual for each variant (required)<br><br>
	--ids, the indices of individuals in the genotypes file that have at least one alternate allele (required)<br><br>
	--output, the path to the output file (required)<br><br>
	--region, the genomic region to consider formatted as chromosome, position start and position end in 1-based fully-closed coordinates (optional)
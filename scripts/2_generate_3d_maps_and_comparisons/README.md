This directory contains a subdirectory and scripts to generate 3d maps from FASTAs using Akita and compare the resulting contact maps. Scripts are described and listed below in the order they should be run.

- basenji/ contains scripts to run Akita.

- akita_prediction_reference.py generates 3d predictions per chromosome for the reference sequence, panTro6, using Akita. This script has six arguments:<br>
	>--windows, the path to windows file, formatted as a tab-separated two column file with the first column indicating the chromosome and the second column a comma-delimited list of 0-based window start coordinates<br><br>
	--model_directory, the path to the Akita model directory<br><br>
	--chr, the chromosome for which to generate predictions<br><br>
	--cell_types, a space-delimited list of cell types for which to generate predictions: GM12878, H1ESC, HCT116, HFF, IMR90 (default is HFF only)<br><br>
	--output_directory, the output directory for predictions<br><br>
	--fasta, the path to the FASTA file for the target chromsome<br><br>

- akita_prediction_reference.sh runs akita_prediction_reference.py to generate 3d predictions for all 23 autosomes and the X chromosome across all five cell types.

- concat_reference_predictions.sh concatenates chromosome-level predictions per cell type for the reference sequence for pairwise comparisons.

- akita_prediction_samples.py generates 3d predictions per chromosome per individual for all individuals using Akita. This script has the same seven arguments:<br>
	>--windows, the path to windows file, formatted as a tab-separated two column file with the first column indicating the chromosome and the second column a comma-delimited list of 0-based window start coordinates<br><br>
	--model_directory, the path to the Akita model directory<br><br>
	--chr, the chromosome for which to generate predictions<br><br>
	--cell_types, a list of cell types for which to generate predictions: GM12878, H1ESC, HCT116, HFF, IMR90 (default is HFF only)<br><br>
	--output_directory, the output directory for predictions<br><br>
	--individual, the ID of the individual<br><br>
	--fasta, the path to the FASTA file for the target chromsome<br><br>
	
- akita_prediction_samples.sh runs akita_prediction_samples.py to generate predictions for all chromosomes per individual for GM12878 and HFF cell types.

- concat_sample_predictions.sh concatenates chromosome-level predictions per individual for pairwise comparisons.

- sequence_differences.py calculates the number of nucleotide differences in 1 Mb window (as defined in this study) for a given pair of individuals. This script has five arguments:<br>
	>--windows, the path to windows file, formatted as a tab-separated two column file with the first column indicating the chromosome and the second column a comma-delimited list of 0-based window start coordinates<br><br>
	--individual_1_FASTA, the path to the FASTA file for the first individual<br><br>
	--individual_2_FASTA, the path to the FASTA file for the second individual<br><br>
	--individual_1_ID, the ID of the first individual<br><br>
	--individual_2_ID, the ID of the second individual<br><br>
	
- sequence_differences.sh runs sequence_differences.py to get the sequence differences for all 2,485 pairwise comparisons.

- pairwise_comparisons_reference.py calculates the mean squared error and Spearman rho between predicted contact maps for different cell type predictions from the reference sequence. This script has four arguments:<br>
	>--cell_type_1_predictions, the path to the first cell type's predictions<br><br>
	--cell_type_2_predictions, the path to the second cell type's predictions<br><br>
	--cell_type_1_ID, the first cell type<br><br>
	--cell_type_2_ID, the second cell type<br><br>
	
- pairwise_comparisons_reference.sh runs pairwise_comparisons_reference.py to compare the panTro6 predictions for all five cell types to each other (10 total comparisons).

- pairwise_comparisons_samples.py calculates the mean squared error and Spearman rho between predicted contact maps for different cell type predictions from the reference sequence. This script has five arguments:<br>
	>--cell_type, the cell type for predictions are compared<br><br>
	--individual_1_predictions, the path to predictions for the first individual<br><br>
	--individual_2_predictions, the path to predictions for the second individual<br><br>
	--individual_1_ID, the ID of the first individual type<br><br>
	--individual_2_ID, the ID of the second individual<br><br>

- pairwise_comparisons_samples.sh runs pairwise_comparisons_samples.py on HFF and GM12878 predictions for all 71 individuals, resulting in 2,485 total pairwise comparisons.

- concat_pairwise_and_sequence_differences.sh concatenates all 2,485 comparisons into a single file for HFF contact map predictions, GM12878 contact map predictions, and sequence differences.
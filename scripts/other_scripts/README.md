This directory contains scripts needed to generate data used in the analysis notebook. Scripts are described and listed below in the order they are needed.

- hierarchical_clustering_per_windows_stats.py completes hierarchical clustering using specified linkage for a set of comparisons in a given genomic window. This script has three arguments:<br>
	>--input, the input comparisons file<br><br>
	--linkage, the type of linkage to be used (see https://docs.scipy.org/doc/scipy/reference/generated/scipy.cluster.hierarchy.linkage.html#scipy.cluster.hierarchy.linkage)<br><br>
	--output, the path to the output file

- complete_linkage_hierarchical_clustering_per_windows.sh runs hierarchical_clustering_per_windows_stats.py using complete linkage on all 4,420 analyzable windows in the panTro6 genome.

- ppn_ptr_windows_n_genes_randomization.py randomly samples 89 windows from the analyzable panTro6 genome and sums the number of genes that fall within the window set.

- ppn_ptr_windows_n_genes_randomization.sh runs ppn_ptr_windows_n_genes_randomization.py.

- identify_3d_modifying_CpGs.py identifies 3d-modifying variants that are CpGs. This script has three arguments:<br>
	>--variants, the path to the input file<br><br>
	--fasta, the path to the FASTA file<br><br>
	--output, the path to the output file

- identify_3d_modifying_CpGs.sh runs identify_3d_modifying_CpGs.py for all 51 3d-modifying variants.

- contact_frequencies_distribution.py randomly samples 50,000 contacts from a given input.  This script has one argument:<br>
	>--input, the path to the input file

- contact_frequencies_distribution.sh runs contact_frequencies_distribution.py on each of the 56 individuals included in the final analysis.
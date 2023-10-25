This directory contains scripts to complete *in silico* mutagenesis of chimpanzee subspecies-specific variants. Scripts are described and listed below in the order they should be run.

- retrieve_pt*_specific_variants.sh retrieves lineage-specific variants genome-wide per chimpanzee subspecies.

- map_window_to_ptr_subspecies_specific_variants.sh adds the genomic window as a fifth field to the output files from the above scripts as required by the following scripts.

- in_silico_mutagenesis_pt*_specific_variants.sh completes the *in silico* mutagenesis of chimpanzee subspecies-specific variants. Nigeria-Cameroon and western chimpanzee variants are evaluated using an array for each set of 500 variants. An array job is not used for central or eastern chimpanzees because they have < 1,000 lineage-specific variants.

- concat_ptr_specific_variant_in_silico_mutagenesis.sh concatenates output files from the Nigeria-Cameroon and western chimpanzee *in silico* mutagenesis arrays.
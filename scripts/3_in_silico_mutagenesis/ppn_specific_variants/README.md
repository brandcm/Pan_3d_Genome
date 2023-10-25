This directory contains scripts to complete *in silico* mutagenesis of bonobo-specific variants in bonobo-chimpanzee divergent windows. Scripts are described and listed below in the order they should be run.

- retrieve_ppn_specific_variants_in_ppn_ptr_divergent_windows.sh retrieves bonobo-specific variants in bonobo-chimpanzee divergent windows.

- concat_retrieved_ppn_specific_variants.sh concatenates all retrieved bonobo-specific variants in bonobo-chimpanzee divergent windows.

- in_silico_mutagenesis_ppn_specific_variants_in_ppn_ptr_divergent_windows completes the *in silico* mutagenesis of bonobo-specific variants in bonobo-chimpanzee divergent windows using an array for each set of 500 variants.

- concat_ppn_specific_variant_in_silico_mutagenesis.sh concatenates output files from the array used to complete the *in silico* analysis for bonobo-specific variants in bonobo-chimpanzee divergent windows.

- generate_ppn_ptr_divergent_window_3d_modifying_variant_contact_maps.sh outputs the predicted contact map for all 61 3d-modifying variant-window pairs.

- calculate_3D_modifying_variant_contact_effects.sh calculates the summed contact difference between contact maps with and without a 3D-modifying variant.
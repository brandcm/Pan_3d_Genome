This directory contains scripts to retrieve annotation data for this project. As noted in the retrieve_panTro6_\*.sh scripts, one must also include the liftOver executable ([download here](https://genome-store.ucsc.edu/)) and four chain files (below) to run those scripts from this directory. Scripts are described below and ordered alphabetically. To replicate any analysis, I recommend running all these scripts first before any other scripts in this repository.

- generate_panTro6_windows.py creates the windows file.

- intersect_panTro6_windows_and_genes.sh intersects BED files of genomic windows used in this analysis and genes.

- retrieve_panTro6_CTCF.sh downloads, reformats, and converts coordinates for CTCF peaks called in chimpanzee LCLs. The resulting output file should be placed in the data/annotations folder.

- retrieve_panTro6_genes.sh downloads, reformats, and converts coordinates for panTro6 genes, keeping the gene model with the longest transcript. The resulting output files for both individual exons and whole genes should be placed in the data/annotations folder.

- retrieve_panTro6_phastCons_elements.sh downloads, reformats, and converts coordinates for phastCons conserved elements called in a 30-way vertebrate multiple species alignment. The resulting output files should be placed in the data/annotations folder.

- retrieve_Pan_inversions.sh downloads, reformats, and converts coordinates for bonobo- and chimpanzee-specific inversions from Porubsky et al. 2020, which are identified using merge_strandSeq_intervals.py. The resulting output files are placed in the data/ppn_ptr_structural_variants folder. I manually edited these outputs files to further include inversions identified in Mao et al. 2021.

&nbsp;

Chain Files:
- hg38 to panTro6 ([download here](https://hgdownload.soe.ucsc.edu/goldenPath/hg38/liftOver/))

- panTro2 to panTro4 ([download here](https://hgdownload.soe.ucsc.edu/goldenPath/panTro2/liftOver/))

- panTro4 to panTro5 ([download here](https://hgdownload.soe.ucsc.edu/goldenPath/panTro4/liftOver/))

- panTro5 to panTro6 ([download here](https://hgdownload.soe.ucsc.edu/goldenPath/panTro5/liftOver/))
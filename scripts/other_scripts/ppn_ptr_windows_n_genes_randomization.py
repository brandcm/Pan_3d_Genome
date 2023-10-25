import pandas as pd
import pybedtools
import random

def ppn_ptr_windows_n_genes_randomization(): 
	windows_BED = pd.read_csv('/wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_windows_with_full_coverage.bed', sep = '\t', names = ['chr','start','end'])
	windows_BED_sample = windows_BED.sample(n = 89)
	windows_BED_sample_pbtBED = pybedtools.BedTool().from_dataframe(windows_BED_sample)
	
	genes = pybedtools.BedTool('/wynton/group/capra/projects/pan_3d_genome/data/annotations/panTro6_genes.bed')
	intersect = windows_BED_sample_pbtBED.intersect(genes, wa = True, wb = True).to_dataframe(names = ['window_chr','window_start','window_end','gene_chr','gene_start','gene_end','gene_transcript','gene'])
	shuffled_genes = set([x for x in intersect['gene'] if str(x) != '.'])
	return (len(shuffled_genes))

n_gene_list = [ppn_ptr_windows_n_genes_randomization() for _ in range(10000)]

with open('ppn_ptr_windows_n_genes_randomization.txt', 'w') as out:
	for x in n_gene_list:
		out.write(str(x) + '\n')

import pandas as pd
import pybedtools

# identify gene counts in non-ppn-ptr divergent windows
all_windows_genes_count_intersect = pd.read_csv('/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows/all_windows_genes_count_intersect.txt', sep = '\t', header = 0)
ppn_ptr_divergent_windows_genes_count_intersect = pd.read_csv('/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_windows/ppn_ptr_divergent_windows_genes_counts.txt', sep ='\t', header = 0)
non_ppn_ptr_divergent_windows_genes_count_intersect = all_windows_genes_count_intersect.merge(ppn_ptr_divergent_windows_genes_count_intersect, on = ['window_chr','window_start','window_end'], how = 'left', indicator = True)
non_ppn_ptr_divergent_windows_genes_count_intersect = non_ppn_ptr_divergent_windows_genes_count_intersect[non_ppn_ptr_divergent_windows_genes_count_intersect['_merge'] == 'left_only'].drop(columns=['gene_count_y','_merge']).rename(columns = {'gene_count_x':'gene_count'})

# create gene count distribution for ppn-ptr divergent windows
ppn_ptr_divergent_windows_genes_count_distribution = ppn_ptr_divergent_windows_genes_count_intersect['gene_count'].value_counts().sort_index()

# load read counts
all_read_counts = pd.read_csv('/wynton/group/capra/projects/pan_3d_genome/data/RNAseq/analysis/all_genes_read_counts_with_species_difference.txt', sep = '\t', header = 0)

# load gene coordinates
genes_pbtBED = pybedtools.BedTool('/wynton/group/capra/projects/pan_3d_genome/data/annotations/panTro6_genes.bed')

# write function for randomization
def species_difference_in_expression_randomization(ppn_ptr_divergent_windows_genes_count_distribution, non_ppn_ptr_divergent_windows_genes_count_intersect, all_read_counts, genes_pbtBED):
	sampled_dfs = []
	for gene_count, count in ppn_ptr_divergent_windows_genes_count_distribution.items():
		matching_rows = non_ppn_ptr_divergent_windows_genes_count_intersect[non_ppn_ptr_divergent_windows_genes_count_intersect['gene_count'] == gene_count]
		if len(matching_rows) >= count:
			sampled_rows = matching_rows.sample(n = count)
		else:
			sampled_rows = matching_rows.sample(n = count, replace = True)
		sampled_dfs.append(sampled_rows)

	random_control_windows_gene_counts = pd.concat(sampled_dfs, ignore_index=True)
	random_control_windows_pbtBED = pybedtools.BedTool().from_dataframe(random_control_windows_gene_counts[['window_chr', 'window_start', 'window_end']]).sort()
	random_control_windows_genes_intersect = random_control_windows_pbtBED.intersect(genes_pbtBED, wa=True, wb=True).to_dataframe(names=['window_chr', 'window_start', 'window_end', 'gene_chr', 'gene_start', 'gene_end', 'gene_transcript', 'gene'])
	random_control_windows_genes_read_counts = all_read_counts[all_read_counts['gene'].isin(random_control_windows_genes_intersect['gene'])]
	random_control_windows_genes_read_counts = random_control_windows_genes_read_counts[(random_control_windows_genes_read_counts['ppn_female'] != 0) & (random_control_windows_genes_read_counts['ppn_male'] != 0) & (random_control_windows_genes_read_counts['ptr_female'] != 0) & (random_control_windows_genes_read_counts['ptr_male'] != 0)]
	random_control_windows_genes_read_counts = random_control_windows_genes_read_counts[~random_control_windows_genes_read_counts['tissue'].isin(['prefrontal_cortex', 'testis'])]
	random_control_windows_genes_read_counts = random_control_windows_genes_read_counts[random_control_windows_genes_read_counts['species_diff'].notna()]

	return random_control_windows_genes_read_counts

tissues = ['cerebellum', 'heart', 'kidney', 'liver']
summary_stats = {tissue: {'mean': [], 'median': [], 'max': []} for tissue in tissues}
mean_tissues_per_gene_list = []

for _ in range(10000):
	random_counts = species_difference_in_expression_randomization(ppn_ptr_divergent_windows_genes_count_distribution, non_ppn_ptr_divergent_windows_genes_count_intersect, all_read_counts, genes_pbtBED)
	for tissue in tissues:
		tissue_counts = random_counts[random_counts['tissue'] == tissue]
		summary_stats[tissue]['mean'].append(tissue_counts['species_diff'].mean())
		summary_stats[tissue]['median'].append(tissue_counts['species_diff'].median())
		summary_stats[tissue]['max'].append(tissue_counts['species_diff'].max())

	mean_tissues_per_gene = random_counts.groupby('gene').size().mean()
	mean_tissues_per_gene_list.append(mean_tissues_per_gene)

# Save summary statistics for each tissue
for tissue in tissues:
	tissue_stats = pd.DataFrame({'mean': summary_stats[tissue]['mean'], 'median': summary_stats[tissue]['median'], 'max': summary_stats[tissue]['max']})
	tissue_stats.to_csv(f'/wynton/group/capra/projects/pan_3d_genome/data/RNAseq/analysis/ppn_ptr_windows_species_difference_in_expression_randomization_for_{tissue}.txt', sep = '\t', header = True, index = False)

# Collect the max values of all tissues and save to a separate file
mean_tissues_df = pd.DataFrame({'mean_tissue_per_gene': mean_tissues_per_gene_list})
mean_tissues_df.to_csv('/wynton/group/capra/projects/pan_3d_genome/data/RNAseq/analysis/ppn_ptr_windows_species_difference_in_expression_randomization_mean_tissues_per_gene.txt', sep = '\t', header = True, index = False)

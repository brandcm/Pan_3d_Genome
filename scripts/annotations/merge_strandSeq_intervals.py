# Colin M. Brand, University of California San Francisco, 07/19/2023

import argparse
import pandas as pd

def main():	
	df_header = ['chr','start','end','length','ploidy','lineage','type']
	df = pd.read_csv('Porubsky_et_al_2020_inversions.bed', sep = '\t', names = df_header)
	merge_intervals(df)

def merge_intervals(df):
	# sort dataframe
	df_sorted = df.sort_values(by=['chr', 'start'])

	# set variables for current interval and an empty list for merged regions
	current_chr = None
	current_start = None
	current_end = None
	current_lineages = []
	merged_regions = []

	# iterate through rows
	for index, row in df_sorted.iterrows():
		if current_chr is None:
			current_chr = row['chr']
			current_start = row['start']
			current_end = row['end']
			current_lineages = [row['lineage']]

		else:
			# calculate overlap between A|B and B|A
			overlap_start = max(current_start, row['start'])
			overlap_end = min(current_end, row['end'])
			overlap_length = overlap_end - overlap_start
			length_current = current_end - current_start
			length_row = row['end'] - row['start']
			proportion_current = overlap_length / length_current
			proportion_row = overlap_length / length_row

			# keep iterating if there is at least 50% reciprocal overlap between current interval and current row
			if current_chr == row['chr'] and proportion_current >= 0.5 and proportion_row >= 0.5:
				current_end = max(current_end, row['end'])
				current_lineages.append(row['lineage'])

			# otherwise add merged data to the merged intervals list    
			else:
				merged_regions.append({'chr': current_chr, 'start': current_start, 'end': current_end, 'lineage': ','.join(sorted(current_lineages))})
				current_chr = row['chr']
				current_start = row['start']
				current_end = row['end']
				current_lineages = [row['lineage']]

	# Append the last merged region to the list
	merged_regions.append({'chr': current_chr, 'start': current_start, 'end': current_end, 'lineage': ','.join(current_lineages)})

	# created df from merged intervals list and write df out
	merged_df = pd.DataFrame(merged_regions)
	merged_df.to_csv('merged_Porubsky_et_al_2020_inversions.bed', sep = '\t', header = False, index = False)

if __name__ == '__main__':
	main()
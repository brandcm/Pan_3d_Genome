# Colin M. Brand, University of California San Francisco, 09/06/2023

import argparse
import numpy as np
import pandas as pd

def parse_args():
	parser = argparse.ArgumentParser()

	parser.add_argument('--input', type = str, required = True, help = 'Path to input file with variants. Formatted as a tab-delimited file with chromosome, 1-based variant position, and 0-based window start as the first, second, and fifth fields, respectively.')
		
	parser.add_argument('--output', type = str, required = True, help = 'Path to output file.')

	args = parser.parse_args()
	return args

def main():
	args = parse_args()

	df = []

	with open(f'{args.input}', 'r') as input, open(f'{args.output}', 'w') as out:
		for line in input:
			line = line.split('\t')

			global chr
			chr = line[0]

			global variant_pos
			variant_pos = line[1]

			global window
			window = line[4]
			
			global variant_index
			variant_diff, variant_index = get_variant_index(variant_pos, window)
			
			if variant_diff < 65536 or variant_diff > 917504:
				ref_map_contacts_sum = float('NaN')
				alt_map_contacts_sum = float('NaN')
				summed_contact_difference = float('NaN')
			
			else:
				ref_map_contacts_sum = sum_reference_map_contacts(window)
				alt_map_contacts_sum = sum_alternate_map_contacts(variant_pos, window)
				summed_contact_difference = alt_map_contacts_sum - ref_map_contacts_sum

			df.append({'chr':chr,'pos':variant_pos,'window':window,'ref_map_contacts_sum':ref_map_contacts_sum,'alt_map_contacts_sum':alt_map_contacts_sum,'summed_contact_difference':summed_contact_difference})
			print(f'Calculation of summed contact differences for {chr}: {variant_pos} variant in window: {window} completed.')

	df = pd.DataFrame(df)[['chr','pos','window','ref_map_contacts_sum','alt_map_contacts_sum','summed_contact_difference']]
	df.to_csv(args.out, sep='\t', index=False)

def set_diag(arr, x, i = 0):
	start = max(i, -arr.shape[1] * i)
	stop = max(0, (arr.shape[1] - i)) * arr.shape[1]
	step = arr.shape[1] + 1
	arr.flat[start:stop:step] = x
	return arr

def from_upper_triu(vector_repr, matrix_len, num_diags):
	z = np.zeros((matrix_len,matrix_len))
	triu_tup = np.triu_indices(matrix_len,num_diags)
	z[triu_tup] = vector_repr
	for i in range(-num_diags+1,num_diags):
		set_diag(z, np.nan, i)
	return z + z.T

def get_variant_index(variant, window):
	start = int(window.split('_')[1])
	first = start + 65536
	variant_diff = int(variant) - first
	variant_index = int(variant_diff/2048) - 1
	return variant_diff, variant_index

def sum_reference_map_contacts(window):
	start = window.split('_')[1]

	with open(f'/wynton/group/capra/projects/pan_3d_genome/data/predictions/reference/3d_predictions_HFF_{chr}.txt', 'r') as ref_file:
		for line in ref_file:
			ref_line = line.split('\t')
			if ref_line[0] == chr and ref_line[1] == start:
				ref_pred_hff = list(map(float,ref_line[2:]))
				ref_mat = np.array(ref_pred_hff)
				ref_mat = from_upper_triu(ref_mat, 448, 2)
				lower_triangle_mask = np.tril(np.ones_like(ref_mat, dtype = bool), k = -1)
				ref_mat[lower_triangle_mask] = 0
				ref_mat = np.nan_to_num(ref_mat, nan = 0)
				ref_sum = np.sum(ref_mat[variant_index, :]) + np.sum(ref_mat[:, variant_index])
				return ref_sum

def sum_alternate_map_contacts(variant, window):
	alt_file = pd.read_csv(f'/wynton/group/capra/projects/pan_3d_genome/data/in_silico_mutagenesis/ppn_ptr_divergent_window_3d_modifying_variant_predictions/{chr}_{variant}_{window}.txt', sep = '\t', header = None)
	alt_file = alt_file.iloc[:, 2:]
	alt_file = alt_file.to_numpy()
	alt_mat = from_upper_triu(alt_file, 448, 2)
	lower_triangle_mask = np.tril(np.ones_like(alt_mat, dtype = bool), k = -1)
	alt_mat[lower_triangle_mask] = 0
	alt_mat = np.nan_to_num(alt_mat, nan = 0)
	alt_sum = np.sum(alt_mat[variant_index, :]) + np.sum(alt_mat[:, variant_index])
	return alt_sum

if __name__ == '__main__':
	main()

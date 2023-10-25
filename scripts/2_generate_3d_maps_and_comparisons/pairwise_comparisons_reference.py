# Colin M. Brand, University of California San Francisco, 05/25/2022
# built on code from Evonne McArthur, David Rinker, and Erin Gilbertson

import argparse
import numpy as np
from scipy import stats

def parse_args():
	parser = argparse.ArgumentParser()
	
	parser.add_argument('--cell_type_1_predictions', type = str, required = True, help = 'Path to cell type 1 predictions.')

	parser.add_argument('--cell_type_2_predictions', type = str, required = True, help = 'Path to cell type 2 predictions.')
	
	parser.add_argument('--cell_type_1_ID', type = str, required = True, help = 'ID for first cell type.')
		
	parser.add_argument('--cell_type_2_ID', type = str, required = True, help = 'ID for second cell type.')
		
	args = parser.parse_args()
	return args

def main():
	args = parse_args()

	# write comparison metrics function
	def comparePreds(cell_type_1, cell_type_2):
		mse = np.mean(np.square(cell_type_1 - cell_type_2))
		spearman = stats.spearmanr(cell_type_1, cell_type_2)[0]
		return (mse, spearman)

	# create output file
	outfile = open(f'{args.cell_type_1_ID}_{args.cell_type_2_ID}_comparison.txt', 'w')
	
	# read in prediction files
	cell_type_1_predictions_file = open(f'{args.cell_type_1_predictions}', 'r')
	cell_type_2_predictions_file = open(f'{args.cell_type_2_predictions}', 'r')

	# read lines
	cell_type_1_predictions_lines = cell_type_1_predictions.readlines()
	cell_type_2_predictions_lines = cell_type_2_predictions.readlines()

	# parse lines and calculate pairwise metrics
	for i in range(max(len(cell_type_1_predictions_lines),len(cell_type_2_predictions_lines))):
		cell_type_1_predictions_line = cell_type_1_predictions_lines[i]
		cell_type_1_predictions_line = cell_type_1_predictions_line.strip().split('\t')
		cell_type_1_chr = cell_type_1_predictions_line[0]
		cell_type_1_pos = cell_type_1_predictions_line[1]
		cell_type_1_predictions = list(map(float,cell_type_1_predictions_line[2:]))

		cell_type_2_predictions_line = cell_type_2_predictions_lines[i]
		cell_type_2_predictions_line = cell_type_2_predictions_line.strip().split('\t')
		cell_type_2_chr = cell_type_2_predictions_line[0]
		cell_type_2_pos = cell_type_2_predictions_line[1]
		cell_type_2_predictions = list(map(float,cell_type_2_predictions_line[2:]))

		if (cell_type_1_chr == cell_type_2_chr) and (cell_type_1_pos == cell_type_2_pos):
			mse, spearman = comparePreds(np.array(cell_type_1_predictions), np.array(cell_type_2_predictions))
			outfile.write('{}\t{}\t{}\t{}\t{}\t{}\n'.format(args.cell_type_1_ID, args.cell_type_2_ID, cell_type_1_chr, cell_type_1_pos, mse, spearman))

		else:
			print('Window mismatch') 

	outfile.close()
	cell_type_1_predictions_file.close()
	cell_type_2_predictions_file.close()

if __name__ == '__main__':
	main()
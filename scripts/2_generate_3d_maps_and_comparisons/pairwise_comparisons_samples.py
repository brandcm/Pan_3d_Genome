# Colin M. Brand, University of California San Francisco, 05/25/2022
# built on code from Evonne McArthur, David Rinker, and Erin Gilbertson

import argparse
import numpy as np
from scipy import stats

def parse_args():
	parser = argparse.ArgumentParser()

	parser.add_argument('--cell_type', type = str, required = True, help = 'Cell type for which predictions are compared.')
	
	parser.add_argument('--individual_1_predictions', type = str, required = True, help = 'Path to target individual 1 predictions.')

	parser.add_argument('--individual_2_predictions', type = str, required = True, help = 'Path to target individual 2 predictions.')
	
	parser.add_argument('--individual_1_ID', type = str, required = True, help = 'ID for first target individual.')
		
	parser.add_argument('--individual_2_ID', type = str, required = True, help = 'ID for second target individual.')
		
	args = parser.parse_args()
	return args

def main():
	args = parse_args()

	# write comparison metrics function
	def comparePreds(individual_1, individual_2):
		mse = np.mean(np.square(individual_1 - individual_2))
		spearman = stats.spearmanr(individual_1, individual_2)[0]
		return (mse, spearman)

	# create output file
	outfile = open(f'{args.individual_1_ID}_{args.individual_2_ID}_{args.cell_type}_comparison.txt', 'w')
	
	# read in prediction files
	individual_1_predictions_file = open(f'{args.individual_1_predictions}', 'r')
	individual_2_predictions_file = open(f'{args.individual_2_predictions}', 'r')

	# read lines
	individual_1_predictions_lines = individual_1_predictions.readlines()
	individual_2_predictions_lines = individual_2_predictions.readlines()

	# parse lines and calculate pairwise metrics
	for i in range(max(len(individual_1_predictions_lines),len(individual_2_predictions_lines))):
		individual_1_predictions_line = individual_1_predictions_lines[i]
		individual_1_predictions_line = individual_1_predictions_line.strip().split('\t')
		individual_1_chr = individual_1_predictions_line[0]
		individual_1_pos = individual_1_predictions_line[1]
		individual_1_predictions = list(map(float,individual_1_predictions_line[2:]))

		individual_2_predictions_line = individual_2_predictions_lines[i]
		individual_2_predictions_line = individual_2_predictions_line.strip().split('\t')
		individual_2_chr = individual_2_predictions_line[0]
		individual_2_pos = individual_2_predictions_line[1]
		individual_2_predictions = list(map(float,individual_2_predictions_line[2:]))

		if (individual_1_chr == individual_2_chr) and (individual_1_pos == individual_2_pos):
			mse, spearman = comparePreds(np.array(individual_1_predictions), np.array(individual_2_predictions))
			outfile.write('{}\t{}\t{}\t{}\t{}\t{}\n'.format(args.individual_1_ID, args.individual_2_ID, individual_1_chr, individual_1_pos, mse, spearman))

		else:
			print('Window mismatch') 

	outfile.close()
	individual_1_predictions_file.close()
	individual_2_predictions_file.close()

if __name__ == '__main__':
	main()
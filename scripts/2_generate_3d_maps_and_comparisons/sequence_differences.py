import argparse	
import pysam

def parse_args():
	parser = argparse.ArgumentParser()
	
	parser.add_argument('--windows', type = str, required = True, help = 'Path to intervals file. Input should be two fields: 1) the contig name and 2) a comma-delimited list of 0-based start coordinates.')

	parser.add_argument('--individual_1_FASTA', type = str, required = True, help = 'Path to FASTA file for first target individual.')
		
	parser.add_argument('--individual_2_FASTA', type = str, required = True, help = 'Path to FASTA file for second target individual.')
		
	parser.add_argument('--individual_1_ID', type = str, required = True, help = 'ID for first target individual.')
		
	parser.add_argument('--individual_2_ID', type = str, required = True, help = 'ID for second target individual.')
		
	args = parser.parse_args()
	return args

def main():
	args = parse_args()

	with open(args.windows, 'r') as windows, open(f'{args.individual_1_ID}_{args.individual_2_ID}_sequence_differences.txt', 'w') as out:
		line = [ line.strip().split('\t') for line in windows ]
		for x in line:
			chromosome = x[0]
			window_starts = x[1].split(',')
			for x, y in zip(window_starts[:-1], window_starts[2:]):
				individual_1_sequence = pysam.FastaFile(args.individual_1_FASTA).fetch(chr, int(x), int(y))
				individual_2_sequence = pysam.FastaFile(args.individual_2_FASTA).fetch(chr, int(x), int(y))
				n_sequence_differences = 0
				for a, b in zip(individual_1_sequence, individual_2_sequence):
					if a.upper() != b.upper():
						n_sequence_differences = n_sequence_differences + 1
				out.write('{}\t{}\t{}\t{}\t{}\t{}\n'.format(args.individual_1_ID, args.individual_2_ID, chromosome, x, y, n_sequence_differences))

if __name__ == '__main__':
	main()
# Colin M. Brand, University of California San Francisco, 03/20/2022

import argparse
import gzip
import pysam

def parse_args():
	parser = argparse.ArgumentParser()

	parser.add_argument('--fasta', type = str, required = True, help = 'Path to input FASTA file')
		
	parser.add_argument('--bed', type = str, required = True, help = "Path to input BED file.')
		
	parser.add_argument('--output', type = str, required = True, help = 'Path to output file. Will overwrite if it exists.')
		
	args = parser.parse_args()
	return args

def main():
	args = parse_args()
	
	with pysam.FastaFile(args.fasta) as fasta, open(args.bed, 'r') as bed, open(args.out, 'a') as out:
		for line in bed:
			line = [x.strip() for x in line.split('\t')]
			ancestral_allele = fasta.fetch(line[0], int(line[1]), int(line[2]))
			out.write("{}\t{}\t{}\t{}\n".format(line[0], line[1], line[2], ancestral_allele))
			
if __name__ == '__main__':
    main()
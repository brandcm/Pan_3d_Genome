import argparse

def parse_args():
	parser = argparse.ArgumentParser()
	
	parser.add_argument('--genotypes', type = str, required = True, help = 'Path to genotypes file.')
	
	parser.add_argument('--ids', type = int, nargs = '+', required = True, help = 'Indices of individuals in genotypes file that have at least one alternate allele.')

	parser.add_argument('--output', type = str, required = True, help = 'Path to output file.')
		
	parser.add_argument('--region', type = str, nargs = '+', required = False, help = 'Optional genomic region to consider formatted as chromosome, position start, and position end in 1-based fully closed coordinates.')
		
	args = parser.parse_args()
	return args

def main():
	args = parse_args()
	
	# construct match line
	match = []
	for x in range(1,57):
		if x in args.ids:
			match.append(1)
		else: 
	 		match.append(0)

	# open out file
	out = open(args.output, 'w')
	
	# set up region variables, if included
	if args.region is not None:
		target_chr = args.region[0]
		target_start = int(args.region[1])
		target_end = int(args.region[2])
			
	# parse genotypes file per line
	genotypes_file = open(args.genotypes, 'r')
	genotypes_lines = genotypes_file.readlines()
	for i in range(len(genotypes_lines)):
		genotype_line = genotypes_lines[i]
		genotype_line = genotype_line.strip().split('\t')
		chr = genotype_line[0]
		pos = int(genotype_line[1])
		ref = genotype_line[2]
		alt = genotype_line[3]
		gts = list(genotype_line[4:])
		gts = [int(i) for i in gts]
		
		# set up region variables, if included
		if args.region is not None:			
			if chr == target_chr and pos >= target_start and pos <= target_end and gts == match:
				out.write('{}\t{}\t{}\t{}\t{}_{}\n'.format(chr, pos, ref, alt, chr, target_start-1))
	
		else:
			if gts == match:
				out.write('{}\t{}\t{}\t{}\n'.format(chr, pos, ref, alt))
		
	out.close()

if __name__ == '__main__':
	main()

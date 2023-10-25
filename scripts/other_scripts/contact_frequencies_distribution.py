# 03-10-23, Colin M. Brand, University of California San Francisco

import argparse
import numpy as np

def parse_args():
	parser = argparse.ArgumentParser()
		
	parser.add_argument('--input', type = str, required = True, help = 'Input file path.')

	return parser.parse_args()

def main():
	args = parse_args()
		
	data = np.loadtxt(args.input, delimiter='\t', usecols=range(2,99683,1))
	min = data.min()
	max = data.max()
	random_list = np.random.choice(data.flatten(), size = 50000, replace=False)
	random = '\n'.join(map(str, random_list))
	
	with open('contact_frequencies_minima.txt', 'a') as mins_out, open('contact_frequencies_maxima.txt', 'a') as maxes_out, open('random_contact_frequencies.txt', 'a') as random_out:
		mins_out.write('{}\n'.format(min))
		maxes_out.write('{}\n'.format(max))
		random_out.write('{}\n'.format(random))

if __name__ == '__main__':
    main()

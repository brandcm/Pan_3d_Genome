# Colin M. Brand, University of California San Francisco, 09/19/2022
# modified from script by Evonne McArthur

import argparse
import itertools
import json
import numpy as np
import os
import pandas as pd
import pysam

from basenji import dataset, dna_io, seqnn
from scipy import stats

def parse_args():
	parser = argparse.ArgumentParser()
	
	parser.add_argument('--fasta', type = str, required = True, help = 'Path to input FASTA.')

	parser.add_argument('--input', type = str, required = True, help = 'Path to input file with variants. Formatted as a tab-delimited file with chromosome, 0-based position, reference allele, alternate allele, and 1-based window start.')
		
	parser.add_argument('--start', type = int, required = False, default = 0, help = '0-based line in input file at which to start in silico mutagenesis.')
		
	parser.add_argument('--end', type = int, required = False, help = '0-based line in input file at which to end in silico mutagenesis.')
		
	parser.add_argument('--output', type = str, required = True, help = 'Path to output file.')

	args = parser.parse_args()
	return args

def main():
	args = parse_args()

	loadAkita()

	df = []

	with open(f'{args.input}', 'r') as input, open(f'{args.output}', 'w') as out:
		if args.end is None:
			file_end = len(input.readlines())
			print(file_end)
		elif args.end is not None:
			file_end = args.end

		for line in itertools.islice(input, args.start, file_end):
			line = line.split('\t')

			global chr
			chr = line[0]

			global variant_pos
			variant_pos = line[1]

			ref_allele = line[2]

			global alt_allele
			alt_allele = line[3]

			window = line[4].strip()

			global window_start
			window_start = line[4].split('_')[1].strip()

			ref_prediction, alt_prediction = get_contact_maps()
			mse, divergence = comparePreds(np.array(ref_prediction), np.array(alt_prediction))

			df.append({'chr':chr,'pos':variant_pos,'ref':ref_allele,'alt':alt_allele,'window':window,'mse':mse,'divergence':divergence})
			print(f'In silico mutagenesis for {chr}: {variant_pos} variant in window: {window} completed.')

	df = pd.DataFrame(df)[['chr','pos','ref','alt','window','mse','divergence']]
	df.to_csv(args.out, sep='\t', index=False)

def loadAkita():
	os.environ["CUDA_VISIBLE_DEVICES"] = '-1'

	import tensorflow as tf
	if tf.__version__[0] == '1':
		tf.compat.v1.enable_eager_execution()

	with open('/wynton/group/capra/projects/pan_3d_genome/data/model/params.json') as params_file:
		params = json.load(params_file)
		params_model = params['model']
		params_train = params['train']

	global seqnn_model
	seqnn_model = seqnn.SeqNN(params_model)
	seqnn_model.restore('/wynton/group/capra/projects/pan_3d_genome/data/model/model_best.h5')

def Akita(seq):
	if len(seq) != 2**20: raise ValueError('len(seq) != seq_length')
	seq_1hot = dna_io.dna_1hot(seq)
	test_pred_from_seq = seqnn_model.model.predict(np.expand_dims(seq_1hot,0))
	return test_pred_from_seq

def get_contact_maps():
	args = parse_args()

	with open(f'/wynton/group/capra/projects/pan_3d_genome/data/predictions/reference/3d_predictions_HFF_{chr}.txt', 'r') as ref_file:
		for line in ref_file:
			ref_line = line.split('\t')
			if ref_line[0] == chr and ref_line[1] == window_start:
				ref_pred_hff = list(map(float,ref_line[2:]))

	ref_fasta_open = pysam.Fastafile(f'{args.fasta}')
	ref_seq = ref_fasta_open.fetch(chr, int(window_start), int(window_start)+2**20).upper()
	pos_in_window = (int(variant_pos)-1)-int(window_start)

	if int(variant_pos) == int(window_start):
		alt_seq = alt_allele + ref_seq[1:]
	else:
		alt_seq = ref_seq[0:pos_in_window] + alt_allele + ref_seq[pos_in_window+1:]

	alt_pred = Akita(alt_seq)
	alt_pred_hff = alt_pred[:,:,0][0]
	return ref_pred_hff, alt_pred_hff

def comparePreds(ref, alt):
	mse = np.mean(np.square(ref - alt))
	spearman = stats.spearmanr(ref, alt)[0]
	divergence = 1 - spearman
	return (mse, divergence)

if __name__ == '__main__':
	main()
# Colin M. Brand, University of California San Francisco, 07/20/2023

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

	parser.add_argument('--chr', type = str, required = True, help = 'Target chromosome.')

	parser.add_argument('--inv_start', type = str, required = True, help = '0-based inversion start coordinate.')

	parser.add_argument('--inv_end', type = str, required = True, help = '0-based inversion end coordinate.')

	parser.add_argument('--window_start', type = str, required = True, help = '0-based window start coordinate.')

	parser.add_argument('--out', type = str, required = True, help = 'Path to output file.')

	args = parser.parse_args()
	return args

def main():
	args = parse_args()

	loadAkita()

	results = []

	global chr
	chr = args.chr

	global inv_start
	inv_start = args.inv_start

	global inv_end
	inv_end = args.inv_end

	global window_start
	window_start = args.window_start

	alt_pred = get_alt_map()
	ref_pred = load_ref_map()
	mse, pearson, spearman = compare3Dmaps(ref_pred, alt_pred)
	results.append({'chr':chr,'start':int(inv_start),'end':int(inv_end),'window':int(window_start),'mse':mse,'1-pearson':pearson,'1-spearman':spearman})
	print(f'Akita prediction for window {window_start} with inversion {chr}: {inv_start}-{inv_end} completed.')

	with open(f'/wynton/group/capra/projects/pan_3d_genome/data/ppn_ptr_structural_variants/inversion_predictions/{chr}_{window_start}_{inv_start}.txt', 'w') as pred_out:
		pred_out.write(chr + "\t" + str(window_start) + "\t" + "\t".join([str(x) for x in alt_pred]))

	df = pd.DataFrame(results)[['chr', 'start', 'end', 'window', 'mse', '1-pearson', '1-spearman']]
	with open(args.out, 'a') as out:
		df.to_csv(out, sep = '\t', header = False, index = False)

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

def runAkitaPreds(seq):
	if len(seq) != 2**20: raise ValueError('len(seq) != seq_length')
	seq_1hot = dna_io.dna_1hot(seq)
	test_pred_from_seq = seqnn_model.model.predict(np.expand_dims(seq_1hot,0))
	return test_pred_from_seq

def reverse_complement(seq):
	complement = {'A': 'T', 'T': 'A', 'C': 'G', 'G': 'C'}
	return ''.join(complement[base] for base in reversed(seq))

def get_alt_map():
	args = parse_args()
	ref_fasta_open = pysam.Fastafile(f'{args.fasta}')
	ref_seq = ref_fasta_open.fetch(chr, int(window_start), int(window_start)+2**20).upper()

	inv_start_in_window = (int(inv_start)-int(window_start))
	inv_end_in_window = (int(inv_end)-int(window_start))

	seq_to_invert = ref_seq[inv_start_in_window:inv_end_in_window + 1]
	inverted_seq = reverse_complement(seq_to_invert)

	alt_seq = ref_seq[0:inv_start_in_window] + inverted_seq + ref_seq[inv_end_in_window + 1:]
	alt_pred = runAkitaPreds(alt_seq)
	alt_pred = alt_pred[:,:,0][0]
	return alt_pred

def load_ref_map():
	with open(f'/wynton/group/capra/projects/pan_3d_genome/data/predictions/reference/3d_predictions_HFF_{chr}.txt', 'r') as ref_file:
		for line in ref_file:
			ref_line = line.split('\t')
			if ref_line[0] == chr and ref_line[1] == window_start:
				ref_pred = list(map(float,ref_line[2:]))
				ref_pred = np.array(ref_pred)
	return ref_pred

def compare3Dmaps(ref_pred, alt_pred):
	mse = np.mean(np.square(ref_pred  - alt_pred))
	pearson = 1 - stats.pearsonr(ref_pred, alt_pred)[0]
	spearman = 1 - stats.spearmanr(ref_pred, alt_pred)[0]
	return mse, pearson, spearman

if __name__ == '__main__':
	main()

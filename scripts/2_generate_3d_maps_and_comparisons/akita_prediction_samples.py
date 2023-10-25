import argparse
import json
import numpy as np
import os
import pandas as pd
import pysam
import tensorflow as tf

from basenji import dataset, dna_io, seqnn
from cooltools.lib.numutils import set_diag
from scipy import stats

def parse_args():
	parser = argparse.ArgumentParser()
	
	parser.add_argument('--windows', type = str, required = True, help = 'Path to windows file. Input should be two fields: 1) the contig name and 2) a comma-delimited list of 0-based start coordinates.')

	parser.add_argument('--model_directory', type = str, required = True, help = 'Path to Basenji model directory.')
		
	parser.add_argument('--chr', type = str, required = True, help = 'Chromosome for which to generate predictions.')

	parser.add_argument('--cell_types', type = str, nargs = '+', default = ['HFF'], help = 'Space-delimited list of which cell types to generated predictions: GM12878, H1ESC, HCT116, HFF, IMR90. Default is HFF predictions only.')
	
	parser.add_argument('--output_directory', type = str, required = True, help = 'Path to output directory.')

	parser.add_argument('--individual', type = str, required = True, help = 'ID of target individual.')

	parser.add_argument('--fasta', type = str, required = True, help = 'Path to FASTA file for target chromosome.')
		
	args = parser.parse_args()
	return args

def main():
	args = parse_args()

	# run on CPU
	os.environ["CUDA_VISIBLE_DEVICES"] = '-1'

	if tf.__version__[0] == '1':
		tf.compat.v1.enable_eager_execution()

	# set seed for reproducibility
	np.random.seed(1337)

	# read in chromosome for prediction
	target_chromosome = args.chr

	# read in genomic windows for reference sequence
	windows = {}
	with open(args.windows) as windows_file:
		for line in windows_file:
			window = line.strip().split("\t")
			windows[window[0]] = [int(x) for x in window[1].split(",")]
	windows_file.close()

	# load parameters and specify the model
	with open(f'{args.model_directory}/params.json') as params_file:
		params = json.load(params_file)
		params_model = params['model']
		params_train = params['train']

	seqnn_model = seqnn.SeqNN(params_model)

	# restore model
	seqnn_model.restore(f'{args.model_directory}/model_best.h5')

	# designate names of targets (cell types)
	hic_targets = pd.read_csv(f'{args.model_directory}/targets.txt', sep = '\t')
	hic_file_dict_num = dict(zip(hic_targets['index'].values, hic_targets['file'].values) )
	hic_file_dict = dict(zip(hic_targets['identifier'].values, hic_targets['file'].values) )
	hic_num_to_name_dict = dict(zip(hic_targets['index'].values, hic_targets['identifier'].values) )

	# read data parameters
	with open(f'{args.model_directory}/statistics.json') as data_stats_open:
		data_stats = json.load(data_stats_open)
	seq_length = data_stats['seq_length']
	target_length = data_stats['target_length']
	hic_diags =  data_stats['diagonal_offset']
	target_crop = data_stats['crop_bp'] // data_stats['pool_width']
	target_length1 = data_stats['seq_length'] // data_stats['pool_width']
	target_length1_cropped = target_length1 - 2*target_crop

	# run Akita
	def Akita(seq):
		if len(seq) != 2**20: raise ValueError('len(seq) != seq_length')
		seq_1hot = dna_io.dna_1hot(seq)
		test_pred_from_seq = seqnn_model.model.predict(np.expand_dims(seq_1hot,0))
		return test_pred_from_seq

	# open output files per cell type
	output_files = {}
	for cell_type in args.cell_types:
		print(f'Generating Akita predictions for {cell_type}.')
		output_files[cell_type] = open(f'{args.output_directory}/3d_predictions_{cell_type}_{args.individual}_{target_chromosome}.txt', 'w')

	# generate predictions per cell type per window in chromosome for designated individual
	for chromosome, window_start_list in windows.items():
		if chromosome == target_chromosome:
			try:
				fasta_open = pysam.Fastafile(args.fasta)
			except:
				print(f'{chromosome} FASTA could not be accessed.')
				continue

			for window_start in window_start_list:
				print(f'Starting predictions for {chromosome}: {window_start}.')
				try: # some input start locations won't work because when + 1 Mb they are past the end of the chromosome stop
					window_sequence = fasta_open.fetch(chromosome, window_start, window_start+2**20).upper()
					window_predictions  = Akita(window_sequence)
					cell_type_indices = {'HFF': 0, 'H1ESC': 1, 'GM12878': 2, 'IMR90': 3, 'HCT116': 4}

					for cell_type in args.cell_types:
						if cell_type in cell_type_indices:
							index = cell_type_indices[cell_type]
							cell_type_prediction = window_predictions[:,:,index][0]
							output_files[cell_type].write(chromosome + "\t" + str(window_start) + "\t" + "\t".join([str(x) for x in cell_type_prediction]) + "\n")

				except:
					print(f'{chromosome}: {window_start} predictions cannot be generated because this window is < 1,048,576 bp in length.')
					continue

	# close output files
	for cell_type, file_handle in output_files.items():
		file_handle.close()

if __name__ == '__main__':
	main()

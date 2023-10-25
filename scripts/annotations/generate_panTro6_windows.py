import numpy as np

with open('/wynton/group/capra/projects/pan_3d_genome/data/metadata/panTro6_chr_lengths.txt', 'r') as lengths, open('/wynon/group/capra/projects/pan_3d_genome/data/metadata/panTro6_windows.txt', 'a') as out:
	lines = lengths.readlines()
	for line in lines:
		line = line.strip().split('\t')
		chr = line[0]
		len = int(line[1])
		chr_intervals = np.arange(0, len, 524288)
		chr_intervals = ','.join(chr_intervals.astype(str))
		out.write(f'{chr}\t{chr_intervals}\n')
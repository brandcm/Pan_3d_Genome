import argparse

def parse_args():
	parser = argparse.ArgumentParser()

	parser.add_argument('--genes', type = str, required = True, help = 'Name of genes file in data directory')	

	parser.add_argument('--ontology', type = str, required = True, help = 'Name of ontology')
	
	parser.add_argument('--set_name', type = str, required = True, help = 'Name of gene set')

	return parser.parse_args()

def main():
	args = parse_args()
	
	genes_file = open(f'data/{args.genes}', 'r')
	genes = [line.rstrip('\n') for line in genes_file]

	with open(f'ontologies/{args.ontology}.txt') as file, open(f'observed/{args.set_name}_{args.ontology}_observed.txt', 'w') as out:
		unlisted_genes='\t'.join(genes)
		out.write("\t{}\n".format(unlisted_genes))
		for terms in file:
			terms = terms.strip().split("\t")
			term_name = terms[0]
			present = []
			for gene in genes:
				if gene in terms[2:]:
					present.append('True')
				else:
					present.append('False')
			unlisted_present='\t'.join(present)
			out.write("{}: {}\t{}\n".format(args.ontology, term_name, unlisted_present))

if __name__ == '__main__':
    main()

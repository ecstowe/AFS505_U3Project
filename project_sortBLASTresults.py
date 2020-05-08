#import the packages necessary for the script
import pandas as pd
import sys

#define arguments to be read from command line

script, step2_output = argv

#read the bast results file into a pandas dataframe
blast_results = pd.read_csv(step2_output, sep = '\t' )

#add BLAST column headers
blast_results.columns = ['geneID','identical_matches']

#remove the last two characters from all protein names in ['geneID'] column so they read as gene names
blast_results['geneID'] = blast_results['geneID'].map(lambda x: x.rstrip('.1'))

#sort blast results by number of identical matches with largest on top
blast_results=blast_results.sort_values(by=['identical_matches'], ascending = False)

#save the file to a .csv
blast_results.to_csv('BLAST_results')


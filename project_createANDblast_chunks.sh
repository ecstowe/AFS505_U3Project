#!/usr/bin/bash
#SBATCH --partition=kamiak
#SBATCH --account=dhingra
#SBATCH --job-name=project_swisspot_blastp
#SBATCH --output=/home/evan.stowe/project_createANDblast_output/project_swissprot_vs_all.out
#SBATCH --error=/home/evan.stowe/project_createANDblast_output/project_swissprot_vs_all.err
#SBATCH --time=0-00:30:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=5

# add modules to use 

module load blast anaconda3/20.02.0 python3/3.7.4

#create an Anaconda3 environment to operate Biopython to split large .fasta files into chunks
conda create -n chunkenv
#proceed? yes 
y
source activate chunkenv 
conda install biopython 
#proceed? yes 
y
# run python script in Anaconda3 environment to chunk fasta file 
python project_create_chunks.py 

#deactivate and remove the environment 
source deactivate 
conda remove -n chunkenv --all 

# create variables for paths to files to blast and database to use 

chunked_files="./*.fasta"
database="/data/ficklin_class/AFS505/course_material/data/swissprot"

#run blast with above defined query and database output format will be 1 file in tab delimited form

for chunked_file in $chunked_files; do

	blastp \
	-query $chunked_file \
	-db $database \
	-num_threads 5 \
	-outfmt 6 \
	-evalue 1e-6
done 

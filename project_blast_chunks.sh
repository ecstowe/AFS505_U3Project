#!/usr/bin/bash
#SBATCH --partition=kamiak
#SBATCH --account=dhingra
#SBATCH --job-name=project_swisspot_blastp
#SBATCH --output=/home/evan.stowe/project_blast_output/project_swissprot_vs_all.out
#SBATCH --error=/home/evan.stowe/project_blast_output/project_swissprot_vs_all.err
#SBATCH --time=0-00:30:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=5

# add modules to use 

module add blast 

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

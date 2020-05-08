# AFS 505 Unit 3 Project README
## Overview
This workflow executes a split BLAST job on Washington State University’s ‘Kamiak’ HPC and as such assumes the user is familiar with basic command line interface. This workflow requires a .fasta file and a database to BLAST the query against. Necessary software includes: *Python* 3 or greater and *Anaconda3*, both available on Kamiak.  A total of three (3) scripts are needed to execute this workflow. An overview of the workflow is as follows: 
#### Step 1
- Split a large .fasta file into ten (10) equal sized ‘chunks’ with the python script     `project_create_chunks.py`. 
#### Step 2
- Submit a batch job through the SLURM scheduler on Kamiak to BLAST the output of **Step 1**  files against your specified database with the BASH script `project_blast_chunks.srun`. 
#### Step 3 
- Modify and sort the output from **Step 2**  such that the user has one (1) .csv file; *BLAST_results.csv* with two columns: gene ID’s (geneID) and their corresponding number of identical matches from the BLAST (nident). This step is performed by calling the python script `project_sortBLASTresults.py` followed by the path to the output from **Step 2** on the command line.  

## Execution 
SSH into Washington State University's Kamiak HPC and navigate to the following directory: `/data/ficklin_class/AFS505/Spring2020/evan.stowe`

#### Step 1 
This step requires the *Python* package [BioPython](https://biopython.org/). Rather than install it for all users on Kamiak, we will create an environment just for this project within *Anaconda* to run it. Execute the following command line arguments:
- To install Biopython, load the *Anaconda3* module: 
`$ module load anaconda3`
- Now create an environment to install the BioPython package: 
`$ conda create -n projectenv`
- Activate the environment to begin using it: 
`$ source activate projectenv` 
- Finally, install the BioPython package: 
`$ conda install -n projectenv biopython`

Now we have the proper environment to execute our the python script to break apart our large .fasta file into smaller'chunks'. 
To change the input file, open the script in a text editor and modify the variable `path`. 
- Run the script: 
`$ python ./scripts/project_create_chunks.py`

#### Step 2

Now that we have our large file split into 'chunks', we will create a batch job to run a BLAST against our specified database with each 'chunk' file as a unique query. 
To change the database, open the script in a text editor and modify the variable `database`. 
To specify output formats and data within the output, modify the `-outfmt "6 qseqid nident"` BASH command within the script. 
View all available data configurations for BLAST output format 6 [here](http://www.metagenomics.wiki/tools/blast/blastn-output-format-6). 
You may have to specify a different Kamiak account or partition within the script. To do this, open a text editor and edit the SBATCH parameters account and partition to 
those that you have permission to use. 

- Sumbit the batch job: 
`$ sbatch ./scripts/project_blast_chunks.srun`

Output and error files will be sent to the directory `/data/ficklin_class/AFS505/Spring2020/evan.stowe/project_blast_output`. 

#### Step 3 

Now that we have BLAST results, we will modify them to depict only gene names and sort them by order of identical matches. 

- Run *Python* script with the output from **Step 2** as the only command line argument. 
`$ python ./scripts/project_sortBLASTresults.py ./project_blast_output/project_swissprot_vs_all.out`

Output from the script `scripts/project_sortBLASTresults.py` will be sent to the current working directory. Look for the file *BLAST_results.csv*. 

## Post Hoc
If you do not wish to kep the environment created in **Step 1**,  execute the following commands: 
```  
source deactivate
conda remove -n projectenv --all
```
## Authors 

Evan Stowe

evan.stowe@wsu.edu

## Acknowledgements 
I would like to thank Hielke Walinga for helping me understand how to properly implement the Biopython iterator. 





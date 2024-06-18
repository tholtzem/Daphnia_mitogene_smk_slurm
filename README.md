
# This is the README.md for Daphnia_mitogene_smk_slurm


======================================================


## Information on the tutorial

This workflow is designated for the extraction and analysis of mitochondrial protein-coding genes from sequencing libraries.

The first part entails the use of [MitoGeneExtractor](https://github.com/cmayer/MitoGeneExtractor/tree/last-reviews-before-publication) to extract mitochondrial protein-coding genes from sequencing libraries, and the alignment of those genes with [MUSCLE v5](https://github.com/rcedgar/muscle?tab=readme-ov-file).

Input files:

1) amino acid reference in fasta file format:
Here, we used the protein sequences of the *Daphnia* *galeata* mitochondrial genome, downloaded from [GeneBank](https://www.ncbi.nlm.nih.gov/nuccore/OM397534.1?report=genbank).
We created separate files for each gene sequence (see refs/)  

2) whole genome sequencing data in the form of trimmed (bbduk) and decontaminated (KRAKEN2) fastq reads. For more information on the pre-processing process see  the [Daphnia_Resakemake_pbs_2.0 Tutorial](https://github.com/tholtzem/Daphnia_RestEggs_snakemake_pbs_2.0/tree/master).


### Part 1: rules executed on the cluster using snakemake
* Use merge_multilanes_fastq.smk to merge fastq files in case your samples have been sequenced on multiple lanes prior to the extraction of mtgenes.
* Use mitogene_extractor.smk to concatenate cleaned and trimmed paired-end reads, and to extract PCG mtgenes using MitoGeneExtractor.
* Use rename_consensus_header.smk to rename the header of the consensus sequence according to the sequence name.
* Use muscle.smk to create alignments for a desired set of samples.
* Use fas2nex.smk to transform the alignment into nexus format.

### Part 2: steps executed on a local device
* Open SequenceMatrix and create a matrix in nexus format of your mtgene alignments

Download and install

```
git clone https://github.com/gaurav/taxondna/releases/download/v1.9/SequenceMatrix-1.9.zip ~/bio/
unzip SequenceMatrix-1.9.zip
```
Open GUI with
```
java -jar ~/bio/SequenceMatrix-1.9/SequenceMatrix.jar

```

* Create a partition file (DNA.par) manually


======================================================


## Anaconda and Mamba


Mamba (https://github.com/mamba-org/mamba) is a reimplementation of the conda package manager in C++.

```
# Load Anaconda on cluster (here mach2):
module load Anaconda3/2023.10/miniconda-base-2023.10
 

# To use conda commands in your current shell session, first do:
eval "$(/$UIBK_CONDA_DIR/bin/conda shell.bash hook)"

# Users of the c770 group can simply activate the environment on leo5 with:
conda activate da_mitogenextractor

# !!! In case you want to change the environment or create your own !!! 
## Create environment from yaml file (in envs/):
mamba env create -f env/daphnia_mitogene.yaml -p $SCRATCH/envs/daphnia_mitogenextractor
#conda config --append envs_dirs $SCRATCH/envs


# Software can be installed/updated by modifying the env/ file.
## To use the modified conda environment, update with:
mamba env update --name da_mitogenextractor --file env/daphnia_mitogene.yaml

```

## Users of the c770 group can get the snakemake pipeline for the slurm based cluster (here leo5)

```
mkdir some_directory
cd some_directory
rsync -avP /scratch/c77011XX/snakemake/ ./

```


## Some information on the snakemake pipeline for the slurm based cluster (here leo5)


1. Testing and execution of snakemake in working directory (where your snakefile is located)

2. Slurm specific files and logs are in slurm/ directory
* cluster submission script for main job (slurm/clusterSnakemake_template.sh) **Do not forget to change the filename (to slurm/clusterSnakemake.sh), the job-name and mail-user!**
* configuration profile for slurm (slurm/config_template.yaml) **Do not forget to change the filename (to slurm/config.yaml)!**
* sbatch log files (output & erro files) are sent to slurm/log/

3. The snakefile:
* contains the names of the output files (should correspond to the output in your rule)
* always includes the file rules/common.smk
* includes additional files with rules you want to execute (f.ex. rules/test.smk)

4. The rules/common.smk file:
* calls the input config file (config/config.yaml) and 
* contains python code for loading sample information (and helper functions)

5. The snakemake configuration file (config/config.yaml) contains the paths to adapters, Kraken2 database and references 

6. Sample information and metadata are in list/samples.csv

7. Data was downloaded from (https://github.com/snakemake/snakemake-tutorial-data/archive/v5.4.5.tar.gz) **NOT required for c770 group!**

## Local execution of snakemake (for testing only, else not recommended!)

# dry-run

```
snakemake -n

```

## Run snakemake via cluster execution on leo5

For more information on leo5 and slurm (https://www.uibk.ac.at/zid/systeme/hpc-systeme/common/tutorials/slurm-tutorial.html)

```
sbatch slurm/clusterSnakemake.sh

```

## Check/cancel jobs

```
# check all jobs
sq

# check your jobs only
squ

# cancel job
scancel <JOBID>

# check usage of running job
## ssh to node (NODELIST)
ssh <NODELIST>
## on the compute node
top

# check usage after the job has completed
export SACCT_FORMAT="JobID%20,JobName,User,Partition,NodeList,Elapsed,State,ExitCode,MaxRSS,AllocTRES%32"
sacct -j <JOBID>

```


## Some notes and recommendations to the pipeline


1) The individual alignments are computed by calling the Exonerate program. Exonorate will produce a temporary file for each sample separately, so if your storage is limited consider running the pipeline for a FEW samples, but for ALL protein coding genes at once (rather than the other way around). If the main job has finished, you can always add more samples step by step.

f.ex. To extract all 13 protein coding genes from a few samples, put this in your snakefile:

```
expand("mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.fas", sample=samples_subset_prefix[0:10], gene=config['genes'])
```

2) ressources

rule fastq_concat: 100-150 **MB**, walltime < 15 min, rule creates temporary files which will be removed after the job from rule MitogeneExtractor has finished

rule MitogeneExtractor: 100-200 **GB**, walltime < 12 hours (usually < 6 h, but it can also take up to 2 days for very large files)



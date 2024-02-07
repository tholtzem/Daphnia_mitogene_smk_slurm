#!/bin/bash
##################
#### Start SLURM preamble
####  Job name
#SBATCH --job-name=Rest_eggs
#### Select queue: std.q (max:240h), short.q (max:10h),
#### bigmem.q (max:240h) for jobs with high main memory requirements (512GB) of memory
#SBATCH --partition=std
#### Execute in current working directory
#### Notification to your e-mail address
##SBATCH --mail-user=xxx@xxx
##SBATCH --mail-type=END
#### requested walltime 
#SBATCH --time=120:00:00
#### request a per slot memory limit size
#SBATCH --mem-per-cpu=200M
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm/log/%x-%j.out
#SBATCH --error=slurm/log/%x-%j.err
# Add a note here to say what software modules should be loaded.
# for this job to run successfully.
# It will be convenient if you give the actual load command(s), e.g.,
#
# module load intel/16.0.4
# module load sratoolkit/2.8.2-1
#module load jdk/1.8.0_45 
#module load snakemake/5.32.0-conda-2020.03 

#module load Anaconda3/2023.03/miniconda-base-2023.03
module load Anaconda3/2023.10/miniconda-base-2023.10 
eval "$(/$UIBK_CONDA_DIR/bin/conda shell.bash hook)"
conda activate da_mitogenextractor

module load singularity/3.8.7-python-3.10.8-gcc-8.5.0-e6f6onc

####  End SLURM preamble
##################

#### Some SLURM job only tasks

echo STARTED on $(date)

# Initiating snakemake and running workflow in cluster mode
snakemake --use-envmodules --profile slurm/ #--rerun-incomplete

echo FINISHED on $(date)


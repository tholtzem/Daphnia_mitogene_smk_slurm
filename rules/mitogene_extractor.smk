rule fastq_concati:
  input:
    r1 = "/scratch/c7701178/mach2/DAPHNIA/Daphnia_RestEggs_snakemake_pbs_2.0_HiC/KRAKEN2_RESULTS/{sample}_R1.trmdfilt.keep.fq.gz",
    r2 = "/scratch/c7701178/mach2/DAPHNIA/Daphnia_RestEggs_snakemake_pbs_2.0_HiC/KRAKEN2_RESULTS/{sample}_R2.trmdfilt.keep.fq.gz"
    #r1 = "/scratch/c7701178/mach2/DAPHNIA/Daphnia_RestEggs_4lakes_smk_slurm/KRAKEN2_RESULTS/{sample}_R1.trmdfilt.keep.fq.gz",
    #r2 = "/scratch/c7701178/mach2/DAPHNIA/Daphnia_RestEggs_4lakes_smk_slurm/KRAKEN2_RESULTS/{sample}_R2.trmdfilt.keep.fq.gz"
  output:
    temp("KRAKEN2_RESULTS/concat/{sample}.trmdfilt.keep.concat.fq")
  threads: 1
  message: """ fqgz 2 fq, remove white space in read names """
  resources: mem_mb=150, walltime="00:15:00"
  shell:
    """
    zcat {input.r1} {input.r2} | sed 's, ,_,g' > {output}
    """

rule MitoGeneExtractor:
  input:
    DNA = "KRAKEN2_RESULTS/concat/{sample}.trmdfilt.keep.concat.fq",
    AA = "refs/D_galeata_linear_{gene}.fasta"
    #AA = config['prot_ref_Dgal']    
  output:
    a = "mitogenes/{gene}/{sample}_alignment_Daphnia_galeata_{gene}.fas",   #the output name depends also on the name of your supplied reference and might be adjusted;
    b = "mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.fas",   #here the reference name was 'Passeriformes_COX1.fas'
    c = "mitogenes/{gene}/{sample}_vulgar.txt"
  log: "log/{gene}/{sample}_Mitogene_extractor.log"
  threads: 1
  message: " MGE "
  resources: mem_mb=400000, walltime="48:00:00"
  shell:
    """
    module load singularity/3.8.7-python-3.10.8-gcc-8.5.0-e6f6onc
    singularity exec --home $PWD:$HOME /scratch/c7701178/bio/mito.sif MitoGeneExtractor --report_gaps_mode 1 -q {input.DNA} -p {input.AA} -o mitogenes/{wildcards.gene}/{wildcards.sample}_alignment_ -c mitogenes/{wildcards.gene}/{wildcards.sample}_consensus_ -V {output.c} -C 5 -r 1 -n 0 -t 0.5 --minSeqCoverageInAlignment_total 1 2> {log}
    """

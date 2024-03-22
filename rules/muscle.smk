rule symlink_sets:
  input:
    "/scratch/c7701178/mach2/DAPHNIA/Daphnia_mitogene_smk_slurm/mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.renamed.fas"
  output:
    touch("/scratch/c7701178/mach2/DAPHNIA/Daphnia_mitogene_smk_slurm/mitogenes/{sets}/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.renamed.symlink.done")
  threads: 1
  message: """ Create a symlink for cretain samples, always use the FULL path!!! """
  shell:
    """ 
    ln -s {input} mitogenes/{wildcards.sets}/{wildcards.gene}/{wildcards.sample}_consensus_Daphnia_galeata_{wildcards.gene}.renamed.fas
    """


rule multifas:
  input:
	  #"mitogenes/{sets}/{gene}/"
  output:
    "mitogenes/{sets}/{gene}_multi.fas"
  threads: 1
  message: """ fqgz 2 fq, remove white space in read names """
  shell:
    """ 
    cat mitogenes/{wildcards.sets}/{wildcards.gene}/*_consensus_Daphnia_galeata_{wildcards.gene}.renamed.fas > {output}
    """


rule muscle_super5:
  input:
    "mitogenes/{sets}/{gene}_multi.fas"
  output:
    "muscle/{sets}/{gene}_multi.super5.fas"
  log: "log/{sets}/{gene}_multi.super5.log"
  threads: 1
  message: "Align sequences using MUSCLE"
  resources: mem_mb=2000, walltime="00:30:00"
  shell:
    """
    muscle -super5 {input} -output {output} -log {log} -verbose
    """


rule muscle_align:
  input:
    "mitogenes/{sets}/{gene}_multi.fas"
  output:
    "muscle/{sets}/{gene}_multi.aligned.fas"
  log: "log/{sets}/{gene}_multi.aligned.log"
  threads: 1
  message: "Align sequences using MUSCLE"
  resources: mem_mb=10000, walltime="02:00:00"
  shell:
    """
    muscle -align {input} -output {output} 2> {log}
    """

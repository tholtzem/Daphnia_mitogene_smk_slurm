rule rename_consensus_header:
  input:
    fasta = "mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.fas"
  output:
    fasta = "mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.renamed.fas"
  log: "log/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.renamed.log"
  threads: 1
  message: " Rename header of consensus sequence according to the sequence name "
  resources: mem_mb=150, walltime="01:00:00"
  #resources: partition="mem2000", mem_mb=100000, walltime="06:00:00"
  shell:
    """
    sed '1s/.*/>{wildcards.sample}/' {input.fasta} > {output.fasta} 2> {log}
    """


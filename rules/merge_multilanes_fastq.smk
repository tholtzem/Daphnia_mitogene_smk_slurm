rule merge_fastq_REF:
  input:
    #"/scratch/c7701125/mach2/EXCHANGE/CLONE_DATA/KRAKEN2/{id}_{read}.trmdfilt.keep.fastq.gz"
  output:
    touch("/scratch/c7701125/mach2/EXCHANGE/CLONE_DATA/merged_fastq/{ids}_merged.fastq.done")
  threads: 1
  message: """ Merge files for each unique ID """
  resources: mem_mb=1000, walltime="06:00:00"
  log: "log/{ids}_R_1_merged.fastq.log"
  shell:
  	"""
	zcat /scratch/c7701125/mach2/EXCHANGE/CLONE_DATA/KRAKEN2/{wildcards.ids}_*_R_1.trmdfilt.keep.fastq.gz | gzip > /scratch/c7701125/mach2/EXCHANGE/CLONE_DATA/merged_fastq/{wildcards.ids}_R_1_merged.fastq.gz && zcat /scratch/c7701125/mach2/EXCHANGE/CLONE_DATA/KRAKEN2/{wildcards.ids}_*_R_2.trmdfilt.keep.fastq.gz | gzip > /scratch/c7701125/mach2/EXCHANGE/CLONE_DATA/merged_fastq/{wildcards.ids}_R_2_merged.fastq.gz 2> {log}
	"""
 

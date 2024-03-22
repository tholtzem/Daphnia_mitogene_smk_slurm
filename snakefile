include: "rules/common.smk"


# -----------------------------------------------

#The {wildcards} will be replaced with your specification in the confiq.yaml file. 
rule all:
    input:
	    #expand("mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.fas", sample=samples_ALL_prefix, gene=config['genes']),
	    #expand("mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.fas", sample=samples_subset_prefix, gene=config['genes'][9]),
	    #expand('/scratch/c7701125/mach2/EXCHANGE/CLONE_DATA/merged_fastq/{ids}_{ext}', ids=unique_ids, ext=['merged.fastq.done']),
	    #expand('mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.fas', sample=unique_ids, gene=config['genes']),
	    #expand('mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.renamed.fas', sample=unique_ids, gene=config['genes']),
	    expand('mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.renamed.fas', sample=samples_subset_prefix, gene=config['genes']),
	    expand('/scratch/c7701178/mach2/DAPHNIA/Daphnia_mitogene_smk_slurm/mitogenes/{sets}/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.renamed.symlink.done', sets=['LC'], sample=samples_LC_REF_prefix, gene=config['genes']), 
	    expand('mitogenes/{sets}/{gene}_multi.fas', sets=['LC'], gene=config['genes']),
	    expand('muscle/{sets}/{gene}_multi.super5.fas', sets=['LC'], gene=config['genes']),
	    #expand('muscle/{sets}/{gene}_multi.aligned.fas', sets=['LC'], gene=config['genes']),





# ---------------------------------------------


#include: "rules/mitogene_extractor.smk"
#include: "rules/merge_multilanes_fastq.smk"
include: "rules/rename_consensus_header.smk"
include: "rules/muscle.smk"
#include: "rules/mtGene_matrix.smk"

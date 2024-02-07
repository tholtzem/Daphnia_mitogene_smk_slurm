include: "rules/common.smk"


# -----------------------------------------------

#The {wildcards} will be replaced with your specification in the confiq.yaml file. 
rule all:
    input:
	    #expand("mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.fas", sample=samples_subset_prefix[0:10], gene=config['genes']),
	    expand("mitogenes/{gene}/{sample}_consensus_Daphnia_galeata_{gene}.fas", sample=samples_subset_prefix, gene=config['genes'][0:1])
        #expand("{gene}/{sample}_r_{r}_cov_{cov}_n_{n}_consensus_Passeriformes_{gene}.fas", sample=config["samples"], gene=config["genes"], r = config["r_params"], n = config["n_params"], cov=config["cov_params"])
	#





# ---------------------------------------------


include: "rules/mitogene_extractor.smk"

import os
import pandas as pd

###### Config file and sample sheets #####


configfile:
  "config/config.yaml"

# load sample info from raw data
samples_info = pd.read_csv("list/sample_sheet.csv", sep=',', index_col=False)
sample_names = list(samples_info['prefix'])
sample_ID = list(samples_info['sample_id'])
sample_dir = list(samples_info['fastq_dir'])
samples_set = zip(sample_names, sample_dir)
samples_dict = dict(zip(sample_names, sample_dir))

samples_ALL = pd.read_csv("list/Da_Resteggs_4lakes.metadata.csv", sep=',', index_col=False)
samples_ALL_prefix = list(samples_ALL['prefix'])
# extract ref clones, except outgroup
samples_subset = samples_ALL[(samples_ALL['location']!='VAR') & (samples_ALL['location']!='ANN') & (samples_ALL['period']!='REF')] 
#& (samples_ALL['prefix']!='79552_ID2376_22-1204a_S167_L004') & (samples_ALL['prefix']!='54067_ID1725_48-B-91S_S10_L001')]
samples_subset_prefix = list(samples_subset['prefix'])

# different data sets, here: LC
#samples_paper1 = pd.read_csv("list/Da_Resteggs_Refclones_metadata.csv", sep='\t', index_col=False)
#samples_LC_REF = samples_paper1[(samples_paper1['location']!='VAR') & (samples_paper1['location']!='ANN') & (samples_paper1['location']!='LZ') & (samples_paper1['species']!='curvirostris') & (samples_paper1['species']!='lacustris') & (samples_paper1['species']!='lacustris')] 
#& (samples_ALL['prefix']!='79552_ID2376_22-1204a_S167_L004') & (samples_ALL['prefix']!='54067_ID1725_48-B-91S_S10_L001')]
#samples_LC_REF_prefix = list([prefix.replace('.bb.HiC', '') for prefix in samples_LC_REF['prefix']])
samples_paper1 = pd.read_csv("list/mito_LC_outgroup_admix_LC_REF_K4_pruned.list", sep='\t', index_col=False)
samples_LC_REF_prefix = list([prefix.replace('.bb.HiC', '') for prefix in samples_paper1['ID']])

## Some of the REF samples were sequenced on multiple lanes
## so we need to merge them first

# Define paths
path2Kraken = "/scratch/c7701125/mach2/EXCHANGE/CLONE_DATA/KRAKEN2"
path2merged = "/scratch/c7701125/mach2/EXCHANGE/CLONE_DATA/merged_fastq"

# Extract unique IDs
ids = []
for i in os.listdir(path2Kraken):
    if i.endswith("_R_1.trmdfilt.keep.fastq.gz"):
        if i.startswith(("F3J", "FP2")):
            id = i.split("_")[0] + "_" + i.split("_")[1]  # extracting the ID from the first and second part of the filename due to inconsistent naming in both samples
        else:
            id = i.split("_")[0]  # for all remaining samples extracting the ID from the first part of the filename
        ids.append(id)
unique_ids = sorted(set(ids))


#samples_REF = samples_ALL[samples_ALL['period']=='REF']
#samples_REF_prefix = list(samples_REF['prefix'])

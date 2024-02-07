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


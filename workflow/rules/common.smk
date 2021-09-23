##############################
# common.smk
#
# Collection of code common to all parts of the workflow
##############################
from snakemake.utils import validate
import pandas as pd


# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
container: "docker://continuumio/miniconda3"


##### load config and sample sheets #####
configfile: "config/config.yaml"


validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_csv(config["samples"], sep="\t").set_index("sample", drop=False)
samples.index.names = ["sample_id"]
validate(samples, schema="../schemas/samples.schema.yaml")

reads = pd.read_csv(config["reads"], sep="\t").set_index("sample", drop=False)
reads.index.names = ["sample_id"]
validate(reads, schema="../schemas/reads.schema.yaml")


##### Global wildcard constraints: valid in all rules #####
wildcard_constraints:
    fasta="(fasta|fa)",
    sample="({})".format("|".join(samples.index)),
    unit="({})".format("|".join(reads.unit.drop_duplicates().values)),


##############################
# Utility functions - could move to separate file(s) if many of them
##############################
def ref_basename():
    """Return the basename of the reference file"""
    return os.path.splitext(os.path.basename(config["ref"]))[0]


def ref_dirname():
    """Return the dirname of the reference file"""
    return os.path.dirname(config["ref"])

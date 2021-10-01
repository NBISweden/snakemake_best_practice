##############################
# Snakefile dedicated to input functions
#
# The snakemake linter complains if rules are mixed with input
# functions. This file contains input functions only to make the
# linter happy.
#
# Naming convention: rule name + _input
##############################
def bwa_mem_index_input_ext(wildcards):
    """Retrieve bwa mem index with extensions"""
    return expand(
        "{index}{ext}", index=config["ref"], ext=[".amb", ".ann", ".bwt", ".pac", ".sa"]
    )


def map_sample_unit_input(wildcards):
    """Retrieve input to a mapping job for a given sample and unit"""
    df = reads.loc[wildcards.sample]
    if isinstance(df, pd.Series):
        df = pd.DataFrame(df).T
    inputreads = sorted(df[df["unit"] == wildcards.unit].read1.values) + sorted(df[df["unit"] == wildcards.unit].read2.values)
    return inputreads


def picard_merge_sam_input(wildcards):
    """Generate picard merge input file targets

    The map_picard_merge_sam rule merges mapped units to a
    sample-level bam file.

    """
    df = reads.loc[wildcards.sample][["unit", "sample_name"]].drop_duplicates()
    if isinstance(df, pd.Series):
        units = [df.unit]
    else:
        units = df.unit.unique()
    bam = [f"data/interim/map/bwa/{wildcards.sample}/{unit}.bam" for unit in units]
    return bam


def qc_multiqc_input(wildcards):
    return all_qc_fastqc(wildcards)


##############################
# Pseudotarget rules that collect outputs from other rules
##############################
def all_map_input(wildcards):
    """Pseudotarget that collects all merged bam files"""
    fn = "data/interim/map/bwa/{}.bam"
    bam = [fn.format(x) for x in samples.index]
    return bam


def all_qc_fastqc(wildcards):
    fn = "results/qc/fastqc/{}_fastqc.zip"
    files = [fn.format(x) for x in reads.read1.values] + [fn.format(x) for x in reads.read2.values]
    return files


def all_qc_plot(wildcards):
    fn = "results/qc/samtools/{}.coverage.png"
    files = [fn.format(x) for x in samples.index]
    return files


def all_qc(wildcards):
    d = {
        "fastqc": all_qc_fastqc(wildcards),
        "plots": all_qc_plot(wildcards),
        "multiqc": "reports/qc/multiqc.html",
        "notebook": "reports/qc/notebook.html",
    }
    return d


def all(wildcards):
    d = {"map": all_map_input(wildcards)}
    d.update(**all_qc(wildcards))
    return d

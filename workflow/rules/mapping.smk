##############################
# Rules to do mapping with bwa
##############################
rule map_bwa_index:
    """bwa index a reference

    The rule runs bwa via the shell directive. The rule defines an
    isolated software environment with the conda directive. The
    envmodules directive defines a lua module in the uppmax module
    system.
    """
    output:
        expand(
            "{{refdir}}/{{genome}}{ext}", ext=[".amb", ".ann", ".bwt", ".pac", ".sa"]
        ),
    input:
        config["ref"],
    log:
        "logs/bwa/index/{refdir}/{genome}.log",
    resources:
        runtime=100,
    wildcard_constraints:
        genome=ref_basename(),
        refdir=ref_dirname(),
    envmodules:
        "bwa/0.7.17",
    conda:
        "../envs/bwa.yaml"
    threads: 1
    shell:
        "bwa index {input}"


rule map_bwa_mem:
    """Map reads to an index

    The output file is marked with 'temp' such that it will be removed
    once all jobs depending on this output have completed. The rule
    makes use of two input functions to collect the bwa index and the
    reads to be mapped. The resources directive specifies the resource
    runtime using a lambda signature that includes the 'attempt'
    variable.

    The rule makes use of a public snakemake wrapper from the
    snakemake wrapper repository. The wrapper defines the appropriate
    software environment which is why we don't need to specify the
    conda directive here. See
    https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/bwa/mem.html
    for more information."""
    output:
        temp("data/interim/map/bwa/{sample}/{unit}.bam"),
    input:
        index=bwa_mem_index_input_ext,
        reads=map_sample_unit_input,
    resources:
        mem_mb=2000,
        runtime=lambda wildcards, attempt: attempt
        * workflow.default_resources.parsed.get("runtime", 100),
    log:
        "logs/bwa/{sample}/{unit}.log",
    envmodules:
        "bwa/0.7.17",
    params:
        # Following parameters *must* be defined to comply with the
        # snakemake wrapper
        index=config["ref"],
        sort=config["bwa_mem_options"]["sort"],
        sort_order=config["bwa_mem_options"]["sort_order"],
        sort_extra="",
        extra="",
    threads: 2
    wrapper:
        "0.78.0/bio/bwa/mem"

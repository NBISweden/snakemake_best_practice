##############################
# Various utility rules
##############################
rule picard_merge_sam:
    """Merge sam/bam files with picard"""
    output: "data/interim/map/bwa/{sample}.bam"
    input: picard_merge_sam_input
    resources: runtime = 100
    log: "logs/picard/merge/{sample}.log"
    threads: 1
    wrapper: "0.78.0/bio/picard/mergesamfiles"

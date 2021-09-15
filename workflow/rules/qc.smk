##############################
# Various qc rules
##############################
rule qc_multiqc:
    """Run MultiQC on QC outputs"""
    output: "reports/qc/multiqc.html"
    input: unpack(qc_multiqc_input)
    params: config["qc_multiqc"]["options"]
    log: "logs/reports/qc/multiqc.log"
    conda: "../envs/multiqc.yaml"
    envmodules:
        "MultiQC/1.11"
    shell:
        "multiqc {params} --force -o reports/qc -n multiqc {input} > {log}"


rule qc_fastqc:
    """Run FastQC on input sequence files

    The rule uses a snakemake wrapper to run FastQC. See
    https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/fastqc.html

    The wildcard_constraints directive is used to limit the 'prefix'
    wildcard to strings starting with data/, followed by an arbitrary
    number of characters."""
    output: html = "results/qc/fastqc/{prefix}.gz.html",
            zip = "results/qc/fastqc/{prefix}.gz_fastqc.zip"
    input:  "{prefix}.gz"
    wildcard_constraints:
        # Assume input reads always live in data/.+
        prefix = "data/.+"
    threads: 1
    log: "logs/qc/fastqc/{prefix}.gz.log"
    wrapper: "0.78.0/bio/fastqc"


rule qc_samtools_coverage:
    """Calculate alignment coverage with samtools"""
    output: txt = "results/qc/samtools/{sample}.coverage.txt"
    input: bam = "data/interim/map/bwa/{sample}.bam"
    threads: 1
    conda: "../envs/samtools.yaml"
    envmodules:
        "samtools/1.12"
    log: "logs/qc/samtools/{sample}.coverage.log"
    shell:
        "samtools coverage {input.bam} -o {output.txt} > {log}"

rule qc_plot_samtools_coverage:
    """Plot the meandepth coverage for samtools coverage"""
    output: png = report("results/qc/samtools/{sample}.coverage.png", caption="../report/coverage.rst", category="Coverage")
    input: txt = "results/qc/samtools/{sample}.coverage.txt"
    threads: 1
    log: "logs/qc/samtools/{sample}.coverage.log"
    conda: "../envs/R.yaml"
    envmodules:
        "R_packages/4.0.4"
    script:
        "../scripts/plot_coverage.R"

rule qc_notebook:
    """Run a jupyter notebook"""
    output: html = "reports/qc/notebook.html"
    input: coverage = ["results/qc/samtools/{}.coverage.txt".format(x) for x in samples.index]
    conda: "../envs/jupyter.yaml"
    log: "logs/qc/notebooks/notebook.log"
    notebook: "../notebooks/notebook.py.ipynb"

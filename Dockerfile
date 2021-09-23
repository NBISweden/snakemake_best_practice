FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="6dd34be24a4ea762d0253133ff979573da2b2f88dd0d4aafe099d561ec9574fe"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: https:/github.com/snakemake/snakemake-wrappers/raw/0.78.0/bio/bwa/mem/environment.yaml
#   prefix: /conda-envs/1c13e56240ad3f4af6b92e2cbfe72c58
#   channels:
#     - bioconda
#     - conda-forge
#     - defaults
#   dependencies:
#     - bwa ==0.7.17
#     - samtools =1.12
#     - picard =2.25
RUN mkdir -p /conda-envs/1c13e56240ad3f4af6b92e2cbfe72c58
ADD https://github.com/snakemake/snakemake-wrappers/raw/0.78.0/bio/bwa/mem/environment.yaml /conda-envs/1c13e56240ad3f4af6b92e2cbfe72c58/environment.yaml

# Conda environment:
#   source: https:/github.com/snakemake/snakemake-wrappers/raw/0.78.0/bio/fastqc/environment.yaml
#   prefix: /conda-envs/08d4368302a4bdf7eda6b536495efe7d
#   channels:
#     - bioconda
#     - conda-forge
#     - defaults
#   dependencies:
#     - fastqc ==0.11.9
RUN mkdir -p /conda-envs/08d4368302a4bdf7eda6b536495efe7d
ADD https://github.com/snakemake/snakemake-wrappers/raw/0.78.0/bio/fastqc/environment.yaml /conda-envs/08d4368302a4bdf7eda6b536495efe7d/environment.yaml

# Conda environment:
#   source: https:/github.com/snakemake/snakemake-wrappers/raw/0.78.0/bio/picard/mergesamfiles/environment.yaml
#   prefix: /conda-envs/b2d213b3f556bd74f6dbb226a0f9d537
#   channels:
#     - bioconda
#     - conda-forge
#     - defaults
#   dependencies:
#     - picard ==2.22.1
#     - snakemake-wrapper-utils ==0.1.3
RUN mkdir -p /conda-envs/b2d213b3f556bd74f6dbb226a0f9d537
ADD https://github.com/snakemake/snakemake-wrappers/raw/0.78.0/bio/picard/mergesamfiles/environment.yaml /conda-envs/b2d213b3f556bd74f6dbb226a0f9d537/environment.yaml

# Conda environment:
#   source: workflow/envs/R.yaml
#   prefix: /conda-envs/1c4232a516d5eac329ac893d2d315fe7
#   channels:
#     - conda-forge
#     - bioconda
#     - default
#   dependencies:
#     - r-ggplot2=3.3.5
RUN mkdir -p /conda-envs/1c4232a516d5eac329ac893d2d315fe7
COPY workflow/envs/R.yaml /conda-envs/1c4232a516d5eac329ac893d2d315fe7/environment.yaml

# Conda environment:
#   source: workflow/envs/bwa.yaml
#   prefix: /conda-envs/b99350fbff5c237f6370046342d6cd9d
#   channels:
#     - conda-forge
#     - bioconda
#     - defaults
#   dependencies:
#     - bwa=0.7.17
RUN mkdir -p /conda-envs/b99350fbff5c237f6370046342d6cd9d
COPY workflow/envs/bwa.yaml /conda-envs/b99350fbff5c237f6370046342d6cd9d/environment.yaml

# Conda environment:
#   source: workflow/envs/jupyter.yaml
#   prefix: /conda-envs/1e3a44ac917a549d98a13e6f518b9d5a
#   channels:
#     - conda-forge
#   dependencies:
#     - python=3.8
#     - pandas=1.3.3
#     - jupyter=1.0
#     - jupyter_contrib_nbextensions=0.5.1
#     - jupyterlab_code_formatter=1.4
RUN mkdir -p /conda-envs/1e3a44ac917a549d98a13e6f518b9d5a
COPY workflow/envs/jupyter.yaml /conda-envs/1e3a44ac917a549d98a13e6f518b9d5a/environment.yaml

# Conda environment:
#   source: workflow/envs/multiqc.yaml
#   prefix: /conda-envs/34744841bbfb4e23c9cb4b68136d5b34
#   channels:
#     - conda-forge
#     - bioconda
#     - default
#   dependencies:
#     - multiqc=1.11
RUN mkdir -p /conda-envs/34744841bbfb4e23c9cb4b68136d5b34
COPY workflow/envs/multiqc.yaml /conda-envs/34744841bbfb4e23c9cb4b68136d5b34/environment.yaml

# Conda environment:
#   source: workflow/envs/samtools.yaml
#   prefix: /conda-envs/b38a6266b250d885d6c3910144ba072a
#   channels:
#     - conda-forge
#     - bioconda
#     - default
#   dependencies:
#     - samtools=1.13
RUN mkdir -p /conda-envs/b38a6266b250d885d6c3910144ba072a
COPY workflow/envs/samtools.yaml /conda-envs/b38a6266b250d885d6c3910144ba072a/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/1c13e56240ad3f4af6b92e2cbfe72c58 --file /conda-envs/1c13e56240ad3f4af6b92e2cbfe72c58/environment.yaml && \
    mamba env create --prefix /conda-envs/08d4368302a4bdf7eda6b536495efe7d --file /conda-envs/08d4368302a4bdf7eda6b536495efe7d/environment.yaml && \
    mamba env create --prefix /conda-envs/b2d213b3f556bd74f6dbb226a0f9d537 --file /conda-envs/b2d213b3f556bd74f6dbb226a0f9d537/environment.yaml && \
    mamba env create --prefix /conda-envs/1c4232a516d5eac329ac893d2d315fe7 --file /conda-envs/1c4232a516d5eac329ac893d2d315fe7/environment.yaml && \
    mamba env create --prefix /conda-envs/b99350fbff5c237f6370046342d6cd9d --file /conda-envs/b99350fbff5c237f6370046342d6cd9d/environment.yaml && \
    mamba env create --prefix /conda-envs/1e3a44ac917a549d98a13e6f518b9d5a --file /conda-envs/1e3a44ac917a549d98a13e6f518b9d5a/environment.yaml && \
    mamba env create --prefix /conda-envs/34744841bbfb4e23c9cb4b68136d5b34 --file /conda-envs/34744841bbfb4e23c9cb4b68136d5b34/environment.yaml && \
    mamba env create --prefix /conda-envs/b38a6266b250d885d6c3910144ba072a --file /conda-envs/b38a6266b250d885d6c3910144ba072a/environment.yaml && \
    mamba clean --all -y

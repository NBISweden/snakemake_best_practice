#!/usr/bin/env python3
import os
import pandas as pd


def _read_table(infile):
    x = pd.read_table(infile)
    x["infile"] = os.path.basename(infile)
    return x


df = pd.concat([_read_table(x) for x in snakemake.input.txt])
plt = (
    df.plot.scatter(x="covbases", y="coverage")
    .get_figure()
    .savefig(snakemake.output.png)
)

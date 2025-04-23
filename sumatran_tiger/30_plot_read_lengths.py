#!/usr/bin/env python3
# 22/4/25
# run the script in the python3.12 conda environment on Ada

# run with: srun --partition defq --cpus-per-task 1 --mem 80g --time 5:00:00 --pty bash
# run for simplex reads with: python 30_plot_read_lengths.py /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_simplex_simplex.fastq.gz


import gzip
import argparse
import os
import matplotlib.pyplot as plt

def parse_fastq_lengths(fastq_path):
    lengths = []
    with gzip.open(fastq_path, 'rt') as f:
        while True:
            header = f.readline()
            if not header:
                break  # End of file
            seq = f.readline().strip()
            f.readline()  # +
            f.readline()  # quality
            lengths.append(len(seq))
    return lengths

import numpy as np

def make_histogram(lengths, output_path):
    #lengths_log = [np.log10(l / 1000) for l in lengths if l > 0]  # Avoid log(0)
    lengths_log = [np.log10(l) for l in lengths if l > 0]  # Avoid log(0)
    plt.figure(figsize=(10, 6))
    plt.hist(lengths_log, bins=100, color='darkorange', edgecolor='black')
    #plt.xlabel("log10(Read Length in kb)", fontsize=14)
    plt.xlabel("log10(Read Length)", fontsize=14)
    plt.ylabel("Read Count", fontsize=14)
    #plt.title("Log-Transformed Read Length Distribution", fontsize=16)
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout()
    plt.savefig(output_path, dpi=300)
    plt.close()

def main():
    parser = argparse.ArgumentParser(description="Plot read length histogram from a .fastq.gz Nanopore file")
    parser.add_argument("fastq", help="Input .fastq.gz file")
    args = parser.parse_args()

    input_path = args.fastq
    if not input_path.endswith(".fastq.gz"):
        raise ValueError("Input file must end with .fastq.gz")

    output_path = input_path.replace(".fastq.gz", "_read_length_plot.png")

    print(f"Reading: {input_path}")
    lengths = parse_fastq_lengths(input_path)
    print(f"Found {len(lengths)} reads")

    print(f"Generating plot: {output_path}")
    make_histogram(lengths, output_path)
    print("Done!")

if __name__ == "__main__":
    main()

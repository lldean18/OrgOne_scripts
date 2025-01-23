import sys
import os

if len(sys.argv) != 2:
    print("Usage: python script.py <fasta_file>")
    sys.exit(1)

fasta_file = sys.argv[1]

# Validate the input file
if not os.path.isfile(fasta_file):
    print(f"Error: File '{fasta_file}' not found.")
    sys.exit(1)

# Generate the output file name
output_file = os.path.splitext(fasta_file)[0] + "_seq_lengths.txt"

header = None
length = 0

try:
    with open(fasta_file, 'r') as fasta, open(output_file, 'w') as output:
        for line in fasta:
            # Trim newline
            line = line.rstrip()
            if line.startswith('>'):
                # If we captured one before, write it to the output file
                if header is not None:
                    output.write(f"{header}\t{length}\n")
                    length = 0
                header = line[1:]
            else:
                length += len(line)
        # Don't forget the last one
        if length:
            output.write(f"{header}\t{length}\n")

    print(f"Output written to {output_file}")

except Exception as e:
    print(f"An error occurred: {e}")
    sys.exit(1)



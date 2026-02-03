#!/bin/bash
# Laura Dean
# 3/2/26

# notes on blasting assembly against symbionts
# run on my Mac


#conda create --name blast bioconda::blast
conda activate blast

# make the database
makeblastdb \
-in all_symbionts.fasta \
 -dbtype nucl \
-out symbiontsdb

# blast the asm against the database
e=1e-5
e=1e-50
blastn \
  -query hifiasm_asm4/ONTasm.bp.p_ctg.fasta \
  -db symbiontsdb \
  -out hifiasm_asm4/assembly_vs_symbionts_$e.blast \
  -outfmt 6 \
  -evalue $e \
  -num_threads 8

conda deactivate

# convert the output to csv format for reading into bandage
sed 's/\t/,/g' hifiasm_asm4/assembly_vs_symbionts_$e.blast  > hifiasm_asm4/assembly_vs_symbionts_$e.csv

# keep only the best hit per contig
sort -k1,1 -k12,12nr hifiasm_asm4/assembly_vs_symbionts_$e.blast |
 awk '!seen[$1]++' > hifiasm_asm4/assembly_vs_symbionts_$e.best.blast
sed 's/\t/,/g' hifiasm_asm4/assembly_vs_symbionts_$e.best.blast  > hifiasm_asm4/assembly_vs_symbionts_$e.best.csv

# cut the first and second columns only from the CSV and then add a column for colour
cut -f1,2 -d "," hifiasm_asm4/assembly_vs_symbionts_$e.best.csv > hifiasm_asm4/assembly_vs_symbionts_$e.best_formatted.csv


##  # build an accession to species table
##  awk '
##    /^>/ {
##      acc=$1; sub(/^>/,"",acc);
##      species=$2"_"$3;
##      print acc "," species
##    }
##  ' all_symbionts.fasta > acc_to_species.csv

# convert accessions to species
awk -F',' '
  BEGIN { OFS="," }
  NR==FNR { map[$1]=$2; next }
  {
    if ($2 in map)
      $2 = map[$2];
    else
      $2 = "Unknown";
    print
  }
' acc_to_species.csv hifiasm_asm4/assembly_vs_symbionts_$e.best_formatted.csv \
> hifiasm_asm4/assembly_vs_symbionts_$e.best_formatted_spp.csv

# create colour column

conda activate lectures
ptpython
import pandas as pd
import hashlib
# Load your CSV
e = "1e-50"
df = pd.read_csv(f"hifiasm_asm4/assembly_vs_symbionts_{e}.best_formatted_spp.csv")
# Function to convert a string to a hex color
def text_to_hex(text):
    # Hash the text to get a consistent value
    hash_object = hashlib.md5(text.encode())
    hash_hex = hash_object.hexdigest()
    # Use first 6 characters for RGB hex
    color_hex = "#" + hash_hex[:6]
    return color_hex
# Create the new column based on the 2nd column (index 1)
df['Color'] = df.iloc[:, 1].apply(text_to_hex)
# Save to a new CSV
df.to_csv(f"hifiasm_asm4/assembly_vs_symbionts_{e}.best_formatted_spp_col.csv", index=False)


# then just add a header column to the top
# Contig,Species,Colour



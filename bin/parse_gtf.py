#!/usr/bin/env python

# argparse is a library that allows you to make user-friendly command line interfaces
import argparse

# here we are initializing the argparse object that we will modify
parser = argparse.ArgumentParser()

# we are asking argparse to require a -i or --input flag on the command line when this
# script is invoked. It will store it in the "filenames" attribute of the object
# we will be passing it via snakemake, a list of all the outputs of verse so we can
# concatenate them into a single matrix using pandas 

parser.add_argument("-i", "--input", help='a GFF file', dest="input", required=True)
parser.add_argument("-o", "--output", help='Output file with region', dest="output", required=True)

# this method will run the parser and input the data into the namespace object
args = parser.parse_args()
#parse_gtf(args.input, args.output)

# you can access the values on the command line by using `args.input` or 'args.output`

def parse_attributes(attr_str):
    """
    Extract gene_id and gene_name from the GTF attribute field.
    Example of attribute string:
    gene_id "ENSG00000121410"; gene_name "A1BG"; gene_biotype "protein_coding";
    """
    attrs = {}
    for item in attr_str.strip().split(';'):
        if item.strip():
            key, value = item.strip().split(' ', 1)
            attrs[key] = value.strip('"')
    return attrs


def parse_gtf(infile, outfile):
    """Read GTF and write out a delimited file of gene_id and gene_name."""
    seen = set()
    with open(infile, 'r') as fin, open(outfile, 'w') as fout:
        fout.write("gene_id\tgene_name\n")
        for line in fin:
            if line.startswith("#"):
                continue
            fields = line.strip().split('\t')
            if len(fields) < 9:
                continue
            feature_type = fields[2]
            if feature_type != "gene":
                continue
            attributes = parse_attributes(fields[8])
            gene_id = attributes.get("gene_id")
            gene_name = attributes.get("gene_name", "NA")
            if gene_id and gene_id not in seen:
                fout.write(f"{gene_id}\t{gene_name}\n")
                seen.add(gene_id)
                
parse_gtf(args.input, args.output)
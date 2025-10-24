#!/usr/bin/env nextflow

process MERGE_VERSE {
    label 'process_high'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir "${params.outdir}/merged_counts", mode: 'copy'

    input:
    path(exon)

    output:
    path "merged_counts.csv"

    script:
    """
    concat.py -i $exon -o merged_counts.csv
    """
}
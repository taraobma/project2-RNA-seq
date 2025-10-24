#!/usr/bin/env nextflow

process PARSE_GTF {
    label 'process_low'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode: "copy"
    

    input:
    path gtf

    output:
    path("gtf.txt")

    script: 
    """
    parse_gtf.py -i $gtf -o gtf.txt
    """


}
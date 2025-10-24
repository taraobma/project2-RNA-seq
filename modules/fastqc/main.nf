#!/usr/bin/bash nextflow

process FASTQC {

    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(sample), path(fastq)
    
    output:
    tuple val(sample), path('*.zip'), emit: zip
    tuple val(sample), path("*.html"), emit: html

    script:
    """
    fastqc $fastq -t $task.cpus
    """

}
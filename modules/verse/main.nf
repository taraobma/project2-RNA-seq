#!/usr/bin/env nextflow

process VERSE {
    label 'process_high'
    container 'ghcr.io/bf528/verse:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample), path(bam)
    path gtf

    output:
    tuple val(sample), path("*.exon.txt"), emit: exon

    script:
    """

    verse -S -a $gtf -o $sample $bam
    
    """
}

//tuple val(sample), path("*.Aligned.out.bam")
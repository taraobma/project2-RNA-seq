#!/usr/bin/env nextflow

process STAR_INDEX {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest'
    publishDir "${params.outdir}/STAR_index", mode:'copy'

    input:
    path genome
    path gtf

    output:
    path "STAR_index", emit: star_index 

    script:
    """

    mkdir STAR_index
    STAR --runThreadN $task.cpus \\
        --runMode genomeGenerate \\
        --genomeDir STAR_index \\
        --genomeFastaFiles $genome \\
        --sjdbGTFfile $gtf
    
    """
}


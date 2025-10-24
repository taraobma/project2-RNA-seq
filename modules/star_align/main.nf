#!/usr/bin/env nextflow

process STAR_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest'
    publishDir "${params.outdir}/STAR_align", mode:'copy'

    input:
    path genome_dir
    tuple val(sample), path(reads)

    output:
    tuple val(sample), path("${sample}.Aligned.out.bam"), emit: bam
    path "${sample}.Log.final.out", emit: log

    script:
    """
    STAR --runThreadN $task.cpus --genomeDir $genome_dir --readFilesIn $reads --readFilesCommand zcat --outFileNamePrefix ${sample}. --outSAMtype BAM Unsorted 2> ${sample}.Log.final.out
    """
}
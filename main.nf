#!/usr/bin/env nextflow

include {FASTQC} from './modules/fastqc'
include {PARSE_GTF} from './modules/parse_gtf'
include {STAR_INDEX} from './modules/star_index'   
include {STAR_ALIGN} from './modules/star_align' 
include {MULTIQC} from './modules/multiqc'
include {VERSE} from './modules/verse'
include {MERGE_VERSE} from './modules/merge_verse'

workflow {

    // Create a channel with the input files
    // channel has 2 reads of 3 control samples and 3 exp samples; total of 12 
    Channel.fromFilePairs(params.full_dir).set { align_ch }

    // fastqc channel
    Channel.fromFilePairs(params.full_dir).transpose().set { fastqc_ch }

    // Run FASTQC process
    FASTQC(fastqc_ch)


    // run chmod +x bin/parse_gtf.py first to make the extract_region.py in the bin executable
    PARSE_GTF(params.gtf)

    //star index
    STAR_INDEX(params.genome, params.gtf)

    // star align
    STAR_ALIGN(STAR_INDEX.out, align_ch)

    // view the output of star align by assign star_align workflow from above to align and then run the code below
    // STAR_ALIGN(genome_ch, align_ch).bam_file.view()
    // STAR_ALIGN(genome_ch, align_ch).log_file.view()


    // //preparing for multiqc
    multiqc_ch = FASTQC.out.zip
                .map { sample, zip -> zip }
                .mix(STAR_ALIGN.out.log)
                .collect()
    
    // multiqc
    MULTIQC(multiqc_ch)


    // verse
    VERSE(STAR_ALIGN.out.bam, params.gtf)
    
    //view output of verse
    // VERSE.out.exon.view()

    //run chmod +x bin/verse_count.py to execute the script prior to the up coming workflow
    // need to use .collect to make sure that merge verse will only starts when verse is done 
    // collect gathers all the emitted items into a single list after all upstream process have completed
    
    // MERGE_VERSE(VERSE.out.exon.collect())

    exon_file_ch = VERSE.out.exon.map {it[1]}.collect()
    
    MERGE_VERSE(exon_file_ch)

    // view the output of merge_verse 
    // MERGE_VERSE.out.view()


}

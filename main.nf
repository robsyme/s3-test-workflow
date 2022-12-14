#!/usr/bin/env nextflow 

process Passthrough {
    memory '1G'
    cpus 1 

    input:
    path(inbam)

    output:
    path('out.bam')

    script:
    "cp $inbam out.bam"
}

process UseFile {
    memory '1G'
    cpus 1

    input:
    tuple path(bam), val(i)

    output:
    path("*.sam")

    script:
    "samtools view $bam | head > out.${i}.sam"
}


workflow {
    ints = Channel.of(1..params.procs)

    Channel.fromPath(params.infile)
    | Passthrough
    | combine(ints)
    | UseFile
}
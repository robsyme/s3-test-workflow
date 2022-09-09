params.procs = 10
params.infile = "ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/NA12878/NA12878_PacBio_MtSinai/merged_ec_output_primary.bam"

process Passthrough {
    memory 1G
    cpus 1 

    input:
    path(bam)

    output:
    path(bam)

    "echo does nothing"
}

process UseFile {
    memory 1G
    cpus 1
    
    input:
    tuple val(i), path(bam)

    "du -sh $bam"
}


workflow {
    ints = Channel.of(1..params.procs)

    Channel.fromPath(params.infile)
    | Passthrough
    | combine(ints)
    | view
}
workflow multiFastqc {
    Array[File]+ fq_gzs
    String fastqc_out_dir
    String multiqc_out_dir
    Int cpus

    scatter (fq_gz in fq_gzs) {
        call run_fastqc { input: fq_gz = fq_gz, out_dir = fastqc_out_dir, cpus = cpus }
    }

    call run_multiqc { input: in_dir = fastqc_out_dir, out_dir = multiqc_out_dir, wait_fastqc_end_flag = run_fastqc.report_out_dir }
}

task run_fastqc {
    File fq_gz
    String out_dir
    Int cpus

    command {
        mkdir -p ${out_dir}
        $(which fastqc) --threads ${cpus} --outdir ${out_dir} ${fq_gz}
    }

    output {
        String report_out_dir = "${out_dir}"
    }
}

task run_multiqc {
    String in_dir
    String out_dir
    Array[String] wait_fastqc_end_flag

    command {
        mkdir -p ${out_dir}
        $(which multiqc) -o ${out_dir} ${in_dir}
    }
}

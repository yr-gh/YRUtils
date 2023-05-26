#!/bin/bash -e

fastqc_dir=$(find $1 -name call-run_fastqc)
multiqc_dir=$(find $1 -name call-run_multiqc)

[ ! ${fastqc_dir} ] && echo "No valid fastqc directory found!" && exit 1
[ ! ${multiqc_dir} ] && echo "No valid multiqc directory found!" && exit 1

echo "Find fastqc directory: ${fastqc_dir}"
echo "Find multiqc directory: ${multiqc_dir}"
echo "The results will be saved in run_fastqc.log"

for shard in `ls ${fastqc_dir} | grep "shard-"`
do
	cat ${fastqc_dir}/${shard}/execution/stderr ${fastqc_dir}/${shard}/execution/stdout >> run_fastqc.log
	echo "" >> run_fastqc.log
done

cat ${multiqc_dir}/execution/stderr ${multiqc_dir}/execution/stdout >> run_fastqc.log


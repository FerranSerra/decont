working_dir="/home/vant/MásterBioinformática/LinuxAvanzado/PrácticaFinal/decont"

# run STAR for all trimmed files
for fname in "${working_dir}/out/trimmed/"*.fastq.gz
do
    # you will need to obtain the sample ID from the filename
    sid=$(basename "$fname" .trimmed.fastq.gz)
    mkdir -p out/star/$sid
    STAR --runThreadN 4 --genomeDir res/contaminants_idx \
         --outReadsUnmapped Fastx --readFilesIn "$fname" \
         --readFilesCommand gunzip -c --outFileNamePrefix "${working_dir}/out/star/${sid}/"
done 

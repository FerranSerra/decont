# Ruta al archivo que contiene las URLs de los archivos a descargar
filename_file="/home/vant/MásterBioinformática/LinuxAvanzado/PrácticaFinal/decont/data/urls"

# Verifica si el archivo de nombres de archivo existe
if [ ! -f "$filename_file" ]; then
    echo "El archivo $filename_file no existe."
    exit 1
fi

#Download all the files specified in data/urls
for url in $(cat "$filename_file") 
do
    bash scripts/download.sh $url data
done


# Download the contaminants fasta file, uncompress it, and
# filter to remove all small nuclear RNAs
bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz res yes "small nuclear" 

# Index the contaminants file
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx

# Merge the samples into a single file
## Ruta al archivo que contiene las samples
path="/home/vant/MásterBioinformática/LinuxAvanzado/PrácticaFinal/decont/data"
for sid in $(ls $path/*.fastq.gz | cut -d'-' -f1 | awk -F"data/" '{print $2}' | sort | uniq)
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done

# TODO: run cutadapt for all merged files
# cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
#     -o <trimmed_file> <input_file> > <log_file>

# TODO: run STAR for all trimmed files
for fname in out/trimmed/*.fastq.gz
do
    # you will need to obtain the sample ID from the filename
    sid=#TODO
    # mkdir -p out/star/$sid
    # STAR --runThreadN 4 --genomeDir res/contaminants_idx \
    #    --outReadsUnmapped Fastx --readFilesIn <input_file> \
    #    --readFilesCommand gunzip -c --outFileNamePrefix <output_directory>
done 

# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in

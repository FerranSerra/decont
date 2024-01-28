# Merge the samples into a single file
## Ruta al archivo que contiene las samples
path="/home/vant/MásterBioinformática/LinuxAvanzado/PrácticaFinal/decont/data"
for sid in $(ls $path/*.fastq.gz | cut -d'-' -f1 | awk -F"data/" '{print $2}' | sort | uniq)
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done

working_dir="home/vant/MásterBioinformática/LinuxAvanzado/PrácticaFinal/decont"

# run cutadapt for all merged files
echo "Running cutadapt for merged files"
##Make directories for trimmed and log files
mkdir -p "${working_dir}/out/trimmed"
mkdir -p "${working_dir}/log/cutadapt"
for file in "${working_dir}/out/merged/"*.fastq.gz; do
    #Extraer el nombre del archivo 
    base_name=$(basename "$file" .fastq.gz)
    
    #Definir el trimmed y el log
    trimmed_file="${working_dir}/out/trimmed/${base_name}.trimmed.fastq.gz"
    log_file="${working_dir}/log/cutadapt/${base_name}.log"
    
    #Ejecutar cutadapt y redirigir la salida al archivo de log
    cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
     -o "$trimmed_file" "$file" > "$log_file"
done

echo "Cutadapt ended"
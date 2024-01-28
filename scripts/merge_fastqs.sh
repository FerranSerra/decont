# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).


# Verifica si se proporcionaron los argumentos necesarios
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 INPUT_DIR OUTPUT_DIR SAMPLE_ID"
    exit 1
fi

input_dir=$1
output_dir=$2
sample_id=$3

# Verifica y crea el directorio de salida si no existe
mkdir -p "$output_dir"

# Combina todos los archivos fastq.gz para un sample_id específico
cat "${input_dir}"/*"${sample_id}"*.fastq.gz > "${output_dir}/${sample_id}.fastq.gz"

echo "Archivos combinados en ${output_dir}/${sample_id}.fastq.gz"
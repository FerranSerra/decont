# Define los directorios que corresponden a cada argumento
working_dir="/home/vant/MásterBioinformática/LinuxAvanzado/PrácticaFinal/decont"

data_dir="${working_dir}/data"
resources_dir="${working_dir}/res"
output_dir="${working_dir}/out"
logs_dir="${working_dir}/log"

# Función para eliminar directorio si existe
remove_dir() {
    if [ -d "$1" ]; then
        echo "Eliminando $1..."
        rm -rf "$1"
    else
        echo "Directorio $1 no encontrado."
    fi
}

# Verifica si se pasaron argumentos
if [ "$#" -eq 0 ]; then
    # No se pasaron argumentos, eliminar todo
    remove_dir "$data_dir"
    remove_dir "$resources_dir"
    remove_dir "$output_dir"
    remove_dir "$logs_dir"
else
    # Procesar cada argumento
    for arg in "$@"; do
        case $arg in
            data)
                remove_dir "$data_dir"
                ;;
            resources)
                remove_dir "$resources_dir"
                ;;
            output)
                remove_dir "$output_dir"
                ;;
            logs)
                remove_dir "$logs_dir"
                ;;
            *)
                echo "Argumento no reconocido: $arg"
                ;;
        esac
    done
fi

# Define los directorios que corresponden a cada argumento
working_dir="/home/vant/MásterBioinformática/LinuxAvanzado/PrácticaFinal/decont"

data_dir="${working_dir}/data"
resources_dir="${working_dir}/res"
output_dir="${working_dir}/out"
logs_dir="${working_dir}/log"

# Función para eliminar archivos en un directorio, excluyendo un archivo específico
remove_files_except() {
    local dir=$1
    local exclude_file=$2

    if [ -d "$dir" ]; then
        echo "Eliminando archivos en $dir excepto $exclude_file..."

        # Encuentra y elimina todos los archivos en el directorio, excluyendo el archivo especificado
        find "$dir" -type f -not -name "$(basename "$exclude_file")" -exec rm -f {} +
    else
        echo "Directorio $dir no encontrado."
    fi
}

# Verifica si se pasaron argumentos
if [ "$#" -eq 0 ]; then
    # No se pasaron argumentos, eliminar archivos en todos los directorios excepto data/urls
    remove_files_except "$data_dir" "$data_dir/urls"
    remove_files_except "$resources_dir" ""
    remove_files_except "$output_dir" ""
    remove_files_except "$logs_dir" ""
else
    # Procesar cada argumento
    for arg in "$@"; do
        case $arg in
            data)
                remove_files_except "$data_dir" "$data_dir/urls"
                ;;
            resources)
                remove_files_except "$resources_dir" ""
                ;;
            output)
                remove_files_except "$output_dir" ""
                ;;
            logs)
                remove_files_except "$logs_dir" ""
                ;;
            *)
                echo "Argumento no reconocido: $arg"
                ;;
        esac
    done
fi
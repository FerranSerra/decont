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

working_dir="/home/vant/MásterBioinformática/LinuxAvanzado/PrácticaFinal/decont"

#Variable de control para la primera ejecución
first_run=true

#Procesa los logs de cutadapt
for fname in "${working_dir}/log/cutadapt/"*.log
do
    base_name=$(basename "$fname" .log)
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    #Añadir dos saltos de línea para el primer registro del log (primera ejecución de este for)
    if [ "$first_run" = true ]; then
        echo -e "\n\nCUTADAPT $base_name $timestamp\n" >> "${working_dir}/log/pipeline.log"
        first_run=false
    else 
        echo -e "\nCUTADAPT $base_name $timestamp\n" >> "${working_dir}/log/pipeline.log"
    fi
    
    grep "Reads with adapters:" "$fname" >> "${working_dir}/log/pipeline.log"
    grep "Total basepairs processed:" "$fname" >> "${working_dir}/log/pipeline.log"
    
done

#Procesa los logs de STAR
for fname in "${working_dir}/out/star/"*/
do
    base_name=$(basename "${fname%/}") #Elimina la barra final para que basename no devuelva cadena vacía
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\nSTAR $base_name $timestamp\n" >> "${working_dir}/log/pipeline.log"
    grep "Uniquely mapped reads %" "${fname}Log.final.out" >> "${working_dir}/log/pipeline.log"
    grep "% of reads mapped to multiple loci" "${fname}Log.final.out" >> "${working_dir}/log/pipeline.log"
    grep "% of reads mapped to too many loci" "${fname}Log.final.out" >> "${working_dir}/log/pipeline.log"
    
done

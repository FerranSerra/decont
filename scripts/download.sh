# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
# and *optionally*:
# - uncompress the downloaded file with gunzip if the third
#   argument ($3) contains the word "yes"
# - filter the sequences based on a word contained in their header lines:
#   sequences containing the specified word in their header should be **excluded**
#
# Example of the desired filtering:
#
#   > this is my sequence
#   CACTATGGGAGGACATTATAC
#   > this is my second sequence
#   CACTATGGGAGGGAGAGGAGA
#   > this is another sequence
#   CCAGGATTTACAGACTTTAAA
#
#   If $4 == "another" only the **first two sequence** should be output


# Verifica si se proporcionaron al menos dos argumentos
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 URL DESTINO [DESCOMPRESIÓN] [PALABRA_FILTRO]"
    exit 1
fi

URL=$1
NOMBRE_ARCHIVO=$(basename "$URL")
DESTINO="$2/$NOMBRE_ARCHIVO"
DECOMPRESION=${3:-no}  # Valor predeterminado es "no"
PALABRA_FILTRO=$4

# Verificar si el archivo ya existe
if [ -f "$DESTINO" ]; then
    echo "El archivo $NOMBRE_ARCHIVO ya existe. Omitiendo descarga."
else
    # Descargar el archivo y verificar MD5
    wget -O "$DESTINO" "$URL" && \
    MD5_HASH_URL=$(wget -qO- "${URL}.md5" | awk '{ print $1 }') && \
    MD5_HASH_ARCHIVO=$(md5sum "$DESTINO" | awk '{ print $1 }') && \
    
    #Comprobación de los hashes MD5 para depuración
    #echo "MD5 esperado: $MD5_HASH_URL"
    #echo "MD5 obtenido: $MD5_HASH_ARCHIVO"
    
    if [ "$MD5_HASH_URL" != "$MD5_HASH_ARCHIVO" ]; then
        echo "La verificación MD5 falló para $NOMBRE_ARCHIVO. Eliminando archivo."
        rm "$DESTINO"
        exit 1
    else
        echo "Archivo descargado y verificado correctamente: $NOMBRE_ARCHIVO"
    fi
fi

# Opcionalmente descomprime el archivo
if [ "$DECOMPRESION" == "yes" ] && [[ "$NOMBRE_ARCHIVO" == *.gz ]]; then
    # Descomprime el archivo y lo renombra (eliminando la extensión .gz)
    gunzip -c "$DESTINO" > "${DESTINO%.*}"
    if [ $? -eq 0 ]; then
        echo "Archivo descomprimido correctamente."
        # Actualiza la variable DESTINO para que apunte al archivo descomprimido
        DESTINO="${DESTINO%.*}"
    else
        echo "Error al descomprimir el archivo."
        exit 1
    fi
fi

# Filtra las secuencias basado en la palabra del encabezado
if [ -n "$PALABRA_FILTRO" ]; then
    awk -v palabra="$PALABRA_FILTRO" 'BEGIN{print_seq=1} /^>/{print_seq=($0 !~ palabra)} {if(print_seq) print}' "$DESTINO" > "${DESTINO}.filtrado"
    mv "${DESTINO}.filtrado" "$DESTINO"
fi


echo "Archivo procesado y guardado en $DESTINO"
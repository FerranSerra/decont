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


# Check if the number of arguments is less than 2
if [ $# -lt 2 ]; then
    echo "Usage: $0 <file_url> <output_directory>"
    exit 1
fi

file_url="$1"
output_directory="$2"
filename=$(basename "$file_url")
output_file="$output_directory/$filename"

# Check if the output file already exists
if [ -e "$output_file" ]; then
    echo "Output file '$output_file' already exists. Skipping the operation."
    exit 0
fi

# Download the file
wget -O "$output_file" "$file_url"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error downloading file from $file_url"
    exit 1
fi

# Calculate the MD5 checksum of the downloaded file
downloaded_md5=$(md5sum "$output_file" | awk '{print $1}')

# Append ".md5" to the file URL to get the URL of the MD5 checksum
md5_url="${file_url}.md5"

# Download the content of the .md5 file (without downloading the .md5 file itself)
md5_content=$(wget -qO- "$md5_url")

# Extract the expected MD5 checksum from the content
expected_md5=$(echo "$md5_content" | awk '{print $1}')

# Compare the calculated MD5 checksum with the expected one
if [ "$downloaded_md5" != "$expected_md5" ]; then
    echo "MD5 checksum mismatch for $output_file. Expected: $expected_md5, Calculated: $downloaded_md5"
    exit 1
else
    echo "MD5 checksum matched for $output_file"
fi

echo "Download and MD5 check completed successfully for $output_file"

 

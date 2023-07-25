#Install "conda install -c bioconda -c conda-forge barrnap"

#!/bin/bash
# Directory to store the combined output_fna files
combined_output_dir="combined_output"
mkdir -p "$combined_output_dir"


# Function to process .fasta files
process_fasta_file() {
    local fasta_file="$1"
    echo "$1"
    # Get the base filename (without the extension) of the input fasta file
    local base_filename="$(basename "$fasta_file" .fasta)"
    
    # Use the base filename to create the output .fna and .gff files
    local output_fna="$dir/${base_filename}_16s.fna"
    local output_gff="$dir/${base_filename}_16s.gff"
    
    # Process the fasta file using barrnap and save results in the specified output files
    barrnap -k bac --threads 16 -o "$output_fna" < "$fasta_file" > "$output_gff" 2> /dev/null
    # Replace the existing ">" line in the .fna file with ">base_filename"
    sed -i "1s/^>.*/>${base_filename}/" "$output_fna"
    # Append the content of the output_fna file to the combined output_fna file
    cat "$output_fna" >> "$combined_output_dir/combined_output.fna"
    cat "$output_gff" >> "$combined_output_dir/combined_output.gff"
}

# Function to traverse subdirectories recursively
traverse_subdirs() {
    local dir="$1"
    local file_ext=".fasta"

    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            # If the item is a directory, recursively call the function
            traverse_subdirs "$file"
        elif [ "${file##*.}" = "fasta" ]; then
            # If the item is a .fasta file, process it
            process_fasta_file "$file"
        fi
    done
}

# Main function to start traversal from the current directory
main() {
    echo "Searching for .fasta files in subdirectories..."
    traverse_subdirs "$(pwd)"
    echo "Done."
}

main

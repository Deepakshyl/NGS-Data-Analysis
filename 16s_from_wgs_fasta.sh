#!/bin/bash
#Install "conda install -c bioconda -c conda-forge barrnap"
# Function to process .fasta files
process_fasta_file() {
    local fasta_file="$1"
    echo "$1"
        # Add your processing logic here
    # For example, you could print the content of the file
    #barrnap -k bac --threads "$(nproc)" -o output_rrna.fna < input_file.fna > output_rrna.gff 2> /dev/null
    
    barrnap -k bac --threads 16 -o "$dir"/16s.fna < "$fasta_file" > "$dir"/16s.gff 2> /dev/null
    #cat "$fasta_file"
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


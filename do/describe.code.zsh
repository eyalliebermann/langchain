#!/bin/zsh

# Configuration variables
OUTPUT_FILE="tmp.code.description.txt"
DIR_TO_DESCRIBE="."
FILES_OF_INTEREST_REGEX='\.(zsh|js|html|css|yaml)$|package\.json$|webpack\.config\.js$|babel\.config\.json$|manifest\.xml$'


echo "Outlining development files in $DIR_TO_DESCRIBE..."

# Clear the output file content before writing
echo "clearing output file..."
rm "$OUTPUT_FILE"

# Function to traverse the directory
traverse() {
    echo "Traversing directory: $1"
    for file in "$1"/*; do
        if [ -d "$file" ]; then
            echo "Found directory: $file"
            if [[ $(basename "$file") != "node_modules" ]]; then  # Skip node_modules directory
                traverse "$file"
            else
                echo "Skipping directory $file"
            fi
        else
                if [[ "$file" =~ $FILES_OF_INTEREST_REGEX ]]; then
                    echo "Echoing file name: $file"
                    echo "File: $file" >> "$OUTPUT_FILE"
                    # Append the file contents to the output file
                    echo "\nContents of $file:" >> "$OUTPUT_FILE"
                    cat "$file" >> "$OUTPUT_FILE"
                    echo "\n---\n" >> "$OUTPUT_FILE"
                else
                    echo "Skipping file: $file"
                fi
        fi
    done
}

# Start traversing from the add-in directory
echo "Starting directory traversal..."
traverse "./$DIR_TO_DESCRIBE"
echo "Directory traversal completed. Output available in $OUTPUT_FILE"

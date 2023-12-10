#!/bin/bash

# Input file with municipality information
INPUT_FILE="updated-info.txt"

# Output HTML file
OUTPUT_FILE="paragraphlist.html"

# Start HTML file with exam code
echo "<html><body>" > "$OUTPUT_FILE"
echo "<h3>Exam code: 10012</h3>" >> "$OUTPUT_FILE"

# Loop through each municipality in the input file
while IFS= read -r line; do
    # Check if the line is not empty
    if [[ -n "$line" ]]; then
        # Output paragraph for the municipality
        echo "<p>" >> "$OUTPUT_FILE"
        echo "$line" >> "$OUTPUT_FILE"
        echo "</p>" >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"

# End HTML file
echo "</body></html>" >> "$OUTPUT_FILE"

echo "HTML page generated. Check the file $OUTPUT_FILE."


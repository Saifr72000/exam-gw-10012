#!/bin/bash

# URL of the Wikipedia page
URL="https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway"

# Output file
OUTPUT_FILE="tables.txt"

# Fetch the HTML content
curl -s "$URL" > page.html

# Use xmllint to format and extract <table> tags
xmllint --html --xpath '//table' page.html > "$OUTPUT_FILE" 2>/dev/null

echo "Extraction completed. Check the file $OUTPUT_FILE."

# Clean up
rm page.html

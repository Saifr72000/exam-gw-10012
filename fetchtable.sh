#!/bin/bash

# URL of the Wikipedia page
URL="https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway"

# Output files
HTML_FILE="table.html"

# Fetch the HTML content
curl -s "$URL" > page.html

# Use xmllint to format and extract <table> tags for the first output file
xmllint --html --xpath '//table' page.html > "$HTML_FILE" 2>/dev/null

# Clean up
rm page.html

echo "Extraction completed. Check the files: $TABLE_OUTPUT, $ANOTHER_OUTPUT."




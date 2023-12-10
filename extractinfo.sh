#!/bin/bash

# Input file with extracted tables
INPUT_FILE="tables.txt"

# Output file for specific columns
OUTPUT_FILE="municipalities_data.txt"

# Process the file
awk -v RS="</tr>" -v FS="</td>" '
BEGIN { print "Municipality, URL, Population" }
$0 ~ /<td><a href="\/wiki\/[^"]+"/ {
    # Extract the municipality name
    name = $2;
    gsub(/<[^>]*>/, "", name); # Remove HTML tags

    # Extract the URL
    url = $2;
    match(url, /href="([^"]+)"/);
    url = "https://en.wikipedia.org" substr(url, RSTART+6, 
RLENGTH-7);

    # Extract the population
    population = $5;
    gsub(/<[^>]*>/, "", population); # Remove HTML tags
    if(name != "" && url != "" && population != "")
        print name, url, population;
}' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Extraction completed. Check the file $OUTPUT_FILE."

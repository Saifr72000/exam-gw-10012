#!/bin/bash

# Input file with extracted municipalities data
INPUT_FILE="municipalities_data.txt"

# Output file for coordinates
OUTPUT_FILE="updated-info.txt"

# This declares an associative array to keep track of the  processed URLs
declare -A processed_urls

# Function to convert DMS coordinates to decimal coordinates
convert_dms_to_decimal() {
    local dms=$1
    local sign

    # Determine sign (N/S or E/W)
    if [[ $dms == *S* || $dms == *W* ]]; then
        sign="-"
    else
        sign=""
    fi

    # Remove non-numeric characters
    dms=$(echo "$dms" | tr -cd '0-9.-')

    # Convert DMS to decimal
    echo "$sign$dms" | bc
}

# Loop through each URL
while IFS= read -r url; do
    # Extract municipality name, URL, and population
    data=$(awk -v url="$url" -F'\n' -v RS="" '$0~url{gsub("\n"," "); print $0}' "$INPUT_FILE")

    # Extract municipality name (first string)
    municipality=$(echo "$data" | awk '{print $1}')

    # Check if the URL is already processed
    if [[ -n "${processed_urls[$url]}" ]]; then
        continue
    fi

    # Mark the URL as processed
    processed_urls["$url"]=1

    # Extract population (last string)
    population=$(echo "$data" | awk '{print $NF}')

    # Fetch the HTML content of the URL
    html_content=$(curl -s "$url")

    # Extract latitude and longitude values within <span> tags
    latitude_dms=$(echo "$html_content" | grep -oP '<span class="latitude">([^<]+)</span>' | sed 
's/[^0-9.]//g')
    longitude_dms=$(echo "$html_content" | grep -oP '<span class="longitude">([^<]+)</span>' | sed 
's/[^0-9.]//g')

    # Convert DMS coordinates to decimal coordinates
    latitude_decimal=$(convert_dms_to_decimal "$latitude_dms")
    longitude_decimal=$(convert_dms_to_decimal "$longitude_dms")

    # Output the information to the updated file
    echo "Name: $municipality" >> "$OUTPUT_FILE"
    echo "Coordinates: Latitude: $latitude_decimal, Longitude: $longitude_decimal" >> 
"$OUTPUT_FILE"
    echo "Population: $population" >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"  # Add an empty line between entries
done < <(grep -o 'https://[^ ]*' "$INPUT_FILE")

echo "Coordinates extraction completed. Check the file $OUTPUT_FILE."

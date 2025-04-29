#!/bin/bash

# Output file
output_file="metadata_output_dict.json"
echo "{" > "$output_file"

# First run flag to handle comma separation
first_run=true

# Iterate over each directory in fastlane/metadata
for localization_dir in fastlane/metadata/*/; do
    # Check if name.txt, subtitle.txt, and keywords.txt exist
    if [[ -f "$localization_dir/name.txt" && -f "$localization_dir/subtitle.txt" && -f "$localization_dir/keywords.txt" ]]; then
        # Remove trailing slash to get the localization name
        localization_name=$(basename "$localization_dir")

        # Read the metadata files, escaping double quotes
        name=$(sed 's/"/\\"/g' "$localization_dir/name.txt")
        subtitle=$(sed 's/"/\\"/g' "$localization_dir/subtitle.txt")
        keywords=$(sed 's/"/\\"/g' "$localization_dir/keywords.txt")

        # Add comma before each entry except the first
        if [ "$first_run" = true ]; then
            first_run=false
        else
            echo "," >> "$output_file"
        fi

        # Append JSON entry
        echo "  \"$localization_name\": {" >> "$output_file"
        echo "    \"title\": \"$name\"," >> "$output_file"
        echo "    \"subtitle\": \"$subtitle\"," >> "$output_file"
        echo "    \"keywords\": \"$keywords\"" >> "$output_file"
        echo "  }" >> "$output_file"
    fi
done

# Close the JSON object
echo "}" >> "$output_file"

echo "Metadata output written to $output_file"
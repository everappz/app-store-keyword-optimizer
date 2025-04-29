#!/bin/bash

# Input JSON file
input_file="metadata_output_dict.json"

# Loop through each localization key in the top-level object
jq -r 'keys[]' "$input_file" | while read -r localization_name; do
  # Extract values using the localization key
  name=$(jq -r --arg loc "$localization_name" '.[$loc].title' "$input_file")
  subtitle=$(jq -r --arg loc "$localization_name" '.[$loc].subtitle' "$input_file")
  keywords=$(jq -r --arg loc "$localization_name" '.[$loc].keywords' "$input_file")

  # Set the localization directory
  localization_dir="fastlane/metadata/$localization_name/"

  # Ensure localization directory exists
  if [ ! -d "$localization_dir" ]; then
    echo "Directory $localization_dir does not exist. Skipping..."
    continue
  fi

  # Write values to the respective files
  echo "$name" > "${localization_dir}name.txt"
  echo "$subtitle" > "${localization_dir}subtitle.txt"
  echo "$keywords" > "${localization_dir}keywords.txt"

  echo "Updated metadata for $localization_name"
done

echo "Localization files updated."
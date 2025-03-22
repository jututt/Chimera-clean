#!/data/data/com.termux/files/usr/bin/bash

# Define the target directory
TARGET_DIR="/data/user_de/0/com.google.android.gms/app_chimera/m"  # Target directory

# Declare associative arrays to track the latest file paths and duplicates
declare -A file_map
declare -A duplicates

# Display initial disk usage
initial_size=$(du -hs "$TARGET_DIR" | awk '{print $1}')
echo "Initial disk usage: $initial_size"

# Collect all .apk files in the target directory
mapfile -t files < <(find "$TARGET_DIR" -type f -name "*.apk" -print0 | xargs -0 ls -t)

# Process the files to group duplicates by base name
for filepath in "${files[@]}"; do
    base=$(basename "$filepath" | sed -E 's/(_[0-9]+)?\.apk$//')

    if [[ -n "${file_map[$base]}" ]]; then
        duplicates[$base]="${duplicates[$base]} $filepath"
    else
        file_map[$base]="$filepath"
    fi
done

# Sort base names alphabetically
sorted_basenames=($(printf "%s\n" "${!file_map[@]}" | sort))

# Process duplicates and latest files for each base name
for base in "${sorted_basenames[@]}"; do
    latest_file="${file_map[$base]}"
    latest_dir=$(basename "$(dirname "$latest_file")")  # Immediate parent directory

    # Display the latest file
    echo
    echo "Latest: $latest_dir/$(basename "$latest_file")"

    # Check if there are duplicates
    if [[ -z "${duplicates[$base]}" ]]; then
        echo "No duplicates found"
    else
        # Prompt for manual confirmation to delete duplicates
        for duplicate_file in ${duplicates[$base]}; do
            duplicate_dir=$(basename "$(dirname "$duplicate_file")")  # Immediate parent directory of the duplicate
            echo -n "Delete all files in: $duplicate_dir/$(basename "$duplicate_file") [y/n]: "
            read -r confirm
            if [[ -z "$confirm" || "$confirm" == "y" ]]; then
                # Delete all files in the duplicate subdirectory
                rm -rf "$(dirname "$duplicate_file")"/*
                # Clean up the directory if it's empty
                find "$(dirname "$duplicate_file")" -type d -empty -delete
            elif [[ "$confirm" == "n" ]]; then
                # Skip deletion
                echo "Skipped: $duplicate_dir/$(basename "$duplicate_file")"
            else
                # Handle invalid input
                echo "Invalid input. Skipped: $duplicate_dir/$(basename "$duplicate_file")"
            fi
        done
    fi
done

# Display final disk usage
final_size=$(du -hs "$TARGET_DIR" | awk '{print $1}')
echo "Final disk usage: $final_size"

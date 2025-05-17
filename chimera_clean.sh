#!/data/data/com.termux/files/usr/bin/bash

# Define the target directory
TARGET_DIR="/data/user_de/0/com.google.android.gms/app_chimera/m"  # Target directory

# Declare associative arrays to track the latest file paths and duplicates
declare -A file_map
declare -A duplicates

# Collect all .apk files in the target directory
mapfile -t files < <(find "$TARGET_DIR" -type f -name "*.apk" -print0 | xargs -0 ls -t)

# Process the files to group duplicates by base name
for filepath in "${files[@]}"; do
    # Extract base name from file (without _version numbers or extensions)
    base=$(basename "$filepath" | sed -E 's/(_[0-9]+)?\.apk$//')

    if [[ -n "${file_map[$base]}" ]]; then
        # Already encountered this base name, add to duplicates
        duplicates[$base]="${duplicates[$base]} $filepath"
    else
        # First occurrence of this base name, mark it as the latest
        file_map[$base]="$filepath"
    fi
done

# Sort base names alphabetically
sorted_basenames=($(printf "%s\n" "${!file_map[@]}" | sort))

# Process duplicates and latest files for each base name in sorted order
for base in "${sorted_basenames[@]}"; do
    latest_file="${file_map[$base]}"
    latest_dir=$(basename "$(dirname "$latest_file")")

    # Add a blank line before "Latest" for better readability
    echo
    echo "Latest: $latest_dir/$(basename "$latest_file")"

    # Check if there are duplicates and delete them automatically
    if [[ -n "${duplicates[$base]}" ]]; then
        for duplicate_file in ${duplicates[$base]}; do
            duplicate_dir=$(basename "$(dirname "$duplicate_file")")
            rm "$duplicate_file"
            echo "Deleted: $duplicate_dir/$(basename "$duplicate_file")"
        done
    else
        echo "No duplicates found"
    fi
done

# **Find and delete empty directories**
echo
echo "Checking for empty directories..."
find "$TARGET_DIR" -type d -empty -print -delete
echo "Empty directories removed."


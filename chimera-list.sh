#!/system_ext/bin/bash

TARGET_DIR="/data/user_de/0/com.google.android.gms/app_chimera/m"  # Target directory
TEMP_FILE="/data/local/tmp/file_map_debug.txt"  # Temporary file to store intermediate results

# Clear the temp file at the start
> "$TEMP_FILE"

# Find only .apk files in the target directory and process them silently
find "$TARGET_DIR" -type f -name "*.apk" | while IFS= read -r file; do
  # Extract the base name (before '_')
  base=$(basename "${file%_*}")

  # Get the relative path from the target directory
  relative_path="${file#$TARGET_DIR/}"

  # Try to fetch modification date (only date, no time)
  mod_date=$(stat -c '%y' "$file" 2>/dev/null | cut -d' ' -f1)
  if [ -z "$mod_date" ]; then
    mod_date="Unknown"  # Fallback if stat fails
  fi

  # Fetch file size in bytes and convert to human-readable
  file_size=$(stat -c '%s' "$file" 2>/dev/null)
  if [ -z "$file_size" ]; then
    file_size="Unknown"  # Fallback if stat fails
  else
    file_size=$(numfmt --to=iec --format="%.1f" "$file_size")  # Convert size to human-readable
  fi

  # Write to the temp file: base|relative_path|mod_date|file_size
  echo "$base|$relative_path|$mod_date|$file_size" >> "$TEMP_FILE"
done

# Process the temp file to group and sort results
if [ ! -s "$TEMP_FILE" ]; then
  echo "No .apk files found or processed. Exiting."
  exit 0
fi

# Sort the temp file by base name and modification date (most recent first)
sorted_file="/data/local/tmp/sorted_file_map.txt"
sort -t'|' -k1,1 -k3,3r "$TEMP_FILE" > "$sorted_file"  # Sort by base (1st column) and date (3rd column, reverse order)

# Output sorted results
last_base=""
while IFS='|' read -r base relative_path mod_date file_size; do
  if [ "$base" != "$last_base" ]; then
    # Start a new group for a new base name (most recent becomes original)
    if [ -n "$last_base" ]; then
      echo  # Add a blank line between groups
    fi
    echo "$relative_path $mod_date $file_size"
    last_base="$base"
  else
    # Apply truncation for filenames longer than 55 characters
    if [[ "${#relative_path}" -gt 55 ]]; then
      # Truncate: Keep the first part of the name, append ellipsis, and keep the ending characters
      prefix="${relative_path:0:$((55 - 10))}"  # Keep enough characters to fit within the limit
      suffix="${relative_path: -10}"           # Keep the last 10 characters
      shortened_path="${prefix}…${suffix}"
    else
      shortened_path="$relative_path"
    fi
    echo "  $shortened_path $mod_date"
  fi
done < "$sorted_file"

# Clean up
rm "$TEMP_FILE" "$sorted_file"

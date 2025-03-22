# Chimera-clean
Cleans /data/user_de/0/com.google.android.gms/app_chimera/m [root][Termux]

File Discovery: The script scans the target directory and its subdirectories for all .apk files and organizes them by modification time. This ensures the latest version of each file is identified, regardless of its location in the directory hierarchy.
Duplicate Identification:
Files with the same base name (e.g., app.apk, app_v1.apk, app_v2.apk) are considered part of a group.
Among these, the most recent file is marked as the latest, while older versions are flagged as duplicates.
The duplicates exist across different subdirectories
For each identified duplicate, the script prompts the user to confirm whether to delete all files in the directory containing the duplicate.
If confirmed, the script deletes all files in the duplicate's directory. This ensures that not only the .apk file but also any related or additional files in the same subdirectory are removed.
Afterward, if the directory becomes empty, it is cleaned up automatically.

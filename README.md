# Chimera-clean
### Cleans /data/user_de/0/com.google.android.gms/app_chimera/m [root][Termux]

The script scans the target directory and its subdirectories for all .apk files and organizes them by modification time.
Files with the same base name (e.g., app.apk, app_v1.apk, app_v2.apk) are considered part of a group.
Among these, the most recent file is marked as the latest, while older versions are flagged as duplicates.
For each identified duplicate, the script prompts the user to confirm whether to delete all files in the directory containing the duplicate and the directory itself.

https://xdaforums.com/t/chimera-clean-cleans-data-user_de-0-com-google-android-gms-app_chimera-m-root-termux.4726513/

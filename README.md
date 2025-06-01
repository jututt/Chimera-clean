# Chimera-clean
### Cleans /data/user_de/0/com.google.android.gms/app_chimera/m [root][Termux]

chimera_clean.sh:
The script scans GMS Chimera directory and its subdirectories for all .apk files and organizes them by modification time.
Files with the same base name (e.g., app.apk, app_v1.apk, app_v2.apk) are grouped.
Among these, the most recent file is marked as the latest, while older versions are flagged as duplicates.
For each identified duplicate, the script deletes all files in the directory containing the duplicate and the directory itself.

chimera-list.sh: just shows the duplicates apks

https://xdaforums.com/t/chimera-clean-cleans-data-user_de-0-com-google-android-gms-app_chimera-m-root-termux.4726513/

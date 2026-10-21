# Chimera-clean
### Cleans /data/user_de/0/com.google.android.gms/app_chimera/m [root][Termux]

Google Chimera is a system that splits Google Play Services into smaller, on-demand modules. These are usually updated monthly, but older versions never get purged automatically, causing this system directory to constantly grow and waste storage.

chimera_clean.sh:
The script scans GMS Chimera directory and its subdirs for all modules .apk files and organizes them by modification time, marks the latest, and flags older versions as duplicates.
For each identified duplicate, the script deletes all files in the directory containing the duplicate and the directory itself.

chimera-list.sh: just shows the duplicates apks
advised to run every couple of months to monitor the ongoing directory bloat.

https://xdaforums.com/t/chimera-clean-cleans-data-user_de-0-com-google-android-gms-app_chimera-m-root-termux.4726513/

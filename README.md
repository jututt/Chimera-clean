# Chimera-clean
### Cleans /data/user_de/0/com.google.android.gms/app_chimera/m [root][Termux]

Google Chimera is a system that splits Google Play Services into smaller, on-demand modules. Sizes range from under 1MB to over 20MB, with a median size of around 10MB. Modules are usually updated monthly, but older versions never get purged automatically, causing this system directory to constantly grow (up to several gigabytes)

`chimera_clean.sh`:
The script scans GMS Chimera directory and its subdirs for all modules .apk files and organizes them by modification time, marks the latest, and flags older versions as duplicates.
For each identified duplicate, the script deletes all files in the directory containing the duplicate and the directory itself.

`chimera-list.sh`: just shows the duplicates apks. Advised to run every couple of months to monitor the ongoing directory bloat.

https://xdaforums.com/t/chimera-clean-cleans-data-user_de-0-com-google-android-gms-app_chimera-m-root-termux.4726513/

 

### UPDATE 2026-11:
after a Vending data clean, a new path has been found for Chimera modules: `/data/data/com.android.vending/cache/installercache/com.google.android.gms/[timestamp]/`

This is a much better approach, every update is packed in its own dir, so you can keep only the latest and delete older to keep the bloat in check.

Old `user_de` path my script is pointing to seems now deprecated and stays empty.

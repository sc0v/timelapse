# Timelapse Script

This script pulls an image from a network camera and uploads it to a CMU Box account.  If either the download or upload fails, sc0v@springcarnival.org will be notified by email.

To use this script, add lines to the crontab.
For example, if you wanted to pull images every 30 seconds from a camera you would add the following lines to the crontab.

```
* * * * * /path/to/file/getimage.sh camera_hostname camera_username camera_password andrewid andrewid_password
* * * * * sleep 30 && /path/to/file/getimage.sh camera_hostname camera_username camera_password andrewid andrewid_password
```

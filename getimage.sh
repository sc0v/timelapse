#!/bin/bash

# This script pulls an image from a network camera and uploads it to a CMU Box account.
# If either the download or upload fails, sc0v@springcarnival.org will be notified by email.
#
# To use this script, add lines to the crontab.
# For example, if you wanted to pull images every 30 seconds from a camera you would add the following lines to the crontab.
#
# * * * * * /path/to/file/getimage.sh camera_hostname camera_username camera_password andrewid andrewid_password
# * * * * * sleep 30 && /path/to/file/getimage.sh camera_hostname camera_username camera_password andrewid andrewid_password 


usage='usage: getimage camera_hostname camera_username camera_password andrewid andrewid_password'

if [ $# -ne 5 ] ; then
    echo "$usage"
    exit 1;
fi

# Download the image from the camera.
wget -v -t 1 -T 10 --user $2 --password $3 $1/jpg/image.jpg -O $1.jpg 2> $1.log
# If this is the first time the download command failed after previously succeeding, send an email to sc0v@springcarnival.org.
if [ $? -ne 0 ] ; then
    if [ ! -f $1.err ] ; then
        touch $1.err
        mail -s "Camera Error - $1 download failed" sc0v@springcarnival.org < $1.log
    fi
    exit 2
fi

# Upload the image to the CMU Box account.
curl -v -m 10 -u $4@andrew.cmu.edu:$5 --ssl --ftp-create-dirs --upload-file $1.jpg ftp://ftp.box.com/$1-$(date +%Y%m%d)/$(date +%Y%m%d%H%M%S).jpg 2>> $1.log
# If this is the first time the upload command failed after previously succeeding, send an email to sc0v@springcarnival.org.
if [ $? -ne 0 ] ; then
    if [ ! -f $1.err ] ; then
        touch $1.err
    	mail -s "Camera Error - $1 upload failed" sc0v@springcarnival.org < $1.log
    fi
    exit 3
fi

# Remove the image, log file, and error file.
rm $1.jpg
rm $1.log
rm $1.err

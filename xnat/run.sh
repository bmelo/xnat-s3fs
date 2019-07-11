#!/bin/bash

echo ${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY} > ~/.passwd-s3fs
chmod 600  ~/.passwd-s3fs

s3fs xnatidor /mnt/s3fsdata -o passwd_file=~/.passwd-s3fs \
    -o url=https://s3.amazonaws.com/ \
    -o use_path_request_style \
    -o use_cache=/tmp/s3cache

rmdir /data/xnat/archive
ln -s /mnt/s3fsdata/archive /data/xnat/archive

# yas3fs s3://$S3_PATH /data/xnat/archive -f &

/usr/local/tomcat/bin/catalina.sh run
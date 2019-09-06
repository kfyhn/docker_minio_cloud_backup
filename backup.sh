#!/bin/bash
#
# Check for required parameters
#
if [ -z "${SOURCE_ACCESS_KEY}" ]; then
    echo "The environment variable SOURCE_ACCESS_KEY is not set."
    exit 1
fi

if [ -z "${SOURCE_SECRET_KEY}" ]; then
    echo "The environment variable SOURCE_SECRET_KEY is not set."
    exit 1
fi

if [ -z "${SOURCE_HOST_ENDPOINT}" ]; then
    echo "The environment variable SOURCE_HOST_ENDPOINT is not set."
    exit 1
fi

if [ -z "${DEST_ACCESS_KEY}" ]; then
    echo "The environment variable DEST_ACCESS_KEY is not set."
    exit 1
fi

if [ -z "${DEST_SECRET_KEY}" ]; then
    echo "The environment variable DEST_SECRET_KEY is not set."
    exit 1
fi

if [ -z "${DEST_HOST_ENDPOINT}" ]; then
    echo "The environment variable DEST_HOST_ENDPOINT is not set."
    exit 1
fi

BACKUP_DIR=/tmp/backups
rm -r ${BACKUP_DIR}/*

IFS=$'\n'
for LINE in $(s3cmd --access_key=$SOURCE_ACCESS_KEY --secret_key=$SOURCE_SECRET_KEY --host=$SOURCE_HOST_ENDPOINT ls)
do 
	BUCKET=$(awk '{print $3}' <<< $LINE)
	LOCAL_DIR=$(cut -c 6- <<< $BUCKET)
	echo "Now backing up ${LOCAL_DIR}..."
	mkdir -p ${BACKUP_DIR}/${LOCAL_DIR}
	s3cmd --access_key=$SOURCE_ACCESS_KEY --secret_key=$SOURCE_SECRET_KEY --host=$SOURCE_HOST_ENDPOINT --host-bucket="$SOURCE_HOST_ENDPOINT/%(bucket)" sync --skip-existing $BUCKET ${BACKUP_DIR}/${LOCAL_DIR}
done
	
s3cmd --no-check-md5 --access_key=$DEST_ACCESS_KEY --secret_key=$DEST_SECRET_KEY --host=$DEST_HOST_ENDPOINT --host-bucket="$DEST_HOST_ENDPOINT/%(bucket)" sync --skip-existing ${BACKUP_DIR}/ s3://gitlab-backup-bucket 

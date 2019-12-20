#!/bin/bash
set -o errexit
set -u

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

if [ -z "${BUCKET_NAME}" ]; then
    echo "The environment variable BUCKET_NAME is not set."
    exit 1
fi

echo "Starting backup..."

BACKUP_DIR=/home/user/tmp_backups

IFS=$'\n'
for LINE in $(s3cmd --access_key=$SOURCE_ACCESS_KEY --secret_key=$SOURCE_SECRET_KEY --host=$SOURCE_HOST_ENDPOINT ls)
do 
	BUCKET=$(awk '{print $3}' <<< $LINE)
	LOCAL_DIR=$(cut -c 6- <<< $BUCKET)
    echo "Now backing up ${LOCAL_DIR}..."
    mkdir -p ${BACKUP_DIR}/${LOCAL_DIR}
    s3cmd --access_key=$SOURCE_ACCESS_KEY --secret_key=$SOURCE_SECRET_KEY --host=$SOURCE_HOST_ENDPOINT --host-bucket="$SOURCE_HOST_ENDPOINT/%(bucket)" \
        sync --no-check-md5 --human-readable-sizes $BUCKET ${BACKUP_DIR}/${LOCAL_DIR}
done

echo "All files retrieved from Minio. Now transferring to Alibaba OSS..."

ossutil64 --access-key-id=$DEST_ACCESS_KEY --access-key-secret=$DEST_SECRET_KEY --endpoint=$DEST_HOST_ENDPOINT \
    cp --recursive --force --update ${BACKUP_DIR} oss://$BUCKET_NAME 
echo "Backup complete!"

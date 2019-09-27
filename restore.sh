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
BACKUP_DIR=/home/user/backups
rm -r ${BACKUP_DIR}/*

#s3cmd --no-check-md5 --access_key=$DEST_ACCESS_KEY --secret_key=$DEST_SECRET_KEY --host=$DEST_HOST_ENDPOINT --host-bucket="$DEST_HOST_ENDPOINT/%(bucket)" sync --skip-existing s3://gitlab-backup-bucket ${BACKUP_DIR}
ossutil64 --access-key-id=$DEST_ACCESS_KEY --access-key-secret=$DEST_SECRET_KEY --endpoint=$DEST_HOST_ENDPOINT \
    cp --recursive --force --update oss://gitlab-backup-bucket ${BACKUP_DIR}

IFS=$'\n'
for LINE in $(s3cmd --access_key=$SOURCE_ACCESS_KEY --secret_key=$SOURCE_SECRET_KEY --host=$SOURCE_HOST_ENDPOINT ls)
do 
	BUCKET=$(awk '{print $3}' <<< $LINE)
	LOCAL_DIR=$(cut -c 6- <<< $BUCKET)
	#s3cmd --access_key=$SOURCE_ACCESS_KEY --secret_key=$SOURCE_SECRET_KEY --host=$SOURCE_HOST_ENDPOINT --host-bucket="$SOURCE_HOST_ENDPOINT/%(bucket)" \
    #    rm -r $BUCKET/*
	s3cmd --access_key=$SOURCE_ACCESS_KEY --secret_key=$SOURCE_SECRET_KEY --host=$SOURCE_HOST_ENDPOINT --host-bucket="$SOURCE_HOST_ENDPOINT/%(bucket)" \
        sync --skip-existing --human-readable-sizes ${BACKUP_DIR}/${LOCAL_DIR}/ $BUCKET
done
	
echo "Restore complete!"
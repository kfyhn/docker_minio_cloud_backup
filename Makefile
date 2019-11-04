NAME=minio_cloud_backup

build:
	docker build -t ${NAME} .

run: build
	docker run --rm -it --name ${NAME} \
		--env SOURCE_ACCESS_KEY=${SOURCE_ACCESS_KEY} \
		--env SOURCE_SECRET_KEY=${SOURCE_SECRET_KEY} \
		--env SOURCE_HOST_ENDPOINT=${SOURCE_HOST_ENDPOINT} \
		--env DEST_ACCESS_KEY=${DEST_ACCESS_KEY} \
		--env DEST_SECRET_KEY=${DEST_SECRET_KEY} \
		--env DEST_HOST_ENDPOINT=${DEST_HOST_ENDPOINT} \
		--env BUCKET_NAME=${BUCKET_NAME} \
		${NAME} \
		/bin/bash

backup:
	docker run --rm --name ${NAME} \
		--env SOURCE_ACCESS_KEY=${SOURCE_ACCESS_KEY} \
		--env SOURCE_SECRET_KEY=${SOURCE_SECRET_KEY} \
		--env SOURCE_HOST_ENDPOINT=${SOURCE_HOST_ENDPOINT} \
		--env DEST_ACCESS_KEY=${DEST_ACCESS_KEY} \
		--env DEST_SECRET_KEY=${DEST_SECRET_KEY} \
		--env DEST_HOST_ENDPOINT=${DEST_HOST_ENDPOINT} \
		--env BUCKET_NAME=${BUCKET_NAME} \
		${NAME} \
		./backup.sh

restore:
	docker run --rm --name ${NAME} \
		--env SOURCE_ACCESS_KEY=${SOURCE_ACCESS_KEY} \
		--env SOURCE_SECRET_KEY=${SOURCE_SECRET_KEY} \
		--env SOURCE_HOST_ENDPOINT=${SOURCE_HOST_ENDPOINT} \
		--env DEST_ACCESS_KEY=${DEST_ACCESS_KEY} \
		--env DEST_SECRET_KEY=${DEST_SECRET_KEY} \
		--env DEST_HOST_ENDPOINT=${DEST_HOST_ENDPOINT} \
		--env BUCKET_NAME=${BUCKET_NAME} \
		${NAME} \
		./restore.sh

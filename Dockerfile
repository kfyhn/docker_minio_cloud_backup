FROM alpine:3.3

RUN apk update
RUN apk add --no-cache bash python py-pip py-setuptools git ca-certificates
RUN pip install python-dateutil

RUN git clone https://github.com/s3tools/s3cmd.git /opt/s3cmd
RUN ln -s /opt/s3cmd/s3cmd /usr/bin/s3cmd

WORKDIR /opt

ADD .s3cfg /root/.s3cfg
ADD backup.sh /opt/backup.sh
ADD restore.sh /opt/restore.sh

RUN mkdir -p /tmp/backups

RUN chmod 777 backup.sh
RUN chmod 777 restore.sh


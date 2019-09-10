FROM alpine:3.8

RUN apk update
RUN apk add --no-cache libc6-compat bash python py-pip py-setuptools git ca-certificates
RUN pip install python-dateutil

# S3CMD
RUN git clone https://github.com/s3tools/s3cmd.git /opt/s3cmd
RUN ln -s /opt/s3cmd/s3cmd /usr/bin/s3cmd

# OSSUTIL
RUN wget http://gosspublic.alicdn.com/ossutil/1.6.1/ossutil64 -O /opt/ossutil64
RUN chmod 755 /opt/ossutil64
RUN ln -s /opt/ossutil64 /usr/bin/ossutil64

WORKDIR /opt

ADD .s3cfg /root/.s3cfg
ADD backup.sh /opt/backup.sh
ADD restore.sh /opt/restore.sh

RUN mkdir -p /tmp/backups

RUN chmod 777 backup.sh
RUN chmod 777 restore.sh


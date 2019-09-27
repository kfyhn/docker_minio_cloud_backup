FROM alpine:3.8

RUN addgroup -S -g 1000 user_group && adduser -S user -G user_group -u 1000

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

ADD .s3cfg /home/user/.s3cfg
ADD backup.sh /home/user/backup.sh
ADD restore.sh /home/user/restore.sh
RUN chown user:user_group /home/user/backup.sh
RUN chown user:user_group /home/user/restore.sh

WORKDIR /home/user
USER user

RUN mkdir -p /home/user/tmp_backups
RUN chmod +x backup.sh
RUN chmod +x restore.sh





#!/bin/bash

/usr/local/s3-fuse.sh

export LOG_FILE=`grep vsftpd_log_file /etc/vsftpd.conf|cut -d= -f2`
touch ${LOG_FILE}
tail -f ${LOG_FILE} &

/usr/bin/supervisord
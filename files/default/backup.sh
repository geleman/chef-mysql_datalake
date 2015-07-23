#! /bin/bash

cd /data/dumps
:>dumplog.txt
:>mysql_err.txt

# Send output to a log file and suppress input
declare LOG="dumplog.txt"
[[ -t 1 ]] && echo "Writing to logfile '$LOG'"
exec > $LOG 2>&1

# check dump start time of data dump
date
time mysqldump --log-error=mysql_err.txt --flush-privileges --single-transaction --quick --routines --all-databases --user=backup --password=backup --socket=/tmp/mysqld.sock > full_dump.sql

# do a schema dump and check time complete 
time mysqldump --no-data --routines --all-databases --user=backup --password=backup --socket=/tmp/mysqld.sock > schema.sql
date


# list files in dir
ls -ltrh *.sql
ls -ltrh *.txt


# email copy to dba
/bin/mail -s "MySQL full dump log report" glane@gannett.com < /data/dumps/dumplog.txt
#!/bin/sh
#
# Simple Backup Script
# (c) Sebastian Muszytowski
#
# Please see README for detailed instructions

## CONFIGURATION ##
date="$(date +%Y.%m.%d-%k.%M)"
backupdir=/path/to/backupdir

host="user@host.tld"

  # Attention:
  #  If you have a trailing / in backupdir then please delete the / below

mkdir ${backupdir}/${date}
newdir= ${backupdir}/${date}

tarcmd="tar -czf -"
extension=".tar.gz" # .tgz is also possible

## END OF CONFIGURATION PATH ##

##
# Backup process
##
# -> PostgreSQL
##
ssh ${host} "su postgres -c pg_dumpall" >> ${newdir}/postgres.sql
##
# -> OpenLDAP
##
ssh ${host} slapcat >> ${newdir}/openldap
##
# -> Cronjobs (/var/spool/cron)
##
ssh ${host} "${tarcmd} /var/spool/cron" >> ${newdir}/crontab${extension}
##
# -> /etc/
##
ssh ${host} "${tarcmd} /etc/" >> ${newdir}/etc${extension}
##
# -> /var/spool/mail
##
ssh ${host} "${tarcmd} /var/spool/mail" >> ${newdir}/mails${extension}
##
# -> /var/www/
##
ssh ${host} "${tarcmd} /var/www" >> ${newdir}/www${extension}


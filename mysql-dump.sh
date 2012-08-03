#!/bin/bash
### MySQL Backup Setup ###                                                                                                                                                                                                                
MUSER="python -c 'from production_settings import DATABASES; print DATABASES["default"]["USER"];'"                                                                                                                                        
MPASS="python -c 'from production_settings import DATABASES; print DATABASES["default"]["PASSWORD"];'"                                                                                                                                    
MHOST="python -c 'from production_settings import DATABASES; print DATABASES["default"]["HOST"]'"

### Disable MySQL Backup ###
# Change to 0 to disable
BACKUPMYSQL=1 

# Dump MYSQL to /platform/storage_bkup/db

if [[ -n "$BACKUPMYSQL" && "$BACKUPMYSQL" -gt 0 ]]; then
    MYSQLBKUPDIR="/platform/storage_bkup/db"
    MYSQL="$(which mysql)"
    MYSQLDUMP="$(which mysqldump)"
    GZIP="$(which gzip)"
fi

if [[ -n "$BACKUPMYSQL" && "$BACKUPMYSQL" -gt 0 ]]; then
    if [[ -n "$MYSQL" || -n "$MYSQL" || -n "$MYSQLDUMP" || -n "$GZIP" ]]; then
        echo "Not all MySQL commands found."
        exit 2
    fi
fi

if [[ -n "$BACKUPMYSQL" && "$BACKUPMYSQL" -gt 0 ]]; then
    # Get all databases name
    DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
    for db in $DBS
    do
        if [ "$db" != "information_schema" ]; then
        $MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS $db | $GZIP -9 > $MYSQLTMPDIR/mysql-$db
        fi
    done
fi

# End Dump MYSQL


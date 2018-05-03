#!/bin/bash


function FILE_EXISTS() {
    FILE=$1
    if [ -f $FILE ]; then
           echo "File $FILE exists."
           return 0
       else
           echo "File $FILE does not exist."
           return -1
       fi
}

function FAIL_ALERT() {

    ##################
    # ALERT function #
    # with exit code #
    ##################

    message="$1"
    exit_code="$2"
    echo "ERROR: $message, exit code: $exit_code" 1>&2
    exit $exit_code
}


function send_mail() {

    ########################
    # A SEND MAIL FUNCTION #
    ########################

    to="$1"
    subject="$2"
    body="$3"
    echo "$to $subject $body"
    echo "$body" | mail -s "$subject" "$to"
    # enable this if you have a text file with subject as body
    # cat "$body" | mail -s "$subject" "$to"
}

function error_mail() {

    ##########################
    # MAIL SENDER FROM LISTS #
    ##########################

    status_value="$1"
    echo $status
    declare -a error_mail_list=("yodebu@gmail.com" "yodebu2@gmail.com")
    declare -a good_mail_list=("yodebu@gmail.com" "yodebu2@gmail.com")
    subject="This is the status!"
    error_message="Fuck! it failed!"
    good_message="Fuck! it worked"

    if [ $status_value = "fail" ]; then
        echo "Faillll..."
        for id in "${error_mail_list[@]}"; do
            echo $id
            send_mail "$id" "$subject" "$error_message"
        done

    elif [ $status_value = "pass" ]; then
        echo "Faillll..."
        for id in "${good_mail_list[@]}"; do
            echo $id
            send_mail "$id" "$subject" "$good_message"
        done
    else
        echo "Wrong Status!"
        message="FAiled due to wrong status!"
        FAIL_ALERT "$message" 1
    fi

}



function CONNECT_DB() {
    echo "db2 connect to $DBNAME user $USER using $PASSWD"
    db2 connect to $DBNAME user $USER using $PASSWD
    rec=0
    if [ $rec -ne 0 ]; then
        ALERT "Failure in connecting to DB -`date +%Y%m%d%H%M%S` " 10
    fi
}



function DISCONNECT_DB() {
    #To disconnect from DB2 database
    echo "disconnecting from DB"
    db2 disconnect $DBNAME
    rec=$?
    if [ $rec -ne 0 ]; then
        ALERT "Failure in disconnecting from DB -`date +%Y%m%d%H%M%S` " 10
    fi
}


function RUN_ETL() {

    # defining informatica details
    INFA_SERVICE=$Integration_Service
    DOMAIN_NAME=$ETL_DOMAIN
    PM_USER=$ETL_USER
    INFA_FOLDER=$FOLDER
    if [ -s $SRCDIR/*.csv ]; then
        echo " Found file : $FILENAME.csv "
        pmcmd startworkflow -sv $INFA_SERVICE -d $DOMAIN_NAME -uv $PM_USER  -wait wf_XXX
    else
        echo " File Not Found : $FILENAME.csv "
        ALERT " File Not Found : $FILENAME.csv " 10
    fi
    return
}


##########################################################################

#######################################
###      MAIN CODE STARTS HERE      ###
#######################################




FEED_NAME=$1
FILE_NUM=$2

#LOG_DIRECTORY_FULLPATH
export LOG_DIR="/home/lightbringer/Desktop/shell-work/logs/"
export INBOUND_DIR="/home/lightbringer/Desktop/shell-work/inbound"
export TEMP_DIR="/home/lightbringer/Desktop/shell-work/tmp"


#SET TIMESTAMP
DATE=`date +%Y%m%d%H%M%S`

log_filename="fileLoader.$FEED_NAME.$DATE.console.log"
error_filename="fileLoader.$FEED_NAME.$DATE.error.log"
log_fullpath=$LOG_DIR$log_filename
error_log_fullpath=$LOG_DIR$error_filename

# fileLoader.<$Feed_NAME>.<YYMMDDHHMMSS>.log.

exec 2> >(tee -a $error_log_fullpath)
exec 1> >(tee -a $log_fullpath)

## TEST CODE

statusv="fass"
error_mail $statusv
# ALERT hithere 2
FILE_EXISTS $PWD

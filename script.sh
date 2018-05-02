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


##########################################################################

#######################################
###      MAIN CODE STARTS HERE      ###
#######################################


FEED_NAME=$1
FILE_NUM=$2

#LOG_DIRECTORY_FULLPATH
LOG_DIR="/home/lightbringer/Desktop/shell-work/logs/"

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

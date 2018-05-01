#!/bin/bash



function ALERT() {

    ##################
    # ALERT function #
    # with exit code #
    ##################

    message="$1"
    exit_code="$2"
    echo "ERROR: $message, exit code: $exit_code"
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
    fi

}


FEED_NAME=$1
FILE_NUM=$2

## TEST CODE

statusv="fass"
error_mail $statusv
ALERT hithere 2

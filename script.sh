#!/bin/bash


function send_mail() {
    to="$1"
    subject="$2"
    body="$3"
    echo "$to $subject $body"
    echo "$body" | mail -s "$subject" "$to"
    # enable this if you have a text file with subject as body
    # cat "$body" | mail -s "$subject" "$to"
}

function error_mail() {
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



## TEST CODE

statusv="fass"
error_mail $statusv

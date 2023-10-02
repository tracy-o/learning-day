#!/bin/bash
export PATH=${PATH}:/usr/local/bin:/sbin

#######
# Uploads log rotated (.gz) files to GCS and renames them by adding '.uploaded' suffix.
# On error, it leaves them unaltered for subsequent attempts.
# Logs shipped to GCS are to be ingested in BigQuery.
#######

####### Global Variables #######
START_DATE=$(date)

# Inject values obtained via Cosmos
GCS_ACCESS_LOGS_BUCKET_NAME=$(cat /etc/bake-scripts/config.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["configuration"]["GCS_ACCESS_LOGS_BUCKET_NAME"])')
ACCESS_LOG_ENV=$(cat /etc/bake-scripts/config.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["environment"])')
ACCESS_LOG_FAMILY="www"
ACCESS_LOG_TYPE="access"
STACK_ID=$(cat /etc/bake-scripts/config.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["configuration"]["STACK_ID"])')
AUTHENTICATION_FLAG_FILE="/tmp/gcp_authenticated"

# GCS bucket path, dependent on some injected info
BUCKET_PATH="gs://$GCS_ACCESS_LOGS_BUCKET_NAME/$ACCESS_LOG_ENV/$ACCESS_LOG_FAMILY/$ACCESS_LOG_TYPE/$STACK_ID"

# Let's create the service account key file
cat /etc/bake-scripts/config.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["secure_configuration"]["GCP_AUTH"])' > /tmp/gcp_auth.json

# google-cloud-sdk configuration
configure_gcloud() {
    if [ ! -f $AUTHENTICATION_FLAG_FILE ]; then
        gcloud auth activate-service-account --key-file /tmp/gcp_auth.json 1> /dev/null
        if [ $? -ne 0 ]; then
            log_message "GCP error" "Failed GCP service account activation"
            exit 1
        else
            log_message "GCP success" "GCP service account activated"
            touch $AUTHENTICATION_FLAG_FILE
        fi
        rm /tmp/gcp_auth.json
    else
        log_message "info" "GCP service account already activated, flag file present"
    fi
}

####### Functions #######
log_message() {
    logger "bq-logs-shipping [$1]: ${2}"
}

ship_log_files() {    
    declare -a files=("${!1}")
    BUCKET_PATH=$2

    for LOG_FILE_PATH in ${files[@]}; do
        # We are prefixing *on the fly* a UUID to the file name
        # so that we can avoid collisions in the bucket
        FILE_NAME="$(uuidgen -t)-$(basename $LOG_FILE_PATH)"
        DESTINATION="$BUCKET_PATH/$FILE_NAME"

        if [ -f "$LOG_FILE_PATH" ]; then
            gsutil -q cp $LOG_FILE_PATH $DESTINATION 1>/dev/null
            RETURN_STATUS=$(echo $?)
            if [ $RETURN_STATUS -ne 0 ]; then
                log_message "GCP error" "Upload to bucket failed for file ${FILE_NAME}"
            else
                log_message "GCP success" "File $FILE_NAME uploaded to bucket"
                mv "$LOG_FILE_PATH" "$LOG_FILE_PATH.uploaded" 1>/dev/null
                RETURN_STATUS=$(echo $?)
                if [ $RETURN_STATUS -ne 0 ]; then 
                    log_message "error" "Failed to rename $LOG_FILE_PATH to $LOG_FILE_PATH.uploaded"
                else
                    log_message "success" "File ${LOG_FILE_PATH} renamed to $LOG_FILE_PATH.uploaded"
                fi
            fi
        else
            log_message "error" "File not found or not a regular file: $LOG_FILE_PATH"
        fi
    done
}

get_files() {
    ####### GCS - GCP (Google Cloud Platform) GCS - Google Cloud Storage #######
    # Access log files should be named as access.x.log.gz
    # This naming pattern requires the access.log rotation definition to
    # be updated
    ACCESS_LOG_FILES=$(find /var/log/component/ -iname "access.*log.gz" )
}

configure_gcloud

get_files

ship_log_files \
    ACCESS_LOG_FILES[@] \
    $BUCKET_PATH

log_message "info" "Logs shipping execution at ${START_DATE} finished."

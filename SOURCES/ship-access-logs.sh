#!/bin/bash
export PATH=${PATH}:/usr/local/bin:/sbin

#######
# Uploads log rotated (.gz) files to GCS and renames them by adding '.uploaded' suffix.
# On error, it leaves them unaltered for subsequent attempts.
# Logs shipped to GCS are to be ingested in BigQuery.
#######

####### Global Variables #######
START_TIME=$(date +%s)
STATUS_CODE=1
FILES_COUNTER=0

# Inject values obtained via Cosmos
GCS_ACCESS_LOGS_BUCKET_NAME=$(cat /etc/belfrage/component_configuration.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["configuration"]["GCS_ACCESS_LOGS_BUCKET_NAME"]')
ACCESS_LOG_ENV=$(cat /etc/belfrage/component_configuration.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["environment"]')
ACCESS_LOG_FAMILY="www"
ACCESS_LOG_TYPE="access"
STACK_ID=$(cat /etc/belfrage/component_configuration.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["configuration"]["STACK_ID"]')

# GCS bucket path, dependent on some injected info
BUCKET_PATH="gs://$GCS_ACCESS_LOGS_BUCKET_NAME/$ACCESS_LOG_ENV/$ACCESS_LOG_FAMILY/$ACCESS_LOG_TYPE/$STACK_ID"

# Let's create the service account key file
cat /etc/belfrage/component_configuration.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["secure_configuration"]["GCP_AUTH"]' > /tmp/gcp_auth.json

# google-cloud-sdk configuration
configure_gcloud() {
    gcloud auth activate-service-account --key-file /tmp/gcp_auth.json 1> /dev/null
    if [ $? -ne 0 ]; then
        log_message "Failed to authenticate with GCP"
        exit 1
    else
        echo "GCP service account activated"
    fi
    rm /tmp/gcp_auth.json
}

####### Functions #######
log_message() {
    echo -e "$(date +'%d/%m/%Y %H:%M:%S'): ${1}"
}

ship_log_files() {    
    declare -a files=("${!1}")
    BUCKET_PATH=$2

    for LOG_FILE_PATH in ${files[@]}; do
        # We are prefixing *on the fly* a UUID to the file name
        # so that we can avoid collisions in the bucket
        FILE_NAME="$(uuidgen -t)-$(basename $LOG_FILE_PATH)"
        DESTINATION="${BUCKET_PATH}/${FILE_NAME}"

        if [ -f "$LOG_FILE_PATH" ]; then
            gsutil -q cp $LOG_FILE_PATH $DESTINATION 1>/dev/null
            RETURN_STATUS=$(echo $?)
            if [ $RETURN_STATUS -ne 0 ]; then
                log_message "File ${FILE_NAME} failed to get uploaded on the bucket"
                STATUS_CODE=0
            else
                mv "${LOG_FILE_PATH}" "${LOG_FILE_PATH}.uploaded" 1>/dev/null
                RETURN_STATUS=$(echo $?)
                if [ $RETURN_STATUS -ne 0 ]; then 
                    log_message "File deletion failed"
                    STATUS_CODE=0
                else
                    FILES_COUNTER=$(($FILES_COUNTER+1))
                fi
            fi
        else
            log_message "File not found or not a regular file: ${LOG_FILE_PATH}"
            STATUS_CODE=0
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

log_message "START: $(basename "$0")"

configure_gcloud

get_files

ship_log_files \
    ACCESS_LOG_FILES[@] \
    $BUCKET_PATH

END_TIME=$(date +%s)
TIME_TAKEN=$(expr ${END_TIME} - ${START_TIME})
log_message " ${FILES_COUNTER} files were shipped"
log_message " FINISH: Time taken - ${TIME_TAKEN} seconds\n "

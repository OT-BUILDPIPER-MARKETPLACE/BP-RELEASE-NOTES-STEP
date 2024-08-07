#!/bin/bash
source /opt/buildpiper/shell-functions/functions.sh
source /opt/buildpiper/shell-functions/log-functions.sh
source /opt/buildpiper/shell-functions/str-functions.sh
source /opt/buildpiper/shell-functions/file-functions.sh
source /opt/buildpiper/shell-functions/aws-functions.sh

TASK_STATUS=0

CODEBASE_LOCATION="${WORKSPACE}"/"${CODEBASE_DIR}"
logInfoMessage "I'll do processing at [$CODEBASE_LOCATION]"
sleep  $SLEEP_DURATION
cd  "${CODEBASE_LOCATION}"
python3 generate_release_notes.py .
TASK_STATUS=$?

if [ $TASK_STATUS -eq 0 ]; then
    logInfoMessage "Done the required operation"
    cat release_notes.md
else
    TASK_STATUS=1
    logErrorMessage "Target server not provided please check"
    
fi
saveTaskStatus ${TASK_STATUS} ${ACTIVITY_SUB_TASK_CODE}
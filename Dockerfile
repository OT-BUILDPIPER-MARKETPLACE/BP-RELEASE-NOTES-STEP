
FROM python:3-alpine
RUN apk add --no-cache --upgrade bash
RUN pip install --no-cache-dir jinja2
RUN apk add --no-cache --upgrade bash jq git
COPY build.sh .
COPY generate_release_notes.py .
 

ADD BP-BASE-SHELL-STEPS /opt/buildpiper/shell-functions/


ENV SLEEP_DURATION 5s
ENV ACTIVITY_SUB_TASK_CODE REPLACE_IT
ENV VALIDATION_FAILURE_ACTION WARNING

ENTRYPOINT [ "./build.sh" ]

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{.name}}-config
  namespace: {{.namespace}}
  labels:
    {{.labels.key}}: {{.labels.value}}
data:
  entrypoint.sh: |-
    #!/bin/bash
    set -e
    LOG=${1:-/var/log/access.log}
    [ -f "$LOG" ] || touch $LOG
    echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO] - log to: ${LOG}"
    while true; do
      echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO] - ${RANDOM}"
      echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO] - ${RANDOM}" >> $LOG
      sleep 10
    done

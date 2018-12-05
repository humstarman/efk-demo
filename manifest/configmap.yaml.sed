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
    show_help () {
    cat << USAGE
    usage: $0 [ -l LOG-PATH ]
        -l : Specify the path of the log in term of file.
    USAGE
    exit 0
    }
    # Get Opts
    while getopts "hl:" opt; do 
        case "$opt" in
        h)  show_help
            ;;
        l)  LOG=$OPTARG
            ;;
        ?) echo "unkonw argument"
            exit 1
            ;;
        esac
    done
    [[ -z $* ]] && show_help
    chk_var () {
    if [ -z "$2" ]; then
      echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [ERROR] - no input for \"$1\", try \"$0 -h\"."
      sleep 3
      exit 1
    fi
    }
    chk_var -l $LOG
    [ -f "$LOG" ] || touch $LOG
    echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO] - log to: ${LOG}"
    echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [DEBUG] - log to: ${LOG}" >> $LOG
    while true; do
      N=${RANDOM}
      echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [INFO] - ${N}"
      echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [DEBUG] - ${N}" >> $LOG
      sleep 10
    done

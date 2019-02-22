#!/bin/bash

# This script checks to see whether this pod is or is not a capture pod
# Kubernetes will pass the PODTYPE variable as an environment variable with
# value True to  those pods meant for capture and False for the viewer pod.
# This allows us to only use one container for both the viewer and capture pods

if [[ ! -z "${PODTYPE}" ]]; then  
  if [[ "${PODTYPE}" == "CAPTURE" ]]; then    
    cd /data/moloch/viewer
    /data/moloch/bin/node /data/moloch/viewer/viewer.js -c /data/moloch/etc/config.ini > /data/moloch/logs/viewer.log &
    /data/moloch/bin/moloch-capture -c /data/moloch/etc/config.ini
  elif [[ "${PODTYPE}" == "VIEWER" ]]; then
    cd /data/moloch/viewer
    /data/moloch/bin/node /data/moloch/viewer/viewer.js -c /data/moloch/etc/config.ini
  elif [[ "${PODTYPE}" == "BOOTSTRAP" ]]; then
    /usr/bin/expect /data/moloch/bin/auto-init
    /data/moloch/bin/moloch_add_user.sh -c /data/moloch/etc/config.ini "${MOLOCH_LOGIN}" "${MOLOCH_LOGIN}" "${MOLOCH_PASS}" --admin --webauth
  fi
fi

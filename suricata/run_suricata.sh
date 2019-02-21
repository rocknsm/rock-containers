#!/bin/bash

if [[ ! -z "${PODTYPE}" ]]; then
  if [[ "${PODTYPE}" == "SURICATA" ]]; then
    filebeat modules enable suricata
    /usr/bin/sed -i 's|#var.paths:|var.paths: [\"/var/log/suricata/eve-*.json\"]|' /etc/filebeat/modules.d/suricata.yml
    /usr/share/filebeat/bin/filebeat -c /etc/filebeat/filebeat.yml -path.home /usr/share/filebeat -path.config /etc/filebeat -path.data /var/lib/filebeat -path.logs /var/log/filebeat &
    /usr/sbin/suricata -c /etc/suricata/suricata.yaml --af-packet
  elif [[ "${PODTYPE}" == "BOOTSTRAP" ]]; then
    filebeat modules enable suricata
    filebeat setup -e
  fi
fi

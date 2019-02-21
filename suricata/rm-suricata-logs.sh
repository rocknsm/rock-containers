#!/bin/bash
ls /var/log/suricata | grep eve- | head -n -2 | xargs -I X rm /var/log/suricata/X

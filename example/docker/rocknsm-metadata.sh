#!/bin/sh
#
# This script runs at bootup and populates `/run/metadata/`
#
# This file is part of RockNSM. 
# See (http://github.com/rocknsm/rock/) for LICENSE
#

## This isn't really useful, as the systemd container
# is smart enough to pass on environment variables
# to services

# Populate the environment file
_env=$(cat /proc/1/environ | \
      tr '\000' '\n' | \
      grep -vE '^(PATH|TERM|HOME|HOSTNAME)')

echo -n "${_env}" > /run/metadata/environ


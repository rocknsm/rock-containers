#!/bin/sh

# These are the defaults
BRO_SCRIPTS_GIT="https://github.com/rocknsm/rock-scripts.git"
BRO_SCRIPTS_BRANCH="master"
BRO_SCRIPTS_DIR="/usr/share/bro/site/scripts"

# Override defaults
if [ -f /etc/sysconfig/bro-scripts ]; then
  . /etc/sysconfig/bro-scripts
fi

# Check if directory exists. If yes, update, else clone
if [ -d "${BRO_SCRIPTS_DIR}" ]; then
  if [ ! -d "${BRO_SCRIPTS_DIR}/.git" ]; then
    echo "ERROR: Bro scripts directory is present, but not a git repository."
    echo "ERROR:   ${BRO_SCRIPTS_DIR}/.git is not present"
    exit 1;
  fi

  cd "${BRO_SCRIPTS_DIR}"
  echo "Updating scripts."
  if ! git pull "${BRO_SCRIPTS_GIT}"; then
    echo "ERROR: Unable to pull remote at ${BRO_SCRIPTS_GIT}."
    exit 1;
  fi
  echo "SUCCESS: Bro scripts successfully updated."

  #TODO Maybe restart bro if it is already running?
else
  _parent=$(dirname "${BRO_SCRIPTS_DIR}")
  mkdir -p "${_parent}"
  cd "${_parent}"

  if git clone --branch "${BRO_SCRIPTS_BRANCH}" ${BRO_SCRIPTS_GIT} "${BRO_SCRIPTS_DIR}"; then
    echo "SUCCESS: Bro scripts successfully cloned"
  else
    echo "ERROR: Unable to clone git repo"
    exit 1;
  fi

fi

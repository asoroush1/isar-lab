#!/bin/sh
# Boot report: proves the image booted and identifies what is running.
. /etc/os-release
. /etc/lab-release
echo "PLATFORM-HEARTBEAT: host=$(hostname) os=\"${PRETTY_NAME}\" kernel=$(uname -r) platform=${LAB_PLATFORM_VERSION}"
#!/bin/bash

# Use the following image as a base for the installer: 
# https://wiki.ubuntu.com/ARM/RaspberryPi
# http://www.finnie.org/software/raspberrypi/ubuntu-rpi3/ubuntu-16.04-preinstalled-server-armhf+raspi3.img.xz

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
  echo "ERROR: Operation not permitted. Forgot sudo?"
  exit 1
fi

CURRENT_HOSTNAME=$(hostname)
NEW_HOSTNAME="ur5-ros-controller"

if [[ $NEW_HOSTNAME != $CURRENT_HOSTNAME ]]; then
  echo "Updating hostname to '$NEW_HOSTNAME'..."
  hostname $NEW_HOSTNAME
  echo $NEW_HOSTNAME > /etc/hostname
  sed -i "s/$CURRENT_HOSTNAME/$NEW_HOSTNAME/" /etc/hosts
fi

echo "Done"

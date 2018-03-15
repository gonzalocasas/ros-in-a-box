#!/bin/bash

# Use 'Ubuntu Classic Server 16.04' as a base for the installer:
# https://ubuntu-pi-flavour-maker.org/download/
# Default credentials: ubuntu/ubuntu (pass must be changed on first login)
# Clone this repository:
#   $ git clone https://github.com/gonzalocasas/ros-in-a-box.git ~/ros-in-a-box
#   $ cd ~/ros-in-a-box
#   $ ./install

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
  echo "ERROR: Operation not permitted. Forgot sudo?"
  exit 1
fi

echo "ROS-IN-A-BOX installation"
echo "-------------------------"

# Get first non-loopback network device that is currently connected
NIC_NAME=$(ip -oneline link show up 2>&1 | grep -v LOOPBACK | sed -E 's/^[0-9]+: ([0-9a-z]+): .*/\1/' | head -1)
if [[ -z $NIC_NAME ]]; then
  echo "ERROR: No network interface found."
  exit 1
fi

# Then build new hostname with last 3 bytes (the first 3 are common to all RPis) of the MAC address
NEW_HOSTNAME=$(cat /sys/class/net/$NIC_NAME/address | awk -F\: '{print "robot-controller-"$4$5$6}')
CURRENT_HOSTNAME=$(hostname)
    
if [[ $NEW_HOSTNAME != $CURRENT_HOSTNAME ]]; then
  echo "Updating hostname to '$NEW_HOSTNAME'..."
  hostname $NEW_HOSTNAME
  echo $NEW_HOSTNAME > /etc/hostname
  echo "127.0.0.1  $NEW_HOSTNAME" >> /etc/hosts
  #sed -i "s/$CURRENT_HOSTNAME/$NEW_HOSTNAME/" /etc/hosts
fi

echo "Updating locale..."
update-locale LANG=C LANGUAGE=C LC_ALL=C LC_MESSAGES=POSIX

echo "Updating apt-get and adding ROS sources..."
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
apt-get update

echo "Done"

#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
  echo "ERROR: Operation not permitted. Forgot sudo?"
  exit 1
fi

echo
echo "========================="
echo "ROS-IN-A-BOX installation"
echo "========================="
echo


# Installing ROS packages
echo "Installing ROS packages and setting up basic ROS core..."
apt-get install -y ros-kinetic-ros-base
rosdep init
rosdep update
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
apt-get install -y ros-kinetic-rosbridge-server ros-kinetic-tf2-web-republisher

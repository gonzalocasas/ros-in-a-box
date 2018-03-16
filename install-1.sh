#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID == 0 ]; then
  echo "ERROR: Don't run this part with sudo"
  exit 1
fi

echo
echo "========================="
echo "ROS-IN-A-BOX installation"
echo "========================="
echo


# Installing ROS packages
echo "Installing ROS packages and setting up basic ROS core..."
sudo apt-get install -y ros-kinetic-ros-base
sudo rosdep init
rosdep update

# Add ROS sourcing to profile
LINE='source /opt/ros/kinetic/setup.bash'
FILE=~/.bashrc
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
source $FILE

echo "Installing ROS Bridge and additional tools..."
sudo apt-get install -y ros-kinetic-rosbridge-server ros-kinetic-tf2-web-republisher
sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential

echo "Initializing catkin workspace..."
mkdir -p ~/catkin_ws/src
pushd ~/catkin_ws/
catkin_make
popd

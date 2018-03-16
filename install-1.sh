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

echo "Installing ROS Bridge and additional tools..."
sudo apt-get install -y ros-kinetic-rosbridge-server ros-kinetic-tf2-web-republisher
sudo apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo apt-get install -y ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-industrial-core

# Add ROS sourcing to profile
grep -qF 'source /opt/ros/kinetic/setup.bash' ~/.bashrc || echo 'source /opt/ros/kinetic/setup.bash' >> ~/.bashrc
source /opt/ros/kinetic/setup.bash

# Catkin ws init
echo "Initializing catkin workspace..."
mkdir -p ~/catkin_ws/src
pushd ~/catkin_ws/

# Configure catkin workspace sourcing
echo "Configuring catkin workspace..."
grep -qF 'source ~/catkin_ws/devel/setup.bash' ~/.bashrc || echo 'source ~/catkin_ws/devel/setup.bash' >> ~/.bashrc
source ~/catkin_ws/devel/setup.bash

pushd src
echo "Installing UR modern driver..."
if [ ! -d ur_modern_driver ]; then
    git clone https://github.com/Zagitta/ur_modern_driver.git
else
    pushd ur_modern_driver
    git fetch origin
    git reset --hard
    popd
fi
popd

catkin_make
popd

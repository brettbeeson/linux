#!/bin/bash

cd "$(dirname "$0")"

sudo snap install --classic code

#
# sudo
#
sudo usermod -aG sudo bbeeson

#
# Utils
#
sudo apt install -y curl make

#
# Python 3.12 
#

# Use as standalone and don't fuck with system version
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.12 python3.12-dev
# Seperately, gotta get pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.12 get-pip.py
# And venv (with gets ensurepip)
sudo apt-get install python3-venv


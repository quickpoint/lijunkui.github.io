#!/bin/bash

###########################################################
# update.sh
# @author quickpoint
# @version 1.0 2019-07-20

# update.sh will update the linux to the lastest version and
# clean up the additional resources with one click.
###########################################################

# Defining Colors for text output
RED='\033[1;31m'
GRN='\033[1;32m'
YEL='\033[1;33m'
BLU='\033[1;34m'
NC='\033[0m' 


echo "${YEL}--------------- UPDATE ----------------${NC}"
echo "${YEL}sudo apt-get update...${NC}"
sudo apt-get update

echo "${YEL}sudo apt-get upgrade -y...${NC}"
sudo apt-get upgrade -y

echo "${YEL}sudo apt-get dist-upgrade -y...${NC}"
sudo apt-get dist-upgrade -y

echo "${YEL}--------------- CLEAN -----------------${NC}"
echo "${YEL}sudo apt-get autoremove...${NC}"
sudo apt-get autoremove


echo "${YEL}sudo apt-get autoclean...${NC}"

sudo apt-get autoclean
sudo apt-get clean

echo "${YEL}--------------- PURGE -----------------${NC}"
echo "${YEL}sudo deborphan | xargs sudo apt-get -y remove --purge...${NC}"
sudo deborphan | xargs sudo apt-get -y remove --purge

echo "${YEL}--------------- IMAGE ----------------${NC}"
echo "${YEL}sudo dpkg --get-selections | grep linux-image...${NC}"
sudo dpkg --get-selections | grep linux-image

echo "sudo apt-get remove --purge linux-image-3.2.2.1-generic"

#!/bin/bash
# Version 0.1 24/11/2017
# Author 'AdB'
# This scripts installs my must-have packages on Vultr servers
#
# Preparing environment...
apt-get -y install aptitude
aptitude update
aptitude -y dist-upgrade

# Network-related packages
aptitude -y install nmap iptraf iperf tcptraceroute mtr iptables tcpdump ntpdate

# Command-line tools
aptitude -y install tmux screen byobu bash-completion unzip sudo curl lynx w3m htop

# Development
#aptitude -y install vim-nox
#aptitude -y install git mercurial bzr subversion
#aptitude -y install make fakeroot build-essential

## Python Development
#aptitude -y install python-setuptools python-dev markdown
#easy_install pip
#pip install ipython pep8

#for Kali
nikto, wireshark, nmap, spike, Ollydbg debugger, nessus

Google Chrome
wget https://.../chrome.deb
apt-get install gdebi
gdebi chrome.deb

#if running as root it will spit a dummy
google-chrome

#workaround
useradd -m -d /home/pxlusr password
su pxlusr -c google-chrome


# joe nano vim nmap iptables-persistent mlocate htop diffmon chkconfig samhain gnupg ranger
nmap iptraf iperf tcptraceroute mtr iptables  ntpdate
tmux screen byobu bash-completion unzip sudo curl lynx w3m w3m-img  

apt-get install screen htop top ranger sed tcpdump wget curl scp zip gzip visudo rsnapshot

youtube-dl

# Useful software
youtube-dl url-to-video #download youtube video

ranger #terminal file/folder explorer

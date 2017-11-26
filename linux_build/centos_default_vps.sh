#!/bin/bash
# Version 0.1 24/11/2017
# Author 'AdB'
# This scripts installs my must-have packages on Vultr servers
#
# Preparing environment...
# Set correct hostname
hostnamectl set-hostname hostname.domain.com
export HISTCONTROL=ignorespace

# Install basic tools
yum update && yum upgrade
yum -y install gpasswd net-tools bind-utils sudo links gcc git nmap wget curl telnet p7zip unzip zip tcpdump rkhunter ntp nano joe vim python34-setuptools redis haveged
# yum whatprovides <app_name>

# Postfix is optional
#yum -y install postfix dovecot

# Easy install
sudo easy_install-3.4 pip
 
# yum whatprovides <app_name>
 
# Postfix is optional
#yum -y install postfix dovecot
 
# Configure secure SSH logon
adduser pxlusr
passwd pxlusr
gpasswd -a pxlusr wheel
mkdir /home/pxlusr/.ssh
cp .ssh/authorized_keys /home/pxlusr/.ssh/
cd /home/pxlusr/.ssh/
chown pxlusr:pxlusr authorized_keys
#
#
mkdir -p /root/.ssh
chmod 600 /root/.ssh
echo ssh-rsa AA... youremail@example.com > /root/.ssh/authorized_keys
chmod 700 /root/.ssh/authorized_keys
#
#


# Modify sshd_config file followed by service restart
systemctl restart sshd.service
 
# Run Rootkit Hunter
rkhunter --check
 
# Install and configure SElinux Policy
# If it bricks your VPS, add 'sepolicy=0' in GRUB when booting
# yum -y install selinux-policy
# getenforce
# setenforce 0 [OR 1]
 
# Other dependencies and additional RedHat repos
yum -y install epel-release centos-release-scl
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
yum -y install python-pip python3-dev python3-pip libpq5 libjpeg-dev python-devel
 
# Optional for MISP
# yum -y install httpd mariadb mariadb-server libxslt-devel zlib-devel
# pear install Crypt_GPG

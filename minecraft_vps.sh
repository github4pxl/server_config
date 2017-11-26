#!/bin/bash
# Version 0.1 24/11/2017
# Author 'AdB'
# This scripts installs my must-have packages on Vultr servers
#
# Preparing environment...
# Set correct hostname
hostnamectl set-hostname cld-vul-syd-pxldmcft-01.pixelhaystack.com

# To configure timezones
timedatectl set-timezone Australia/Brisbane

# To configure NTP synchronisation
systemctl start ntpd
systemctl enable ntpd

# Disable IPv6 - ensure that SSH is listening on IPv4
nano /etc/sysctl.conf
# append these two lines
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
# net.ipv6.conf.[interface].disable_ipv6 = 1 ### disable on a specific [interface]
# Reload configuration
sysctl -p

# Create SWAP file
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'

# Modify sshd_config file followed by service restart
# update sshd_config and issue/issue.net files
systemctl restart sshd.service

# Configure secure SSH logon for non-priv user
adduser pxlusr
passwd pxlusr
gpasswd -a pxlusr wheel
mkdir /home/pxlusr/.ssh
nano /home/pxlusr/.ssh/authorized_keys
cd /home/pxlusr
chown pxlusr:pxlusr .ssh/authorized_keys
chmod 700 .ssh
chmod 600 .ssh/authorized_keys

# Network tools
yum -y install net-tools mtr bind-utils nmap wget curl telnet tcpdump

# Install basic tools
yum update && yum upgrade
yum -y install sudo visudo gcc gpasswd git haveged htop python34-setuptools gnupg yum-utils selinux-policy
# yum-complete-transaction >> this will fix broken upgrade

# Easy install
sudo easy_install-3.4 pip

# Archiving tools
yum -y install p7zip unzip zip

# Text editors
yum -y install joe vim 

# Text browsers 
yum -y install lynx w3m w3m-img

# Security related tools
yum -y install rkhunter
rkhunter --check # Run Rootkit Hunter

# Configure SElinux Policy
getenforce
setenforce 1

# Minecraft related packages
yum -y install java-1.8.0-openjdk
mkdir /opt/minecraft
chown -R pxlusr:pxlusr /opt/minecraft
chmod -R 770 /opt/minecraft 
cd /opt/minecraft
wget https://s3.amazonaws.com/Minecraft.Download/versions/1.12.2/minecraft_server.1.12.2.jar
chown -R pxlusr:pxlusr /opt/minecraft
chmod -R 770 /opt/minecraft 

# Run it
java -Xmx1024M -Xms1024M -jar minecraft_server.1.12.2.jar nogui

# Create startup script
nano /opt/minecraft/minecraft_server.sh

#!/bin/bash
# Version 0.1 24/11/2017
# Author 'AdB'
#
# Starting Minecraft environment...
java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui

chmod +x /opt/minecraft/minecraft_server.sh
sh minecraft_server.sh

# Configure Firewall
systemctl start firewalld
firewall-cmd --reload # To reload ruleset to apply changes
 
# To automatically start firewall service at boot
systemctl enable firewalld
 
# Check firewall status
systemctl status firewalld 
firewall-cmd --state

# Minecraft Server Management
1. On the left hand side of your Multicraft control panel click the "Console" link.
2. In the console type "whitelist on". Make sure your server is on when you do this.

whitelist add <player>
whitelist list
whitelist on
whitelist off
whitelist reload
whitelist remove <player>

More can be found here https://minecraft.gamepedia.com/Commands


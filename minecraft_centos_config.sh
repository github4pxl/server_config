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

###### Optional #####
# Disable IPv6 - ensure that SSH is listening on IPv4
nano /etc/sysctl.conf
# append these two lines
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
# net.ipv6.conf.[interface].disable_ipv6 = 1 ### disable on a specific [interface]
# exit
sysctl -p
#####################

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
yum -y install sudo visudo gcc gpasswd git haveged htop python34-setuptools gnupg yum-utils
# yum-complete-transaction >> this will fix broken upgrade

# Easy install
sudo easy_install-3.4 pip

# Archiving tools | Text editors | Text browsers | Security Tools
yum -y install p7zip unzip zip joe vim lynx w3m w3m-img rkhunter

# rkhunter --check # Run Rootkit Hunter

# Configure SElinux Policy
#yum -y install selinux-policy
#getenforce
#setenforce 1

# Secure Minecraft server configuration 
adduser minecraft --system --shell /bin/bash --home /opt/minecraft -g minecraft
id minecraft
mkdir /opt/minecraft
chown -R minecraft:minecraft /opt/minecraft
chmod -R 770 /opt/minecraft 
cd /opt/minecraft
wget https://s3.amazonaws.com/Minecraft.Download/versions/1.12.2/minecraft_server.1.12.2.jar
chown -R minecraft:minecraft /opt/minecraft
chmod -R 770 /opt/minecraft 

# Run it to add Op and Whitelist users
cd /opt/minecraft
java -Xmx1024M -Xms768M -jar minecraft_server.1.12.2.jar nogui
chown -R minecraft:minecraft /opt/minecraft
chmod -R 770 /opt/minecraft

# More can be found here https://minecraft.gamepedia.com/Commands
# To generate UUID for whilist
https://mcuuid.net/?q=username

# Add an Op
/op <player>

# Whitelist players
whitelist add <player>
whitelist list
whitelist on
whitelist off
whitelist reload
whitelist remove <player>

# Configure as a services
nano /usr/lib/systemd/system/minecraftd.service

# Service file starts here
[Unit]
Description=Minecraft Server %i
After=network.target

[Service]
WorkingDirectory=/opt/minecraft/%i
PrivateUsers=true
User=minecraft
Group=minecraft
ProtectSystem=full
ProtectHome=true
ProtectKernelTunables=true
# Implies MountFlags=slave
ProtectKernelModules=true
# Implies NoNewPrivileges=yes
ProtectControlGroups=true
# Implies MountAPIVFS=yes

ExecStart=/bin/sh -c '/usr/bin/screen -DmS mc-%i /usr/bin/java -server -Xms768M -Xmx768M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10 -jar $(ls -v | grep -i "FTBServer.*jar\|minecraft_server.*jar" | head -n 1) nogui'

ExecReload=/usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "reload"\\015'
ExecStop=/usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "say SERVER SHUTTING DOWN. Saving map..."\\015'
ExecStop=/usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "save-all"\\015'
ExecStop=/usr/bin/screen -p 0 -S mc-%i -X eval 'stuff "stop"\\015'
ExecStop=/bin/sleep 10

Restart=on-failure
RestartSec=60s

[Install]
WantedBy=multi-user.target
# End here

# Reload the systemd service files
systemctl daemon-reload
systemctl start minecraftd.service
systemctl enable minecraftd.service

# Configure Firewall
firewall-cmd --permanent --add-port=25565/tcp
firewall-cmd --reload
firewall-cmd --state
 
# Check firewall status
systemctl status firewalld 
# systemctl enable firewalld
#### Script End

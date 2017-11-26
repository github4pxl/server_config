apt-get update && apt-get upgrade
export LC_ALL="en_US.UTF-8"
export HISTCONTROL=ignorespace
wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.0f-3+deb9u1_amd64.deb
dpkg -i libssl1.1_1.1.0f-3+deb9u1_amd64.deb 
echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | tee -a /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50 
apt install -y sudo dirmngr joe nano vim nmap iptables-persistent mlocate
# Optional installes but not mendatory
# apt install -y openjdk-7-jre
 
# Unifi Controller Prerequisites
echo 'deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main' | tee -a /etc/apt/sources.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo 'deb http://ftp.debian.org/debian jessie-backports main' | tee -a /etc/apt/sources.list
apt-get install -y mongodb-org-shell mongodb-org-server mongodb-org-mongos mongodb-org-tools mongodb-org
 
# Enable Mongod services
systemctl enable mongod.service
systemctl start mongod
systemctl status mongod
 
# Install Unifi Controller
apt-get install -y unifi
tail /usr/lib/unifi/logs/server.log
tail /usr/lib/unifi/logs/mongod.log
### End

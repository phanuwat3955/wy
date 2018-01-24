#!/bin/bash
#

# install
apt-get update -y
apt-get upgrade -y
apt-get install git wget squid3 -y

# install sshd
rm -rf /etc/ssh/sshd_config
wget https://raw.githubusercontent.com/Panuwatbank/sshd/master/sshd_config -O /etc/ssh/sshd_config
service sshd start
service sshd restart

# install pritunl
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.0.list
echo "deb http://repo.pritunl.com/stable/apt trusty main" > /etc/apt/sources.list.d/pritunl.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7F0CEB10
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv CF8E292A
sudo apt-get update
sudo apt-get install python-software-properties pritunl mongodb-org
sudo service pritunl start
sudo service pritunl restart

# install squid3 
apt-get -y install squid3 
wget -O /etc/squid3/squid.conf
"https://raw.githubusercontent.com/Panuwatbank/sshd/master/squid3.conf"
sed -i $MYIP2 
/etc/squid3/squid.conf;
service squid3 restart
pritunl setup-key

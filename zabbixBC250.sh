#!/bin/bash
##########################
### make sure your disk is expanded
###
### MAKE SURE LOGS ARE ON
### If logs are not on, they will be turned on but you'll lose the zabbix folder in /var/log/
### if this happens, you need to do the following
### 1. logs on && shutdown -r now
### 2. mkdir /var/log/zabbix
### 3. chown zabbix /var/log/zabbix
###
### Once this script is done
### run crontab -e and "save" and click on the "X" on the top right corner
### that will ensure the cron job is saved.
##########################

#turn logs on

logs-on

#stop current miner screen
screen -S wart_miner -X quit

#install zabbix agent
cd /home/user
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1%2Bubuntu20.04_all.deb
dpkg -i zabbix-release_6.4-1+ubuntu20.04_all.deb

apt update 
apt -y install zabbix-agent 


#download necessary scripts
wget https://raw.githubusercontent.com/kernelpanic0007/dnar/main/amd-oc.conf -O /hive-config/amd-oc.conf
wget https://raw.githubusercontent.com/kernelpanic0007/dnar/main/zabbix_agentd.conf -O /etc/zabbix/zabbix_agentd.conf
wget https://raw.githubusercontent.com/kernelpanic0007/dnar/main/customminer.sh -O /home/user/customminer.sh
wget https://raw.githubusercontent.com/kernelpanic0007/dnar/main/rig.conf -O /hive-config/rig.conf
#start zabbix
systemctl start zabbix-agent 
systemctl enable zabbix-agent 

#make scripts executable
chmod +x /home/user/customminer.sh

#replace dummy var with wallet

sed -i 's/walletaddress/TYPEINYOURWALLETHERE/g' /home/user/customminer.sh
sed -i 's/nodeipaddressvar/TYPEINYOURNODEIP/g' /home/user/customminer.sh
sed -i 's/nodeipport/TYPEINYOURNODEPORT/g' /home/user/customminer.sh

#replace zabbix HostName with systems
sed -i 's/zabbixipaddressvar/TYPEINYOURZABBIXSERVERIP/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/hostnamevar/'"$HOSTNAME"'/g' /etc/zabbix/zabbix_agentd.conf

#zabbix log file
if ! [ -d /var/log/zabbix/ ]; then
 mkdir /var/log/zabbix/
 chown zabbix /var/log/zabbix/
fi

#add customminer to rc.local for auto startup
#for Ubuntu 20.04 create customminer.sh as service
#sed -i -e '$i \/home/user/customminer.sh\n' /etc/rc.local
 
#restart zabbix agent

systemctl restart zabbix-agent
shutdown -r now

#exit out of screen
screen -S wart_miner -X quit
#download if necessary and run miner
cd /home/user
wget -nc https://github.com/CoinFuMasterShifu/janusminer/releases/download/0.2.2/janusminer_hiveos-0.2.2.tgz
rm -r /home/user/janusminer_hiveos/*
tar xzvf janusminer_hiveos-0.2.2.tgz
/hive/sbin/amd-oc
screen -dmS wart_miner bash -c  "while true; do /home/user/janusminer_hiveos/wart-miner -a walletaddress -h nodeipaddressvar -p nodeipport --threads=8 2>&1 | tee /var/log/janusminer_hiveos.log; done"


#!/bin/sh

set -e
mkdir -p /home/`whoami`
 sudo service rsyslog restart
# sudo chown -R rsyslog:rsyslog /home/rsyslog
sudo sysctl -w net.ipv4.ip_forward=1
echo "configure iptables"

sudo iptables -t nat -A POSTROUTING -s 192.168.122.0/24 ! -d 192.168.122.0/24 -j MASQUERADE
sudo iptables -A INPUT -i ppp+ -j ACCEPT
sudo iptables -A OUTPUT -o ppp+ -j ACCEPT
sudo iptables -A FORWARD -i ppp+ -j ACCEPT
sudo iptables -A FORWARD -o ppp+ -j ACCEPT

iptables -A FORWARD -p tcp -d 192.168.8.46 --dport 8080 -j ACCEPT
echo "configure iptables success"

# sudo touch /var/log/auth.log
# sudo chown -R rsyslog:rsyslog /var/log
sudo service pptpd restart
tail -f /var/log/messages
#exec  "$@"

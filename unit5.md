### VM's IP addresses
VM 1: 10.1.1.4 
VM 2: 10.1.1.6

### Firewall to block port 22 (ssh) on VM1
sudo iptables -A INPUT -p tcp --dport 22 -j DROP

### Port forward VM 2's ssh on port 12345 to VM 1 to go into port 22
sudo iptables -t nat -A PREROUTING -p tcp --dport 12345 -j DNAT --to-destination 10.1.1.4:22
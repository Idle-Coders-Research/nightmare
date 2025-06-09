#!/bin/bash
echo "[+] Setting Strict Firewalls And Tor Enforced Traffic System"

# Disable UFW Firewall
if command -v ufw >/dev/null 2>&1; then
    echo "[+] Disabling UFW to avoid conflicts..."
    sudo ufw disable
fi

# Flush all existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t mangle -F

# Set default DROP policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow only Tor DNS and traffic
iptables -A OUTPUT -p udp --dport 9053 -j ACCEPT       # Tor DNSPort
iptables -A OUTPUT -p tcp --dport 9050 -j ACCEPT       # Tor SOCKS
iptables -A OUTPUT -p tcp --dport 9040 -j ACCEPT       # Tor TransPort

# Allow only Tor daemon to access network
iptables -A OUTPUT -m owner --uid-owner debian-tor -j ACCEPT

# Drop any non-Tor DNS leaks
iptables -A OUTPUT -p udp --dport 53 -j DROP

# Log 
iptables -A OUTPUT -j LOG --log-prefix "TOR BLOCKED: "

#Block all other outbound traffic
iptables -A OUTPUT -j REJECT

echo "[+] All traffic forced through Tor or blocked. Strict Rules Are Activated !"

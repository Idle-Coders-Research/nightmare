#!/bin/bash
echo "[+] Resetting Strict Firewall Rules to Default State"

# Flush all current rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t mangle -F

# Set default policies to ACCEPT (normal behavior)
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

echo "[+] Firewall is now reset to default: all traffic allowed."

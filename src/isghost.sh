#!/bin/bash


echo "🔍 Checking GHOST MODE status..."

# Get interface name
interface=$(nmcli device status | awk '$2 == "wifi" && $3 == "connected" && $1 !~ /^p2p-dev-/ { print $1 }')


if [ -z "$interface" ]; then
  echo "[✗] No active WiFi interface found."
else
  echo "[~] Active Interface: $interface"

  # Check current MAC
  echo "[~] Checking MAC Address Details..."
  macchanger -s "$interface"
fi

# Check external IP
external_ip=$(wget -qO- https://api.ipify.org)
if [ -n "$external_ip" ]; then
  echo "[~] Your external IP: $external_ip"
else
  echo "[✗] Could not fetch external IP."
fi

# Check if IPv6 is disabled
ipv6_all=$(sysctl -n net.ipv6.conf.all.disable_ipv6 2>/dev/null)
ipv6_default=$(sysctl -n net.ipv6.conf.default.disable_ipv6 2>/dev/null)

if [[ "$ipv6_all" -eq 1 && "$ipv6_default" -eq 1 ]]; then
    echo "[✓] IPv6 is DISABLED"
else
    echo "[✗] IPv6 is ENABLED"
fi



# Check Anonsurf status
echo "[✓] Anonsurf Status: "
if systemctl is-active --quiet anonsurf; then
  echo "[✓] Anonsurf is RUNNING"
  anonsurf myip
else
  anonsurf myip
fi

# Check UFW status
if command -v ufw &> /dev/null; then
  ufw_status=$(ufw status | head -n 1)
  echo "[~] UFW Firewall: $ufw_status"
else
  echo "[✗] UFW not found"
fi

echo "✅ Ghost status check complete."

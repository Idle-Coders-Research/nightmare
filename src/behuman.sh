#!/bin/bash


echo "[*] Reverting to human mode..."

# Detect active WiFi interface
iface=$(nmcli device status | awk '$2 == "wifi" && $3 == "connected" && $1 !~ /^p2p-dev-/ { print $1 }')
echo "[~] finding interface: $iface"
if [[ -z "$iface" ]]; then
  echo "[ERROR] No active WiFi interface found. Exiting."
  exit 1
fi

# Detect connection name
conn_name=$(nmcli -t -f NAME,DEVICE connection show --active | grep "$iface" | cut -d: -f1)

echo "[+] Detected Interface: $iface"
echo "[+] Detected Connection: $conn_name"

# MAC Restore
echo "[+] Restoring MAC address..."

#diconnecting
nmcli connection down "$conn_name"

ip link set "$iface" down
spoof_output=$(macchanger -p "$iface")


nmcli connection modify "$conn_name" 802-11-wireless.cloned-mac-address ""
nmcli connection modify "$conn_name" 802-11-wireless.mac-address-randomization "default"

echo "[~] Getting Current MAC Status..."
macchanger -s "$iface"
ip link set "$iface" up
# Dynamic IP
echo "[+] Setting dynamic IP..."
nmcli connection modify "$conn_name" ipv4.method auto
nmcli connection up "$conn_name"

# Check external IP
external_ip=$(wget -qO- https://api.ipify.org)
if [ -n "$external_ip" ]; then
  echo "[~] Your external IP: $external_ip"
else
  echo "[✗] Could not fetch external IP."
fi


# Re-enable IPv6
echo "[+] Enabling IPv6..."
sysctl -w net.ipv6.conf.all.disable_ipv6=0
sysctl -w net.ipv6.conf.default.disable_ipv6=0

# Stop Anonsurf (optional)
read -p "[?] Stop Anonsurf? (y/n): " stop_ans
if [[ "$stop_ans" =~ ^[Yy]$ ]]; then
    anonsurf stop
fi

# Disable firewall (optional)
read -p "[?] Disable UFW firewall? (y/n): " disable_fw
if [[ "$disable_fw" =~ ^[Yy]$ && $(command -v ufw) ]]; then
    ufw disable
fi

echo "[✓] You are now back in HUMAN MODE."

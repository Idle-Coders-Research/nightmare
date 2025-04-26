#!/bin/bash



# Safe begghost.sh

echo "[*] Starting ghost mode..."

# Detect active WiFi interface
iface=$(nmcli device status | awk '$2 == "wifi" && $3 == "connected" && $1 !~ /^p2p-dev-/ { print $1 }')
echo "[~] finding interface: $iface"
if [[ -z "$iface" ]]; then
  echo "[ERROR] No active WiFi interface found. Exiting."
  exit 1
fi

# Detect connection name
conn_name=$(nmcli -t -f NAME,DEVICE connection show --active | grep "$iface" | cut -d: -f1)

echo "[✓] Detected Interface: $iface"
echo "[✓] Detected Connection: $conn_name"

# MAC Spoof
echo "[+] Spoofing MAC address..."

#diconnecting
nmcli connection down "$conn_name"

ip link set "$iface" down
spoof_output=$(macchanger -A "$iface")


# Extract and store the cloned MAC address
cloning_mac_address=$(echo "$spoof_output" | grep 'New MAC' | awk '{print $3}')
nmcli connection modify "$conn_name" 802-11-wireless.cloned-mac-address "$cloning_mac_address"
nmcli connection modify "$conn_name" 802-11-wireless.mac-address-randomization "never"
echo "[✓] Spoofed  MAC: $cloning_mac_address"
ip link set "$iface" up
# Dynamic IP
echo "[+] Setting dynamic IP..."
nmcli connection modify "$conn_name" ipv4.method auto
nmcli connection up "$conn_name"

# Check external IP
external_ip=$(wget -qO- https://api.ipify.org)
if [ -n "$external_ip" ]; then
  echo "[✓] Your external IP: $external_ip"
else
  echo "[✗] Could not fetch external IP."
fi

# Disable IPv6 (runtime only)
echo "[+] Disabling IPv6..."
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

# Ask before Anonsurf
read -p "[?] Start Anonsurf? (y/n): " start_anon
if [[ "$start_anon" =~ ^[Yy]$ ]]; then
  anonsurf start
fi

# Ask before firewall lockdown
read -p "[?] Apply strict firewall rules? (y/n): " apply_fw
if [[ "$apply_fw" =~ ^[Yy]$ ]]; then
  ufw default deny outgoing
  ufw default deny incoming
  ufw allow out to 127.0.0.1
  ufw --force enable
fi

echo " [✓] You are now in Ghost Mode "

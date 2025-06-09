#!/bin/bash


echo "[*] Reverting to human mode..."

# Step 1: Detect currently active WiFi interface
detected_iface=$(nmcli device status | awk '$2 == "wifi" && $3 == "connected" && $1 !~ /^p2p-dev-/ { print $1 }')

# Step 2: Use detected interface to find default connection
detected_conn=$(nmcli -t -f NAME,DEVICE connection show --active | grep "$detected_iface" | cut -d: -f1)

# Step 3: Prompt user for connection name (optional override)
read -p "[?] Enter connection name [default: $detected_conn] press ENTER for deffault : " conn_name
conn_name="${conn_name:-$detected_conn}"

# Step 4: Redetect iface based on final connection name
iface=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device | awk -F: -v name="$conn_name" '$4 == name { print $1 }')

# Step 5: Validate interface found
if [[ -z "$iface" ]]; then
  echo "[✗] Error: Could not find interface for connection '$conn_name'"
  exit 1
fi

# Show final results
echo "[+] Detected Interface: $iface"
echo "[+] Detected Connection: $conn_name"

# Stop Anonsurf (optional)
read -p "[?] Stop Anonsurf? (y/n): " stop_ans
if [[ "$stop_ans" =~ ^[Yy]$ ]]; then
    echo "y" | anonsurf stop >/dev/null 2>&1
fi

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


# Force disable UFW without prompting
if command -v ufw >/dev/null 2>&1; then
    echo "[+] Disabling UFW (forced)"
    sudo ufw disable
fi
# rollback strict rules
echo " "
/opt/nightmare/rollbackFirewall.sh
echo " "
echo "[✓] You are now back in HUMAN MODE."

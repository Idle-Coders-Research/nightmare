#!/bin/bash



# Get iface and conn_name from arg
iface="$1"
conn_name="$2"

if [[ -z "$iface" || -z "$conn_name" ]]; then
  echo "[✗] resetghost.sh requires iface and conn_name as arguments."
  exit 1
fi

echo "[*] Resetting network state for $conn_name ($iface)..."

# Step 5: Validate interface found
if [[ -z "$iface" ]]; then
  echo "[✗] Error: Something went wrong: find interface for connection '$conn_name'"
  exit 1
fi

# MAC Restore

#diconnecting
nmcli connection down "$conn_name" >/dev/null 2>&1
sleep 1
ip link set "$iface" down
spoof_output=$(macchanger -p "$iface")


nmcli connection modify "$conn_name" 802-11-wireless.cloned-mac-address ""
nmcli connection modify "$conn_name" 802-11-wireless.mac-address-randomization "default"


ip link set "$iface" up
# Dynamic IP


nmcli connection modify "$conn_name" ipv4.method auto
nmcli connection up "$conn_name" >/dev/null 2>&1
sleep 2
# Re-enable IPv6

sysctl -w net.ipv6.conf.all.disable_ipv6=0 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=0 >/dev/null 2>&1

# Stop Anonsurf 
echo "y" | anonsurf stop >/dev/null 2>&1


# Disable firewall (optional)
echo "y" | ufw disable >/dev/null 2>&1

echo "[+] Resetting Complete"


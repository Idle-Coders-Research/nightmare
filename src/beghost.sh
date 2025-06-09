#!/bin/bash



# Safe begghost.sh

echo "[*] Starting ghost mode..."

# Step 1: Detect currently active WiFi interface
detected_iface=$(nmcli device status | awk '$2 == "wifi" && $3 == "connected" && $1 !~ /^p2p-dev-/ { print $1 }')

# Step 2: Use detected interface to find default connection
detected_conn=$(nmcli -t -f NAME,DEVICE connection show --active | grep "$detected_iface" | cut -d: -f1)

# Step 3: Prompt user for connection name (optional override)
read -p "[?] Enter connection name [default: $detected_conn] press ENTER for default : " conn_name
conn_name="${conn_name:-$detected_conn}"

# Step 4: Redetect iface based on final connection name
iface=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device | awk -F: -v name="$conn_name" '$4 == name { print $1 }')

# Step 5: Validate interface found
if [[ -z "$iface" ]]; then
  echo "[✗] Error: Could not find interface for connection '$conn_name'"
  exit 1
fi

# Show final results
echo "[+] Interface: $iface"
echo "[+] Connection: $conn_name"

#Reset Immidiate
echo "[~] Resetting Configs... "
/opt/nightmare/resetghost.sh "$iface" "$conn_name"

# MAC Spoof
echo "[+] Spoofing MAC address..."

#diconnecting
nmcli connection down "$conn_name" >/dev/null 2>&1
sleep 1
echo "[-] Connection Decitvated Successfully"
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
nmcli connection up "$conn_name" >/dev/null 2>&1
echo "[✓] Connection Acitvated Successfully"
sleep 2
# Check external IP
external_ip=$(wget -qO- https://api.ipify.org)
if [ -n "$external_ip" ]; then
  echo "[✓] Your external IP: $external_ip"
else
  echo "[✗] Could not fetch external IP."
fi

# Disable IPv6 (runtime only)
echo "[+] Disabling IPv6..."
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1 

# Check if IPv6 is disabled
ipv6_all=$(sysctl -n net.ipv6.conf.all.disable_ipv6 2>/dev/null)
ipv6_default=$(sysctl -n net.ipv6.conf.default.disable_ipv6 2>/dev/null)

if [[ "$ipv6_all" -eq 1 && "$ipv6_default" -eq 1 ]]; then
    echo "[✓] IPv6 is DISABLED"
else
    echo "[✗] Failed To Disable IPv6. You better restart nightmare"
fi

echo " "

# Ask before firewall lockdown
#!/bin/bash
read -p "[?] Apply strict firewall rules? (Y/n): " apply_fw

if [[ "$apply_fw" =~ ^[Yy]$ ]]; then
    echo "[+] Enabling strict iptables firewall rules..."
    
    # Optional path to your strict iptables script
    /opt/nightmare/strictFirewall.sh

else
    echo "[+] Applying limited UFW lockdown instead..."

    if command -v ufw >/dev/null 2>&1; then
        sudo ufw --force reset
        sudo ufw default deny outgoing
        sudo ufw default deny incoming
        sudo ufw allow out to 127.0.0.1
        sudo ufw --force enable
        echo "[+] UFW limited lockdown is now active."
    else
        echo "[-] UFW is not installed. Skipping UFW fallback."
    fi
fi
echo " "


# start Anonsurf
echo " "

anonsurf start

echo " "
echo " [✓] You are now in Ghost Mode. Sucessfully Became The Ghost Of A Nightmare "

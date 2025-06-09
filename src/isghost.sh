echo "🔍 Checking GHOST MODE status..."
echo "-----------------------------------"

# Get active WiFi interface (excluding p2p-dev)
interface=$(nmcli device status | awk '$2 == "wifi" && $3 == "connected" && $1 !~ /^p2p-dev-/ { print $1 }')

if [ -z "$interface" ]; then
  echo "[✗] No active WiFi interface found."
else
  echo "[~] Active Interface: $interface"
  echo "[~] MAC Address Info:"
  macchanger -s "$interface"
fi

# Check external IP
echo "[~] Fetching external IP..."
external_ip=$(wget -qO- https://api.ipify.org)
if [ -n "$external_ip" ]; then
  echo "[✓] Your External IP: $external_ip"
else
  echo "[✗] Could not fetch external IP."
fi

# Check if IPv6 is disabled
ipv6_all=$(sysctl -n net.ipv6.conf.all.disable_ipv6 2>/dev/null)
ipv6_default=$(sysctl -n net.ipv6.conf.default.disable_ipv6 2>/dev/null)

if [[ "$ipv6_all" -eq 1 && "$ipv6_default" -eq 1 ]]; then
    echo "[✓] IPv6 is DISABLED"
else
    echo "[✗] IPv6 is ENABLED — consider disabling it for anonymity."
fi

# Check Anonsurf status
echo "[~] Checking Anonsurf..."
if systemctl is-active --quiet anonsurf; then
  echo "[✓] Anonsurf is RUNNING"
else
  echo "[✗] Anonsurf is NOT running"
fi

# Always show what Tor sees
echo "[~] Tor IP (Anonsurf):"
anonsurf myip

# Check UFW status
if command -v ufw &> /dev/null; then
  echo "[~] UFW Firewall Status:"
  sudo ufw status verbose
else
  echo "[✗] UFW not found."
fi

# Show iptables rules
echo "[~] iptables Rules (Summary):"
sudo iptables -L -v -n --line-numbers

echo "-----------------------------------"
echo "✅ Ghost status check complete."

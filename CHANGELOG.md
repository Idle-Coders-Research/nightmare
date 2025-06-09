# 📦 Changelog - Nightmare CLI

## v2.0.0 - June 2025
- ✨ Added `strictFirewall.sh` to More Enable Strict Firewall Rules before ghosting.
- ✅ Integrated Tor Enforced Traffic Route. Every traffics will go through tor network or it will be blocked.
- 🔧 No DNS leaks
- 🔧 No WebRTC ISP IP Leaks
- 🔧 Successfully Passed the tests on ipleaks.net, dnsleak website, check.torproject website, tcpdump, torrent magnet link attack;
- 🔧 Can't Browse internet without tor connection.
- ✅ Integrated silent rollback into `rollbackFirewall.sh` to set everything normal .
- 🛠 Improved interface for smoother UX 


## v1.1.0 - April 2025
- ✨ Added `resetghost.sh` to clean up MAC, IP, IPv6, firewall, and Anonsurf before ghosting
- ✅ Integrated silent reset into `beghost.sh`
- 🔧 Improved Anonsurf stop to suppress dangerous app prompt
- 🛠 Cleaned CLI interface for smoother UX

## v1.0.0 - Initial Release
- 🎉 Base CLI wrapper: `nightmare start | status | stop`
- 🧠 MAC spoofing, IPv6 disabling, Anonsurf + UFW toggles
- 👻 Become the Ghost of a Nightmare

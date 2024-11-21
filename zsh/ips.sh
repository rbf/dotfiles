#!/bin/zsh

# Kagi assistant session
# https://kagi.com/assistant?mode=5&sub_mode=NaN&thread=utlQLjW6ULsMnw06PdgiaWcytPcq4TH3

# Quickly list all relevant local and external IP addresses, and log them to a
# csv file.

# Quickly list all relevant local in the terminal and external IP addresses, in
# the following formats. When the

# Ethernet      : off
# Wi-Fi         : off
# External      : offline

# Ethernet (en7): 10.1.1.123 (10.1.1.1, [Device name])
# Wi-Fi    (en0): 10.1.1.123 (10.1.1.1, [ssid name])
# External      : 123.123.123.123 ([City] [CountryCode] - [organization name])

# Save the device names, the SSIDs and the external IPS to a file on e.g. .cache/ips
# If we have not seen them before, ask the user whether they are trusted or not or undecided.
# If we have seen them before, display the corresponding line in green, red or default, accordingly.

set -euo pipefail

DIM="\e[2m"
RESET="\e[0m"

function echo_dim() {
  echo "${DIM}${1}${RESET}"
}

SERVICES=()

# SOURCE: https://stackoverflow.com/a/7760828
# for service in "${(@f)$(networksetup -listallnetworkservices | grep -v '*')}"; do                                          VPN 20:00:36
networksetup -listallnetworkservices | grep -v '*' | while IFS= read -r service; do
  # echo "${service}: $(networksetup -getinfo "${service}" | egrep '^IP address')"
  echo "${service}: $(networksetup -getinfo "${service}")"
done

exit

ETHERNET_IP="$(ipconfig getifaddr en1)"
WIFI_IP="$(ipconfig getifaddr en0)"
IPINFO="$(curl -sSL --connect-timeout 0.6  -H "User-Agent:" -H "Referer:" -H "Accept:" -H "Accept-Language:" -H "Accept-Encoding:" -H "Connection:" --cookie "" --http1.1 https://ipinfo.io/ 2>/dev/null)"

if [ -n "${ETHERNET_IP}" ]; then
  echo "Ethernet (en1): ${ETHERNET_IP}"
else
  echo "${DIM}Ethernet (en1): off${RESET}"
fi
if [ -n "${WIFI_IP}" ]; then
  echo "Wi-Fi    (en0): ${WIFI_IP}"
else
  echo "${DIM}Wi-Fi    (en0): off${RESET}"
fi
if [ -n "${IPINFO}" ]; then
  echo "External      : $(echo ${IPINFO} | jq -r '.ip') ($(echo ${IPINFO} | jq -r '.city') $(echo ${IPINFO} | jq -r '.country') - $(echo ${IPINFO} | jq -r '.org'))"
else
  echo "${DIM}External      : offline${RESET}"
fi

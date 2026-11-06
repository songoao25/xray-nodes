#!/bin/sh
# Generates /etc/xray/config.json from environment variables and starts xray.
#   UUID   (required) - VLESS client UUID
#   PORT   (default 8080) - port xray listens on
#   WSPATH (default /vless) - WebSocket path, must start with /
set -eu
UUID="${UUID:?UUID env var is required}"
PORT="${PORT:-8080}"
WSPATH="${WSPATH:-/vless}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": ${PORT},
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${UUID}"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "${WSPATH}"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom", "tag": "direct"}]
}
EOF
exec /usr/bin/xray run -c /etc/xray/config.json

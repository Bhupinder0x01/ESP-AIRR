#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! "$1" =~ ^[A-Za-z0-9_-]+$ ]]; then
  echo "Usage: $0 DEVICE_NAME (letters, numbers, _ and - only)" >&2
  exit 64
fi

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
device_name="$1"
cd "$root_dir"

python3 generate_keys.py --prefix "$device_name"
mkdir -p private/devices
mv "output/${device_name}.keys" "output/${device_name}_keyfile" "output/${device_name}_devices.json" private/devices/
rmdir output

echo "Created ignored identity material in private/devices/:"
echo "  ${device_name}.keys          (private backup)"
echo "  ${device_name}_keyfile       (flash to the ESP32)"
echo "  ${device_name}_devices.json  (import into the web UI)"

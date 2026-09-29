#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 DEVICE_NAME SERIAL_PORT" >&2
  exit 64
fi

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
device_name="$1"
serial_port="$2"
keyfile="$root_dir/private/devices/${device_name}_keyfile"
firmware_dir="$root_dir/firmware/ESP32/prebuilt"

[[ -f "$keyfile" ]] || { echo "Missing $keyfile. Run tools/add_device.sh first." >&2; exit 1; }

python3 -m esptool --port "$serial_port" erase_flash
python3 -m esptool --port "$serial_port" write_flash \
  0x1000 "$firmware_dir/bootloader.bin" \
  0x8000 "$firmware_dir/partitions.bin" \
  0x10000 "$firmware_dir/firmware.bin" \
  0x110000 "$keyfile"

echo "Flash complete. Press EN/RESET once if the board does not begin advertising."

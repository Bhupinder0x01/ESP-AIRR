# Operations and recovery

## Service lifecycle

Run these from `deploy/` on the VM:

```bash
docker compose ps
docker compose logs --tail=100 macless-haystack
docker compose logs --tail=100 anisette
docker compose restart macless-haystack anisette
```

The endpoint needs Anisette at `http://anisette:6969` inside the Docker
network. Do not publish Anisette to the public internet.

## Token recovery

If Apple authentication has expired, preserve a volume backup first. Then
delete only the `auth.json` in `mh_data`, run the foreground first-login flow
from the README, complete 2FA, and restart the persistent service. Do not
delete the entire volume merely to refresh a token: it may also contain your
endpoint configuration.

## Volume backup

Back up volumes on the VM to a protected location, not into this Git checkout:

```bash
docker run --rm -v mh_data:/source -v "$PWD":/backup alpine \
  tar czf /backup/mh_data-private-backup.tar.gz -C /source .
docker run --rm -v anisette-v3_data:/source -v "$PWD":/backup alpine \
  tar czf /backup/anisette-private-backup.tar.gz -C /source .
```

Those archives are secrets. Move them to encrypted storage and remove them
from the VM working directory when the copy is verified.

## Frontend restore

Re-run the Pages workflow from GitHub Actions or push a reviewed change to
`main`. A static frontend rebuild does not affect Docker volumes or device
identities. Users must still keep their imported device JSON files and browser
accessory backups.

## Firmware rebuild

The known-good binary files are in `firmware/ESP32/prebuilt/`. To compile from
source instead, install PlatformIO and run:

```bash
python3 -m pip install --upgrade platformio
pio run -d firmware/ESP32
```

Use newly compiled `.pio/build/esp32dev/` binaries only after testing; the
prebuilt files remain the documented baseline.

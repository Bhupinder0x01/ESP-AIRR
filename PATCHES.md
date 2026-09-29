# Local patch record

This repository is based on the existing preserved Macless-Haystack checkout:

- upstream repository: `https://github.com/dchristl/macless-haystack.git`
- preserved base commit: `0bda271` (`new release`)

The changes below are intentional production compatibility fixes recovered from
the working Azure/FindMy materials. Keep this document and the code changes
together when comparing future upstream releases.

## Apple GSA and two-factor authentication

`endpoint/register/pypush_gsa_icloud.py` is patched to:

1. use `com.apple.akd/1.0` in every relevant `X-Mme-Client-Info` value;
2. continue to the secondary-authentication flow if Apple omits `M2`, while
   still verifying `M2` whenever Apple sends it;
3. accept current JSON trusted-phone responses for SMS 2FA and fall back to
   the earlier HTML `boot_args` parser; and
4. use the current IDMS SMS request endpoint after a code is not delivered.

The earlier server backup supplied the observed working `akd`, no-`M2`, and
2FA behavior. The master implementation preserves its behavior while using
the current endpoint configuration and Anisette integration.

## Report retrieval resilience

`tools/request_reports.py` retains the working report schema bootstrap:

```sql
CREATE TABLE IF NOT EXISTS reports (
  name TEXT PRIMARY KEY, timestamp INTEGER, datePublished INTEGER,
  payload TEXT, id TEXT, statusCode INTEGER
)
```

It uses fallback values when Apple leaves out `datePublished` or `statusCode`.
The script now defaults all keys, auth data, and SQLite output to ignored
`private/` paths, so a diagnostic run cannot make secrets look commit-ready.

## Docker and endpoint deployment

The upstream endpoint Dockerfile cloned upstream code at build/startup. That
would overwrite this master repository's compatibility fixes. It is replaced
with a local build that copies `endpoint/` from the current checkout and runs
it directly. `deploy/docker-compose.yml` keeps Anisette internal and binds the
endpoint to loopback for Caddy HTTPS proxying.

## Frontend and GitHub Pages

The Flutter source remains in `macless_haystack/`. `.github/workflows/pages.yml`
builds it from source, tests it, uses a repository-safe project Pages base
path, and deploys only `build/web`. The endpoint URL/password are browser
settings rather than build-time secrets.

## Safe update rule

Never replace this source tree with a fresh upstream clone. When considering an
update, compare it against this repository and reapply/test every item above.
The existing working `~/esp32-airtag` directories and backup archive are
preserved outside this master repository for recovery only; they are not part
of its Git history.
